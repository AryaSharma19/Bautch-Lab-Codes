//Full Batch Processing for Embryo Stainings
//Arya Sharma, 12/16/22, ideas and code examples from Morgan Oatley 
//Inputs: 
 
//Outputs: 

//has the User select the Working Directory manually
entrypoint = getDirectory("Input directory");
main(entrypoint)

//loops through the subdirectories and calls the helper functions
function main(entrypoint) {
	while (1) {
		waitForUser("Run");
		name = getInfo("window.title");
		saveAs("Tiff", entrypoint + File.separator + name + ".tif");
		close();
	}
}
