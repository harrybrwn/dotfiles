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

set -e

make clean distclean

cflags='-O3 -fno-strength-reduce -Wall -fstack-protector-strong -Wformat -Werror=format-security -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1'
ldflags='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed'

features='--disable-gui --disable-gpm --with-x=no --disable-sysmouse --disable-netbeans'

CFLAGS=$cflags LDFLAGS=$ldflags ./configure $features

