// Set up batch processing //
input = getDirectory("Input directory");
output = getDirectory("Output directory");

Dialog.create("File type");
Dialog.addString("File suffix: ", ".oir", 5);
Dialog.show();
suffix = Dialog.getString();

nProcessed = 0;
processFolder(input);
showStatus("Done: processed " + nProcessed + " images.");

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		showProgress(i, list.length);
		if(endsWith(list[i], "/"))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}


function processFile(input, output, file) {
	run("Bio-Formats Windowless Importer", "open=[" + input + list[i] +"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
// Find title of your image //
title = getTitle();

//turn z stacks into single image max projection, ie combine zstacks
run("Z Project...", "projection=[Max Intensity]");
//close original z-stack image
close(title);
//rename the combined z-stack image to the orginals name
rename(title);

// Split image into channels // 
run("Split Channels");

// Use the Gaussian Blur Filter & binary mask to identify the nuclei in the image // 
selectWindow("C1-" + title);
run("Gaussian Blur...", "sigma=3");
setOption("BlackBackground", true);
run("Convert to Mask");

// Use the Watershed algorithm to identify the border between adjacent nuclei // 
run("Watershed");

// Adjust the threshold // 
selectWindow("C1-" + title);
//run("Threshold...");
//setThreshold(255, 255);
run("Convert to Mask");

// Analyse particles to identify the nuclei & add them to the ROI // 
run("Set Measurements...", "area mean standard display redirect=None decimal=3");
run("Analyze Particles...", "size=3-500 show=Outlines exclude add");

// Overlay the nuclei on your channel where you wish to measure fluorescence intensity // 
// And duplicate image // 
selectWindow("C3-" + title);
run("From ROI Manager");
run("Duplicate...", " ");
rename("Duplicate");

// Select all objects in the ROI manager & then remove the background fluorescence // 
count=roiManager("count");
array=newArray(count);
for(i=0; i<count;i++) {
        array[i] = i;}
        
roiManager("Select", array);
roiManager("Combine");
setBackgroundColor(0, 0, 0);
run("Clear Outside");

// Subtract the intensity of the nuclei from the duplicated image // 
// This will give you an average value for fluorescence outside of the nucleus // 
imageCalculator("Subtract create", "C3-" + title,"Duplicate");

// Measure this average intensity - the value will be added to a results page // 
selectWindow("Result of C3-" + title);
run("Measure");

// Then redirect the measurements to your channel of interest & measure intensity for each of the nuclei in the ROI //
selectWindow("C3-" + title);
rename("Nuclei_toMeasure");
run("Set Measurements...", "area mean standard display redirect=Nuclei_toMeasure decimal=3");
roiManager("Measure");

// Save the results page // 
// The first value is the fluorescence outside of the nuclei followed by a value for each nuclei // 
// You can then make an average of all nuclei & look at the ratio of nuclear to cytoplasmic intensity // 

saveAs("Results", output + title + ".csv");
selectWindow("Nuclei_toMeasure");
run("Flatten");
saveAs("TIFF", output + title);
run("Close All");
run("Clear Results");
selectWindow("Results");
run("Close");
roiManager("reset");
}




