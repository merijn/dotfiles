from os import chdir, system

def bitbucket(ui, repo, args=None, **kwargs):
    url = ui.paths["default"].url
    if args == "push" and url.host == "github.com" and "bitbucket" in ui.paths:
        if repo.url().startswith("file:"):
            chdir(repo.url().strip("file:"))
            system("hg push bitbucket")
    return False
