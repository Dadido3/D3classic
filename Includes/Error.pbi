; ########################################## Variablen ##########################################

Structure Error_Main
  Counter.l                     ; Um bei mehreren Fehlen nicht die selbe Datei zu überschreiben
EndStructure
Global Error_Main.Error_Main

; ########################################## Declares ############################################

Declare Error_Handler()

; ########################################## Ladekram ############################################

OnErrorCall(@Error_Handler())

; ########################################## Proceduren ##########################################

Procedure Error_Handler()
  
  Filename.s = Files_File_Get("Error_HTML")
  Filename.s = ReplaceString(Filename, "[i]", Str(Error_Main\Counter))
  Error_Main\Counter + 1
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    FileBuffersSize(File_ID, 0)
    
    WriteStringN(File_ID, "<html>")
    WriteStringN(File_ID, "  <head>")
    WriteStringN(File_ID, "    <title>Minecraft-Server Error</title>")
    WriteStringN(File_ID, "  </head>")
    WriteStringN(File_ID, "  <body>")
    
    Running_Time.s = StrD((Date() - Main\Running_Time) / 3600 , 2)
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        WriteStringN(File_ID, "    <b><u>Version:</u> "+StrF(Main\Version/1000,3)+" Windows (x86)</b><br>")
      CompilerElse
        WriteStringN(File_ID, "    <b><u>Version:</u> "+StrF(Main\Version/1000,3)+" Windows (x64)</b><br>")
      CompilerEndIf
    CompilerElse
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        WriteStringN(File_ID, "    <b><u>Version:</u> "+StrF(Main\Version/1000,3)+" Linux (x86)</b><br>")
      CompilerElse
        WriteStringN(File_ID, "    <b><u>Version:</u> "+StrF(Main\Version/1000,3)+" Linux (x64)</b><br>")
      CompilerEndIf
    CompilerEndIf
    WriteStringN(File_ID, "    <b><u>Servertime:</u> "+FormatDate("%hh:%ii:%ss   %dd.%mm.%yyyy", Date())+" (t = "+Str(Date())+")</b><br>")
    WriteStringN(File_ID, "    <b><u>Runningtime:</u> "+Running_Time+"h</b><br>")
    WriteStringN(File_ID, "    <b><u>Elapsedmilliseconds:</u> "+Str(Milliseconds())+"ms</b><br>")
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
    
    WriteStringN(File_ID, "    <br>")
    WriteStringN(File_ID, "    -----------------------------------------------------------<br>")
    WriteStringN(File_ID, "    <b><u>Last Log-Entries:</u></b><br>")
    WriteStringN(File_ID, "    <br>")
    
    WriteString(File_ID, "    <table border=1>")
    WriteStringN(File_ID, "      <tr>")
    WriteStringN(File_ID, "        <th><b>Type</b></th>")
    WriteStringN(File_ID, "        <th><b>Time</b></th>")
    WriteStringN(File_ID, "        <th><b>PB_File</b></th>")
    WriteStringN(File_ID, "        <th><b>PB_Line</b></th>")
    WriteStringN(File_ID, "        <th><b>Module</b></th>")
    WriteStringN(File_ID, "        <th><b>Message</b></th>")
    WriteStringN(File_ID, "      </tr>")
    LastElement(Log_Message())
    For i = 1 To 60
      If ListIndex(Log_Message()) <> -1
        WriteStringN(File_ID, "      <tr>")
        WriteStringN(File_ID, "        <td>"+Str(Log_Message()\Type)+"</td>")
        WriteStringN(File_ID, "        <td>"+Str(Log_Message()\Time)+"</td>")
        WriteStringN(File_ID, "        <td>"+GetFilePart(Log_Message()\PB_File)+"</td>")
        WriteStringN(File_ID, "        <td>"+Str(Log_Message()\PB_line)+"</td>")
        WriteStringN(File_ID, "        <td>"+Log_Message()\Module+"</td>")
        WriteStringN(File_ID, "        <td>"+Log_Message()\Message+"</td>")
        WriteStringN(File_ID, "      </tr>")
        
      EndIf
      If PreviousElement(Log_Message()) = 0
        Break
      EndIf
    Next
    WriteString(File_ID, "    </table>")
    
    FlushFileBuffers(File_ID)
    
    WriteStringN(File_ID, "    <br>")
    WriteStringN(File_ID, "    -----------------------------------------------------------<br>")
    WriteStringN(File_ID, "    <b><u>Watchdog:</u></b><br>")
    WriteStringN(File_ID, "    <br>")
    
    LockMutex(Watchdog_Main\Mutex_ID)
    
    Time = 5000
    
    WriteString(File_ID,  "    <table border=1>")
    WriteStringN(File_ID, "      <tr>")
    WriteStringN(File_ID, "        <th><b>Name</b></th>")
    WriteStringN(File_ID, "        <th><b>State</b></th>")
    WriteStringN(File_ID, "        <th><b>Timeout</b></th>")
    WriteStringN(File_ID, "        <th><b>Timeout_Message</b></th>")
    WriteStringN(File_ID, "        <th><b>Last_Message</b></th>")
    WriteStringN(File_ID, "        <th><b>Calls</b></th>")
    WriteStringN(File_ID, "        <th><b>CPU</b></th>")
    WriteStringN(File_ID, "        <th><b>Thread-Handle</b></th>")
    WriteStringN(File_ID, "        <th><b>Kernel-Time</b></th>")
    WriteStringN(File_ID, "        <th><b>Usermode-Time</b></th>")
    WriteStringN(File_ID, "      </tr>")
    ForEach Watchdog_Module()
      WriteStringN(File_ID, "      <tr>")
      WriteStringN(File_ID, "        <td>"+Watchdog_Module()\Name+"</td>")
      If Watchdog_Module()\Timeout_Biggest >= Watchdog_Module()\Timeout_Max
        WriteStringN(File_ID, "      <td><font color="+Chr(34)+"#AA0000"+Chr(34)+"><b>Lagging</b></font></td>")
      Else
        WriteStringN(File_ID, "      <td><font color="+Chr(34)+"#00AA00"+Chr(34)+"><b>Well</b></font></td>")
      EndIf
      WriteStringN(File_ID, "        <td>"+Str(Watchdog_Module()\Timeout_Biggest)+"ms (Max. "+Str(Watchdog_Module()\Timeout_Max)+"ms)</td>")
      WriteStringN(File_ID, "        <td>"+Watchdog_Module()\Message_Biggest+"</td>")
      WriteStringN(File_ID, "        <td>"+Watchdog_Module()\Message_Last+"</td>")
      WriteStringN(File_ID, "        <td>"+StrD(Watchdog_Module()\Calls_Per_Second*1000/Time, 1)+"/s</td>")
      WriteStringN(File_ID, "        <td>"+StrD(Watchdog_Module()\CPU_Usage, 3)+"%</td>")
      If Watchdog_Module()\Thread_ID
        WriteStringN(File_ID, "        <td>"+Str(ThreadID(Watchdog_Module()\Thread_ID))+"</td>")
        WriteStringN(File_ID, "        <td>"+StrD(Watchdog_Module()\CPU_Kernel_Time/10000000,3)+"s</td>")
        WriteStringN(File_ID, "        <td>"+StrD(Watchdog_Module()\CPU_User_Time/10000000,3)+"s</td>")
      Else
        WriteStringN(File_ID, "        <td></td>")
        WriteStringN(File_ID, "        <td></td>")
        WriteStringN(File_ID, "        <td></td>")
      EndIf
      WriteStringN(File_ID, "      </tr>")
      
      Watchdog_Module()\Calls_Per_Second = 0
      Watchdog_Module()\Timeout_Biggest = 0
    Next
    WriteString(File_ID,  "    </table>")
    
    UnlockMutex(Watchdog_Main\Mutex_ID)
    
    FlushFileBuffers(File_ID)
    
    WriteStringN(File_ID, "    <br>")
    WriteStringN(File_ID, "    -----------------------------------------------------------<br>")
    WriteStringN(File_ID, "    <b><u>Memory:</u></b><br>")
    WriteStringN(File_ID, "    <br>")
    
    WriteStringN(File_ID, "      <b><u>Overview:</u></b><br>")
    WriteStringN(File_ID, "      Memory Usage (MEM):  "+StrD(Mem_Main\Memory_Usage/1000000, 6)+"MB<br>")
    WriteStringN(File_ID, "      Memory Usage (RAM):  "+StrD(Mem_Get_WorkingSetSize()/1000000, 6)+"MB<br>")
    WriteStringN(File_ID, "      Memory Usage (PAGE): "+StrD(Mem_Get_PagefileUsage()/1000000, 6)+"MB<br>")
    WriteStringN(File_ID, "      Memory Usage (UNK): "+StrD((Mem_Get_PagefileUsage()-Mem_Main\Memory_Usage)/1000000, 6)+"MB<br>")
    WriteStringN(File_ID, "      Allocations: "+Str(ListSize(Mem_Element()))+"<br>")
    
    WriteStringN(File_ID, "      <br>")
    
    WriteStringN(File_ID, "      <b><u>Chronic:</u></b><br>")
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <table border=0 cellspacing=0>")
    WriteStringN(File_ID, "        <tr>")
    Max = 1
    ForEach Mem_Usage_Chronic()
      If Max < Mem_Usage_Chronic()\Mem
        Max = Mem_Usage_Chronic()\Mem
      EndIf
      If Max < Mem_Usage_Chronic()\Ram
        Max = Mem_Usage_Chronic()\Ram
      EndIf
      If Max < Mem_Usage_Chronic()\Page
        Max = Mem_Usage_Chronic()\Page
      EndIf
    Next
    ForEach Mem_Usage_Chronic()
      Factor.f = Mem_Usage_Chronic()\Mem/Max
      WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#000000"+Chr(34)+" valign="+Chr(34)+"bottom"+Chr(34)+" height="+Chr(34)+"500"+Chr(34)+" >")
      WriteStringN(File_ID, "            <table border=0 cellspacing=0><td bgcolor="+Chr(34)+"#FF0000"+Chr(34)+" height="+Chr(34)+Str((Factor)*500)+Chr(34)+" width="+Chr(34)+"3"+Chr(34)+"> </td></table>")
      WriteStringN(File_ID, "          </td>")
      Factor.f = Mem_Usage_Chronic()\Ram/Max
      WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#000000"+Chr(34)+" valign="+Chr(34)+"bottom"+Chr(34)+" height="+Chr(34)+"500"+Chr(34)+" >")
      WriteStringN(File_ID, "            <table border=0 cellspacing=0><td bgcolor="+Chr(34)+"#FFFF00"+Chr(34)+" height="+Chr(34)+Str((Factor)*500)+Chr(34)+" width="+Chr(34)+"3"+Chr(34)+"> </td></table>")
      WriteStringN(File_ID, "          </td>")
      Factor.f = Mem_Usage_Chronic()\Page/Max
      WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#000000"+Chr(34)+" valign="+Chr(34)+"bottom"+Chr(34)+" height="+Chr(34)+"500"+Chr(34)+" >")
      WriteStringN(File_ID, "            <table border=0 cellspacing=0><td bgcolor="+Chr(34)+"#FFFFFF"+Chr(34)+" height="+Chr(34)+Str((Factor)*500)+Chr(34)+" width="+Chr(34)+"3"+Chr(34)+"> </td></table>")
      WriteStringN(File_ID, "          </td>")
    Next
    WriteStringN(File_ID, "        </tr>")
    WriteStringN(File_ID, "      </table>")
    
    WriteStringN(File_ID, "      <br>")
    
    SortStructuredList(Mem_Element(), #PB_Sort_Ascending, OffsetOf(Mem_Element\Memory), #PB_Integer)
    
    WriteStringN(File_ID, "      <b><u>Fragmentation:</u></b><br>")
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <table border="+Chr(34)+"0"+Chr(34)+" cellspacing="+Chr(34)+"0"+Chr(34)+" cellpadding="+Chr(34)+"0"+Chr(34)+" bgcolor="+Chr(34)+"#000000"+Chr(34)+" >")
    WriteStringN(File_ID, "        <tr>")
    Pos.d = 0
    Max_Pos.d = Pow(2,32)
    ForEach Mem_Element()
      Free.d = Round((Mem_Element()\Memory-Pos)/Max_Pos*800, 1)
      Size.d = Round(Mem_Element()\Size/Max_Pos*800, 1)
      Pos = Mem_Element()\Memory + Mem_Element()\Size
      WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#000000"+Chr(34)+" width="+Chr(34)+Str(Free)+Chr(34)+" height="+Chr(34)+"20"+Chr(34)+"> </td>")
      WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#FF0000"+Chr(34)+" width="+Chr(34)+Str(Size)+Chr(34)+" height="+Chr(34)+"20"+Chr(34)+"> </td>")
    Next
    Free.d = Round((Max_Pos-Pos)/Max_Pos*800, 1)
    WriteStringN(File_ID, "          <td bgcolor="+Chr(34)+"#000000"+Chr(34)+" width="+Chr(34)+Str(Free)+Chr(34)+" height="+Chr(34)+"20"+Chr(34)+"> </td>")
    WriteStringN(File_ID, "        </tr>")
    WriteStringN(File_ID, "      </table>")
    
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    
    SortStructuredList(Mem_Element(), #PB_Sort_Descending, OffsetOf(Mem_Element\Size), #PB_Integer)
    
    WriteStringN(File_ID, "      <b><u>Elements:</u></b><br>")
    WriteStringN(File_ID, "      <br>")
    WriteString(File_ID,  "      <table border=1>")
    WriteStringN(File_ID, "        <tr>")
    WriteStringN(File_ID, "          <th><b>Address</b></th>")
    WriteStringN(File_ID, "          <th><b>Size</b></th>")
    WriteStringN(File_ID, "          <th><b>File</b></th>")
    WriteStringN(File_ID, "          <th><b>Line</b></th>")
    WriteStringN(File_ID, "          <th><b>Message</b></th>")
    WriteStringN(File_ID, "        </tr>")
    ForEach Mem_Element()
      WriteStringN(File_ID, "        <tr>")
      WriteStringN(File_ID, "          <td>"+Str(Mem_Element()\Memory)+"</td>")
      WriteStringN(File_ID, "          <td>"+StrF(Mem_Element()\Size/1000000, 6)+"MB</td>")
      WriteStringN(File_ID, "          <td>"+Mem_Element()\File+"</td>")
      WriteStringN(File_ID, "          <td>"+Str(Mem_Element()\Line)+"</td>")
      WriteStringN(File_ID, "          <td>"+Mem_Element()\Message+"</td>")
      WriteStringN(File_ID, "        </tr>")
    Next
    WriteString(File_ID,  "      </table>")
    
    FlushFileBuffers(File_ID)
    
    WriteStringN(File_ID, "    <br>")
    WriteStringN(File_ID, "    -----------------------------------------------------------<br>")
    WriteStringN(File_ID, "    <b><u>Network:</u></b><br>")
    WriteStringN(File_ID, "    <br>")
    
    WriteStringN(File_ID, "      <b><u>Clients:</u></b><br>")
    WriteStringN(File_ID, "      <br>")
    WriteString(File_ID,  "      <table border=1>")
    WriteStringN(File_ID, "        <tr>")
    WriteStringN(File_ID, "          <th><b>ID</b></th>")
    WriteStringN(File_ID, "          <th><b>Login_Name</b></th>")
    WriteStringN(File_ID, "          <th><b>Client_Version</b></th>")
    WriteStringN(File_ID, "          <th><b>IP</b></th>")
    WriteStringN(File_ID, "          <th><b>Download_Rate</b></th>")
    WriteStringN(File_ID, "          <th><b>Upload_Rate</b></th>")
    WriteStringN(File_ID, "          <th><b>Entity_ID</b></th>")
    WriteStringN(File_ID, "        </tr>")
    ForEach Network_Client()
      WriteStringN(File_ID, "        <tr>")
      WriteStringN(File_ID, "          <td>"+Str(Network_Client()\ID)+"</td>")
      WriteStringN(File_ID, "          <td>"+Network_Client()\Player\Login_Name+"</td>")
      WriteStringN(File_ID, "          <td>"+Str(Network_Client()\Player\Client_Version)+"</td>")
      WriteStringN(File_ID, "          <td>"+Network_Client()\IP+"</td>")
      WriteStringN(File_ID, "          <td>"+StrD(Network_Client()\Download_Rate/1000, 3)+"kB/s</td>")
      WriteStringN(File_ID, "          <td>"+StrD(Network_Client()\Upload_Rate/1000, 3)+"kB/s</td>")
      If Network_Client()\Player\Entity
        WriteStringN(File_ID, "          <td>"+Str(Network_Client()\Player\Entity\ID)+"</td>")
      EndIf
      WriteStringN(File_ID, "        </tr>")
    Next
    WriteString(File_ID,  "      </table>")
    
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
  PrintN("#  !!!! Server crashed !!!!  #")
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

Procedure Error_Main()
  
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 232
; FirstLine = 221
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0