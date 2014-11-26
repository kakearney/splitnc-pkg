function splitnc(ncfile, shfile)
%SPLITNC Creates script to split netcdf file into one file per variable
%
% splitnc(ncfile, shfile)
%
% Creates a shell script that call NCO library utilities to split a netcdf
% file into many small files, with one variable per file.  Can be usefull
% to split up very large files this way.
%
% Input variables:
%
%   ncfile: netcdf file
%
%   shfile: name for shell script file

% Copyright 2010 Kelly Kearney


% Setup

Info = nc_info(ncfile);
vars = {Info.DataSet.Name}';

fid = fopen(shfile, 'wt');
fprintf(fid, '#!/bin/bash\n');
fprintf(fid, 'echo "Splitting %s"\n', ncfile);

ncfilebase = regexprep(ncfile, '\.nc$', '');

% Coordinate variables

fprintf(fid, 'echo "  Coordinates"\n');
fprintf(fid, 'ncks -O -c %s %s.coords.nc\n', ncfile, ncfilebase);

% Other variables

for iv = 1:length(vars)
    if ~nc_iscoordvar(ncfile, vars{iv})
        fprintf(fid, 'echo "  %s"\n', vars{iv});
        fprintf(fid, 'ncks -O -C -v %s %s %s.%s.nc\n', vars{iv}, ncfile, ncfilebase, vars{iv});
    end
end

fclose(fid);
