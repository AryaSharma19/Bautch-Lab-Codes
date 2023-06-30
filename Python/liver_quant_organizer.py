import tkinter as tk
from tkinter import filedialog
import csv


genotypes = {'E367': 'Alk1 Control', 'E368': 'Alk1 Control', 'E369': 'Alk1 Control', 'E389': 'Alk1 Control', 'E462': 'Alk1 Control', 'E464': 'Alk1 Control', 'E465': 'Alk1 Control', 
'E370': 'Alk1OE', 'E371': 'Alk1OE', 'E372': 'Alk1OE', 'E390': 'Alk1OE', 'E463': 'Alk1OE', 'E466': 'Alk1OE', 'E467': 'Alk1OE',
'E334': 'Control', 'E335': 'Control', 'E339': 'Control', 'E468': 'Control', 
'E469': 'Control', 'E470': 'Control', 'E490': 'Control', 'E491': 'Control', 'E492': 'Control', 'E496': 'Control', 'E497': 'Control', 
'E493': 'S6 iECKO', 'E498': 'S6 iECKO', 'E471': 'S6 iECKO', 
'E526': 'S7 iECKO', 'E528': 'S7 iECKO', 'E541': 'S7 iECKO', 
'E527': 'S7 iECKO S6 Het', 'E529': 'S7 iECKO S6 Het', 'E530': 'S7 iECKO S6 Het',
'E489': 'S6S7 Double', 'E501': 'S6S7 Double', 'E331': 'S6S7 Double', 'E332': 'S6S7 Double', 'E336': 'S6S7 Double', 'E340': 'S6S7 Double', 'E341': 'S6S7 Double', 'E473': 'S6S7 Double',
'E500': 'S6 iECKO S7 Het', 'E472': 'S6 iECKO S7 Het', 'E474': 'S6 iECKO S7 Het'
}

values =  {
    'Control': [],
    'Alk1 Control': [],
    'S7 iECKO': [],
    'S6 iECKO': [],
    'S7 iECKO S6 Het': [],
    'S6 iECKO S7 Het': [],
    'S6S7 Double': [],
    'Alk1OE': []
}


def sort():
    path, output = select_csv_file()
    with open(path, 'r') as file:
    # Create a DictReader object
        reader = csv.DictReader(file)
        # Iterate over each row in the CSV file
        for row in reader:
            # Access values using keys
            values[genotypes[row["Embryo"]]].append(row['%Area'])
    write_dict_to_csv(values, "Average Plus half Standard Dev Prism Importable File.csv", output)


def write_dict_to_csv(data_dict, filename, output):
    # Find the maximum number of rows among all columns
    max_rows = max(len(rows) for rows in data_dict.values())

    # Create a list of column names
    column_names = list(data_dict.keys())

    # Open the CSV file for writing
    with open(output + "\\" + filename, 'w', newline='') as file:
        writer = csv.writer(file)

        # Write the column names as the first row
        writer.writerow(column_names)

        # Write the rows for each column
        for i in range(max_rows):
            row = [data_dict[column][i] if i < len(data_dict[column]) else '' for column in column_names]
            writer.writerow(row)


def select_csv_file():
    root = tk.Tk()
    root.withdraw()
    output = filedialog.askdirectory()
    file_path = filedialog.askopenfilename(filetypes=[("CSV Files", "*.csv")])
    return file_path, output

if __name__ == "__main__":
    sort()
