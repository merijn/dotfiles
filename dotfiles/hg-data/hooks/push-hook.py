from os import chdir, system

def stripPrefix(s, prefix):
    n = 0
    if s.startswith(prefix):
        n = len(prefix)
    return s[n:]

def bitbucket(ui, repo, args=None, **kwargs):
    url = ui.paths["default"].url
    if args == "push" and url.host == "github.com" and "bitbucket" in ui.paths:
        if repo.url().startswith("file:"):
            chdir(stripPrefix(repo.url(), "file:"))
            system("hg push bitbucket")
    return False
