; ########################################## Variablen ##########################################

Structure Rank_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Rank_Main.Rank_Main

; #####################################################
; !!! Struktur befindet sich in Main_Structures.pbi !!!
; #####################################################
Global NewList Rank.Rank()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Rank_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ClearList(Rank())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Rank())
        Rank()\Rank = Val(PreferenceGroupName())
        Rank()\Name = ReadPreferenceString("Name", "-")
        Rank()\On_Client = ReadPreferenceLong("On_Client", 0)
        Rank()\Prefix = ReadPreferenceString("Prefix", "")
        Rank()\Suffix = ReadPreferenceString("Suffix", "")
      Wend
    EndIf
    
    Rank_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Rank", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  Else
    Log_Add("Rank", Lang_Get("", "File not loaded", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Rank_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    SortStructuredList(Rank(), #PB_Sort_Ascending, OffsetOf(Rank\Rank), #PB_Word)
    
    ForEach Rank()
      WriteStringN(File_ID, "["+Str(Rank()\Rank)+"]")
      WriteStringN(File_ID, "Name = "+Rank()\Name)
      WriteStringN(File_ID, "On_Client = "+Str(Rank()\On_Client))
      WriteStringN(File_ID, "Prefix = "+Rank()\Prefix)
      WriteStringN(File_ID, "Suffix = "+Rank()\Suffix)
    Next
    
    Rank_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Rank", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Rank_Select(Rank, Exact=0)
  Found = 0
  
  If Exact
    ForEach Rank()
      If Rank()\Rank = Rank
        Found = 1
        Break
      EndIf
    Next
  Else
    Current_Rank = -32769
    
    ForEach Rank()
      If Rank >= Rank()\Rank And Current_Rank < Rank()\Rank
        Current_Rank = Rank()\Rank
        Found = 1
      EndIf
    Next
    
    ForEach Rank()
      If Current_Rank = Rank()\Rank
        Break
      EndIf
    Next
  EndIf
  
  If Found = 1
    ProcedureReturn #True
  Else
    Log_Add("Rank", Lang_Get("", "Can't find Rank()\Rank = [Field_0]", Str(Rank)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure Rank_Get_Pointer(Rank, Exact=0)
  If Rank_Select(Rank, Exact)
    ProcedureReturn Rank()
  EndIf
  
  ProcedureReturn 0
EndProcedure

Procedure Rank_Add(Rank, Name.s, Prefix.s, Suffix.s)
  If ListIndex(Rank()) <> -1
    *Rank_Old = Rank()
  Else
    *Rank_Old = 0
  EndIf
  
  If Rank_Select(Rank, 1)
    Rank()\Name = Name
    Rank()\Prefix = Prefix
    Rank()\Suffix = Suffix
  Else
    AddElement(Rank())
    Rank()\Rank = Rank
    Rank()\Name = Name
    Rank()\Prefix = Prefix
    Rank()\Suffix = Suffix
  EndIf
  
  Log_Add("Rank", Lang_Get("", "Rank added", Str(Rank), Name), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  Rank_Main\Save_File = 1
  
  If *Rank_Old
    ChangeCurrentElement(Rank(), *Rank_Old)
  EndIf
EndProcedure

Procedure Rank_Delete(Rank, Exact=0)
  If Rank_Select(Rank, Exact)
    DeleteElement(Rank())
    
    Log_Add("Rank", Lang_Get("", "Rank deleted", Str(Rank)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    Rank_Main\Save_File = 1
    
  EndIf
EndProcedure

Procedure Rank_Get_On_Client(Rank, Exact=0)
  If ListIndex(Rank()) <> -1
    *Rank_Old = Rank()
  Else
    *Rank_Old = 0
  EndIf
  
  Result = 0
  
  If Rank_Select(Rank, Exact)
    Result = Rank()\On_Client
  EndIf
  
  If *Rank_Old
    ChangeCurrentElement(Rank(), *Rank_Old)
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure Rank_Main()
  If Rank_Main\Save_File
    Rank_Main\Save_File = 0
    Rank_Save(Files_File_Get("Rank"))
  EndIf
  
  If Rank_Main\Timer_File_Check < Milliseconds()
    Rank_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Rank"), #PB_Date_Modified)
    If Rank_Main\File_Date_Last <> File_Date
      Rank_Load(Files_File_Get("Rank"))
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 49
; FirstLine = 41
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0