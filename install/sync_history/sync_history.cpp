#include <errno.h>
#include <pwd.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/un.h>
#include <unistd.h>

#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_map>

using std::string;
using std::runtime_error;

#if defined(__GLIBC__)
static size_t
strlcpy(char *dst, const char *src, size_t siz)
{
    char *d = dst;
    const char *s = src;
    size_t n = siz;

    /* Copy as many bytes as will fit */
    if (n != 0 && --n != 0) {
        do {
            if ((*d++ = *s++) == 0)
                break;
        } while (--n != 0);
    }

    /* Not enough room in dst, add NUL and traverse rest of src */
    if (n == 0) {
        if (siz != 0)
            *d = '\0';          /* NUL-terminate dst */
        while (*s++)
            ;
    }

    return static_cast<size_t>(s - src - 1);   /* count does not include NUL */
}
#endif

const size_t max_size = 1000;

static char messageBuffer[max_size];

class Terminate {
  public:
    const int status;

    Terminate(int s = EXIT_FAILURE) : status(s)
    {}

    Terminate(const Terminate& exc) : status(exc.status)
    {}

    ~Terminate();
};

Terminate::~Terminate() {}

/* Handle premature exit and grabbing errno code */
class FatalError : public runtime_error {
  public:
    FatalError(const string &msg) : runtime_error(msg)
    {}

    FatalError(const FatalError& exc) : runtime_error(exc.what())
    {}

    ~FatalError();
};

FatalError::~FatalError() {}

class ErrnoFatal : public FatalError {
    string from_extra(const string& msg)
    {
        if (msg.empty()) return "";
        return ": " + msg;
    }

  public:
    const int error;
    const string func;

    ErrnoFatal(const string &msg, const string &extra = "")
     : FatalError(msg + "(): " + string(strerror(errno)) + from_extra(extra))
     , error(errno), func(msg)
    {}

    ErrnoFatal(const ErrnoFatal& exc)
     : FatalError(exc.what()), error(exc.error), func(exc.func)
    {}

    ~ErrnoFatal();
};

ErrnoFatal::~ErrnoFatal() {}

static void
closeFd(int fd)
{
    if (close(fd) == -1) {
        //FIXME: log error
    }
}

struct Request {
    enum class Command {
        update,
        deregister,
        shutdown
    };

    pid_t origin;
    Command cmd;
    size_t length;
    char payload[];
};

struct Reply {
    enum class Command {
        new_hist,
        reload_file
    };

    Command cmd;
    size_t length;
    char payload[];
};

struct membuf : public std::streambuf {
    using seekdir = std::ios_base::seekdir;
    using openmode = std::ios_base::openmode;
    using ios_base = std::ios_base;

    template <size_t Size>
    membuf(char (&array)[Size])
    {
        setp(array, array + Size - 2);
        std::fill_n(array, Size, 0);
    }

  protected:
    std::streamsize
    xsputn(const char_type* s, std::streamsize count)
    {
        std::streamsize result = std::streambuf::xsputn(s, count);
        /* Always legal, because epptr points before in due to constructor */
        *pptr() = '\0';
        return result;
    }

    pos_type seekpos(pos_type pos, openmode which = ios_base::out)
    { return seekoff(pos, ios_base::beg, which); }

    pos_type
    seekoff(off_type off, seekdir dir, openmode which = ios_base::out)
    {
        if ((which & ios_base::out) != ios_base::out) {
            return pos_type(off_type(-1));
        }

        off_type current = pptr() - pbase();
        off_type max = epptr() - pbase();

        if (dir == ios_base::end) off = max - off;
        else if (dir == ios_base::cur) off = current + off;

        if (off < 0 || off > max) return pos_type(off_type(-1));
        pbump(static_cast<int>(off - current));
        return pptr() - pbase();
    }

    ~membuf();
};

membuf::~membuf() {}

class UnixSocket {
    bool initialised;
    bool received;
    int sock;
    struct sockaddr_un origin;
    struct sockaddr_un from;

    static sockaddr_un addr_from_path(const string& path)
    {
        size_t ret;
        struct sockaddr_un addr;
        addr.sun_family = AF_UNIX;
        ret = strlcpy(addr.sun_path, path.c_str(), sizeof addr.sun_path);
        if (ret >= sizeof addr.sun_path) {
            throw FatalError("Socket path to long");
        }
        return addr;
    }

