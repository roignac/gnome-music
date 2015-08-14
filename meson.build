# See https://github.com/mesonbuild/meson/issues/226
project('gnome-music', 'c')

version = '3.17.5'

# Configuration params
conf = configuration_data()
conf.set('PACKAGE_VERSION', version)
conf.set('PACKAGE_URL', 'https://wiki.gnome.org/Apps/Music')

message('Looking for dependencies')
py3 = find_program('python3')
glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
gir = dependency('gobject-introspection-1.0')
gmod = dependency('gmodule-2.0')
gtk = dependency('gtk+-3.0', version : '>=3.13.2')
libmediaart = dependency('libmediaart-2.0')
grilo = dependency('grilo-0.2', version : '>=0.2.6')

subdir('data')
subdir('po')
subdir('help')

message('Generate libgd')

libsources = [
    'libgd/libgd/gd-types-catalog.c', 'libgd/libgd/gd-types-catalog.h',
    'libgd/libgd/gd-main-view-generic.c', 'libgd/libgd/gd-main-view-generic.h',
    'libgd/libgd/gd-styled-text-renderer.c', 'libgd/libgd/gd-styled-text-renderer.h',
    'libgd/libgd/gd-two-lines-renderer.c', 'libgd/libgd/gd-two-lines-renderer.h',
    'libgd/libgd/gd-revealer.c', 'libgd/libgd/gd-revealer.h',
    'libgd/libgd/gd-tagged-entry.c', 'libgd/libgd/gd-tagged-entry.h',
]

libgdgir = shared_library('libgd', libsources,
    dependencies : [glib, gtk, gobject, gir, gmod])

gnome.generate_gir(
    libgdgir,
    sources : libsources,
    nsversion : '1.0',
    namespace : 'Gd',
    symbol_prefix : 'gd_',
    identifier_prefix : 'Gd',
    includes : ['GObject-2.0', 'Gio-2.0', 'Gtk-3.0'],
    install : true
)