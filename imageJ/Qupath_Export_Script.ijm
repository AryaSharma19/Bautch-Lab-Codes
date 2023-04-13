entrypoint = getDirectory("Select Directory To Save ScreenShots");
main(entrypoint)


function main(entrypoint) {
	while (1) {
		waitForUser("Hit Run each time AFTER clicking export snapshot to imageJ, Hit Cancel and close imageJ when all done");
		name = getInfo("window.title");
		saveAs("Tiff", entrypoint + File.separator + name + ".tif");
		close();
	}
}
