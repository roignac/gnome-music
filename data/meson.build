gnome = import('gnome')

message('Compiling resources')
myres = gnome.compile_resources(
    'gnome-music', 'gnome-music.gresource.xml',
    source_dir : '.',
    c_name : 'gnome-music')


message('Compiling schemas')
gnome.compile_schemas()

message('Making a .desktop file')

message('Preparing appdata')

message('Compiling a man page')

message('Making a list of icons')
icon_names = []

icon_themes = ['hicolor', 'HighContrast']
icon_sizes = ['16', '22', '32', '48', '256']

foreach theme : icon_themes
    foreach size: icon_sizes
        icon_names = icon_names + ['icons/' + theme + '/' + size + 'x' + size + '/apps/gnome-music.png']
    endforeach
endforeach
icon_names = icon_names + ['icons/gnome-music.svg']