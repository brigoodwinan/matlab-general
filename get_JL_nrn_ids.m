function ids = get_JL_nrn_ids(s)
% ids = get_JL_nrn_ids('coil group name')
% ids = get_JL_nrn_ids(GoupNumber)
%
% Input the string of the coil group name and the output is a vector of the
% neuron indices.
%
% USAGE:
% ids = get_JL_nrn_ids('bi72m1'); or ids = get_JL_nrn_ids(5);
% nu_mono = tholds(ids,2);
% nu_bi = tholds(ids,3);
%
% NEURON Numbers:
% bi61m1: nrns 1 - 6111
% bi61m2: nrns 6112 - 12222
% bi61m3: nrns 12223 - 18333
% bi61m4: nrns 18334 - 24444
% bi72m1: nrns 24445 - 30555
% bi72m2: nrns 30556 - 36666
% bi72m3: nrns 36667 - 42777
% mono44m1: nrns 42778 - 48888
% mono44m2: nrns 48889 - 54999
% mono44m3: nrns 55000 - 61110
% mono55m1: nrns 61111 - 67221
% mono55m2: nrns 67222 - 73332
% mono55m3: nrns 73333 - 79443


if ischar(s)
switch lower(s)
    case 'bi61m1'
        ids = nrn_ids_subfun(1);
    case 'bi61m2'
        ids = nrn_ids_subfun(2);
    case 'bi61m3'
        ids = nrn_ids_subfun(3);
    case 'bi61m4'
        ids = nrn_ids_subfun(4);
    case 'bi72m1'
        ids = nrn_ids_subfun(5);
    case 'bi72m2'
        ids = nrn_ids_subfun(6);
    case 'bi72m3'
        ids = nrn_ids_subfun(7);
    case 'mono44m1'
        ids = nrn_ids_subfun(8);
    case 'mono44m2'
        ids = nrn_ids_subfun(9);
    case 'mono44m3'
        ids = nrn_ids_subfun(10);
    case 'mono55m1'
        ids = nrn_ids_subfun(11);
    case 'mono55m2'
        ids = nrn_ids_subfun(12);
    case 'mono55m3'
        ids = nrn_ids_subfun(13);
    otherwise
        fprintf('\nPossible group names:\n')
        tmp = cell(13,1);
        nnrns = 6111;
        for k = 1:13 
            tmp{k} = get_JL_nrn_varname(k*nnrns);
        end
        fprintf('%s\n',tmp{:})
        error('No name exists')
end
else
    if s<=13 && s>0
        ids = nrn_ids_subfun(s);
    else
        error('Invalid number, must be 0 > GroupNumber >= 13.')
    end
end
end


function tmp = nrn_ids_subfun(num)
nnrns = 6111;
tmp = (num-1)*nnrns+1:num*nnrns;
end