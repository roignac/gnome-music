#/bin/sh
set -x

cd /mnt

# Dependencies
dnf install -q -y python3 gobject-introspection-devel gtk3-devel \
                  libmediaart-devel grilo-devel

# Other boring stuff
dnf install -q -y gnome-common make which intltool git xz

git submodule update --init
./autogen.sh

RELEASE=$(git describe --exact-match HEAD)

if [ -z "$RELEASE" ]; then
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
else
    echo "New release: $RELEASE"
    make distcheck
    FILENAME=gnome-music-$RELEASE.tar.xz
    echo "Filename: $FILENAME"
    mkdir -p /root/.ssh
    cat << EOF >> /root/.ssh/config
    Host *.gnome.org
        User $SSH_USER
        Compression yes
        CompressionLevel 3
        ControlPersist 5m
        StrictHostKeyChecking no
        IdentityFile /ssh/id_rsa

    ControlMaster auto
    ControlPath /tmp/%r@%h:%p
    ControlPersist yes
EOF
    scp -vvvvv $FILENAME master.gnome.org
    #ssh -t master.gnome.org "ftpadmin install gnome-music-$RELEASE.tar.xz"
fi