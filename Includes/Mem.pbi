; ########################################## Variablen ##########################################

Structure Mem_Main
  Timer_Stats.i       ; Timer für die HTML Statistiken
  Mutex_ID.i          ; Hauptmutex für Mem_Element Liste
  Memory_Usage.i      ; Speicherverbrauch in Bytes
EndStructure
Global Mem_Main.Mem_Main

Structure PROCESS_MEMORY_COUNTERS
   lCb                        .l
   lPageFaultCount            .l
   lPeakWorkingSetSize        .l
   lWorkingSetSize            .l
   lQuotaPeakPagedPoolUsage   .l
   lQuotaPagedPoolUsage       .l
   lQuotaPeakNonPagedPoolUsage.l
   lQuotaNonPagedPoolUsage    .l
   lPagefileUsage             .l
   lPeakPagefileUsage         .l
EndStructure

Structure Mem_Element
  *Memory
  Size.i
  File.s
  Line.l
  Message.s
EndStructure
Global NewList Mem_Element.Mem_Element()

Structure Mem_Usage_Chronic
  Mem.i
  Ram.i
  Page.i
EndStructure
Global NewList Mem_Usage_Chronic.Mem_Usage_Chronic()

; ########################################## Ladekram ############################################

Mem_Main\Mutex_ID = CreateMutex()

; ########################################## Declares ############################################

Declare Mem_Get_WorkingSetSize()
Declare Mem_Get_PagefileUsage()

; ########################################## Proceduren ##########################################

Procedure Mem_HTML_Stats()
  Generation_Time = Milliseconds()
  
  File_ID = CreateFile(#PB_Any, Files_File_Get("Mem_HTML"))
  If IsFile(File_ID)
    
    LockMutex(Mem_Main\Mutex_ID)
    
    WriteStringN(File_ID, "<html>")
    WriteStringN(File_ID, "  <head>")
    WriteStringN(File_ID, "    <title>Minecraft-Server Memory</title>")
    WriteStringN(File_ID, "  </head>")
    WriteStringN(File_ID, "  <body>")
    
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
    
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    
    WriteStringN(File_ID, "      Site generated in "+Str(Milliseconds()-Generation_Time)+" ms. "+FormatDate("%hh:%ii:%ss  %dd.%mm.%yyyy", Date())+" ("+Str(Date())+")<br>")
    
    WriteStringN(File_ID, "  </body>")
    WriteStringN(File_ID, "</html>")
    
    CloseFile(File_ID)
    
    UnlockMutex(Mem_Main\Mutex_ID)
    
  EndIf
EndProcedure

Procedure Mem_Allocate(Size, File.s, Line, Message.s)
  *Memory = AllocateMemory(Size)
  
  If *Memory
    LockMutex(Mem_Main\Mutex_ID)
    
    If AddElement(Mem_Element())
      Mem_Element()\Memory = *Memory
      Mem_Element()\Size = Size
      Mem_Element()\File = GetFilePart(File)
      Mem_Element()\Line = Line
      Mem_Element()\Message = Message
      Mem_Main\Memory_Usage + Size
    EndIf
    
    UnlockMutex(Mem_Main\Mutex_ID)
  EndIf
  
  ProcedureReturn *Memory
EndProcedure

Procedure Mem_Free(*Memory)
  LockMutex(Mem_Main\Mutex_ID)
  
  Found = 0
  
  ForEach Mem_Element()
    If Mem_Element()\Memory = *Memory
      FreeMemory(*Memory)
      Found = 1
      Mem_Main\Memory_Usage - Mem_Element()\Size
      DeleteElement(Mem_Element())
      Break
    EndIf
  Next
  
  If Found = 0
    Log_Add("Mem", Lang_Get("", "Can't find Mem_Element()\Memory = [Field_0]", Str(*Memory)), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  UnlockMutex(Mem_Main\Mutex_ID)
EndProcedure

Procedure Mem_Get_WorkingSetSize()
  Protected PMC.PROCESS_MEMORY_COUNTERS 
  
  Lib_ID = OpenLibrary(#PB_Any, "psapi.dll")
  
  If Lib_ID
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      If CallFunction(Lib_ID, "GetProcessMemoryInfo", GetCurrentProcess_() , PMC , SizeOf(PROCESS_MEMORY_COUNTERS) )
        CloseLibrary(Lib_ID)
        ProcedureReturn PMC\lWorkingSetSize; + PMC\lPagefileUsage
      Else
        CloseLibrary(Lib_ID)
        ProcedureReturn -1
      EndIf
    CompilerEndIf
    
    CloseLibrary(Lib_ID)
  Else
    ProcedureReturn -1
  EndIf
EndProcedure

Procedure Mem_Get_PagefileUsage()
  Protected PMC.PROCESS_MEMORY_COUNTERS 
  
  Lib_ID = OpenLibrary(#PB_Any, "psapi.dll")
  
  If Lib_ID
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      If CallFunction(Lib_ID, "GetProcessMemoryInfo", GetCurrentProcess_() , PMC , SizeOf(PROCESS_MEMORY_COUNTERS) )
        CloseLibrary(Lib_ID)
        ProcedureReturn PMC\lPagefileUsage
      Else
        CloseLibrary(Lib_ID)
        ProcedureReturn -1
      EndIf
    CompilerEndIf
    
    CloseLibrary(Lib_ID)
  Else
    ProcedureReturn -1
  EndIf
EndProcedure

Procedure Mem_Main()
  
  If Mem_Main\Timer_Stats < Milliseconds()
    Mem_Main\Timer_Stats = Milliseconds() + 10000
    
    ; ####### Chronik aktualisieren
    FirstElement(Mem_Usage_Chronic())
    If InsertElement(Mem_Usage_Chronic())
      Mem_Usage_Chronic()\Mem = Mem_Main\Memory_Usage
      Mem_Usage_Chronic()\Ram = Mem_Get_WorkingSetSize()
      Mem_Usage_Chronic()\Page = Mem_Get_PagefileUsage()
    EndIf
    While ListSize(Mem_Usage_Chronic()) > 100
      If LastElement(Mem_Usage_Chronic())
        DeleteElement(Mem_Usage_Chronic())
      EndIf
    Wend
    
    
    Mem_HTML_Stats()
    
  EndIf
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 131
; FirstLine = 120
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0