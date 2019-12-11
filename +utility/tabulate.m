function tabulate(fieldn, data, caption, l)
    if isstruct(data)
        if ~isfield(data, fieldn)
            l.info('%s not found in report data', fieldn);
            return;
        end

        l.info(caption);
        tabulate([data.(fieldn)]);
    else
        if ~ismember(fieldn, data.Properties.VariableNames)
            l.info('%s not found in report data', fieldn);
            return;
        end

        l.info(caption);
        tabulate(data.(fieldn));
    end
end

