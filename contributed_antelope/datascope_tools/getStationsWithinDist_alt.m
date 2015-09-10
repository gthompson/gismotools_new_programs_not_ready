function station = getStationsWithinDist(lon, lat, distdegrees)
% station = getStationsWithinDist(lon, lat, distdegrees)
% gets all stations from master stations database within dist degrees of point described by [lon, lat]
% station = getStationsWithinDist('Okmok', [], distdegrees) gets stations
% within distdegrees degrees of 'Okmok'
global paths verbose;

if isstr(lon)
    [lon, lat] = readavovolcs(lon, '/avort/oprun/pf/avo_volcs.pf');
end

dbstations = 'dbmaster/master_stations';
db = dbopen(dbstations, 'r');
db = dblookup_table(db, 'site');
db = dbsubset(db, sprintf('offdate == NULL'));
db2 = dblookup_table(db, 'sitechan');
db2 = dbsubset(db2, 'chan=~/.*HZ/  && offdate == NULL');
db2 = dbjoin(db, db2);
latitude = dbgetv(db2, 'lat');
longitude = dbgetv(db2, 'lon');
elev = dbgetv(db2, 'elev');
staname = dbgetv(db2, 'sta');
channame = dbgetv(db2, 'chan');
dbclose(db);

numstations = length(latitude);
for c=1:length(latitude)
	%stadist(c) = calculate_distance(lon, lat, longitude(c), latitude(c));
    stadist(c) = distance(lat, lon, latitude(c), longitude(c));
end

% order the stations by distance
[y,i]=sort(stadist);
c=1;
while ((c<=numstations) && (stadist(i(c)) < distdegrees))
	station(c).name = staname{i(c)};
	station(c).channel = channame{i(c)};
	station(c).site.lon = longitude(i(c));
	station(c).site.lat = latitude(i(c));
	station(c).site.elev = elev(i(c));
	station(c).distance = stadist(i(c));
	c = c + 1;
end

