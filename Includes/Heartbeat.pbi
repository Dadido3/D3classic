; ########################################## Variablen ##########################################

#Heartbeat_Time = 30000

Structure Heartbeat_Main
  Salt.l            ; Salt für Name-Verification
  Timer_Do.l        ; Timer für das Ausführen vom Heartbeat
EndStructure
Global Heartbeat_Main.Heartbeat_Main

; ########################################## Ladekram ############################################

Heartbeat_Main\Salt = Random(2147483647)

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Heartbeat_Salt_Get()
  ProcedureReturn Heartbeat_Main\Salt
EndProcedure

Procedure Heartbeat_Do(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "Port = "+Str(Network_Settings\Port))
    WriteStringN(File_ID, "Users = "+Str(Network_Client_Count()))
    WriteStringN(File_ID, "Users_Max = "+Str(Player_Main\Players_Max))
    WriteStringN(File_ID, "Salt = "+Str(Heartbeat_Main\Salt))
    WriteStringN(File_ID, "Name = "+System_Main\Server_Name)
    
    CloseFile(File_ID)
    
    Directory.s = Files_Folder_Get("Heartbeat")
    
    If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
      Directory = Left(Directory, Len(Directory)-1)
    EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    If RunProgram(Files_File_Get("Heartbeat_Executable_Win"), "", Directory)
    CompilerElse
    If RunProgram(Files_File_Get("Heartbeat_Executable_Linux"), "", ".")
    CompilerEndIf
      Log_Add("Heartbeat", Lang_Get("", "Heartbeat sent"), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    Else
      Log_Add("Heartbeat", Lang_Get("", "Heartbeat not sent"), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
  EndIf
EndProcedure

Procedure Heartbeat_Main()
  If Heartbeat_Main\Timer_Do < Milliseconds()
    Heartbeat_Main\Timer_Do = Milliseconds() + #Heartbeat_Time
    Heartbeat_Do(Files_File_Get("Heartbeat_Interface"))
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 54
; FirstLine = 10
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0