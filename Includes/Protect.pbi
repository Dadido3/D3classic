; ########################################## Dokumentation ##########################################

; Protection against manipulations
; 
; Zu überprüfende Werte:
; - Command_A4EXYZ33485() ob noch aufrufbar...
; 
; 
; Zu verändernde Variablen/Objekte
; - Map_ID
; - Network_Client
; - Player_List
; - Player_Main\Players_Max
; 
; ########################################## Variablen ##########################################

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #Protect_File = "C:\MPD.txt"
CompilerElse
  #Protect_File = "MC.tmp"
CompilerEndIf

Structure Protect_Main
  Timer.l               ; Timer
  Destroy.b
EndStructure
Global Protect_Main.Protect_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Protect_Destruct_Start()
  If Protect_Main\Destroy = 0
    Protect_Main\Destroy = 1
    
    File_ID = CreateFile(#PB_Any, #Protect_File)
    If File_ID
      CloseFile(File_ID)
    EndIf
    
  EndIf
EndProcedure

Procedure Protect_Check_A4EXYZ33485()
  Found = 0
  ForEach Command()
    If Command()\ID = "L0G"
      If Command()\Name = "a4exyz33485"
        If Command()\Function_Adress = @Command_A4EXYZ33485()
          If Command()\Internal = 1
            If Command()\Rank = 0
              If Command()\Hidden = 1
                Found = 1
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  Next
  If Found = 0
    Protect_Destruct_Start()
  EndIf
  
  Found = 0
  If FirstElement(TMessage())
    If TMessage()\String = "&eRunning Dadido3's Custom Server V"+StrF(Main\Version/1000, 3)
      Found = 1
    EndIf
  EndIf
  If Found = 0
    Protect_Destruct_Start()
  EndIf
EndProcedure

Procedure Protect_Destruct()
  Select Random(3)
    Case 0
      If FirstElement(Map_Data())
        DeleteElement(Map_Data())
      EndIf
      
    Case 1
      If FirstElement(Network_Client())
        DeleteElement(Network_Client())
      EndIf
      
    Case 2
      If FirstElement(Player_List())
        DeleteElement(Player_List())
      EndIf
      
    Case 3
      Player_Main\Players_Max = Random(123456789)
      
  EndSelect
EndProcedure

Procedure Protect_Main()
  Protect_Check_A4EXYZ33485()
  
  If Protect_Main\Timer < Milliseconds() And Protect_Main\Destroy = 1 Or FileSize(#Protect_File) <> -1
    Protect_Main\Timer = Milliseconds() + 60000
    Protect_Destruct()
  EndIf
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 18
; Folding = -
; EnableXP
; DisableDebugger