(* ::Package:: *)

(* ::Package:: *)

BeginPackage["Autosave`"];

StartAutosave::usage =
"StartAutosave[interval:300, dir:Automatic] \
starts a background task that writes a hidden backup of the current \
notebook every interval seconds. dir can be Automatic (use the notebook's \
directory or $TemporaryDirectory if unsaved) or a custom directory.";

StopAutosave::usage =
"StopAutosave[] stops the autosave task.";

AutosaveStatus::usage =
"AutosaveStatus[] returns an Association with the autosave path and \
last write time, or Enabled->False if not active.";

Begin["`Private`"];

StartAutosave[interval_:300, dir_:Automatic] := Module[
  {nb=EvaluationNotebook[], file, useDir, base, name, hidden, path},
  If[!NumericQ[interval] || interval <= 0, Return[$Failed]];

  file   = Quiet@Check[NotebookFileName[nb], $Failed];
  useDir = If[dir =!= Automatic, dir, If[file =!= $Failed, DirectoryName[file], $TemporaryDirectory]];
  If[!DirectoryQ[useDir], Quiet@CreateDirectory[useDir, CreateIntermediateDirectories->True]];

  base   = If[file === $Failed, "Unsaved-"<>StringReplace[CreateUUID[], "-"->""], FileBaseName[file]];
  name   = base<>".autosave.nb";
  hidden = If[$OperatingSystem==="Windows", name, "."<>name];
  path   = FileNameJoin[{useDir, hidden}];

  Export[path, NotebookGet[nb], "NB"];
  If[$OperatingSystem==="Windows", Quiet@Run@StringTemplate["attrib +H \"`1`\""][path]];

  $AutosavePath = path;
  If[ValueQ[$AutosaveTask], Quiet@Check[StopScheduledTask[$AutosaveTask]; RemoveScheduledTask[$AutosaveTask], Null]];
  $AutosaveTask = RunScheduledTask[ Export[$AutosavePath, NotebookGet[nb], "NB"], interval ];

  $AutosavePath
];

StopAutosave[] := If[ValueQ[$AutosaveTask],
  Quiet@Check[StopScheduledTask[$AutosaveTask]; RemoveScheduledTask[$AutosaveTask], Null];
  Unset[$AutosaveTask]; True,
  False
];

AutosaveStatus[] := If[
  ValueQ[$AutosaveTask] && ValueQ[$AutosavePath] && FileExistsQ[$AutosavePath],
  <|"Enabled"->True, "Path"->$AutosavePath, "LastWrite"->FileDate[$AutosavePath]|>,
  <|"Enabled"->False|>
];

End[]; (* `Private` *)
EndPackage[];
