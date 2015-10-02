; ########################################## Variablen ##########################################

Structure Error_Main
  Counter.l                     ; Um bei mehreren Fehlern nicht die selbe Datei zu überschreiben
EndStructure
Global Error_Main.Error_Main

; ########################################## Declares ############################################

; ########################################## Ladekram ############################################

; ########################################## Proceduren ##########################################

Procedure Error_Handler()
  
  Filename.s = PeekS(Files_File_Get("Error_HTML"))
  Filename.s = ReplaceString(Filename, "[i]", Str(Error_Main\Counter))
  Error_Main\Counter + 1
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    FileBuffersSize(File_ID, 0)
    
    WriteStringN(File_ID, "<html>")
    WriteStringN(File_ID, "  <head>")
    WriteStringN(File_ID, "    <title>Minecraft-Server Plugin-Error</title>")
    WriteStringN(File_ID, "  </head>")
    WriteStringN(File_ID, "  <body>")
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        WriteStringN(File_ID, "    <b><u>Plugin-Version:</u> Windows (x86)</b><br>")
      CompilerElse
        WriteStringN(File_ID, "    <b><u>Plugin-Version:</u> Windows (x64)</b><br>")
      CompilerEndIf
    CompilerElse
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        WriteStringN(File_ID, "    <b><u>Plugin-Version:</u> Linux (x86)</b><br>")
      CompilerElse
        WriteStringN(File_ID, "    <b><u>Plugin-Version:</u> Linux (x64)</b><br>")
      CompilerEndIf
    CompilerEndIf
    WriteStringN(File_ID, "    <b><u>Servertime:</u> "+FormatDate("%hh:%ii:%ss   %dd.%mm.%yyyy", Date())+" (t = "+Str(Date())+")</b><br>")
    WriteStringN(File_ID, "    <b><u>Elapsedmilliseconds:</u> "+Str(ElapsedMilliseconds())+"ms</b><br>")
    WriteStringN(File_ID, "    <br>")
    
    WriteStringN(File_ID, "    <br>")
    WriteStringN(File_ID, "    -----------------------------------------------------------<br>")
    WriteStringN(File_ID, "    <b><u>Last Error:</u></b><br>")
    WriteStringN(File_ID, "    <br>")
    
    WriteStringN(File_ID, "    Message: <b>"+ErrorMessage()+"</b><br>")
    WriteStringN(File_ID, "    Code: <b>"+Str(ErrorCode())+"</b><br>")
    WriteStringN(File_ID, "    Address: <b>"+Str(ErrorAddress())+"</b><br>")
    If ErrorCode() = #PB_OnError_InvalidMemory   
      WriteStringN(File_ID, "    Target Address: <b>"+Str(ErrorTargetAddress())+"</b><br>")
    EndIf
    WriteStringN(File_ID, "    Line: <b>"+Str(ErrorLine())+"</b><br>")
    WriteStringN(File_ID, "    File: <b>"+GetFilePart(ErrorFile())+"</b><br>")
    
    FlushFileBuffers(File_ID)
    
    WriteStringN(File_ID, "  </body>")
    WriteStringN(File_ID, "</html>")
    
    CloseFile(File_ID)
  EndIf
  
  PrintN("")
  PrintN("")
  PrintN("Message: "+ErrorMessage())
  PrintN("Code: "+Str(ErrorCode()))
  PrintN("Address: "+Str(ErrorAddress()))
  If ErrorCode() = #PB_OnError_InvalidMemory   
    PrintN("Target Address: "+Str(ErrorTargetAddress()))
  EndIf
  PrintN("Line: "+Str(ErrorLine()))
  PrintN("File: "+GetFilePart(ErrorFile()))
  PrintN("")
  PrintN("")
  PrintN("##############################")
  PrintN("#  !!!! Plugin crashed !!!!  #")
  PrintN("#                            #")
  PrintN("# You can find more          #")
  PrintN("# information about the      #")
  PrintN("# the crash in               #")
  PrintN("# HTML/Error_*.html          #")
  PrintN("#                            #")
  PrintN("# Please send the html       #")
  PrintN("# file to the developer      #")
  PrintN("# ( Dadido3@aol.com )        #")
  PrintN("#                            #")
  PrintN("# If you started the         #")
  PrintN("# server with Autostart.exe  #")
  PrintN("# it will restart in 30-40s  #")
  PrintN("#                            #")
  PrintN("# Sorry for the crash.       #")
  PrintN("#                            #")
  PrintN("##############################")
  
  Delay(30000)
  
EndProcedure

Procedure Error_Enable()
  Error_Main\Counter = 10
  OnErrorCall(@Error_Handler())
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0