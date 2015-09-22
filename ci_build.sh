#/bin/sh
set -x

cd /mnt

# Dependencies
dnf install -q -y python3 gobject-introspection-devel gtk3-devel \
                  libmediaart-devel grilo-devel

# Other boring stuff
dnf install -q -y gnome-common make which intltool git xz rpm-build

git submodule update --init
./autogen.sh

RELEASE=$(git describe --exact-match HEAD)

if [ -z "$RELEASE" ]; then
    if [ "$PR" -e "false" ]; then
        echo "Not a PR, making a new nightly release in COPR"
        make distcheck

        export VERSION=$(git describe --abbrev=0 --tags)
        export RELEASE="$(date +"%Y%m%d")git$(git rev-parse --short=8 HEAD)"
        echo "Making a fedora copr build"
        mkdir -p /root/rpmbuild/SOURCES
        cp gnome-music-*.tar.xz /root/rpmbuild/SOURCES/gnome-music-$VERSION.tar.xz
        cd /root
        git clone git://pkgs.fedoraproject.org/gnome-music.git
        cd gnome-music
        sed -i "s,Version:.*,Version: $VERSION," gnome-music.spec
        sed -i "s,Release:.*,Release: $RELEASE%{?dist}," gnome-music.spec
        rpmbuild -bs gnome-music.spec
        ls -la /root/rpmbuild/SRPMS/*.src.rpm
        # TODO: copy srpm to a public space and start copr build
    else:
        make
    fi

else
    if [ "$PR" -e "false" ]; then
        echo "New release: $RELEASE"
        make distcheck
        FILENAME=gnome-music-$RELEASE.tar.xz
        echo "Built tarball $FILENAME"
        # TODO: copy tarball to master.gnome.org and run ftp-install there
    fi
fi