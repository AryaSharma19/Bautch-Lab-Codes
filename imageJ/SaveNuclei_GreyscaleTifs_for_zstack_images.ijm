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

// Select the pSMAD channel and convert to grey //
//Then invert the image //
selectWindow("C2-" + title);
run("Invert");
//run("Channels Tool...");
run("Grays");


// Save as Tif //
run("Flatten");
saveAs("TIFF", output + title + "grey");
run("Close All");
}