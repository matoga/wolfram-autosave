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

To enable autosaving in a notebook, evaluate:

```
Needs["Autosave`"]
```

By default this saves a hidden backup every 5 mins (a single file that is overwritten each time).
* If the notebook has been saved before, the backup is placed in the same directory.
* If the notebook is still unsaved, the backup goes into $TemporaryDirectory.
  
If Wolfram Mathematica crashes, you can recover your work by opening the hidden `.MyNotebook.autosave.nb` file in that directory.

## Advanced

Options for `StartAutosave` function:

```
StartAutosave[120]              (* autosave every 2 minutes *)  
StartAutosave[300, "/tmp"]      (* autosave every 5 minutes into /tmp directory *)
```
Check current status:

```
AutosaveStatus[]
```

Stop autosave:

```
StopAutosave[]
```

## Notes

- On macOS/Linux the backup file is hidden by a leading dot, e.g. .MyNotebook.autosave.nb, but on Windows the file is hidden just using the attrib +H flag and is saved without the leading dot.
- The package stores state in global symbols ($AutosavePath, $AutosaveTask), so you can only run one autosave task per notebook session  
- Only the notebook contents are backed up, not kernel variables in memory  
