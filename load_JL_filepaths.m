% load_JL_filepaths.m
%
% Loads in filepaths and names.
nnrns = 6111;

suff = '';

% File extensions
ext.i2m = '_i2m';
ext.srnfld = '_scirunfld';
ext.srnlatvol = '_scirunlatvol';
ext.nrns = ['_',num2str(nnrns)];
ext.merged = '_merged';
ext.unmerged = '_unmerged';
ext.mat = '.mat';
ext.txt = '.txt';
ext.pts = '.pts';

% Head files
% The following file names would conflict with those in JLmakeheadtetmesh.m
headf.path = '../Project_HEAD_MODEL/HeadModel_JL/'; % model 2 folder set here.
headf.scalp = 'JL_bs_scalp_i2m.mat';
headf.skull = 'JL_bs_skull_i2m.mat';
headf.csf = 'JL_bs_csf_i2m.mat';
headf.gm_R = 'JL_bs_rgm_i2m.mat';
headf.gm_L = 'JL_fixedlgm_rm.mat';
headf.gm_L_hr = 'JL_fixedlgm.mat'; % High resolution left GM.
headf.wm_R = 'JL_bs_rwm_i2m.mat';
headf.wm_L = 'JL_bs_lwm_i2m.mat';
headf.wm_L_fs = 'JL_bs_lwm.mat'; % This surface is simply a remeshed version of the original FreeSurfer surface and should be used to calculate the surface normals for the axon tracking.
headf.gm = 'JL_bs_gm_full_i2m.mat';
headf.fixremesh_gm_L = 'JL_fixedlgm_rm';
headf.wholeheadsurfs = 'JL_MESHsurfs_and_regions_wholehead';
headf.reducedheadsurfs = 'JL_MESHsurfs_and_regions_reducedhead';
headf.mesh = 'JL_MESH';
headf.comsolmesh = 'JL_bs_comsol_mesh';
headf.fs_pial_and_inflated_pial = [headf.path,'JL_freesurfer_lgm_pial_inflpial',ext.mat]; % [mm]
headf.fs_pial_smoothed = [headf.path,'JL_freesurfer_pial_smoothed',ext.mat];
headf.fs_lwm = [headf.path,'JL_freesurfer_lwm_surf',ext.mat]; % [mm]

dtif.xfm = [headf.path,'JL_xfm_sMRItoSCS.mat'];
dtif.latvolxfm = [headf.path,'DTI/JL_LatVol_XFM_20140604_1214.mat'];
dtif.dtidimensions = [headf.path,'DTI/JL_LatVol_Size_20140604_1214.mat'];
dtif.dtiheadfem = [headf.path,'DTI/JL_DTI_headFEM_20140604_1214.mat'];
dtif.fa = [headf.path,'DTI/JL_FA_20140604_1214.mat'];

% COMSOL paths and files
cmsl.interppath = [headf.path,'InterpolationFunctions_COMSOL/'];
cmsl.modelpath = [headf.path,'ModelsCOMSOL_JL/'];
cmsl.resultpath = [headf.path,'ResultsCOMSOL_JL/'];
cmsl.rootresultpath = '/Users/cbutson/Documents/Brian/Project_HEAD_MODEL/HeadModel_JL/ResultsCOMSOL_JL/';
% cmsl.rootresultpath = '/Users/1773goodwib/Documents/Project_HEAD_MODEL/HeadModel_JL/ResultsCOMSOL_JL/';

% Subject files
subf.path = '../HumanSubjectExperiments/Subject1_JL_2012_12_20/OrigData/';
subf.navtarget = [subf.path,'JL_coil_xfm_adjusted',ext.mat];
subf.coilmodels = [subf.path,'JL_coilmodel_xfms_cellstruct',ext.mat];
subf.bi72m_coilmodel_centers = [subf.path,'JL_bi72m_coilmodel_centers',ext.srnfld,ext.mat];
subf.modelcoils_scirunfields = [subf.path,'JL_modelcoils_glyphs',ext.srnfld,ext.mat];
subf.xfmlist = [subf.path,'JL_coilmodel_xfms_list',ext.mat];
subf.emgvsorient = [subf.path,'JL_emgvsorient_coilxfms_stim',ext.mat];

