#!/bin/sh

# This is the script I use for configuring my
# custom vim build
#
# Usage:
#   $ git clone https://github.com/vim/vim
#   $ cd vim
#   $ sh ~/.vim/build.sh install
#

# Issues:
#   - No Terminal Library: install ncurses-dev
#       - function is in the build script to install from source

set -e

BUILD_DIR="$HOME/.local/rpi/vim"
NCURSES_VERSION='6.2'
[ ! -f $BUILD_DIR ] && mkdir -p $BUILD_DIR

DEFAULT_BUILD_NAME="vim-custom"

get_package_dir() {
    local build_name
    if [ -z "$1" ]; then
        build_name="$DEFAULT_BUILD_NAME"
    else
        build_name="$1"
    fi

    echo "$HOME/.vim/build/$build_name"
}

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

get_debian_package() {
    local name=$1
    if [ -z "$name" ]; then
        return 1
    fi

    local origin="$(pwd)"
    mkdir $name && cd $name
    apt-get download $name

    local archive=$name*
    if [ -z "$archive" ]; then
        echo 'no archive'
        return 1
    fi
    ar x $archive
    rm $archive

    mkdir data control
    tar -xf data.tar.xz -C ./data
    tar -xf control.tar.xz -C ./control
    rm data.tar.xz control.tar.xz

    cd $origin
}

get_packages() {
    #sudo add-apt-repository ppa:jonathonf/vim --yes
    sudo apt-get update
    local data_dir="$(get_package_dir)/../data"
    [ -d $data_dir ] && rm -r $data_dir
    mkdir $data_dir

    for pkg in $*; do
        [ -d "$pkg" ] && echo "'$pkg' already exists" && return 1
        mkdir $pkg && cd $pkg
        apt-get download $pkg

        local archive=$pkg*
        if [ -z "$archive" ]; then
            echo 'no archive'
            return 1
        fi
        ar x $archive
        rm $archive

        tar -xf data.tar.xz -C "$data_dir"
        cd ..
        rm -r $pkg
    done
}

build() {
}

# Notes:
# Dependancies:
#    gcc -std=gnu99 -Iproto -MM <filename> | sed 's/ \\//g' | tr -d '\n'

install() {
    local build_name="$DEFAULT_BUILD_NAME"
    local package_dir="$(get_package_dir $build_name)"
    local prefix="$package_dir/usr/local"

    local cflags='-O3 -fno-strength-reduce -Wall -fstack-protector-strong -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'
    local ldflags='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed'

    # lemme just login to root real quick
    echo 'running sudo:'
    sudo ls > /dev/null

    make clean distclean

    if ! dpkg -l | grep "$buid_name" > /dev/null; then
        echo 'removing vim-custom'
        sudo apt-get remove vim-custom -y
    fi

    CFLAGS=$cflags LDFLAGS=$ldflags ./configure \
        --disable-rightleft \
        --disable-gui       \
        --disable-gpm       \
        --with-x=no         \
        --disable-sysmouse  \
        --disable-netbeans  \
        --disable-xsmp      \
        --disable-autoservername \
        --disable-selinux   \
        --disable-smack     \
        --disable-darwin    \
        --disable-xim       \
        --enable-python3interp=yes \
        --with-python-command=python3.7 \
        --prefix=$prefix    \
        --with-global-runtime='/usr/local/share/vim/vim82,/usr/local/share/vim'

    # TODO: make this a little more dynamic and less hard-coded
    make -j 8 VIMRCLOC=/usr/local/share/vim/vim82
    make install

    get_packages 'vim-common' 'vim-runtime' 'vim'
    cp -r "$package_dir/../data/usr/share/applications" "$package_dir/usr/local/applications"
    cp -r "$package_dir/../data/etc" "$package_dir"

    [ ! -d "$package_dir/DEBIAN" ] && mkdir -p "$package_dir/DEBIAN"
    cat > "$package_dir/DEBIAN/control" <<- EOF
Package: $build_name
Version: 1.0
Section: custom
Architecture: all
Maintainer: $(git config --global --get user.name) <$(git config --global --get user.email)>
Essential: no
Description: This is my custom vim build. It may not work on all operating systems.

EOF
    # Add this for dependancies
    # Depends: vim-common (= 2:8.2.1897-0york0~18.04), vim-runtime (= 2:8.2.1897-0york0~18.04)
    dpkg-deb -b $package_dir
    local package="$package_dir.deb"

    echo "sudo apt-get install -f $package"
    sudo apt-get install -f $package
}

if [ -z "$*" ]; then
    echo 'No arguments'
    exit 1
fi

"$@"