  public:
    UnixSocket(const sockaddr_un& addr)
     : initialised(true), received(false), origin(addr)
    {
        int ret;
        sock = socket(AF_UNIX, SOCK_DGRAM, 0);
        if (sock == -1) throw ErrnoFatal("socket");

        ret = bind(sock, reinterpret_cast<const sockaddr*>(&addr), sizeof addr);
        if (ret == -1) {
            closeFd(sock);
            throw ErrnoFatal("bind", addr.sun_path);
        }
    }

    UnixSocket(const string& path)
     : UnixSocket(addr_from_path(path))
    {}

    UnixSocket(UnixSocket&& s)
     : initialised(s.initialised), received(s.received), sock(s.sock)
     , origin(s.origin), from(s.from)
    { s.initialised = false; }

    ~UnixSocket()
    { close(true); }

    void close(bool do_unlink = false)
    {
        int ret;
        if (initialised) {
            closeFd(sock);
            if (do_unlink) {
                ret = unlink(origin.sun_path);
                if (ret == -1) {
                    //FIXME: log error
                }
            }
            initialised = false;
        }
    }

    template<typename T>
    void recv(T* buf)
    {
        ssize_t ret;

        struct iovec buffers[] = { { buf, max_size } };
        struct msghdr header =
            { .msg_name = &from
            , .msg_namelen = sizeof from
            , .msg_iov = buffers
            , .msg_iovlen = 1
            , .msg_control = nullptr
            , .msg_controllen = 0
            , .msg_flags = 0
            };

        ret = recvmsg(sock, &header, 0);
        if (ret == -1) {
            throw ErrnoFatal("recvmsg");
        } else if (static_cast<size_t>(ret) != buf->length + sizeof *buf) {
            throw FatalError("recvmsg(): Incorrect message length");
        }
        received = true;
    }

    template<typename T>
    void send(T& msg, void *data)
    {
        if (received) send(msg, data, from);
        else throw FatalError("Can't reply without receiving first!");
    }

    template<typename T>
    void send(T& msg, void *data, const string& path)
    { send(msg, data, addr_from_path(path)); }

    template<typename T>
    void send(T& msg, void *data, sockaddr_un&& addr)
    { send(msg, data, addr); }

    template<typename T>
    void send(T& msg, void *data, sockaddr_un& addr)
    {
        ssize_t ret;
        struct iovec buffers[] = {
            { &msg, sizeof msg },
            { data, msg.length }
        };

        struct msghdr header =
            { .msg_name = &addr
            , .msg_namelen = sizeof addr
            , .msg_iov = buffers
            , .msg_iovlen = 2
            , .msg_control = nullptr
            , .msg_controllen = 0
            , .msg_flags = 0
            };

        ret = sendmsg(sock, &header, 0);
        if (ret == -1) {
            throw ErrnoFatal("sendmsg");
        } else if (static_cast<size_t>(ret) != msg.length + sizeof msg) {
            throw FatalError("sendmsg(): Sent incorrect length!");
        }
        received = true;
    }
};

using namespace std;

class HistCache : virtual membuf, public ostream {
    bool fresh;
    char array[max_size];

  public:
    HistCache() : membuf(array), ostream(this), fresh(true) {}
    ~HistCache();

    operator void*()
    { return array; }

    size_t length()
    { return static_cast<size_t>(tellp()); }

    bool is_new()
    {
        bool result = fresh;
        fresh = false;
        return result;
    }

    bool should_reload()
    { return eof() || fail(); }

    void reset()
    { clear(); seekp(0); }
};

HistCache::~HistCache() {}

static void __attribute__((noreturn))
server(UnixSocket sock, ofstream&& history)
{
    int result;
    unordered_map<pid_t,HistCache> caches;

    Reply rep;
    Request *req = reinterpret_cast<Request*>(messageBuffer);

    result = daemon(0, 0);
    if (result == -1) throw ErrnoFatal("daemon");

    while (1) {
        /* receive command from new connection */
        sock.recv(req);

        switch (req->cmd) {
            /* Handle update */
            case Request::Command::update:
            {
                struct timeval time;
                result = gettimeofday(&time, nullptr);
                if (result == -1) throw ErrnoFatal("gettimeofday");

                if (req->length > 0) {
                    /* Generate history entry */
                    //FIXME: optimise
                    stringstream buf;
                    buf << '#' << time.tv_sec << "\n" << req->payload << "\n";
                    string output = buf.str();
                    history << output;
                    history.flush();

                    /* Append to all histories */
                    for(auto it = caches.begin(); it != caches.end(); ) {
                        it->second << output;
                        /* Purge full/errored caches */
                        if (it->second.should_reload()) {
                            it = caches.erase(it);
                        } else {
                            ++it;
                        }
                    }
                }

                /* Check whether to reload or update */
                auto& current = caches[req->origin];
                if (current.is_new()) {
                    rep.cmd = Reply::Command::reload_file;
                    rep.length = 0;
                } else {
                    rep.cmd = Reply::Command::new_hist;
                    rep.length = current.length();
                    if (rep.length) rep.length += 1;
                }

                /* Send result and close connection */
                sock.send(rep, current);
                current.reset();
                break;
            }
            case Request::Command::deregister:
                /* Remove from cache */
                caches.erase(req->origin);
                break;
            case Request::Command::shutdown:
                throw Terminate(EXIT_SUCCESS);
        }
    }
}

