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
[ ! -f $BUILD_DIR ] && mkdir -p $BUILD_DIR

install_ncurses() {
    mkdir $BUILD_DIR/ncurses-vim-build
    cd $BUILD_DIR/ncurses-vim-build
    wget 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz'
    tar -xf ncurses-6.2.tar.gz
    rm ncurses-6.2.tar.gz
    cd ncurses-6.2
    ./configure
    make
    make install
    cd -2
    rm -r $BUILD_DIR/ncurses-vim-build
}

# Notes:
# Dependancies:
#    gcc -std=gnu99 -Iproto -MM <filename> | sed 's/ \\//g' | tr -d '\n'

if [ -n "$@" ]; then
    echo "$@"
    "$@"
    return
fi
echo 'hello'

make clean distclean

cflags='-O3 -fno-strength-reduce -Wall -fstack-protector-strong -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'
ldflags='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed'

features='--disable-gui --disable-gpm --with-x=no --disable-sysmouse --disable-netbeans'

CFLAGS=$cflags LDFLAGS=$ldflags ./configure $features

