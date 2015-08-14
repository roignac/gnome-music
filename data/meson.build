gnome = import('gnome')

# Compile schemas
gnome.compile_schemas()

# Desktop file
# Appdata
# Man page

# Make a list of icons
icon_names = []

icon_themes = ['hicolor', 'HighContrast']
icon_sizes = ['16', '22', '32', '48', '256']

foreach theme : icon_themes
    foreach size: icon_sizes
        icon_names = icon_names + ['icons/' + theme + '/' + size + 'x' + size + '/apps/gnome-music.png']
    endforeach
endforeach
icon_names = icon_names + ['icons/gnome-music.svg']