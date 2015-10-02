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

; ########################################## Macros ##############################################

Macro List_Store(Pointer, Listname)
  If ListIndex(Listname) <> -1
    Pointer = Listname
  Else
    Pointer = 0
  EndIf
EndMacro

Macro List_Restore(Pointer, Listname)
  If Pointer
    ChangeCurrentElement(Listname, Pointer)
  EndIf
EndMacro

; ################################################### Includes ##############################################

XIncludeFile "../Include/Include.pbi"
XIncludeFile "../Include/Error.pbi"
;XIncludeFile "Include/Lua.pbi"

; ################################################### Inits #################################################

; ################################################### Constants #############################################

#Plugin_Name = "Lua"
#Plugin_Author = "David Vogel"

Enumeration 0
  #Lua_Event_Timer
  
  #Lua_Event_Client_Add
  #Lua_Event_Client_Delete
  #Lua_Event_Client_Login
  #Lua_Event_Client_Logout
  #Lua_Event_Entity_Add
  #Lua_Event_Entity_Delete
  #Lua_Event_Entity_Position_Set
  #Lua_Event_Entity_Die
  #Lua_Event_Map_Add
  #Lua_Event_Map_Action_Delete
  #Lua_Event_Map_Action_Resize
  #Lua_Event_Map_Action_Fill
  #Lua_Event_Map_Action_Save
  #Lua_Event_Map_Action_Load
  #Lua_Event_Map_Block_Change
  #Lua_Event_Map_Block_Change_Client
  #Lua_Event_Map_Block_Change_Player
  #Lua_Event_Chat_Map
  #Lua_Event_Chat_All
  #Lua_Event_Chat_Private
EndEnumeration

; ################################################### Variables #############################################

Structure Lua_Event
  ID.s                ; Event-ID as String
  Function.s          ; Function-Name
  Type.a              ; Event Types
  ; ------------------;
  Map_ID.l            ; Map_ID
  Time.l              ; Time (for Timer-Event)
  ; ------------------;
  Timer.l             ; Timer for the Timer-Event
EndStructure
Global NewList Lua_Event.Lua_Event()

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  Error_Enable()
  
  ;Lua_Init()
  
  InsertElement(Lua_Event())
  Lua_Event()\ID = "Test"
  Lua_Event()\Function = "Timer"
  Lua_Event()\Type = #Lua_Event_Timer
  
  Lua_Event()\Time = 1000
  Lua_Event()\Map_ID = 6
  
EndProcedure

ProcedureCDLL Event_Block_Physics(Argument.s, *Map_Data.Map_Data, X, Y, Z)
  If *Map_Data
    ;Lua_Do_Function_Map_Block_Physics(Argument.s, *Map_Data\ID, X, Y, Z)
    Map_ID = *Map_Data\ID
    If Argument = "Physic_Special_Water_Source"
      For ix = -1 To 1
        For iy = -1 To 1
          For iz = -1 To 1
            If Map_Block_Get_Type(*Map_Data, X+ix, Y+iy, Z+iz) = 0
              Map_Block_Change(-1, *Map_Data, X+ix, Y+iy, Z+iz, 8, 1, 1, 1, 1)
            EndIf
          Next
        Next
      Next
    EndIf
    If Argument = "Physic_Special_Sponge_Drain"
      For ix = -2 To 2
        For iy = -2 To 2
          For iz = -2 To 2
            If Map_Block_Get_Type(*Map_Data, X+ix, Y+iy, Z+iz) = 8
              Map_Block_Change(-1, *Map_Data, X+ix, Y+iy, Z+iz, 0, 1, 1, 1, 1)
            EndIf
          Next
        Next
      Next
    EndIf
  EndIf
EndProcedure

ProcedureCDLL Event_Map_Fill(Argument.s, *Map_Data.Map_Data, Argument_String.s)
  If *Map_Data
    ;Lua_Do_Function_Map_Fill("Mapfill_"+LCase(Argument), *Map_Data\ID, *Map_Data\Size_X, *Map_Data\Size_Y, *Map_Data\Size_Z, Argument_String)
    Map_ID = *Map_Data\ID
  EndIf
EndProcedure

