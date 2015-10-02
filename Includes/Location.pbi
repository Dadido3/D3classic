; ########################################## Variablen ##########################################

Structure Location_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Location_Main.Location_Main

Structure Location
  Name.s                  ; Name der Location
  Map_ID.l
  X.f
  Y.f
  Z.f
  Rot.f
  Look.f
EndStructure
Global NewList Location.Location()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Location_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ClearList(Location())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Location())
        Location()\Name = PreferenceGroupName()
        Location()\Map_ID = ReadPreferenceLong("Map_ID", -1)
        Location()\X = ReadPreferenceFloat("X", 0)
        Location()\Y = ReadPreferenceFloat("Y", 0)
        Location()\Z = ReadPreferenceFloat("Z", 0)
        Location()\Rot = ReadPreferenceFloat("Rot", 0)
        Location()\Look = ReadPreferenceFloat("Look", 0)
      Wend
    EndIf
    
    Location_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Location", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  Else
    Log_Add("Location", Lang_Get("", "File not loaded", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Location_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Location()
      WriteStringN(File_ID, "["+Location()\Name+"]")
      WriteStringN(File_ID, "Map_ID = "+Str(Location()\Map_ID))
      WriteStringN(File_ID, "X = "+StrF(Location()\X,2))
      WriteStringN(File_ID, "Y = "+StrF(Location()\Y,2))
      WriteStringN(File_ID, "Z = "+StrF(Location()\Z,2))
      WriteStringN(File_ID, "Rot = "+StrF(Location()\Rot,2))
      WriteStringN(File_ID, "Look = "+StrF(Location()\Look,2))
    Next
    
    Location_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Location", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Location_Select(Name.s) ; Wählt das Linked-List-Objekt
  
  If ListIndex(Location()) <> -1 And LCase(Location()\Name) = LCase(Name)
    ProcedureReturn #True
  Else
    ForEach Location()
      If LCase(Location()\Name) = LCase(Name)
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  Log_Add("Location", Lang_Get("", "Can't find Location()\Name = [Field_0]", Name), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  ProcedureReturn #False
EndProcedure

Procedure Location_Add(Name.s, Map_ID, X.f, Y.f, Z.f, Rot.f, Look.f)
  If Location_Select(Name)
    Location()\Map_ID = Map_ID
    Location()\X = X
    Location()\Y = Y
    Location()\Z = Z
    Location()\Rot = Rot
    Location()\Look = Look
    Location_Main\Save_File = 1
  Else
    AddElement(Location())
    Location()\Name = Name
    Location()\Map_ID = Map_ID
    Location()\X = X
    Location()\Y = Y
    Location()\Z = Z
    Location()\Rot = Rot
    Location()\Look = Look
    Location_Main\Save_File = 1
  EndIf
EndProcedure

Procedure Location_Delete(Name.s)
  If Location_Select(Name)
    DeleteElement(Location())
    Location_Main\Save_File = 1
  EndIf
EndProcedure

Procedure Location_Main()
  If Location_Main\Save_File
    Location_Main\Save_File = 0
    Location_Save(Files_File_Get("Location"))
  EndIf
  
  If Location_Main\Timer_File_Check < Milliseconds()
    Location_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Location"), #PB_Date_Modified)
    If Location_Main\File_Date_Last <> File_Date
      Location_Load(Files_File_Get("Location"))
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 126
; FirstLine = 85
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0