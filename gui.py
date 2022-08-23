import tkinter as tk
from tkinter import filedialog
def browseFiles():
    filename = filedialog.askopenfilename(initialdir = "/",
                                          title = "Select a File",
                                          filetypes = (("Text files",
                                                        "*.txt*"),
                                                       ("all files",
                                                        "*.*")))
    file_text.configure(text=filename)

def validate():
    infile = file_text.cget("text")
    if rngValidation(infile) and schematronValidation(infile):
        print("Your TBXv3 file is valid")

window = tk.Tk()

welcome = tk.Label(text="Welcome to the TBX core Validator\n What would like to validate?")
welcome.grid(row=1, column=1)

file_text = tk.Label(text="Please Select a file")
file_text.grid(row=2, column=1)

file_select = tk.Button(text="Browse", command=browseFiles)
file_select.grid(row=2, column=2)


validate = tk.Button(text="Validate!", command=validate)
validate.grid(row=3, column=1)
window.mainloop()