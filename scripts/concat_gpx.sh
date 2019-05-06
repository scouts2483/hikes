# Script for concatenating all gpx files (recursively) to generate one huge gpx file for goggle mymaps

echo '<?xml version="1.0" encoding="utf-8"?>'
echo '<gpx version="1.1" creator="NCScouts" xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">'


find docs -mindepth 2 -name '*.gpx' | grep -v MtBarneyCollatedTracks | sort > scripts/gpx_filenames.txt

for file in `cat scripts/gpx_filenames.txt`; do
    sed -n '/<trk>/,/<\/trk>/p' $file;
done


echo '</gpx>'

