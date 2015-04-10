function varname = get_JL_nrn_varname(k)
% varname = get_JL_nrn_varname(k)
% varname = get_JL_nrn_varname({num})
%
% Input neuron number (k) and the output is a string of the name of the TMS
% coil position group that the neuron belongs to. The output will one of
% the following:
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
%
% If input is a cell (e.g. {5}), the value within the cell must be between
% 1 and 13. The output is the name of the neuron result set number (see
% above).

if iscell(k)
    k = k{1};
    switch k
        case 1
            varname = 'bi61m1';
        case 2
            varname = 'bi61m2';
        case 3
            varname = 'bi61m3';
        case 4
            varname = 'bi61m4';
        case 5
            varname = 'bi72m1';
        case 6
            varname = 'bi72m2';
        case 7
            varname = 'bi72m3';
        case 8
            varname = 'mono44m1';
        case 9
            varname = 'mono44m2';
        case 10
            varname = 'mono44m3';
        case 11
            varname = 'mono55m1';
        case 12
            varname = 'mono55m2';
        case 13
            varname = 'mono55m3';
        otherwise
            error('Invalid number.')
    end
else
    if k<1
        error('Invalid Neuron Number.')
    end
    
    if k<6112
        varname = 'bi61m1';
    elseif k<12223
        varname = 'bi61m2';
    elseif k<18334
        varname = 'bi61m3';
    elseif k<24445
        varname = 'bi61m4';
    elseif k<30556
        varname = 'bi72m1';
    elseif k<36667
        varname = 'bi72m2';
    elseif k<42778
        varname = 'bi72m3';
    elseif k<48889
        varname = 'mono44m1';
    elseif k<55000
        varname = 'mono44m2';
    elseif k<61111
        varname = 'mono44m3';
    elseif k<67222
        varname = 'mono55m1';
    elseif k<73333
        varname = 'mono55m2';
    elseif k<=79443
        varname = 'mono55m3';
    else
        error('Invalid Neuron Number.')
    end
end