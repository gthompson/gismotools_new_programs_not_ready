function stats = statistics(w, newSamplingPeriod)
% Glenn Thompson, November 12, 2014
% Also look at waveform_clean, waveform_nonempty, waveform_fillempty
% floorMinute
% what about waveform_soh, waveform_qualitycheck?
    w = clean(w);
    stats=[];
    for c=1:length(w)
        oldFs = get(w(c), 'freq');
        if ~strcmp(get(w(c), 'units'), 'nm') & ~strcmp(get(w(c), 'units'), 'counts')
            stats(c).Vmax = makestat(w(c), 'absmax', newSamplingPeriod);
            stats(c).Vmedian = makestat(w(c), 'absmedian', newSamplingPeriod);
            stats(c).Vmean = makestat(w(c), 'absmean', newSamplingPeriod);
            e = energy(w(c)); 
            stats(c).Energy = e.makestat('absmean', newSamplingPeriod); 
            w(c) = integrate(w(c));
        end

        if strcmp(get(w(c), 'units'), 'nm')
            stats(c).Dmax = makestat(w(c), 'absmax', newSamplingPeriod);
            stats(c).Dmedian = makestat(w(c), 'absmedian', newSamplingPeriod);
            stats(c).Dmean = makestat(w(c),'absmean', newSamplingPeriod);
            stats(c).Drms = makestat(w(c), 'rms', newSamplingPeriod);
        end

        length(get(w(c),'data'))
        % compute spectrogram, get back S, F, T
        [S,F,T]=spectrogram(get(w(c),'data'), 1024, 512, 0.5:0.1:15.0, get(w(c),'freq'));

        A=abs(S);
        [Amax,i] = max(A);
        peakf = F(i);
        meanf = (F' * A)./sum(A);
        dnum = unique(matlab_extensions.floorminute(T/86400));
        for k=1:length(dnum)
            p = find(matlab_extensions.floorminute(T/86400) == dnum(k));
            %disp(  sprintf('%s %d',datestr(dnum(k)), numel(p) ));
            stats(c).peakf(k) = nanmean(peakf(p));
            stats(c).meanf(k) = nanmean(meanf(p));
        end
        stats(c).dnum = dnum;
    end
end

function s=makestat(w, method, newSamplingPeriod)
    r = rsam(w, method, newSamplingPeriod);
    s = r.data;
end

