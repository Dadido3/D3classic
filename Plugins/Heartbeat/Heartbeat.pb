; ################################################### Documentation #########################################
; 
; Todo:
;  - 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; ################################################### Includes ##############################################

XIncludeFile "../Include/Include.pbi"

; ################################################### Inits #################################################

UseMD5Fingerprint()

; ################################################### Konstants #############################################

#Plugin_Name = "Heartbeat"
#Plugin_Author = "David Vogel"

#Network_Temp_Buffer_Size = 1024

; ################################################### Variables #############################################

Structure Heartbeat_Main
  Salt.s
  Public.a
  Thread_ID.i
  
  Timer_File_Check.l
  File_Date_Last.l
  Save_File.a
  Load_File.a
EndStructure
Global Heartbeat_Main.Heartbeat_Main

Structure Heartbeat_Info
  Filename.s
  Port.u
  Clients.u
  Clients_Max.u
  Name.s
  Public.a
  Version.a
  Salt.s
  State.a
EndStructure

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

Procedure.s Create_Salt()
  Salt.s = ""
  
  For i = 1 To 32
    Salt.s + Chr(65 + Random(25))
  Next
  
  ProcedureReturn Salt
EndProcedure

Procedure Heartbeat_Save(Filename.s) ; Speichert die Einstellungen
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "Public = "+Str(Heartbeat_Main\Public))
    WriteStringN(File_ID, "Salt = "+Heartbeat_Main\Salt)
    
    Heartbeat_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Heartbeat", PeekS(Lang_Get("", "File saved", Filename)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Heartbeat_Load(Filename.s) ; Lädt die Einstellungen
  If OpenPreferences(Filename)
    
    Heartbeat_Main\Public = ReadPreferenceLong("Public", 1)
    If Heartbeat_Main\Salt = ""
      Heartbeat_Main\Salt = Create_Salt()
    Else
      Heartbeat_Main\Salt = ReadPreferenceString("Salt", Create_Salt())
    EndIf
    
    Heartbeat_Main\Save_File = 1
    
    Heartbeat_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Heartbeat", PeekS(Lang_Get("", "File loaded", Filename)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
    
  EndIf
EndProcedure

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  InitNetwork()
  
  Heartbeat_Main\Load_File = 1
  
  Define_Prototypes(*Plugin_Function)
  
  OpenConsole()
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  While Heartbeat_Main\Thread_ID
    Delay(100)
  Wend
EndProcedure

Procedure Heartbeat_Do(*Heartbeat_Info.Heartbeat_Info)
  
  *Heartbeat_Info\Name = ReplaceString(*Heartbeat_Info\Name, " ", "%20")
  
  If *Heartbeat_Info\Public
    Public_String.s = "true"
  Else
    Public_String.s = "false"
  EndIf
  
  ;If ReceiveHTTPFile("http://www.minecraft.net/heartbeat.jsp?port="+Str(*Heartbeat_Info\Port)+"&users="+Str(*Heartbeat_Info\Clients)+"&max="+Str(*Heartbeat_Info\Clients_Max)+"&name="+*Heartbeat_Info\Name+"&public="+Public_String+"&version="+Str(*Heartbeat_Info\Version)+"&salt="+*Heartbeat_Info\Salt, *Heartbeat_Info\Filename)
  If ReceiveHTTPFile("http://www.classicube.net/heartbeat.jsp?port="+Str(*Heartbeat_Info\Port)+"&users="+Str(*Heartbeat_Info\Clients)+"&max="+Str(*Heartbeat_Info\Clients_Max)+"&name="+*Heartbeat_Info\Name+"&public="+Public_String+"&version="+Str(*Heartbeat_Info\Version)+"&salt="+*Heartbeat_Info\Salt, *Heartbeat_Info\Filename)
    *Heartbeat_Info\State = 2
  Else
    *Heartbeat_Info\State = 3
  EndIf
  
  Heartbeat_Main\Thread_ID = 0
EndProcedure

ProcedureCDLL Event_Client_Verify_Name(Name.s, Pass.s)
  Fingerprint.s = Heartbeat_Main\Salt + Name
  Pass_Valid.s = LTrim( StringFingerprint(Fingerprint, #PB_Cipher_MD5, 0, #PB_Ascii), "0")
  
  If Trim(LCase(Pass_Valid)) = Trim(LCase(Pass))
    ProcedureReturn #True
  Else
    Log_Add("Heartbeat", Trim(LCase(Pass_Valid)) + " !=" + Trim(LCase(Pass)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    ProcedureReturn #False
  EndIf
EndProcedure

ProcedureCDLL Main()
  Static Timer
  Static Heartbeat_Info.Heartbeat_Info
  
  Select Heartbeat_Info\State
    Case 0
      If Timer < ElapsedMilliseconds() And Heartbeat_Main\Thread_ID = 0 And Heartbeat_Main\Salt <> ""
        Timer = ElapsedMilliseconds() + 30000
        Heartbeat_Info\Filename = PeekS(Files_File_Get("Heartbeat_HTML"))
        Heartbeat_Info\Port = Network_Settings_Get_Port()
        Heartbeat_Info\Clients = Client_Count_Elements()
        Heartbeat_Info\Clients_Max = Player_Get_Players_Max()
        Heartbeat_Info\Name = PeekS(System_Get_Server_Name())
        Heartbeat_Info\Public = Heartbeat_Main\Public
        Heartbeat_Info\Version = 7
        Heartbeat_Info\Salt = Heartbeat_Main\Salt
        Heartbeat_Main\Thread_ID = CreateThread(@Heartbeat_Do(), @Heartbeat_Info)
        Heartbeat_Info\State = 1
      EndIf
    Case 2
      Log_Add("Heartbeat", "sent", 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Heartbeat_Info\State = 0
    Case 3
      Log_Add("Heartbeat", "not sent", 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Heartbeat_Info\State = 0
  EndSelect
  
  ; ######## Loading/Saving
  
  If Heartbeat_Main\Timer_File_Check < ElapsedMilliseconds()
    Heartbeat_Main\Timer_File_Check = ElapsedMilliseconds() + 1000
    File_Date = GetFileDate(PeekS(Files_File_Get("Heartbeat")), #PB_Date_Modified)
    If Heartbeat_Main\File_Date_Last <> File_Date Or Heartbeat_Main\Load_File
      Heartbeat_Main\Load_File = 0
      Heartbeat_Load(PeekS(Files_File_Get("Heartbeat")))
    EndIf
  EndIf
  
  If Heartbeat_Main\Save_File
    Heartbeat_Main\Save_File = 0
    Heartbeat_Save(PeekS(Files_File_Get("Heartbeat")))
  EndIf
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 149
; FirstLine = 123
; Folding = --
; EnableThread
; EnableXP
; EnableOnError
; Executable = Heartbeat.x64.dll
; DisableDebugger