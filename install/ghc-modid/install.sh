FILE="ghc-modid/install.sh"

if ! command -v cabal >/dev/null; then
    printf "cabal not found, skipping Haskell config install.\n" 1>&2
    return 0
fi

install_repo "install/ghc-modid" "git+https://github.com/merijn/ghc-modid"

cd ./install/ghc-modid/ghc-modid
printf "Building ghc-modid.\n" 1>&2
cabal new-build >/dev/null 2>&1
printf "Installing ghc-modid.\n" 1>&2
cp dist-newstyle/build/x86_64-linux/ghc-8.0.2/ghc-modid-0.1.0/c/ghc-modid/opt/build/ghc-modid/ghc-modid ~/.bin/
cd - >/dev/null 2>&1
