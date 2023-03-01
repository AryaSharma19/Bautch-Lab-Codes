input = getDirectory("Output directory");

list = getFileList(input);
for (i = 0; i < list.length; i++) {
    print(list[i]);
    print(substring(list[i],0,4));
}