input = getDirectory("Input directory");
output = getDirectory("Output directory");

channel = 3;


list = getFileList(input);
outputgrey = output + File.separator + "Greys";
File.makeDirectory(outputgrey);

outputcolor = output + File.separator + "Colors";
File.makeDirectory(outputcolor);

for (i = 0; i < list.length; i++) {
		processFileGrey(input, outputgrey, list[i]);
		processFileColor(input, outputcolor, list[i]);
		print("Finished " + toString(i + 1) + " of "+ list.length);

}


function processFileColor(input, output, file) {
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
selectWindow("C" + toString(channel) + "-" + title);

run("Flatten");
saveAs("TIFF", output + File.separator + title + "color");
wait(250);
run("Close All");
}





function processFileGrey(input, output, file) {
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
selectWindow("C" + toString(channel) + "-" + title);

run("Invert");
wait(250);
//run("Channels Tool...");
run("Grays");
wait(250);
// Save as Tif //
run("Flatten");
saveAs("TIFF", output + File.separator + title + "grey");
wait(250);
run("Close All");
}