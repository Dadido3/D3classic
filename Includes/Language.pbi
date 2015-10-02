; ########################################## Variablen ##########################################

Structure Language_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung laden
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
  Language.s              ; Hauptsprache, wenn keine angegeben
EndStructure
Global Language_Main.Language_Main

Structure Language_String_Output
  Language.s                            ; Sprache in Kurzform
  Output.s                              ; Ausgabe
EndStructure

Structure Language_String
  Input.s                               ; Eingabe
  Arguments.a                           ; Anzahl der Argumente
  List Output.Language_String_Output()  ; Liste mit Ausgaben
EndStructure
Global NewList Language_String.Language_String()

; ########################################## Ladekram ############################################

Language_Main\Language = "en"
Language_Main\Save_File = 1

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Language_Strings_Load(Filename.s)
  ClearList(Language_String())
  
  File_ID = ReadFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    While Eof(File_ID) = 0
      Line.s = ReadString(File_ID)
      
      If Left(Line, 1) = "["
        String_Input.s = Mid(Line, 2, Len(Line)-3)
        AddElement(Language_String())
        Language_String()\Input = String_Input
        Language_String()\Arguments = Val(Right(Line, 1))
      ElseIf Line <> ""
        String_Language.s = StringField(Line, 1, ":")
        String_Output.s = Mid(Line, Len(String_Language)+3)
        If ListIndex(Language_String()) <> -1
          AddElement(Language_String()\Output())
          Language_String()\Output()\Language = String_Language
          Language_String()\Output()\Output = String_Output
        EndIf
      EndIf
    Wend
    
    CloseFile(File_ID)
    
    Language_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Language", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Language_Strings_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    SortStructuredList(Language_String(), #PB_Sort_Ascending, OffsetOf(Language_String\Input), #PB_String)
    
    ForEach Language_String()
      WriteStringN(File_ID, "["+Language_String()\Input+"]"+Str(Language_String()\Arguments))
      ForEach Language_String()\Output()
        WriteStringN(File_ID, Language_String()\Output()\Language+": "+Language_String()\Output()\Output)
      Next
      WriteStringN(File_ID, "")
    Next
    
    Language_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Language", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Threaded Lang_Get_Return_String.s = ""
Procedure.s Lang_Get(Language.s, Input.s, Field_0.s = "", Field_1.s = "", Field_2.s = "", Field_3.s = "") ; Wandelt einen String zur passenden Sprache  
  If Language = ""
    Language = Language_Main\Language
  EndIf
  
  Lang_Get_Return_String = Input
  
  Found = 0
  
  ForEach Language_String()
    If Language_String()\Input = Input
      Found = 1
      ForEach Language_String()\Output()
        If Language_String()\Output()\Language = Language
          Lang_Get_Return_String = Language_String()\Output()\Output
          Break
        EndIf
      Next
      Break
    EndIf
  Next
  
  If Found = 0
    AddElement(Language_String())
    Language_String()\Input = Input
    If Field_0 : Language_String()\Arguments + 1 : EndIf
    If Field_1 : Language_String()\Arguments + 1 : EndIf
    If Field_2 : Language_String()\Arguments + 1 : EndIf
    If Field_3 : Language_String()\Arguments + 1 : EndIf
    Log_Add("Language", "GET: String not found. Input:"+Input, 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    Language_Main\Save_File = 1
  EndIf
  
  Lang_Get_Return_String = ReplaceString(Lang_Get_Return_String, "[Field_0]", Field_0)
  Lang_Get_Return_String = ReplaceString(Lang_Get_Return_String, "[Field_1]", Field_1)
  Lang_Get_Return_String = ReplaceString(Lang_Get_Return_String, "[Field_2]", Field_2)
  Lang_Get_Return_String = ReplaceString(Lang_Get_Return_String, "[Field_3]", Field_3)
  
  ProcedureReturn Lang_Get_Return_String
EndProcedure

Procedure Language_Main()
  If Language_Main\Timer_File_Check < Milliseconds()
    Language_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Language_Strings"), #PB_Date_Modified)
    If Language_Main\File_Date_Last <> File_Date
      Language_Strings_Load(Files_File_Get("Language_Strings"))
    EndIf
  EndIf
  
  If Language_Main\Save_File
    Language_Main\Save_File = 0
    Language_Strings_Save(Files_File_Get("Language_Strings"))
  EndIf
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 67
; FirstLine = 56
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0