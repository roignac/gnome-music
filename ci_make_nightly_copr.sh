#/bin/sh
export VERSION=$(git describe --abbrev=0 --tags)
export RELEASE="$(date +"%Y%m%d")git$(git rev-parse --short=8 HEAD)"
echo "Making a fedora copr build"
echo "VERSION=$VERSION"
echo "VERSION=$RELEASE"
mkdir -p /root/rpmbuild/SOURCES
cp gnome-music-*.tar.xz /root/rpmbuild/SOURCES/gnome-music-$VERSION.tar.xz
cd /root
git clone git://pkgs.fedoraproject.org/gnome-music.git
cd gnome-music
sed -i "s,Version:.*,Version: $VERSION," gnome-music.spec
sed -i "s,Release:.*,Release: $RELEASE%{?dist}," gnome-music.spec
rpmbuild -bs gnome-music.spec
SRPM=`ls /root/rpmbuild/SRPMS/*.src.rpm`
echo "Got SRPM: $SRPM"


# Upload to my host
mkdir -p ~/.ssh
cp /mnt/id_rsa ~/.ssh
chmod 600 ~/.ssh/id_rsa
scp $SRPM vrutkovs@chaturan.ga:~/srpms
URL="http://chaturan.ga:8000/$SRPM"

echo "Pushing $URL to COPR"