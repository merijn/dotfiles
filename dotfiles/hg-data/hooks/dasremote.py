from urlparse import urlparse

def dasremote(ui, repo, args=None, **kwargs):
    path = ""
    paths = kwargs["pats"]
    if paths:
        path = paths[0]
    url = urlparse(ui.expandpath(path, "default"))

    if url.hostname.startswith("das"):
        kwargs["opts"]["remotecmd"] = "/home/mverstra/opt/python/bin/hg"
    return False
