# See https://github.com/mesonbuild/meson/issues/226
project('gnome-music', 'c')

version = '3.17.5'

# Configuration params
conf = configuration_data()
conf.set('PACKAGE_VERSION', version)
conf.set('PACKAGE_URL', 'https://wiki.gnome.org/Apps/Music')

# Dependencies check
py3 = find_program('python3')
gobject = dependency('gobject-2.0')
gtkdep = dependency('gtk+-3.0', version : '>=3.13.2')
libmediaart = dependency('libmediaart-2.0')
grilo = dependency('grilo-0.2', version : '>=0.2.6')

subdir('data')

gnome = import('gnome')
myres = gnome.compile_resources(
    'gnome-music', 'data/gnome-music.gresource.xml',
    source_dir : 'data',
    c_name : 'gnome-music')
