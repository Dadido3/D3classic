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

; ################################################### Konstants #############################################

#Plugin_Name = "Example"
#Plugin_Author = "David Vogel"

; ################################################### Variables #############################################

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  OpenConsole()
EndProcedure

ProcedureCDLL Event_Block_Physics(Argument.s, *Map_Data.Map_Data, X, Y, Z)
  Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  ;X + Random(2)-1
  ;Y + Random(2)-1
  ;Z + Random(2)-1
  ;Map_Block_Change(-1, *Map_Data, X, Y, Z, Block_Type, 1, 1, 1, 1)
EndProcedure

ProcedureCDLL Event_Map_Fill(Argument.s, *Map_Data.Map_Data, Argument_String.s)
  ;Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  ;X + Random(2)-1
  ;Y + Random(2)-1
  ;Z + Random(2)-1
  ;Map_Block_Change(-1, *Map_Data, X, Y, Z, Block_Type, 1, 1, 1, 1)
  
  If LCase(Argument) = "example"
    
    Time = ElapsedMilliseconds()
    
    X = *Map_Data\Size_X
    Y = *Map_Data\Size_Y
    Z = *Map_Data\Size_Z
    
    For ix = 0 To X-1
      For iy = 0 To Y-1
        For iz = 0 To (Z/2)-1
          Map_Block_Change(-1, *Map_Data, ix, iy, iz, 3, 0, 0, 0, 0)
        Next
      Next
    Next
    
    System_Message_Network_Send_2_All(*Map_Data\ID, "&eTime: "+Str(ElapsedMilliseconds()-Time)+"ms")
  EndIf
EndProcedure

ProcedureCDLL Main()
  Static Timer
  
  If Timer < ElapsedMilliseconds()
    Timer = ElapsedMilliseconds() + 1000
    
    Client_Elements = Client_Count_Elements()
    If Client_Elements > 0
      Dim Temp.Plugin_Result_Element(Client_Elements)
      Client_Get_Array(@Temp())
      
      For i = 0 To Client_Elements-1
        *Client.Network_Client = Temp(i)\Pointer
        
        For j = 0 To *Client\Buffer_Output_Available/250
          Map_Block_Change(-1, Map_Get_Pointer(0), 10+j, 0, 63-i, 21, 0, 0, 1, 10)
        Next
        For k = j To 256
          Map_Block_Change(-1, Map_Get_Pointer(0), 10+k, 0, 63-i, 49, 0, 0, 1, 10)
        Next
        ;System_Message_Network_Send_2_All(-1, "&e"+*Client\IP)
      Next
      For k = i To 20
        For l = 0 To 256
          Map_Block_Change(-1, Map_Get_Pointer(0), 10+l, 0, 63-k, 49, 0, 0, 1, 10)
        Next
      Next
      
      
    EndIf
    
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 85
; FirstLine = 66
; Folding = -
; EnableXP
; EnableOnError
; Executable = Example.x86.dll
; DisableDebugger