ProcedureCDLL Event_Command(Argument.s, *Client.Network_Client, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
  If *Client
    ;Lua_Do_Function_Command(Argument, *Client\ID, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
    Client_ID = *Client\ID
  EndIf
EndProcedure

ProcedureCDLL Event_Build_Mode(Argument.s, *Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode, Block_Type)
  If *Client And *Map_Data
    ;Lua_Do_Function_Build_Mode(Argument, *Client\ID, *Map_Data\ID, X, Y, Z, Mode, Block_Type)
    Map_ID = *Map_Data\ID
    Client_ID = *Client\ID
  EndIf
EndProcedure

; ##############

ProcedureCDLL Event_Client_Add(*Client.Network_Client)
  Result = 1
  If *Client
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Client_Add
        ;Result = Lua_Do_Function_Event_Client_Add(Result, Lua_Event()\Function, *Client\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Client_Delete(*Client.Network_Client)
  Result = 1
  If *Client
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Client_Delete
        ;Result = Lua_Do_Function_Event_Client_Delete(Result, Lua_Event()\Function, *Client\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Client_Login(*Client.Network_Client)
  Result = 1
  If *Client
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Client_Login
        ;Result = Lua_Do_Function_Event_Client_Login(Result, Lua_Event()\Function, *Client\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Client_Logout(*Client.Network_Client)
  Result = 1
  If *Client
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Client_Logout
        ;Result = Lua_Do_Function_Event_Client_Logout(Result, Lua_Event()\Function, *Client\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Entity_Add(*Entity.Entity)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Entity_Add
        ;Result = Lua_Do_Function_Event_Entity_Add(Result, Lua_Event()\Function, *Entity\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Entity_Delete(*Entity.Entity)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Entity_Delete
        ;Result = Lua_Do_Function_Event_Entity_Delete(Result, Lua_Event()\Function, *Entity\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Entity_Position_Set(*Entity.Entity, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Entity_Position_Set And Lua_Event()\Map_ID = Map_ID
        ;Result = Lua_Do_Function_Event_Entity_Position_Set(Result, Lua_Event()\Function, *Entity\ID, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Entity_Die(*Entity.Entity)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Entity_Die
        ;Result = Lua_Do_Function_Event_Entity_Die(Result, Lua_Event()\Function, *Entity\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Add(*Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Add And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Add(Result, Lua_Event()\Function, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Delete(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Delete And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Action_Delete(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Resize(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Resize And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Action_Resize(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Fill(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Fill And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Action_Fill(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Save(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Save And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Action_Save(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Load(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Load And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Action_Load(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change(Player_Number, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Block_Change(Result, Lua_Event()\Function, Player_Number, *Map_Data\ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a)
  Result = 1
  If *Client And *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change_Client And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Block_Change_Client(Result, Lua_Event()\Function, *Client\ID, *Map_Data\ID, X, Y, Z, Mode.a, Type.a)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = 1
  If *Player And *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change_Player And Lua_Event()\Map_ID = *Map_Data\ID
        ;Result = Lua_Do_Function_Event_Map_Block_Change_Player(Result, Lua_Event()\Function, *Player\Number, *Map_Data\ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Chat_Map(*Entity.Entity, Message.s)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Chat_Map
        ;Result = Lua_Do_Function_Event_Chat_Map(Result, Lua_Event()\Function, *Entity\ID, Message.s)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Chat_All(*Entity.Entity, Message.s)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Chat_All
        ;Result = Lua_Do_Function_Event_Chat_All(Result, Lua_Event()\Function, *Entity\ID, Message.s)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Chat_Private(*Entity.Entity, Player_Name.s, Message.s)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Chat_Private
        ;Result = Lua_Do_Function_Event_Chat_Private(Result, Lua_Event()\Function, *Entity\ID, Player_Name.s, Message.s)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Main()
  
  ; ########### Timer-Event
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Timer
      If Lua_Event()\Timer < ElapsedMilliseconds()
        Lua_Event()\Timer = ElapsedMilliseconds() + Lua_Event()\Time
        ;Lua_Do_Function_Event_Timer(Lua_Event()\Function, Lua_Event()\Map_ID)
        Map_Resend(Lua_Event()\Map_ID)
      EndIf
    EndIf
  Next
  
  ; ############# Test!
  *Entity.Entity = Entity_Get_Pointer(0)
  If *Entity
    Prefix.s = *Entity\Prefix
    Name.s = *Entity\Name
    Suffix.s = *Entity\Suffix
  EndIf
	Entity_Displayname_Set(0, Prefix, Name, " &cThe Master")
  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 133
; FirstLine = 104
; Folding = -----
; EnableXP
; EnableOnError
; Executable = Fake_Lua.x64.dll
; DisableDebugger