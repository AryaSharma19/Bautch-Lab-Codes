import os
from tkinter.filedialog import askdirectory
import shutil


path = askdirectory(title='Select Folder') # shows dialog box and return the path
print(path) 

#removes all the other stuff except for the processed Images folder
os.chdir(path)
for file in os.listdir(path):
    d = path + "/" + file
    if os.path.isdir(d):
        os.chdir(d)
        for i in os.listdir(d):
            full_path: str = d + "/" + i
            if not full_path.endswith("Processed Images"):
                os.remove(full_path)
            
#moves everything to main folder
os.chdir(path)
for file in os.listdir(path):
    d = path + "/" + file
    if os.path.isdir(d):
        os.chdir(d)
        for i in os.listdir(d):
            full_path: str = d + "/" + i
            if full_path.endswith("Processed Images"):
                os.chdir(full_path)
                for j in os.listdir(os.getcwd()):
                    shutil.move(full_path + "/" + j, d)
                break

#deletes empty Processed Images Folder
os.chdir(path)
for file in os.listdir(path):
    d = path + "/" + file
    if os.path.isdir(d):
        os.chdir(d)
        for i in os.listdir(d):
            full_path: str = d + "/" + i
            if full_path.endswith("Processed Images"):
                os.remove(full_path)
                break           

print(os.getcwd())