This text file was created for MCW.

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
	Performs a fast cross product for a signal (e.g., used for transforming the load cell moment (M_xfm) response to a specified location given a vector). Typical use would be: >> M_xfm = M_LC+crossSingletonExpansion(-vector_from_LC_to_new_location, force);

customPlotyy.m
	creates a quick plot of two traces that require two y-axis (one on the right and one on the left).

dft.m
	A true discrete Fourier Transform.

dftnorm.m
	A normalized true discrete Fourier Transform.

divideSignalIntoWindows.m
	converts a signal into prescribed windows.

dostMatrixOneSide.m
	discrete orthonormal stockwell transform.

evaluateEffectsOfCutoffFreq.m
	A helpful way to quantify the effects of filtering on a large ensemble of signals.

findCellsThatHaveExactStringLogical.m
	This (and functions like it; see below) are used to find the column index in a header. For example, if you want to find the column that contains the "T1 Force ZL" and "T1 Force XL" response in mech*.mat files, call the function like this: 
>> fz = findCellsThatHaveExactStringLogical(mech.head,'T1 Force ZL') | ...
	findCellsThatHaveExactStringLogical(mech.head,'T1 Force XL');
>> fz = mech.x(:,fz);

findCellsThatHaveMatchingString.m
	Similar to the above function, but it will output the cell IDs that contain the provided string argument.

findCellsThatHaveMatchingStringLogical.m
	Same as above function, but the output is a logical string instead of indices.
	
findCrossings.m
	Finds locations of signal crossings of the provided threshold argument.

getDataFromMechDataStruct.m
	!!! DEPRECATED

getFoldersInDirectory.m
	Outputs a cell structure of the subfolders in a given directory.

getIndexFromMechDataFile.m
	!!! DEPRECATED

getIndexOfValueClosestToValue.m
	outputs the index of a signal that has a value closest to the value provided. e.g., >> I = getIndexOfValueClosestToValue(time,8); % this outputs the index in the time stamp vector that is closest to 8 [s or ms or .w.e]

getSignalBaseline.m
	Uses a histogram approach to find the signal baseline. This is helpful when a signal has an initial offset, which is common in accelerations and other biomechanical responses. To ensure that the baseline is calculated using only the beginning of the signal (e.g., before t=0), use the function like this:
>> fb = getSignalBaseline(force(t<0,:)); % note that if force is n-by-3, then the output fb will be 1-by-3

get_bwcolor_for_colorbar.m
	provide a number(s) between 0 and 1 to get a 3 column vector to get the respective shade of gray.

get_color_for_colorbar.m
	provide a number(s) between 0 and 1 to get a 3 column vector to get the respective color for use in false color mapping; i.e., displaying data through oclors.

get_files_in_dir.m
	Retreives certain files in a directory according to the type that is specified.

hermite.m
	generates a spline given points in 3D space and vectors at those points.

idft.m
	performs true inverse discrete fourier transform.

instFrequency.m
	computes instantaneous frequency for a signal.

isPoolOpen.m
	returns 1 if parallel processing is turned on, 0 if otherwise.

isfread3.m
	reads isf files (outputs from oscilloscopes).

makeHistogramOfGroupedData.m
	provide data and group IDs to create a plot with histograms of the groups of data superimposed on each other.

makeNormalizedHammingWindow.m
	Make hamming window.

makeOddLengthHammingWindow.m
	make odd numbered length hamming window.

makeTimeFreqPlot.m
	helpful tool for making a time frequency plot below the actual time series of the signal. For example:
>> s = stockwell(signal);
>> s = abs(s);
>> makeTimeFreqPlot(s,signal,time);

movingVariance.m
	computes the moving variance for a given window length.

ndhist.m
	compute multidimensional histogram.

plotCollectionOfSignalsInOneWindow.m
	Commonly used for plotting acoustic signals relative to forces. This will plot a multichannel signal in a single window without overlaying the signals. See the help menu for details.

probTimeFracture.m
	convert an acoustic signal to a signal to estimate the fracture timing.

readAcousticSensorData.m
	Reads ISF files containing acoustic sensor data and saves the data as a *.mat file to the desired directory.

readWIAManCSVFile.m
	Reads output CSV files that were created through multiviewer.

roundDate.m
	Rounds the date to the nearest number of minutes that are provided. This is good for filing naming.

saveFigureEps.m
	Saves a figure as an *.eps, *.pdf, or *.png file according to the dimensions provided. See the help menu for details. I used this a lot to create figures for dragging into MS Word or for eding in Adobe Illustrator.

time2peakCalc.m
	Fairly good method at computing time to peaks - requires knowledge about the signal before use.

trendline.m
	computes a trendline given x-y data. For example:
>> xmin = min(x); xmax = max(x);
>> P = trendline(x,y);
>> yfit = polyval(P,[xmin,xmax]);
>> plot([xmin,xmax],yfit,'k');

unsort.m
	Given the new indices from using the sort function where `sorted_data = s(I);`, this function will provide the indices to go back to the original where `s = sorted_data(U);`

vectormag.m
	computes the magnitude of a 2 or 3 column vector. Alternatively, it will compute the distance between a 3D point cloud and a single point in space.

xfm3d.m
	transform a point cloud, vectors, or tensors using a provided transformation matrix. This function allows you to not have to worry about the linear algebra.
