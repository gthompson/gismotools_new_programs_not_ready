function w = load_seisan_waveform_database(snum, enum, db)
% LOAD_SEISAN_WAVEFORM_DATABASE Load waveform data from the MVO Seisan
% Seisan databases for MVOE and DSNC
%   w = load_seisan_waveform_database(snum, enum, db)
%
%   Inputs:
%       db: the 5 character name of a seisan database, e.g. MVOE_ or
%                   DSNC_ (otherwise both)
%       snum:     the start time as a datenum
%       enum:     the end time as a datenum
%
%   Outputs:
%       w:      a vector of waveform objects
%
%   See also: waveform, scnlobject, datasource, waveform>extract,
%               waveform>combine, waveform/private/load_seisan
%
%   Glenn Thompson 2014/10/20
scnl = scnlobject('*','*');
if ~exist('db','var')
    dbpath1 = sprintf('/raid/data/seisan/WAV/%s', 'MVOE_');
    dbpath2 = sprintf('/raid/data/seisan/WAV/%s', 'DSNC_');
    ds1 = datasource('seisan', sprintf('%s/%%4d/%%02d/%%4d-%%02d-%%02d-%%02d*',dbpath1),'year','month','year','month','day','hour')
    ds2 = datasource('seisan', sprintf('%s/%%4d/%%02d/%%4d-%%02d-%%02d-%%02d*',dbpath2),'year','month','year','month','day','hour')
    w1 = waveform(ds1, scnl, snum-40/1440, enum);
    w2 = waveform(ds2, scnl, snum-40/1440, enum);
    w = combine([w1;w2]);
else
    dbpath = sprintf('/raid/data/seisan/WAV/%s', db);
    ds = datasource('seisan', sprintf('%s/%%4d/%%02d/%%4d-%%02d-%%02d-%%02d*',dbpath),'year','month','year','month','day','hour')
    w = waveform(ds, scnl, snum-40/1440, enum); 
end

try
    w = extract(w, 'TIME', snum, enum);
end