% Neuron files
nrnf.neuronpath = '../Project_NEURON_MODEL/AmatrudoWeaver_GoodwinMod/modified_amatrudo_goodwin/';
nrnf.corticalpath = '../Project_CORTICAL_MODEL/JL_CorticalModel/';
nrnf.nrnivresultpath = '/Volumes/Macintosh HD 2/Brian/NRNIV_Results/';
nrnf.nrnivrawbinpath = [nrnf.nrnivresultpath,'JL_nrniv_out/'];
nrnf.nrniv_vout_intracell_path = [nrnf.nrnivresultpath,'JL_vout_intracell_all_mats/'];
nrnf.pop_nrns_cellstruct = [nrnf.corticalpath,'pop_withaxons_20mm_export_comsol_sol_cellstruct',ext.nrns,ext.mat];
nrnf.pop_nrns_scirunviz = [nrnf.corticalpath,'pop_withaxons_20mm_export_comsol_sol',ext.srnfld,ext.nrns,ext.mat];
nrnf.placements = [nrnf.corticalpath,'nrn_placements_',num2str(nnrns),suff,ext.mat];
nrnf.handknobnrns = [nrnf.corticalpath,'hand_knob_nrn_indices',ext.mat];
nrnf.nrnpialindices = [nrnf.corticalpath,'nrnplace_GMindices_',num2str(nnrns),suff,ext.mat];
nrnf.coords_raw = [nrnf.neuronpath,'coords_withaxon_ax20mm',ext.pts];
nrnf.edge_connections = [nrnf.neuronpath,'nrn_edgeconn_withaxon_20mm',ext.mat];
nrnf.extracellularsecs = [nrnf.neuronpath,'coords_section_orders',ext.txt];
nrnf.recordedsecs = [nrnf.neuronpath,'VoutSections_ax20mm',ext.txt];
nrnf.recordedpts = [nrnf.neuronpath,'VoutLocations_ax20mm',ext.txt];
nrnf.nrn_z_oriented = [nrnf.neuronpath,'nrn_withaxon_20mm_z_oriented',ext.mat];
nrnf.Vout_nrn_z_oriented = ['VoutNeuron_withaxon20mm_z_oriented',ext.mat];
nrnf.efield_mult_matrix = ['efield_mult_matrix_ax20mm',ext.mat];
nrnf.mapping_matrix_Vintra2Vextra = [nrnf.neuronpath,'matrix_map_Vintra2Vextra',ext.mat];
% nrnf.threshold_results = [nrnf.nrnivresultpath,'JL_thresholdsV_1thru79443_all',ext.mat];
nrnf.threshold_results = [nrnf.corticalpath,'JL_thresholdsV_1thru79443_all',ext.mat];
nrnf.activation_locations = [nrnf.corticalpath,'JL_nrniv_AP_initiation_sites',ext.mat];
nrnf.nrn_pial_area = [nrnf.corticalpath,'JL_nrn_pial_surfacearea_sqmm',ext.mat];
nrnf.activation_sites_point_clouds_scirun = [nrnf.corticalpath,'JL_nrniv_AP_init_sites_pntcld',ext.srnfld,ext.mat];
nrnf.nrn_data_pts_on_freesurfer_pial = [nrnf.corticalpath,'JL_FreesurferPialFaceIndicesForData',ext.mat]; % d pnt fid
nrnf.nrn_data_pts_on_freesurfer_infpial = [nrnf.corticalpath,'JL_FreesurferInflatedPialPointsForData',ext.mat]; % infpnt
nrnf.nrn_data_pts_on_freesurfer_infpial_srn = [nrnf.corticalpath,'JL_FreesurferInflatedPialPointsForData',ext.srnfld,ext.mat]; % nrndata_inflpial *.node
nrnf.nrn_data_pts_on_freesurfer_pial_srn = [nrnf.corticalpath,'JL_FreesurferPialFaceIndicesForData',ext.srnfld,ext.mat]; % nrndatapts *.node
nrnf.thresholds_results_srnmatrix = [nrnf.corticalpath,'JL_threshold_results_all',ext.srnfld,ext.mat]; % mono*_nu; bi*_nu
nrnf.depth_results_srnmatrix = [nrnf.corticalpath,'JL_depth_results_all',ext.srnfld,ext.mat]; % mono*_depth*; bi*_depth*
nrnf.FAvalue_at_activ_site = [nrnf.corticalpath,'JL_FAvalue_at_activ_site',ext.mat]; % nrnactFA{13}{2}
nrnf.efmagnitude_at_activ_site = [nrnf.corticalpath,'JL_EFmagnitude_at_activ_site',ext.mat]; % nrnactef{13}{2} [V/m]
nrnf.angle_btwn_ef_and_pyrcell = [nrnf.corticalpath,'JL_angle_btwn_ef_and_pyrcell',ext.mat]; % nrnefang{13}
nrnf.ef_at_soma = [nrnf.corticalpath,'JL_ef_at_soma',ext.mat]; % nrnef{13}
nrnf.soma_depolarize_latency = [nrnf.corticalpath,'JL_soma_depolarize_latency',ext.mat]; % somalat{13}{2}(nnrns)
nrnf.dti_around_sample_neurons = [nrnf.corticalpath,'JL_dti_around_SampeNeuronImages',ext.srnfld,ext.mat]; % dti1; dti2
nrnf.sample_neurons = [nrnf.corticalpath,'JL_SampeNeuronImages',ext.srnfld,ext.mat]; % nrnsamp*
nrnf.ef_around_sample_neurons =  [nrnf.corticalpath,'JL_efield_around_SampeNeuronImages',ext.srnfld,ext.mat];% sampef*
nrnf.intracell_sample_neurons = [nrnf.corticalpath,'JL_intracell_SampleNeuronImages',ext.srnfld,ext.mat]; % sampv*_mono sampv*_bi
nrnf.ef_result_plane_within_hk = [nrnf.corticalpath,'JL_ef_resultplane_hk',ext.srnlatvol,ext.mat]; % lvxfm; lvdim; ef_*
nrnf.dti_result_plane_within_hk = [nrnf.corticalpath,'JL_dti_resultplane_hk',ext.srnlatvol,ext.mat]; % lvxfm; lvdim; hk_dti_data