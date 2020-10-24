#/bin/sh

scan='/media/pi/Name of HDD/Movies/'
file='scanMKV.txt'

find "$scan" -name '*.mkv' -type f -exec bash -c 'echo "{}"; mkvinfo "{}" | grep "H.264-Profil"' \; > "$file"
