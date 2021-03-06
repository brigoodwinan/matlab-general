# matlab-general

Brian Goodwin 2017-01-10

Many of my scripts use functions in this library. Below is a list of what I believe to be the most useful functions.

SpinCalc.m
	Allows conversion between Euler vectors, quaternions, rotation matrices, and euler angles.

anglebtwnvectors.m
	Given two 3D vectors, this computes the angle between them.

bary2cart.m
	Barycentric coordinate frame conversion to cartesian coordinates.

calculate_element_center.m
	Outputs the cartesian coordinates of the center of a triangle face element (i.e., a triangle).

calculate_surface_area.m
	Calculates surface area of a meshed surface made up of triangles using point (or vertices) and face fields.

cart2arclength.m
	Provide 2D or 3D points and it converts it to a 1D "line" where each new vector element is the distance from point 0 (or the first point). This simply uses the cumsum() matlab function.

cart2bary.m
	Converts from cartesian coordinates to barycentric coordinates.

changeSigFigsInYaxis.m
	Provide the figure handle to change the significant figures of values in the y-axis.

computeCepstralCoefficients.m
	Compute Cepstral coefficients of a signal.

computeReflectionCoefficients.m
	Compute the reflection coefficients at each prescribed window in a signal.

computeTimeOffset.m
	Helpful in computing the time at which a dynamic response begins; i.e., this will give you the time at which t=0 could be defined. I used this in almost all of my analyses.

convertVector2CellString.m
	This is helpful for creating quick figure legends. Lets say you have response IDs like >> ids=293:295; Then you can use this function to provide quick legend labels: >> legend(convertVector2CellString(ids))

crossSingletonExpansion.m
	Performs a fast cross product for a signal (e.g., used for transforming the load cell moment response to a specified location given a vector). Typical use would be: >> M_xfm = M_LC
customPlotyy.m
debugging_mmse_xfms.m
designDifferentiator.m
dft.m
dftnorm.m
divideSignalIntoWindows.m
dostMatrixOneSide.m
edgefield2cells.m
edotds.m
evaluateEffectsOfCutoffFreq.m
filterWithDifferentiator.m
findCellsThatHaveExactStringLogical.m
findCellsThatHaveMatchingString.m
findCellsThatHaveMatchingStringLogical.m
findCrossings.m
fouriersolver_magnetic2efield.m
freesurfer2trisurf.m
genRandomHmmGuesses.m
generate_tensor_and_reorient.m
generate_tensor_and_reorient_oldversion.m
getBoneFractureDataFileName.m
getDataFromMechDataStruct.m
getDodcFolderString.m
getFoldersInDirectory.m
getHeadNeckFolderString.m
getIndexFromMechDataFile.m
getIndexOfValueClosestToValue.m
getSignalBaseline.m
getSizeOfGmmClusts.m
getVclmFolderString.m
get_JL_nrn_ids.m
get_JL_nrn_varname.m
get_bwcolor_for_colorbar.m
get_color_for_colorbar.m
get_connected_edges.m
get_connected_faces.m
get_connected_nodes.m
get_files_in_dir.m
growthrates.m
hermite.m
hermite_v1.m
identify_nodes_outside_volume.m
idft.m
idftnorm.m
instFrequency.m
interp_dti_data.m
isPoolOpen.m
isfread3.m
kurtosis.m
line_lengths.m
load_JL_filepaths.m
make6cornerboxfromminmax.m
makeBoxFromMinMax.m
makeDifferentiator.m
makeFFTWindowForCepstrum.m
makeHistogramOfGroupedData.m
makeNormalizedHammingWindow.m
makeOddLengthHammingWindow.m
makeTimeFreqPlot.m
make_edge_file_for_scirun.m
make_hist_eigenvalues.m
map_data2element.m
map_data2node.m
map_efield2V_nrn.m
meshquality_hist.m
mmse_xfms.m
movingVariance.m
nanmean.m
ndhist.m
optimize_mesh.m
outputMaximum.m
plotCollectionOfSignalsInOneWindow.m
plot_neuron.m
probTimeFracture.m
project_point_onto_surf.m
rcfilt.m
readAcousticSensorData.m
readCSVWithOneHeader.m
readNavyAcousticCSVFile.m
readTLF3.m
readTdasBin.m
readTdasBin_v1.m
readTdasCalcBin.m
readWIAManCSVFile.m
readWIAManCSVFile_v1.m
read_comsol_output_spreadsheet.m
read_nrniv_bin_vout.m
readsectionwisecomsoloutput.m
readsectionwisecomsoloutput_v1.m
readspreadsheetcomsoloutput.m
readsurface.m
reconstructAndReorientTensor.m
remove_short_tracts.m
roundDate.m
saveFigureEps.m
separate_bs_hemispheres.m
smoothhermitesplinetesting.m
surfnorms_at_nodes.m
surfnorms_at_nodes_v1.m
tetrahedroninterp.m
tetvol.m
time2peakCalc.m
timetilwedding.m
transVec.m
trendline.m
trimlatvol3d.m
unsort.m
vclmAcousticDelay.m
vectormag.m
write_anisotropic_comsolinterpfun.m
write_mtr_tetgen.m
write_node_ele_tetgen.m
xfm3d.m

Matlab functions for general use.

I am a biomedical engineer and I use matlab extensively - so I have a collection of functions that I have made over the past 8ish years. 

Many of the functions may require matlab toolboxes like Iso2Mesh and NIFTI. The help display for each function should indicate the required toolboxes for a certain function to run.
