; ########################################## Variablen ##########################################

Structure String_Main
  Regex_ID.i
EndStructure
Global String_Main.String_Main

; ########################################## Ladekram ############################################

String_Main\Regex_ID = CreateRegularExpression(#PB_Any, "[^A-Za-z0-9!$%&/()=?{}\[\]\\,;.:\-_#'+*<>|@\"+Chr(34)+" "+Chr(10)+"]|&.$|&.(&.)", #PB_RegularExpression_DotAll|#PB_RegularExpression_MultiLine)

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure.s String_GV(Input.s) ; Validiert den String
  If IsRegularExpression(String_Main\Regex_ID)
    ProcedureReturn ReplaceRegularExpression(String_Main\Regex_ID, Input, "#")
  EndIf
EndProcedure

Procedure String_IV(Input.s) ; Prüft ob der String valid ist
  If IsRegularExpression(String_Main\Regex_ID)
    ProcedureReturn MatchRegularExpression(String_Main\Regex_ID, Input)
  EndIf
EndProcedure

Procedure.s String_Multiline(Input.s) ; Teilt einen String in mehrere Zeilen auf
  Output_Message.s = ""
  Max_Length = 65
  While Len(Input) > 0
    For i = 1 To Max_Length
      If Mid(Input, i, 1) = Chr(10)
        Output_Message + Left(Input, i)
        Input = Mid(Input, i+1)
        Break
      ElseIf Mid(Input, i, 1) = Chr(0)
        Output_Message + Left(Input, i-1)
        Input = Mid(Input, i)
        Break
      ElseIf i = Max_Length
        For k = i-5 To 2 Step -1
          If Mid(Input, k, 1) = Chr(32)
            Output_Message + Left(Input, k-1) + "&3>>"+Chr(10)+"&3>>"
            Max_Length = 65-4
            For j = k-1 To 1 Step -1
              If Mid(Input, j, 1) = "&"
                Output_Message + Mid(Input, j, 2)
                Max_Length - 2
                Break
              EndIf
            Next
            Input = Mid(Input, k+1)
            Break 2
          EndIf
        Next
        Output_Message + Left(Input, i-5) + "&3>>"+Chr(10)+"&3>>"
        Max_Length = 65-4
        For j = i-5 To 1 Step -1
          If Mid(Input, j, 1) = "&"
            Output_Message + Mid(Input, j, 2)
            Max_Length -2
            Break
          EndIf
        Next
        Input = Mid(Input, i-4)
        Break
      EndIf
    Next
  Wend
  ProcedureReturn Output_Message
EndProcedure

Procedure String_Main()
  
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 63
; FirstLine = 28
; Folding = -
; EnableXP
; DisableDebugger