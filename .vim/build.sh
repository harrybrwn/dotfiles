#/bin/sh

# This is the script I use for configuring my
# custom vim build
#
# Usage:
#   $ git clone https://github.com/vim/vim
#   $ cd vim
#   $ sh ~/.vim/build.sh
#

# Issues:
#   - No Terminal Library: install ncurses-dev
#       - function is in the build script to install from source

set -e

BUILD_DIR="$HOME/.local/rpi/vim"
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


# Notes:
# Dependancies:
#    gcc -std=gnu99 -Iproto -MM <filename> | sed 's/ \\//g' | tr -d '\n'

build_name="vim-custom"

package_dir="$HOME/.vim/build/$build_name"
prefix="$package_dir/usr/local"
cflags='-O3 -fno-strength-reduce -Wall -fstack-protector-strong -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'
ldflags='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed'

make clean distclean

CFLAGS=$cflags LDFLAGS=$ldflags ./configure \
    --disable-rightleft \
    --disable-gui       \
    --disable-gpm       \
    --with-x=no         \
    --disable-sysmouse  \
    --disable-netbeans  \
    --disable-xsmp      \
    --disable-channel   \
    --disable-autoservername \
    --disable-selinux   \
    --disable-smack     \
    --disable-darwin    \
    --disable-xim       \
    --prefix=$prefix    \
    --with-global-runtime='/usr/local/share/vim/vim82,/usr/local/share/vim'

# TODO: make this a little more dynamic and less hard-coded
make -j 8 VIMRCLOC=/usr/local/share/vim/vim82
make install

[ ! -d "$package_dir/DEBIAN" ] && mkdir -p "$package_dir/DEBIAN"

cat > "$package_dir/DEBIAN/control" <<- EOF
Package: $build_name
Version: 1.0
Section: custom
Architecture: all
Essential: no
Maintainer: $(git config --global --get user.name) <$(git config --global --get user.email)>
Description: This is my custom vim build. It may not work on all operating systems.

EOF

dpkg-deb -b $package_dir

echo "sudo apt-get install -f $package_dir.deb"
sudo apt-get install -f $package_dir.deb
