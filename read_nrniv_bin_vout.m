function v = read_nrniv_bin_vout(filename,ncoords,ntime)
% v = read_nrniv_bin_vout(filename,ncoords)
% v = read_nrniv_bin_vout(filename,ncoords,ntime)
%
% Reads binary files from nrniv output as in the modified
% amatrudo *hoc models.
%
% INPUTS:
% filename: string of filename
% ncoords: number of neuron coordinates that contains
%     intracellular potentials
% ntime: the number of time points for each neuron coordinate.
%     The script runs a bit faster with this entry
%
% OUTPUTS:
% v: ncoords-by-ntime matrix of the intracellular voltage
%     time course for each neuron coordinate.
%     
% Brian Goodwin
%
% 2013-08-22 - v1 (working version)
%
% NOTE:
% 1) The binary files output the first voltage value as a
% bogus value (~1e-313). Therefore, there are 152 values for
% the intracellular voltage for each neuron, and the first
% value needs to be discarded (151 resulting time points).
%
% 2) For amatrudo_goodwin_mod *hoc file:
% The binary files contain intracellular voltage of each
% compartment for 152 time points (from 10ms:0.05ms:17.5ms).
% The 10mm axon model has 491 compartments that the
% intracellular voltage data was recorded from. In this case,
% each voltage output data should be reshaped to a 491x151
% matrix, where the columns ((:,j)) are intracellular voltage
% time points and the rows ((i,:)) indicate the neuron
% compartment.
%
%
% VERSION NOTES
%

fid = fopen(filename,'r');
v = fread(fid,'double');
fclose(fid);
if nargin>2
    v = reshape(v,ntime,ncoords);
    v = v(2:ntime,:).';
    return
else
    v = reshape(v,[],ncoords);
    v = v(2:end,:).';
    return
end