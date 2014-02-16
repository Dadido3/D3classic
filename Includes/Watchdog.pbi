; ########################################## Variablen ##########################################

Structure Watchdog_Main
  Thread_ID.i           ; Watchdog-Thread
  Mutex_ID.i            ; Watchdog-Mutex
EndStructure
Global Watchdog_Main.Watchdog_Main

Structure Watchdog_Module
  Name.s                ; Name des Moduls
  Thread_ID.i           ; Thread_ID (Purebasic) wenn vorhanden
  Message_Last.s        ; Meldung, welche beim Letzten Event hinzugefügt wurde
  Message_Biggest.s     ; Meldung, welche beim größten Timeout hinzugefügt wurde
  Time_Watch.l          ; Zeitpunkt, an dem zuletzt ein Event stattfand
  Timeout.l             ; Timeout
  Timeout_Biggest.l     ; Größter Timeout
  Timeout_Max.l         ; Größte erlaubte "Lag"-Zeit in ms
  Calls_Per_Second.l    ; Aufrufe pro Sekunde
  CPU_Time.l            ; Gesamte CPU-Zeit seit beginn in ms
  CPU_Time_0.l          ; CPU-Zeit Messzeitpunk 0
  CPU_Time_4_Percent.l  ; CPU-Zeit für Prozentmessung in ms
  CPU_Kernel_Last.q     ; CPU-Kernel-Zeitpunkt vom letzten mal (wenn Thread_ID vorhanden)
  CPU_User_Last.q       ; CPU-Usermode-Zeitpunkt vom letzten mal (wenn Thread_ID vorhanden)
  CPU_Kernel_Time.q     ; CPU-Kernel-Zeit (wenn Thread_ID vorhanden)
  CPU_User_Time.q       ; CPU-Usermode-Zeit (wenn Thread_ID vorhanden)
  CPU_Usage.d           ; CPU-Nutzung in Prozent
EndStructure
Global NewList Watchdog_Module.Watchdog_Module()

; ########################################## Declares ############################################

Declare Watchdog_Thread(*Dummy)

; ########################################## Ladekram ############################################

Watchdog_Main\Mutex_ID = CreateMutex()

Watchdog_Main\Thread_ID = CreateThread(@Watchdog_Thread(), 0)

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Main"
Watchdog_Module()\Timeout_Max = 200

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Network"
Watchdog_Module()\Timeout_Max = 200

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Map_Physic"
Watchdog_Module()\Timeout_Max = 400

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Map_Blockchanging"
Watchdog_Module()\Timeout_Max = 400

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Map_Action"
Watchdog_Module()\Timeout_Max = 10000

AddElement(Watchdog_Module())
Watchdog_Module()\Name = "Client_Login"
Watchdog_Module()\Timeout_Max = 2000

; ########################################## Proceduren ##########################################

Procedure Watchdog_Thread(*Dummy)
  Repeat
    
    LockMutex(Watchdog_Main\Mutex_ID)
    
    Generation_Time = Milliseconds()
    
    Time = Milliseconds() - Timer
    Timer = Milliseconds()
    
    ForEach Watchdog_Module()
      Watchdog_Module()\Timeout = Milliseconds()-Watchdog_Module()\Time_Watch
      If Watchdog_Module()\Timeout_Biggest < Watchdog_Module()\Timeout
        Watchdog_Module()\Timeout_Biggest = Watchdog_Module()\Timeout
      EndIf
      
      If Watchdog_Module()\Thread_ID
        Thread_Handle = ThreadID(Watchdog_Module()\Thread_ID)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          GetThreadTimes_(Thread_Handle, @Time_Creation.q, @Time_Exit.q, @Time_Kernel.q, @Time_User.q)
        CompilerEndIf
        Watchdog_Module()\CPU_Kernel_Time = Time_Kernel
        Watchdog_Module()\CPU_User_Time = Time_User
        Watchdog_Module()\CPU_Usage = (Time_Kernel-Watchdog_Module()\CPU_Kernel_Last) + (Time_User-Watchdog_Module()\CPU_User_Last)
        Watchdog_Module()\CPU_Usage / (Time * 100)
        Watchdog_Module()\CPU_Kernel_Last = Time_Kernel
        Watchdog_Module()\CPU_User_Last = Time_User
      Else
        Watchdog_Module()\CPU_Usage = Watchdog_Module()\CPU_Time_4_Percent * 100 / Time ;(%)
        Watchdog_Module()\CPU_Time_4_Percent = 0
      EndIf
    Next
    
    File_ID = CreateFile(#PB_Any, Files_File_Get("Watchdog_HTML"))
    If IsFile(File_ID)
      
      WriteStringN(File_ID, "<html>")
      WriteStringN(File_ID, "  <head>")
      WriteStringN(File_ID, "    <title>Minecraft-Server Watchdog</title>")
      WriteStringN(File_ID, "  </head>")
      WriteStringN(File_ID, "  <body>")
      
      WriteStringN(File_ID, "    <b><u>Modules:</u></b><br>")
      WriteStringN(File_ID, "    <br>")
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
      
      WriteStringN(File_ID, "      <br>")
      WriteStringN(File_ID, "      <br>")
      WriteStringN(File_ID, "      <br>")
      
      WriteStringN(File_ID, "    Site generated in "+Str(Milliseconds()-Generation_Time)+" ms. "+FormatDate("%hh:%ii:%ss  %dd.%mm.%yyyy", Date())+" ("+Str(Date())+")<br>")
      
      WriteStringN(File_ID, "  </body>")
      WriteStringN(File_ID, "</html>")
      
      CloseFile(File_ID)
    EndIf
    
    UnlockMutex(Watchdog_Main\Mutex_ID)
    Delay(5000) ; #################### Sicherer Wartebereich
    
  ForEver
EndProcedure

Procedure Watchdog_Thread_ID_Set(Module_.s, Thread_ID)
  LockMutex(Watchdog_Main\Mutex_ID)
  ForEach Watchdog_Module()
    If Watchdog_Module()\Name = Module_
      Watchdog_Module()\Thread_ID = Thread_ID
    EndIf
  Next
  UnlockMutex(Watchdog_Main\Mutex_ID)
EndProcedure

Macro Watchdog_Watch(Module_, Message, State)
  LockMutex(Watchdog_Main\Mutex_ID)
  ForEach Watchdog_Module()
    If Watchdog_Module()\Name = Module_
      Watchdog_Module()\Timeout = Milliseconds()-Watchdog_Module()\Time_Watch
      If Watchdog_Module()\Timeout_Biggest < Watchdog_Module()\Timeout
        Watchdog_Module()\Timeout_Biggest = Watchdog_Module()\Timeout
        Watchdog_Module()\Message_Biggest = Watchdog_Module()\Message_Last
      EndIf
      Watchdog_Module()\Message_Last = Message
      If State = 0
        Watchdog_Module()\CPU_Time_0 = Milliseconds()
      ElseIf State = 2
        Watchdog_Module()\CPU_Time + (Milliseconds() - Watchdog_Module()\CPU_Time_0)
        Watchdog_Module()\CPU_Time_4_Percent + (Milliseconds() - Watchdog_Module()\CPU_Time_0)
        Watchdog_Module()\Calls_Per_Second + 1
      EndIf
      Watchdog_Module()\Time_Watch = Milliseconds()
      Break
    EndIf
  Next
  UnlockMutex(Watchdog_Main\Mutex_ID)
EndMacro

Procedure Watchdog_Main()
  
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 61
; FirstLine = 58
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0