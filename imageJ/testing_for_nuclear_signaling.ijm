// Check if the image has Z-stacks or is a max projection

if (getSliceNumber() > 1) {
    // Z-stacks
    print("Image has Z-stacks");
} else {
    // Max projection
    print("Image is a maximum projection");
}