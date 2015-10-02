; ########################################## Variablen ##########################################

#Log_Size_Max = 1000 ; Größe in Einträgen (Intern)
#Log_File_Size_Max = 1000000 ; Größe in Bytes (Extern)

Structure Log_Main
  Timer_Do.l              ; Timer für das Ausführen von speziellen Aufgaben
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  Filename.s              ; Dateiname
EndStructure
Global Log_Main.Log_Main

Structure Log_Message
  Module.s      ; Welches Modul den Eintrag erstellte
  Message.s     ; Nachricht des Eintrags
  PB_File.s     ; Source-Code-Datei, in welcher der Log-Eintrag erstellt wurde
  PB_Line.l     ; Source-Code-Zeile, in welcher der Log-Eintrag erstellt wurde
  PB_Procedure.s; Source-Code-Procedure, in welcher der Log-Eintrag erstellt wurde
  Type.b        ; Typ der Nachricht (0=Hinweis 1=Chat 5=Warnung 10=Fehler)
  Time.l        ; Zu welcher Zeit der Eintrag erstellt wurde
EndStructure
Global NewList Log_Message.Log_Message()

; ########################################## Declares ############################################

Declare Log_File_Size_Check()

; ########################################## Ladekram ############################################

Log_File_Size_Check()

; ########################################## Proceduren ##########################################

Procedure Log_File_Size_Check() ; Prüft die Dateigröße und ändert die Datei wenn zu größ
  If FileSize(Log_Main\Filename) > #Log_File_Size_Max Or Log_Main\Filename = ""
    Max_Date = 2147483647
    Number = 0
    For i = 0 To 5
      Temp_Name.s = ReplaceString(Files_File_Get("Log"), "[i]", Str(i))
      File_Date = GetFileDate(Temp_Name, #PB_Date_Modified)
      If Max_Date > File_Date
        Max_Date = File_Date
        Number = i
      EndIf
    Next
    
    Log_Main\Filename = ReplaceString(Files_File_Get("Log"), "[i]", Str(number))
    Log_Main\Filename = ReplaceString(Log_Main\Filename, "[date]", FormatDate("%yyyy.%mm.%dd %hh_%ii_%ss", Date()))
    DeleteFile(Log_Main\Filename)
    
  EndIf
EndProcedure

Procedure Log_File_Write(Filename.s) ; Schreibt das Letzte Element in die Log-Date
  
  Log_File_Size_Check()
  
  File_ID = OpenFile(#PB_Any, Filename)
  
  If File_ID
    
    FileSeek(File_ID, Lof(File_ID))
    
    If LastElement(Log_Message())
      WriteString(File_ID, LSet(Str(Log_Message()\Type), 2)+" | ")
      WriteString(File_ID, LSet("t = "+Str(Log_Message()\Time), 15)+" | ")
      WriteString(File_ID, LSet(GetFilePart(Log_Message()\PB_File), 15)+" | ")
      WriteString(File_ID, LSet(Str(Log_Message()\PB_line), 4)+" | ")
      WriteString(File_ID, LSet(Log_Message()\Module, 15)+": ")
      WriteStringN(File_ID, Log_Message()\Message)
      
      ;WriteStringN(File_ID, "Module = "+Log_Message()\Module)
      
    EndIf
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Log_Add(Module_.s, Message.s, Type, PB_File.s, PB_Line, PB_Procedure.s) ; Speichert einen Log-Eintrag
  LastElement(Log_Message())
  If AddElement(Log_Message())
    Log_Message()\Module = Module_
    Log_Message()\Message = Message
    Log_Message()\PB_File = GetFilePart(PB_File)
    Log_Message()\PB_Line = PB_Line
    Log_Message()\PB_Procedure = PB_Procedure
    Log_Message()\Type = Type
    Log_Message()\Time = Date()
    
    Log_File_Write(Log_Main\Filename)
    
    While ListSize(Log_Message()) > #Log_Size_Max
      If FirstElement(Log_Message())
        DeleteElement(Log_Message())
      EndIf
    Wend
    
    Message = ReplaceString(Message, Chr(7), " ")
    PrintN(LSet(Str(Type), 2)+"|"+LSet(GetFilePart(PB_File), 15)+"|"+LSet(Str(PB_Line), 4)+"| "+Module_+": "+Trim(Message))
  EndIf
  
EndProcedure

Procedure Log_Main()
  
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 13
; FirstLine = 10
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0