static void
launchServer(UnixSocket& sock, const string& sockPath, string path)
{
    int ret = fork();
    if (ret == -1) throw ErrnoFatal("fork");
    else if (ret == 0) {
        /* Child process */
        sock.close();

        path += "/.test_history";
        try {
            server(UnixSocket(sockPath), ofstream(path, ios_base::app));
        } catch (const ErrnoFatal& exc) {
            if (exc.error == EADDRINUSE && exc.func == "bind") {
                /* Either another server won the race, or left over socket. */
                throw Terminate(EXIT_SUCCESS);
            }
            throw;
        }
    }

    /* Wait for child to exit */
    if (waitpid(ret, &ret, 0) == -1) throw ErrnoFatal("waitpid");

    /* Child should return successful */
    if (ret != 0) throw Terminate();
}

static int
client(const string& path, pid_t pid, Request::Command cmd, char* data)
{
    ssize_t ret;
    UnixSocket sock(path + "/.sync-" + to_string(pid));
    string sockPath(path + "/.sync_history");
    Reply *rep = reinterpret_cast<Reply*>(messageBuffer);
    Request req { pid , cmd , data ? strlen(data) + 1 : 0};

    try {
        sock.send(req, data, sockPath);
    } catch (const ErrnoFatal& exc) {
        if (exc.error == ENOENT && exc.func == "sendmsg") {
            /* No server socket! */
            launchServer(sock, sockPath, path);
            /* Retry after launching server */
            sock.send(req, data, sockPath);
        } else {
            /* Rethrow error */
            throw;
        }
    }

    /* Only wait for reply when updating */
    if (cmd != Request::Command::update) return 0;

    sock.recv(rep);
    switch (rep->cmd) {
        case Reply::Command::new_hist:
            if (rep->length) {
                ret = write(STDOUT_FILENO, rep->payload, rep->length);
                if (ret == -1) {
                    throw ErrnoFatal("write");
                } else if (static_cast<size_t>(ret) != rep->length) {
                    throw FatalError("write(): Didn't write full history!");
                }
            }
            break;
        case Reply::Command::reload_file:
            /* Indicate history reload */
            return 2;
    }
    return 0;
}

int main(int argc, char **argv)
{
    Request::Command cmd;
    pid_t pid = 0;
    char *data = nullptr;
    struct passwd *passwdEnt;

    try {
        if ((argc == 3 || argc == 4) && !strcmp(argv[1], "update")) {
            cmd = Request::Command::update;
            pid = stoi(argv[2]);
            if (argc == 4) data = argv[3];
        } else if (argc == 3 && !strcmp(argv[1], "deregister")) {
            cmd = Request::Command::deregister;
            pid = stoi(argv[2]);
        } else if (argc == 2 && !strcmp(argv[1], "shutdown")) {
            cmd = Request::Command::shutdown;
        } else {
            throw Terminate();
        }

        passwdEnt = getpwuid(getuid());
        if (passwdEnt == nullptr) throw ErrnoFatal("getpwduid");

        string path = string(passwdEnt->pw_dir);
        return client(path, pid, cmd, data);
    } catch (const FatalError& exc) {
        /* Program exit due to unexpected errors */
        cerr << exc.what() << endl;
        exit(EXIT_FAILURE);
    } catch (const Terminate& exc) {
        /* Controlled program exit. Allows RAII to unlink sockets. */
        exit(exc.status);
    } catch (const exception& exc) {
        /* Standard library errors */
        cerr << exc.what() << endl;
        exit(EXIT_FAILURE);
    }
    return EXIT_SUCCESS;
}
