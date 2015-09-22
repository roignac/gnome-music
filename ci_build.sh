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

if [ "$PR" != "false" ]; then
    make
else
    echo "Not a PR, making a new nightly release in COPR"
    make distcheck

    RELEASE=$(git describe --exact-match HEAD)
    if [ -n "$RELEASE" ]; then
        echo "Uploading new release $RELEASE to master.gnome.org"
        make distcheck
        FILENAME=gnome-music-$RELEASE.tar.xz
        echo "Built tarball $FILENAME"
        # TODO: copy tarball to master.gnome.org and run ftp-install there
    else
        echo "Building a nightly SRPM and uploading to copr"
        sh ci_make_nightly_copr.sh || true  # don't fail the build if nightly cannot be submitted
    fi
fi