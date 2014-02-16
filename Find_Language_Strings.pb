Structure Language_String_Output
  Language.s                            ; Sprache in Kurzform
  Output.s                              ; Ausgabe
EndStructure

Structure Language_String
  Input.s                               ; Eingabe
  Arguments.a                           ; Anzahl der Argumente
  File.s
  List Output.Language_String_Output()  ; Liste mit Ausgaben
  Found.a
EndStructure
Global NewList Language_String.Language_String()

Procedure Language_String_Add(String.s, Arguments, File.s)
  ForEach Language_String()
    If Language_String()\Input = String
      Language_String()\Arguments = Arguments
      Language_String()\File = File
      Language_String()\Found = 1
      ProcedureReturn #False
    EndIf
  Next
  
  AddElement(Language_String())
  Language_String()\Input = String
  Language_String()\Arguments = Arguments
  Language_String()\File = File
  Language_String()\Found = 1
  
  PrintN("ADD:"+String)
  
  ProcedureReturn #True
EndProcedure

Procedure Find_Language_Strings(File.s)
  File_ID = ReadFile(#PB_Any, File)
  If IsFile(File_ID)
    Size = Lof(File_ID)
    *Memory = AllocateMemory(Size)
    
    ReadData(File_ID, *Memory, Size)
    
    File_String.s = PeekS(*Memory)
    
    Pos = 1
    While Pos <= Size
      Pos = FindString(File_String, "Lang_Get("+Chr(34), Pos)
      If Pos
        Pos + 8
      Else
        Break
      EndIf
      Bracket_Level = 0
      Quote_Level = 0
      Field = 0
      Arguments = 0
      String.s = ""
      Repeat
        Repeat
          Char.s = Mid(File_String, Pos, 1)
          Select Char
            Case " "
              If Quote_Level = 0
                Pos + 1
              Else
                Break
              EndIf
            Case ","
              If Quote_Level = 0 And Bracket_Level = 1
                Select Field
                  Case 0
                  Case 1
                    Language_String.s = String
                  Case 2
                    Arguments + 1
                  Case 3
                    Arguments + 1
                  Case 4
                    Arguments + 1
                  Case 5
                    Arguments + 1
                EndSelect
                Field + 1
                String.s = ""
                Pos + 1
              Else
                Break
              EndIf
            Case "("
              If Quote_Level = 0
                Bracket_Level + 1
                Pos + 1
              Else
                Break
              EndIf
            Case ")"
              If Quote_Level = 0
                Bracket_Level - 1
                Pos + 1
              Else
                Break
              EndIf
            Case Chr(34) ; "
              If Quote_Level = 0
                Quote_Level = 1
              Else
                Quote_Level = 0
              EndIf
              Pos + 1
            Case Chr(10)
              Break 2
            Case Chr(13)
              Break 2
            Default
              Break
          EndSelect
          If Bracket_Level = 0
            Select Field
              Case 0
              Case 1
                Language_String.s = String
              Case 2
                Arguments + 1
              Case 3
                Arguments + 1
              Case 4
                Arguments + 1
              Case 5
                Arguments + 1
            EndSelect
            Break
          EndIf
        ForEver
        
        Char.s = Mid(File_String, Pos, 1)
        Select Bracket_Level
          Case 0
            Language_String_Add(Language_String, Arguments, File)
            ;Debug Language_String
            ;Debug Arguments
            ;Debug File
            Break
          Case 1
            String + Char
            Pos + 1
          Default
            Pos + 1
            
        EndSelect
      ForEver
    Wend
    
    FreeMemory(*Memory)
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Get_Files(Directory.s)
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  Directory_ID = ExamineDirectory(#PB_Any, Directory, "*.*")
  If Directory_ID
    While NextDirectoryEntry(Directory_ID)
      Entry_Name.s = DirectoryEntryName(Directory_ID)
      Filename.s = Directory + "/" + Entry_Name
      
      If Entry_Name <> "." And Entry_Name <> ".."
        
        If DirectoryEntryType(Directory_ID) = #PB_DirectoryEntry_File
          Select LCase(Right(Entry_Name, 3))
            Case ".pb"
              Find_Language_Strings(Filename)
          EndSelect
          Select LCase(Right(Entry_Name, 4))
            Case ".pbi"
              Find_Language_Strings(Filename)
            Case ".lua"
              Find_Language_Strings(Filename)
          EndSelect
        Else
          Get_Files(Filename)
        EndIf
        
      EndIf
      
    Wend
    FinishDirectory(Directory_ID)
  EndIf
EndProcedure

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
  EndIf
EndProcedure

Procedure Language_Strings_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    SortStructuredList(Language_String(), #PB_Sort_Ascending, OffsetOf(Language_String\Input), #PB_Sort_String)
    
    ForEach Language_String()
      WriteStringN(File_ID, "["+Language_String()\Input+"]"+Str(Language_String()\Arguments))
      ForEach Language_String()\Output()
        WriteStringN(File_ID, Language_String()\Output()\Language+": "+Language_String()\Output()\Output)
      Next
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
  EndIf
EndProcedure

OpenConsole()

Language_Strings_Load("Data/Language_Strings.txt")

Get_Files(GetCurrentDirectory())

;SortStructuredList(Language_String(), #PB_Sort_Ascending, OffsetOf(Language_String\Input), #PB_Sort_String)

;ForEach Language_String()
;  Debug LSet(GetFilePart(Language_String()\File), 20, " ") + "   " + Language_String()\Input + "      A:"+Str(Language_String()\Arguments)
;Next

ForEach Language_String()
  If Language_String()\Found = 0
    PrintN("DEL:"+Language_String()\Input)
    DeleteElement(Language_String())
  EndIf
Next

Language_Strings_Save("Data/Language_Strings.txt")

PrintN("Done, press ENTER")

Input()
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 70
; FirstLine = 45
; Folding = -
; EnableXP
; DisableDebugger