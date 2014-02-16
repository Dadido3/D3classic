; ########################################## Variablen ##########################################

Structure Files_Main
  Save_File.b                     ; Pfad-Datei soll gespeichert werden
  Mutex_ID.i                      ; Mutex, um doppelte Zugriffe zu verhindern.
EndStructure
Global Files_Main.Files_Main

Structure Files_File
  Name.s
  File.s
EndStructure
Global NewList Files_File.Files_File()

Structure Files_Folder
  Name.s
  Folder.s
EndStructure
Global NewList Files_Folder.Files_Folder()

; ########################################## Declares ############################################

Declare Files_Load(Filename.s)
Declare Files_Save(Filename.s)

Declare.s Files_File_Get(File.s)
Declare.s Files_Folder_Get(Name.s)

; ########################################## Ladekram ############################################

Files_Main\Mutex_ID = CreateMutex()

AddElement(Files_File())
Files_File()\Name = "Files"
Files_File()\File = "Files.txt"

Files_Load(Files_File_Get("Files"))

; ########################################## Proceduren ##########################################

Procedure Files_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; You have to restart if you change the file.")
    WriteStringN(File_ID, "; ")
    WriteStringN(File_ID, "; How it works:")
    WriteStringN(File_ID, ";   [Folder]")
    WriteStringN(File_ID, ";   Main = ../")
    WriteStringN(File_ID, ";   Data = Data/")
    WriteStringN(File_ID, ";   ")
    WriteStringN(File_ID, ";   [Files]")
    WriteStringN(File_ID, ";   Answer = [Main][Data]Answer.txt")
    WriteStringN(File_ID, "; ")
    WriteStringN(File_ID, "; Means that the File Answer is in '../Data/Answer.txt'.")
    WriteStringN(File_ID, "; You can create your own folders if you want:")
    WriteStringN(File_ID, ";   Example: [Folder]")
    WriteStringN(File_ID, ";            Log = Log/")
    WriteStringN(File_ID, ";            ")
    WriteStringN(File_ID, ";            [Files]")
    WriteStringN(File_ID, ";            Log = [Main][Log]Log_[i].txt")
    WriteStringN(File_ID, "; ")
    WriteStringN(File_ID, "; You can also use [date] instead of [i] for the Logfile.")
    
    WriteStringN(File_ID, "")
    
    WriteStringN(File_ID, "[Folder]")
    ForEach Files_Folder()
      WriteStringN(File_ID, Files_Folder()\Name+" = "+Files_Folder()\Folder)
    Next
    
    WriteStringN(File_ID, "")
    
    WriteStringN(File_ID, "[Files]")
    ForEach Files_Folder()
      If Files_File()\Name <> "Files"
        WriteStringN(File_ID, Files_File()\Name+" = "+Files_File()\File)
      EndIf
    Next
    
    Log_Add("Files", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Files_Load(Filename.s)
  Opened = OpenPreferences(Filename.s)
  
  ClearList(Files_Folder())
  
  PreferenceGroup("Folder")
  If ExaminePreferenceKeys()
    While NextPreferenceKey()
      AddElement(Files_Folder())
      Files_Folder()\Name = PreferenceKeyName()
      Files_Folder()\Folder = PreferenceKeyValue()
      ;CreateDirectory(Files_Folder()\Folder) Ist nicht ganz korrekt, es muss unterordner beachten ([Main][Test1][Test2])
    Wend
  EndIf
  
  ClearList(Files_File())
  
  PreferenceGroup("Files")
  If ExaminePreferenceKeys()
    While NextPreferenceKey()
      AddElement(Files_File())
      Files_File()\Name = PreferenceKeyName()
      Files_File()\File = PreferenceKeyValue()
    Wend
  EndIf
  
  ;Files_Main\Save_File = 1
  
  If Opened
    ClosePreferences()
  EndIf
EndProcedure

Threaded Files_File_Get_Return_String.s = ""
Procedure.s Files_File_Get(Name.s)
  LockMutex(Files_Main\Mutex_ID)
  
  Files_File_Get_Return_String = ""
  Found = 0
  
  ForEach Files_File()
    If Files_File()\Name = Name
      Files_File_Get_Return_String = Files_File()\File
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    Log_Add("Files", Lang_Get("", "Path to file not defined", Name), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  Else
    ForEach Files_Folder()
      Files_File_Get_Return_String = ReplaceString(Files_File_Get_Return_String, "["+Files_Folder()\Name+"]", Files_Folder()\Folder)
    Next
  EndIf
  
  UnlockMutex(Files_Main\Mutex_ID)
  
  ProcedureReturn Files_File_Get_Return_String
EndProcedure

Threaded Files_Folder_Get_Return_String.s = ""
Procedure.s Files_Folder_Get(Name.s)
  LockMutex(Files_Main\Mutex_ID)
  
  Files_Folder_Get_Return_String = ""
  Found = 0
  
  ForEach Files_Folder()
    If Files_Folder()\Name = Name
      Found = 1
      Files_Folder_Get_Return_String = Files_Folder()\Folder
      Break
    EndIf
  Next
  
  If Found = 0
    Log_Add("Files", Lang_Get("", "Path to folder not defined", Name), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  UnlockMutex(Files_Main\Mutex_ID)
  
  ProcedureReturn Files_Folder_Get_Return_String
EndProcedure

Procedure Files_Main()
  If Files_Main\Save_File
    Files_Main\Save_File = 0
    Files_Save(Files_File_Get("Files"))
  EndIf
EndProcedure
; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 80
; FirstLine = 78
; Folding = -
; EnableXP
; Executable = ..\Minecraft-Server.x86.exe
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0