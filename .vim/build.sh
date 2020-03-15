#/bin/sh

# This is the script I use for configuring my
# custom vim build
#
# Usage:
#   $ cd <vim-repo>
#   $ sh ~/.vim/build.sh
#   $ make
#   $ make install
#

# Issues:
#   - No Terminal Library: install ncurses-dev
#       - function is in the build script to install from source

set -e

BUILD_DIR="$HOME/.local/vim"
NCURSES_VERSION='6.2'
[ ! -f $BUILD_DIR ] && mkdir -p $BUILD_DIR

install_ncurses() {
    local prefix=$1
    local origin="$(pwd)"
    mkdir $BUILD_DIR/ncurses-vim-build
    cd $BUILD_DIR/ncurses-vim-build
    wget "https://ftp.gnu.org/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz"
    tar -xf ncurses-$NCURSES_VERSION.tar.gz
    rm ncurses-$NCURSES_VERSION.tar.gz
    cd ncurses-$NCURSES_VERSION
    ./configure --prefix=$prefix
    make
    make install
    cd $origin
    # rm -r $BUILD_DIR/ncurses-vim-build
}

install_ncurses_local() {
    install_ncurses $HOME/.local/vim
}

# install_ncurses_local
# exit

# Notes:
# Dependancies:
#    gcc -std=gnu99 -Iproto -MM <filename> | sed 's/ \\//g' | tr -d '\n'

make clean distclean

cflags='-O3 -fno-strength-reduce -Wall -fstack-protector-strong -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'
ldflags='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed'

features='--disable-gui --disable-gpm --with-x=no --disable-sysmouse --disable-netbeans'

CFLAGS=$cflags LDFLAGS=$ldflags ./configure --prefix=$HOME/.local --includedir=$BUILD_DIR/include --libdir=$BUILD_DIR/lib $features
make -j 8

