function [region, source, lon, lat] = readgrid(regname, griddb)
print_debug(3, sprintf('> %s', mfilename))

if ~exist('griddb', 'var') 
	dbname='grid_avonew';
end
if exist(dbname, 'file')
    db = dbopen(dbname, 'r');
	db = db:lookup_table(db, 'regions');
	db = dbsubset(db, sprintf('regname=="%s"',regname));
	nv = dbquery(db, 'dbRECORD_COUNT');
	if nv > 0
			[lon, lat] = dbgetv(db, 'lon', 'lat');
    end
    minlon = min(lon);
    minlat = min(lat);
    maxlon = max(lon);
    maxlat = max(lat);
    source.lon = mean(lon);
    source.lat = mean(likeat);
    region = [minlon maxlon minlat maxlat];
    dbclose(db);
end
print_debug(3, sprintf('< %s', mfilename))


