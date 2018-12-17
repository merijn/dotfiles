from urlparse import urlparse

def dasremote(ui, repo, args=None, **kwargs):
    if kwargs["pats"]:
        path = kwargs["pats"][0]
    else:
        path = ""

    if kwargs["hooktype"] == "pre-push":
        path = ui.expandpath(path, "default-push")

    path = ui.expandpath(path, "default")
    if path and urlparse(path).hostname.startswith("das"):
        kwargs["opts"]["remotecmd"] = "/home/mverstra/opt/bin/hg"
    elif path and urlparse(path).hostname.startswith("astron"):
        kwargs["opts"]["remotecmd"] = "/home/mverstra/opt/bin/hg"
    return False
