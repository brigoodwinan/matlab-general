function c = readsectionwisecomsoloutput(filename)
% c = readsectionwisecomsoloutput(filename)
%
% Goodwin,Brian
%
% 2014-04-04 - v2
%
% Reads a "Section Wise" data output from COMSOL.
%
% COMSOL data must be exported as "from data source" for this function to
% work. The output is a mesh with data values at the nodes.
%
% Converted to a function at version 2 where the output is a cell
% containing the following:
%
% {Coordinates, Elements, Expressions...}

% Used for debugging:
% filename = '/Users/1773goodwib/Documents/Project_SINGLE_NEURON_MODEL/microcoil_offcenter_tmspulse_solutions/straightaxon_microcoil_offcenter_FourierComponent_2.dat';

fid = fopen(filename,'r');

fgetl(fid);
fgetl(fid);
fgetl(fid);
out.dim = fgetl(fid);
out.dim = str2double(out.dim(22:end));
out.numnodes = fgetl(fid);
out.numnodes = str2double(out.numnodes(22:end));
out.numelem = fgetl(fid);
out.numelem = str2double(out.numelem(22:end));
out.expressions = fgetl(fid);
out.expressions = str2double(out.expressions(22:end));
c = cell(1,out.expressions+2);
fgetl(fid);
fgetl(fid);
fgetl(fid);
c{1} = fscanf(fid,repmat('%f ',1,out.dim),[out.dim,out.numnodes])';
fgetl(fid);
c{2} = fscanf(fid,repmat('%f ',1,out.dim+1),[out.dim+1,out.numelem])';

for k = 1:out.expressions
    junk = fgetl(fid);
    if isempty(junk)
        fgetl(fid);
    end
    tmp = textscan(fid,'%f',out.numnodes);
    c{k+2} = tmp{1};
    clearvars tmp
end
