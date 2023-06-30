
//input directory must have at least two folders: ROIs and Images with the same number of files 
//where each image in the Image folder has a respective roi in the ROIs folder
//images must be tiffs

//has the User select the Working Directory manually
input = getDirectory("Input directory");
//change string below to name ouput directory 
output = input + File.separator + "output " +"ave_plus_half_stdev";
File.makeDirectory(output);
run("Set Measurements...", "area mean standard min area_fraction display redirect=None decimal=3");



main(input, output);




//loops through the subdirectories and calls the helper functions
function main(input, output) {
	image_output = output + File.separator +"Images";
	File.makeDirectory(image_output);
	//open ROI Manager
	run("ROI Manager...");
	//load ROIs
	rois_in_order = open_rois(input + "/ROIs");
	
	images = getFileList(input + "/Images");
	//table = Table.create("results");
	embryo_res = newArray();
	percent_res = newArray();
	for (i = 0; i < images.length; i++) {
	    row_vals = image_processer(input + "/Images" + File.separator + images[i], images[i], rois_in_order, image_output);
	    embryo_res = Array.concat(embryo_res, row_vals[0]);
	    percent_res = Array.concat(percent_res, row_vals[1]);
	}
	Table.create("results");
	Table.setColumn("Embryo", embryo_res);
	Table.setColumn("%Area", percent_res);
	Table.update();
	Table.save(output + File.separator + "results");
	saveAs("Results", output + File.separator + "results.csv");
	wait(250);
	run("Close");
	close("ROI Manager");
}



function image_processer(image_path, image, rois_in_order, image_output) {
	open(image_path);
	wait(250);
	run("8-bit");
	wait(250);
	image = substring(image, 0, 4);
	roi_name = image + "_roi";
	selectWindow(getTitle());
	roiManager("Select", 5);
	roiManager("Select", 4);
	index = 0;
    for (i = 0; i < rois_in_order.length; i++) {
        if (rois_in_order[i] == roi_name) {
            roiManager("Select", i + 1);
            index = i + 1;
        }
    }
    roiManager("Select", index);
    wait(250);
    row_vals = get_percentage(image);
    run("Fire");
    wait(250);
	run("Flatten");
	saveAs("Tiff", image_output + File.separator + image + " Fire.tif");
	wait(250); 
	run("Close All");
	wait(250);
	return row_vals;
}

function get_percentage(image_name) {
	roiManager("Measure");
	average = Table.get("Mean", 0);
	stdev = Table.get("StdDev",0);
	max = Table.get("Max", 0);
	subtract_val = calculation(average, stdev, max);
	run("Subtract...", "value=" + toString(subtract_val));
	roiManager("Measure");
	percent = Table.get("%Area", 1);
	close("Results");
	return newArray(image_name, toString(percent));
}


function calculation(ave, stdev, max) {
	stdev = stdev * 0.5;
	value = ave + stdev ;
	return value	
}


function open_rois(input_roi_folder) {
		rois_in_order = newArray();
		rois = getFileList(input_roi_folder);
		for (i = 0; i < rois.length; i++) {
	    	open(input_roi_folder + File.separator + rois[i]);
			roiManager("Add");
			rois_in_order = Array.concat(rois_in_order, substring(rois[i],0,8));
			close();
		}
		rois_in_order = Array.deleteIndex(rois_in_order, 0);
		roiManager("Show All");
    	roiManager("Deselect");
    	return rois_in_order;
	}