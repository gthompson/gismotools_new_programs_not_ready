function ws = superpose(w)
[snum enum]=gettimerange(w);
snum=min(snum);
enum=max(enum);

% pad the waveform objects to same length
for i=1:numel(w)
    w(i) = pad(w(i), snum, enum, 0);
end

% sum the waveform objects
z = get(w(i), 'data');
for i=2:numel(w)
    y = get(w(i), 'data');
    if numel(z)>numel(y)
        z = z + [y; 0];
    elseif numel(z)<numel(y)
        z = z + y(1:numel(z));
    else
        try
        	z = z + y;
        catch
            size(y)
            size(z)
        end
    end
end

ws = w(1);
ws = set(ws, 'data', z);

    

