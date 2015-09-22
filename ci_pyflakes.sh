#/bin/sh
set -x

cd /mnt

dnf install -q -y python3-pyflakes
python3-pyflakes .