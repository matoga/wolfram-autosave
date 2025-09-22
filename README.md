# Autosave for Wolfram (Mathematica)

A tiny Wolfram package that periodically saves a hidden backup copy of your current notebook.  
Useful if you want timed autosave without overwriting your original file.

## Installation

1. Open Wolfram.  
2. Go to File → Install…  
3. Choose:  
   - Type: Package  
   - Source: point to Autosave.wl  
   - Install Location: For this user only  
4. Click OK. Wolfram will copy the package into your local Applications folder.  
   You only need to do this once.

## Usage

Load the package in any notebook:

```
Needs["Autosave`"]
```

Start autosaving (default = every 5 minutes, hidden file saved next to your notebook or in $TemporaryDirectory if unsaved):

```
StartAutosave[]
```

Options:

```
StartAutosave[120]              (* autosave every 2 minutes *)  
StartAutosave[300, "/tmp"]      (* autosave every 5 minutes into /tmp directory *)
```
Check status:

```
AutosaveStatus[]
```

Stop autosave:

```
StopAutosave[]
```

## Notes

- On macOS/Linux the backup file is hidden by a leading dot, e.g. .MyNotebook.autosave.nb  
- On Windows the file is hidden using the attrib +H flag  
- The package stores state in global symbols ($AutosavePath, $AutosaveTask), so you can only run one autosave task per notebook session  
- Only the notebook contents are saved, not kernel variables in memory  
