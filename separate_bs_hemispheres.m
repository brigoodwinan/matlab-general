function [lgm,rgm,lwm,rwm] = separate_bs_hemispheres(cortex,white)
% [lgm,rgm,lwm,rwm] = separate_bs_hemispheres(cortex,white)
%
% 2014-01-03, Brian Goodwin
%
% bs == BrainStorm
%
% Load in the white_* and cortex_* surfaces that is generated in BrainStorm
% after loading in a freesurfer subject file (into Brainstorm). This
% function simply separates the hemispheres back into their own surfaces so
% that Iso2mesh can be used for processing.
%
% Instruction:
% After the anatomy of the subject has been generated in brainstorm,
% right-click on the cortex and select, File > Export to Matlab. 
% Repeat this for the white matter. 
%
% Also, Ensure that you are using the FreeSurfer cortex and white matter 
% (it should be one with more vertices).
%
% e.g. of surfaces from BrainStorm:
% cortex_40002V 
% cortex_271297V <------ Export this version to Matlab (this is FreeSurfer)
%
% Load them into the function, and voila! :D

for k=1:length(cortex.Atlas)
    if strcmp(cortex.Atlas(k).Name,'Structures')
        structures = k;
    end
end

seed = max(cortex.Atlas(structures).Scouts(1).Seed,cortex.Atlas(structures).Scouts(2).Seed);

for k = 1:2
    if strcmp('Cortex L',cortex.Atlas(structures).Scouts(k).Label)
        lgm.node = cortex.Vertices(cortex.Atlas(structures).Scouts(k).Vertices,:);
        if cortex.Atlas(structures).Scouts(k).Seed==seed
            lgm.face = cortex.Faces(cortex.Faces(:,1)>=seed,:)-cortex.Atlas(structures).Scouts(k).Seed+1; % notice the logical indexing.
        else % in this case, *.Seed = 1
            lgm.face = cortex.Faces(cortex.Faces(:,1)<seed,:)-cortex.Atlas(structures).Scouts(k).Seed+1;
        end
    elseif strcmp('Cortex R',cortex.Atlas(structures).Scouts(k).Label)
        rgm.node = cortex.Vertices(cortex.Atlas(structures).Scouts(k).Vertices,:);
        if cortex.Atlas(structures).Scouts(k).Seed==seed
            rgm.face = cortex.Faces(cortex.Faces(:,1)>=seed,:)-cortex.Atlas(structures).Scouts(k).Seed+1; % notice the logical indexing.
        else % in this case, *.Seed = 1
            rgm.face = cortex.Faces(cortex.Faces(:,1)<seed,:)-cortex.Atlas(structures).Scouts(k).Seed+1;
        end
    end
    
    if strcmp('Cortex L',white.Atlas(structures).Scouts(k).Label)
        lwm.node = white.Vertices(white.Atlas(structures).Scouts(k).Vertices,:);
        if cortex.Atlas(structures).Scouts(k).Seed==seed
            lwm.face = white.Faces(white.Faces(:,1)>=seed,:)-white.Atlas(structures).Scouts(k).Seed+1; % notice the logical indexing.
        else % in this case, *.Seed = 1
            lwm.face = white.Faces(white.Faces(:,1)<seed,:)-white.Atlas(structures).Scouts(k).Seed+1;
        end
    elseif strcmp('Cortex R',white.Atlas(structures).Scouts(k).Label)
        rwm.node = white.Vertices(white.Atlas(structures).Scouts(k).Vertices,:);
                if cortex.Atlas(structures).Scouts(k).Seed==seed
            rwm.face = white.Faces(white.Faces(:,1)>=seed,:)-white.Atlas(structures).Scouts(k).Seed+1; % notice the logical indexing.
        else % in this case, *.Seed = 1
            rwm.face = white.Faces(white.Faces(:,1)<seed,:)-white.Atlas(structures).Scouts(k).Seed+1;
        end
    end
end
