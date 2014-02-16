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

Macro Milliseconds()
  (ElapsedMilliseconds() & 2147483647)
EndMacro

; ################################################### Includes ##############################################

XIncludeFile "../Include/Include.pbi"
XIncludeFile "../Include/Error.pbi"
XIncludeFile "Include/Lua.pbi"

; ################################################### Inits #################################################

; ################################################### Constants #############################################

#Plugin_Name = "Lua"
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
  
  ;Error_Enable()
  
  OpenConsole()
  
  Lua_Init()
  
EndProcedure

ProcedureCDLL Event_Block_Physics(Argument.s, *Map_Data.Map_Data, X, Y, Z)
  If *Map_Data
    Lua_Do_Function_Map_Block_Physics(Argument.s, *Map_Data\ID, X, Y, Z)
  EndIf
EndProcedure

ProcedureCDLL Event_Block_Create(Argument.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
  If *Map_Data And *Client
    Lua_Do_Function_Map_Block_Create(Argument.s, *Map_Data\ID, X, Y, Z, Old_Block.a, *Client\ID)
  EndIf
EndProcedure

ProcedureCDLL Event_Block_Delete(Argument.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
  If *Map_Data And *Client
    Lua_Do_Function_Map_Block_Delete(Argument.s, *Map_Data\ID, X, Y, Z, Old_Block.a, *Client\ID)
  EndIf
EndProcedure

ProcedureCDLL Event_Map_Fill(Argument.s, *Map_Data.Map_Data, Argument_String.s)
  If *Map_Data
    Lua_Do_Function_Map_Fill("Mapfill_"+LCase(Argument), *Map_Data\ID, *Map_Data\Size_X, *Map_Data\Size_Y, *Map_Data\Size_Z, Argument_String)
  EndIf
EndProcedure

ProcedureCDLL Event_Command(Argument.s, *Client.Network_Client, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
  If *Client
    Lua_Do_Function_Command(Argument, *Client\ID, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
  EndIf
EndProcedure

ProcedureCDLL Event_Build_Mode(Argument.s, *Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode, Block_Type)
  If *Client And *Map_Data
    Lua_Do_Function_Build_Mode(Argument, *Client\ID, *Map_Data\ID, X, Y, Z, Mode, Block_Type)
  EndIf
EndProcedure

; ##############

ProcedureCDLL Event_Client_Add(*Client.Network_Client)
  Result = 1
  If *Client
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Client_Add
        Result = Lua_Do_Function_Event_Client_Add(Result, Lua_Event()\Function, *Client\ID)
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
        Result = Lua_Do_Function_Event_Client_Delete(Result, Lua_Event()\Function, *Client\ID)
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
        Result = Lua_Do_Function_Event_Client_Login(Result, Lua_Event()\Function, *Client\ID)
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
        Result = Lua_Do_Function_Event_Client_Logout(Result, Lua_Event()\Function, *Client\ID)
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
        Result = Lua_Do_Function_Event_Entity_Add(Result, Lua_Event()\Function, *Entity\ID)
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
        Result = Lua_Do_Function_Event_Entity_Delete(Result, Lua_Event()\Function, *Entity\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Entity_Position_Set(*Entity.Entity, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
  Result = 1
  If *Entity
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Entity_Position_Set
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = Map_ID
          Result = Lua_Do_Function_Event_Entity_Position_Set(Result, Lua_Event()\Function, *Entity\ID, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
        EndIf
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
        Result = Lua_Do_Function_Event_Entity_Die(Result, Lua_Event()\Function, *Entity\ID)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Add(*Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Add
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Add(Result, Lua_Event()\Function, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Delete(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Delete
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Action_Delete(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Resize(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Resize
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Action_Resize(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Fill(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Fill
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Action_Fill(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Save(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Save
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Action_Save(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Action_Load(Action_ID, *Map_Data.Map_Data)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Action_Load
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Action_Load(Result, Lua_Event()\Function, Action_ID, *Map_Data\ID)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change(Player_Number, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = 1
  If *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Block_Change(Result, Lua_Event()\Function, Player_Number, *Map_Data\ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a)
  Result = 1
  If *Client And *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change_Client
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Block_Change_Client(Result, Lua_Event()\Function, *Client\ID, *Map_Data\ID, X, Y, Z, Mode.a, Type.a)
        EndIf
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Event_Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = 1
  If *Player And *Map_Data
    ForEach Lua_Event()
      If Lua_Event()\Type = #Lua_Event_Map_Block_Change_Player
        If Lua_Event()\Map_ID = -1 Or Lua_Event()\Map_ID = *Map_Data\ID
          Result = Lua_Do_Function_Event_Map_Block_Change_Player(Result, Lua_Event()\Function, *Player\Number, *Map_Data\ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
        EndIf
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
        Result = Lua_Do_Function_Event_Chat_Map(Result, Lua_Event()\Function, *Entity\ID, Message.s)
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
        Result = Lua_Do_Function_Event_Chat_All(Result, Lua_Event()\Function, *Entity\ID, Message.s)
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
        Result = Lua_Do_Function_Event_Chat_Private(Result, Lua_Event()\Function, *Entity\ID, Player_Name.s, Message.s)
      EndIf
    Next
  EndIf
  ProcedureReturn Result
EndProcedure

ProcedureCDLL Main()
  If Lua_Main\State
    If Lua_Main\Timer_File_Check < Milliseconds()
      Lua_Main\Timer_File_Check = Milliseconds() + 1000
      
      ;Temp.s = PeekS(Files_Folder_Get("Lua"))
      ;Lua_Check_New_Files(Temp)
      Lua_Check_New_Files(PeekS(Files_Folder_Get("Lua")))
      
      ForEach Lua_File()
        File_Date = GetFileDate(Lua_File()\Filename, #PB_Date_Modified)
        If Lua_File()\File_Date_Last <> File_Date
          Lua_File()\File_Date_Last = File_Date
          Lua_Do_File(Lua_File()\Filename)
        EndIf
      Next
      
    EndIf
  EndIf
  
  ; ########### Timer-Event
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Timer
      If Lua_Event()\Timer < Milliseconds()
        Lua_Event()\Timer = Milliseconds() + Lua_Event()\Time
        Lua_Do_Function_Event_Timer(Lua_Event()\Function, Lua_Event()\Map_ID)
      EndIf
    EndIf
  Next
  
EndProcedure
; IDE Options = PureBasic 5.11 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 36
; Folding = ------
; EnableThread
; EnableXP
; EnableOnError
; Executable = lua.x86.so
; DisableDebugger
; Compiler = PureBasic 5.11 (Windows - x86)