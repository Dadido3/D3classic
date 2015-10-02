
; ########################################## Konstanten ########################################

#Plugin_Version = 503

; ######################################### Prototypes ##########################################

PrototypeC   Plugin_Inside_Main()
PrototypeC   Plugin_Inside_Event_Block_Physics(Argument.s, *Map_Data.Map_Data, X, Y, Z)
PrototypeC   Plugin_Inside_Event_Block_Create(Argument.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Block_Delete(Argument.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Map_Fill(Argument.s, *Map_Data.Map_Data, Argument_String.s)
PrototypeC   Plugin_Inside_Event_Command(Argument.s, *Client.Network_Client, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
PrototypeC   Plugin_Inside_Event_Build_Mode(Argument.s, *Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode, Block_Type)

PrototypeC   Plugin_Inside_Event_Client_Add(*Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Client_Delete(*Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Client_Verify_Name(Name.s, Pass.s)
PrototypeC   Plugin_Inside_Event_Client_Login(*Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Client_Logout(*Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Entity_Add(*Entity.Entity)
PrototypeC   Plugin_Inside_Event_Entity_Delete(*Entity.Entity)
PrototypeC   Plugin_Inside_Event_Entity_Position_Set(*Entity.Entity, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
PrototypeC   Plugin_Inside_Event_Entity_Die(*Entity.Entity)
PrototypeC   Plugin_Inside_Event_Map_Add(*Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Action_Delete(Action_ID, *Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Action_Resize(Action_ID, *Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Action_Fill(Action_ID, *Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Action_Save(Action_ID, *Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Action_Load(Action_ID, *Map_Data.Map_Data)
PrototypeC   Plugin_Inside_Event_Map_Block_Change(Player_Number, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
PrototypeC   Plugin_Inside_Event_Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a)
PrototypeC   Plugin_Inside_Event_Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
PrototypeC   Plugin_Inside_Event_Chat_Map(*Entity.Entity, Message.s)
PrototypeC   Plugin_Inside_Event_Chat_All(*Entity.Entity, Message.s)
PrototypeC   Plugin_Inside_Event_Chat_Private(*Entity.Entity, Player_Name.s, Message.s)

; ########################################## Variablen ##########################################

Structure Plugin_Main
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
EndStructure
Global Plugin_Main.Plugin_Main

Structure Plugin_Info
  Name.s{16}                  ; Bezeichnung des Plugins (16 Zeichen!) / Name of the Plugin (16 Chars!)
  Version.l                   ; Pluginversion (Wird geändert wenn ältere Plugins nicht mehr kompatibel sind) /  Pluginversion
  Author.s{16}                ; Autor des Plugins (16 Zeichen!) / Author of the plugin
EndStructure
Structure Plugin_Inside_Functions
  Main.Plugin_Inside_Main
  Event_Block_Physics.Plugin_Inside_Event_Block_Physics
  Event_Block_Create.Plugin_Inside_Event_Block_Create
  Event_Block_Delete.Plugin_Inside_Event_Block_Delete
  Event_Map_Fill.Plugin_Inside_Event_Map_Fill
  Event_Command.Plugin_Inside_Event_Command
  Event_Build_Mode.Plugin_Inside_Event_Build_Mode
  
  Event_Client_Add.Plugin_Inside_Event_Client_Add
  Event_Client_Delete.Plugin_Inside_Event_Client_Delete
  Event_Client_Verify_Name.Plugin_Inside_Event_Client_Verify_Name
  Event_Client_Login.Plugin_Inside_Event_Client_Login
  Event_Client_Logout.Plugin_Inside_Event_Client_Logout
  Event_Entity_Add.Plugin_Inside_Event_Entity_Add
  Event_Entity_Delete.Plugin_Inside_Event_Entity_Delete
  Event_Entity_Position_Set.Plugin_Inside_Event_Entity_Position_Set
  Event_Entity_Die.Plugin_Inside_Event_Entity_Die
  Event_Map_Add.Plugin_Inside_Event_Map_Add
  Event_Map_Action_Delete.Plugin_Inside_Event_Map_Action_Delete
  Event_Map_Action_Resize.Plugin_Inside_Event_Map_Action_Resize
  Event_Map_Action_Fill.Plugin_Inside_Event_Map_Action_Fill
  Event_Map_Action_Save.Plugin_Inside_Event_Map_Action_Save
  Event_Map_Action_Load.Plugin_Inside_Event_Map_Action_Load
  Event_Map_Block_Change.Plugin_Inside_Event_Map_Block_Change
  Event_Map_Block_Change_Client.Plugin_Inside_Event_Map_Block_Change_Client
  Event_Map_Block_Change_Player.Plugin_Inside_Event_Map_Block_Change_Player
  Event_Chat_Map.Plugin_Inside_Event_Chat_Map
  Event_Chat_All.Plugin_Inside_Event_Chat_All
  Event_Chat_Private.Plugin_Inside_Event_Chat_Private
EndStructure
Structure Plugin
  Plugin_Info.Plugin_Info
  Functions.Plugin_Inside_Functions
  Filename.s
  Library_ID.i                ; Rückgabe von Openlibrary (0: Ungültig)
  File_Date_Last.l            ; Datum letzter Änderung
EndStructure
Global NewList Plugin.Plugin()

Structure Plugin_Result_Element
  *Pointer
  ID.l
EndStructure

XIncludeFile "../Shared Includes/Plugin_Functions.pbi"
Global Plugin_Function.Plugin_Function

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Imports ##########################################

; ########################################## Macros #############################################

; #################################### Initkram ###############################################

;-################################## Proceduren im Plugin ##########################################

Procedure Client_Count_Elements()
  ProcedureReturn ListSize(Network_Client())
EndProcedure

Procedure Client_Get_Array(*Memory)
  Element = 0
  ForEach Network_Client()
    *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = Network_Client()
    *Pointer\ID = Network_Client()\ID
    Element + 1
  Next
EndProcedure

Procedure Network_Settings_Get_Port()
  ProcedureReturn Network_Settings\Port
EndProcedure

Procedure Entity_Count_Elements()
  ProcedureReturn ListSize(Entity())
EndProcedure

Procedure Entity_Get_Array(*Memory)
  Element = 0
  ForEach Entity()
    *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = Entity()
    *Pointer\ID = Entity()\ID
    Element + 1
  Next
EndProcedure

Procedure Player_Count_Elements()
  ProcedureReturn ListSize(Player_List())
EndProcedure

Procedure Player_Get_Array(*Memory)
  Element = 0
  ForEach Player_List()
    *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = Player_List()
    *Pointer\ID = Player_List()\Number
    Element + 1
  Next
EndProcedure

Procedure Player_Get_Players_Max()
  ProcedureReturn Player_Main\Players_Max
EndProcedure

Procedure Map_Count_Elements()
  ProcedureReturn ListSize(Map_Data())
EndProcedure

Procedure Map_Get_Array(*Memory)
  Element = 0
  ForEach Map_Data()
    *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = Map_Data()
    *Pointer\ID = Map_Data()\ID
    Element + 1
  Next
EndProcedure

Procedure Block_Count_Elements()
  ProcedureReturn 256
EndProcedure

Procedure Block_Get_Array(*Memory)
  ;Size = 256 * SizeOf(Block)
  For i = 0 To 255
    *Pointer.Plugin_Result_Element = *Memory + i*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = @Block(i)
    *Pointer\ID = i
  Next
EndProcedure

Procedure Rank_Count_Elements()
  ProcedureReturn ListSize(Rank())
EndProcedure

Procedure Rank_Get_Array(*Memory)
  Element = 0
  ForEach Rank()
    *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
    *Pointer\Pointer = Rank()
    *Pointer\ID = Rank()\Rank
    Element + 1
  Next
EndProcedure

Procedure Teleporter_Count_Elements(*Map_Data.Map_Data)
  If *Map_Data
    ProcedureReturn ListSize(*Map_Data\Teleporter())
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Teleporter_Get_Array(*Map_Data.Map_Data, *Memory)
  If *Map_Data
    Element = 0
    ForEach *Map_Data\Teleporter()
      *Pointer.Plugin_Result_Element = *Memory + Element*SizeOf(Plugin_Result_Element)
      *Pointer\Pointer = *Map_Data\Teleporter()
      *Pointer\ID = -1;Teleporter()\ID
      Element + 1
    Next
  EndIf
EndProcedure

Procedure.s System_Get_Server_Name()
  ProcedureReturn System_Main\Server_Name
EndProcedure

Procedure Main_LockMutex()
  LockMutex(Main\Mutex)
EndProcedure

Procedure Main_UnlockMutex()
  UnlockMutex(Main\Mutex)
EndProcedure

; ########################################## Eintragen der Funktionen in die Struktur

Plugin_Function\Client_Count_Elements = @Client_Count_Elements()
Plugin_Function\Client_Get_Array = @Client_Get_Array()
Plugin_Function\Client_Get_Pointer = @Network_Client_Get_Pointer()
Plugin_Function\Client_Kick = @Network_Client_Kick()

Plugin_Function\Network_Settings_Get_Port = @Network_Settings_Get_Port()

Plugin_Function\Build_Mode_Set = @Build_Mode_Set()
Plugin_Function\Build_Mode_Get = @Build_Mode_Get()
Plugin_Function\Build_Mode_State_Set = @Build_Mode_State_Set()
Plugin_Function\Build_Mode_State_Get = @Build_Mode_State_Get()
Plugin_Function\Build_Mode_Coordinate_Set = @Build_Mode_Coordinate_Set()
Plugin_Function\Build_Mode_Coordinate_Get_X = @Build_Mode_Coordinate_Get_X()
Plugin_Function\Build_Mode_Coordinate_Get_Y = @Build_Mode_Coordinate_Get_Y()
Plugin_Function\Build_Mode_Coordinate_Get_Z = @Build_Mode_Coordinate_Get_Z()
Plugin_Function\Build_Mode_Long_Set = @Build_Mode_Long_Set()
Plugin_Function\Build_Mode_Long_Get = @Build_Mode_Long_Get()
Plugin_Function\Build_Mode_Float_Set = @Build_Mode_Float_Set()
Plugin_Function\Build_Mode_Float_Get = @Build_Mode_Float_Get()
Plugin_Function\Build_Mode_String_Set = @Build_Mode_String_Set()
Plugin_Function\Build_Mode_String_Get = @Build_Mode_String_Get()

Plugin_Function\Build_Line_Player = @Build_Line_Player()
Plugin_Function\Build_Box_Player = @Build_Box_Player()
Plugin_Function\Build_Sphere_Player = @Build_Sphere_Player()
Plugin_Function\Build_Rank_Box = @Build_Rank_Box()

Plugin_Function\Font_Draw_Text = @Font_Draw_Text()
Plugin_Function\Font_Draw_Text_Player = @Font_Draw_Text_Player()

Plugin_Function\Entity_Count_Elements = @Entity_Count_Elements()
Plugin_Function\Entity_Get_Array = @Entity_Get_Array()
Plugin_Function\Entity_Get_Pointer = @Entity_Get_Pointer()
Plugin_Function\Entity_Add = @Entity_Add()
Plugin_Function\Entity_Delete = @Entity_Delete()
Plugin_Function\Entity_Resend = @Entity_Resend()
Plugin_Function\Entity_Message_2_Clients = @Entity_Message_2_Clients()
Plugin_Function\Entity_Displayname_Get = @Entity_Displayname_Get()
Plugin_Function\Entity_Displayname_Set = @Entity_Displayname_Set()
Plugin_Function\Entity_Position_Set = @Entity_Position_Set()
Plugin_Function\Entity_Kill = @Entity_Kill()

Plugin_Function\Player_Count_Elements = @Player_Count_Elements()
Plugin_Function\Player_Get_Array = @Player_Get_Array()
Plugin_Function\Player_Get_Pointer = @Player_List_Get_Pointer()
Plugin_Function\Player_Get_Players_Max = @Player_Get_Players_Max()
Plugin_Function\Player_Attribute_Long_Set = @Player_Attribute_Long_Set()
Plugin_Function\Player_Attribute_Long_Get = @Player_Attribute_Long_Get()
Plugin_Function\Player_Attribute_String_Set = @Player_Attribute_String_Set()
Plugin_Function\Player_Attribute_String_Get = @Player_Attribute_String_Get()
Plugin_Function\Player_Inventory_Set = @Player_Inventory_Set()
Plugin_Function\Player_Inventory_Get = @Player_Inventory_Get()
Plugin_Function\Player_Rank_Set = @Player_Rank_Set()
Plugin_Function\Player_Kick = @Player_Kick()
Plugin_Function\Player_Ban = @Player_Ban()
Plugin_Function\Player_Unban = @Player_Unban()
Plugin_Function\Player_Stop = @Player_Stop()
Plugin_Function\Player_Unstop = @Player_Unstop()
Plugin_Function\Player_Mute = @Player_Mute()
Plugin_Function\Player_Unmute = @Player_Unmute()
Plugin_Function\Player_Get_Prefix = @Player_Get_Prefix()
Plugin_Function\Player_Get_Name = @Player_Get_Name()
Plugin_Function\Player_Get_Suffix = @Player_Get_Suffix()

Plugin_Function\Map_Count_Elements = @Map_Count_Elements()
Plugin_Function\Map_Get_Array = @Map_Get_Array()
Plugin_Function\Map_Get_Pointer = @Map_Get_Pointer()
Plugin_Function\Map_Block_Change = @Map_Block_Change()
Plugin_Function\Map_Block_Change_Client = @Map_Block_Change_Client()
Plugin_Function\Map_Block_Change_Player = @Map_Block_Change_Player()
Plugin_Function\Map_Block_Move = @Map_Block_Move()
Plugin_Function\Map_Block_Get_Type = @Map_Block_Get_Type()
Plugin_Function\Map_Block_Get_Rank = @Map_Block_Get_Rank()
Plugin_Function\Map_Block_Get_Player_Number = @Map_Block_Get_Player_Number()
Plugin_Function\Map_Block_Set_Rank_Box = @Map_Block_Set_Rank_Box()
Plugin_Function\Map_Add = @Map_Add()
Plugin_Function\Map_Action_Add_Save = @Map_Action_Add_Save()
Plugin_Function\Map_Action_Add_Load = @Map_Action_Add_Load()
Plugin_Function\Map_Action_Add_Resize = @Map_Action_Add_Resize()
Plugin_Function\Map_Action_Add_Fill = @Map_Action_Add_Fill()
Plugin_Function\Map_Action_Add_Delete = @Map_Action_Add_Delete()
Plugin_Function\Map_Export = @Map_Export()
Plugin_Function\Map_Import_Player = @Map_Import_Player()
Plugin_Function\Map_Resend = @Map_Resend()

Plugin_Function\Block_Count_Elements = @Block_Count_Elements()
Plugin_Function\Block_Get_Array = @Block_Get_Array()
Plugin_Function\Block_Get_Pointer = @Block_Get_Pointer()

Plugin_Function\Rank_Count_Elements = @Rank_Count_Elements()
Plugin_Function\Rank_Get_Array = @Rank_Get_Array()
Plugin_Function\Rank_Get_Pointer = @Rank_Get_Pointer()
Plugin_Function\Rank_Add = @Rank_Add()
Plugin_Function\Rank_Delete = @Rank_Delete()

Plugin_Function\Teleporter_Count_Elements = @Teleporter_Count_Elements()
Plugin_Function\Teleporter_Get_Array = @Teleporter_Get_Array()
Plugin_Function\Teleporter_Get_Pointer = @Teleporter_Get_Pointer()
Plugin_Function\Teleporter_Add = @Teleporter_Add()
Plugin_Function\Teleporter_Delete = @Teleporter_Delete()

Plugin_Function\System_Message_Network_Send_2_All = @System_Message_Network_Send_2_All()
Plugin_Function\System_Message_Network_Send = @System_Message_Network_Send()
Plugin_Function\System_Get_Server_Name = @System_Get_Server_Name()

Plugin_Function\Network_Out_Block_Set = @Network_Out_Block_Set()

Plugin_Function\Main_LockMutex = @Main_LockMutex()
Plugin_Function\Main_UnlockMutex = @Main_UnlockMutex()

Plugin_Function\Lang_Get = @Lang_Get()

Plugin_Function\Files_File_Get = @Files_File_Get()
Plugin_Function\Files_Folder_Get = @Files_Folder_Get()

Plugin_Function\Log_Add = @Log_Add()

;-########################################## Proceduren ##########################################

Procedure Plugin_Event_Block_Physics(Destination.s, *Map_Data.Map_Data, X, Y, Z)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Block_Physics
          Plugin()\Functions\Event_Block_Physics(Argument, *Map_Data, X, Y, Z)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Event_Block_Create(Destination.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Block_Create
          Plugin()\Functions\Event_Block_Create(Argument, *Map_Data, X, Y, Z, Old_Block.a, *Client)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Event_Block_Delete(Destination.s, *Map_Data.Map_Data, X, Y, Z, Old_Block.a, *Client.Network_Client)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Block_Delete
          Plugin()\Functions\Event_Block_Delete(Argument, *Map_Data, X, Y, Z, Old_Block.a, *Client)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Event_Map_Fill(Destination.s, *Map_Data.Map_Data, Argument_String.s)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Map_Fill
          Plugin()\Functions\Event_Map_Fill(Argument, *Map_Data, Argument_String)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Event_Command(Destination.s, *Client.Network_Client, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Command
          Plugin()\Functions\Event_Command(Argument, *Client, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Event_Build_Mode(Destination.s, *Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode, Block_Type)
  If FindString(Destination, ":", 1)
    Plugin.s = StringField(Destination, 1, ":")
    Argument.s = Mid(Destination, 2+Len(Plugin))
  Else
    Plugin.s = Destination
    Argument.s = ""
  EndIf
  
  ForEach Plugin()
    If Plugin()\Plugin_Info\Name = Plugin Or Plugin = "*"
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Build_Mode
          Plugin()\Functions\Event_Build_Mode(Argument, *Client, *Map_Data, X, Y, Z, Mode, Block_Type)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

;-

Procedure Plugin_Event_Client_Add(*Client.Network_Client)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Add
        If Plugin()\Functions\Event_Client_Add(*Client) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Client_Delete(*Client.Network_Client)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Delete
        If Plugin()\Functions\Event_Client_Delete(*Client) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Client_Verify_Name(Name.s, Pass.s)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Verify_Name
        If Plugin()\Functions\Event_Client_Verify_Name(Name.s, Pass.s) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Client_Login(*Client.Network_Client)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Login
        If Plugin()\Functions\Event_Client_Login(*Client) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Client_Logout(*Client.Network_Client)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Logout
        If Plugin()\Functions\Event_Client_Logout(*Client) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Entity_Add(*Entity.Entity)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Entity_Add
        If Plugin()\Functions\Event_Entity_Add(*Entity) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Entity_Delete(*Entity.Entity)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Entity_Delete
        If Plugin()\Functions\Event_Entity_Delete(*Entity) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Entity_Position_Set(*Entity.Entity, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Entity_Position_Set
        If Plugin()\Functions\Event_Entity_Position_Set(*Entity, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Entity_Die(*Entity.Entity)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Entity_Die
        If Plugin()\Functions\Event_Entity_Die(*Entity) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Add(*Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Add
        If Plugin()\Functions\Event_Map_Add(*Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Action_Delete(Action_ID, *Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Action_Delete
        If Plugin()\Functions\Event_Map_Action_Delete(Action_ID, *Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Action_Resize(Action_ID, *Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Action_Resize
        If Plugin()\Functions\Event_Map_Action_Resize(Action_ID, *Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Action_Fill(Action_ID, *Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Action_Fill
        If Plugin()\Functions\Event_Map_Action_Fill(Action_ID, *Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Action_Save(Action_ID, *Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Action_Save
        If Plugin()\Functions\Event_Map_Action_Save(Action_ID, *Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Action_Load(Action_ID, *Map_Data.Map_Data)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Action_Load
        If Plugin()\Functions\Event_Map_Action_Load(Action_ID, *Map_Data) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Block_Change(Player_Number, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Block_Change
        If Plugin()\Functions\Event_Map_Block_Change(Player_Number, *Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Block_Change_Client
        If Plugin()\Functions\Event_Map_Block_Change_Client(*Client, *Map_Data, X, Y, Z, Mode.a, Type.a) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Map_Block_Change_Player
        If Plugin()\Functions\Event_Map_Block_Change_Player(*Player, *Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Chat_Map(*Entity.Entity, Message.s)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Chat_Map
        If Plugin()\Functions\Event_Chat_Map(*Entity, Message) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Chat_All(*Entity.Entity, Message.s)
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Chat_All
        If Plugin()\Functions\Event_Chat_All(*Entity, Message) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Event_Chat_Private(*Entity.Entity, Player_Name.s, Message.s) ; ####################### Not Finished !!!!!!!!!!!!!
  Result = #True
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Chat_Private
        If Plugin()\Functions\Event_Chat_Private(*Entity, Player_Name.s, Message.s) = #False
          Result = #False
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

;-##################################

Procedure Plugin_Initialize(Filename.s) ; Initialisiert Plugin und übergibt Funktionspointer...
  ForEach Plugin()
    If Plugin()\Filename = Filename
      CallCFunction(Plugin()\Library_ID, "Init", @Plugin()\Plugin_Info, @Plugin_Function)
      
      If Plugin()\Plugin_Info\Version = #Plugin_Version
        
        Plugin()\Functions\Main = GetFunction(Plugin()\Library_ID, "Main")
        Plugin()\Functions\Event_Block_Physics = GetFunction(Plugin()\Library_ID, "Event_Block_Physics")
        Plugin()\Functions\Event_Block_Create = GetFunction(Plugin()\Library_ID, "Event_Block_Create")
        Plugin()\Functions\Event_Block_Delete = GetFunction(Plugin()\Library_ID, "Event_Block_Delete")
        Plugin()\Functions\Event_Map_Fill = GetFunction(Plugin()\Library_ID, "Event_Map_Fill")
        Plugin()\Functions\Event_Command = GetFunction(Plugin()\Library_ID, "Event_Command")
        Plugin()\Functions\Event_Build_Mode = GetFunction(Plugin()\Library_ID, "Event_Build_Mode")
        Plugin()\Functions\Event_Client_Add = GetFunction(Plugin()\Library_ID, "Event_Client_Add")
        Plugin()\Functions\Event_Client_Delete = GetFunction(Plugin()\Library_ID, "Event_Client_Delete")
        Plugin()\Functions\Event_Client_Verify_Name = GetFunction(Plugin()\Library_ID, "Event_Client_Verify_Name")
        Plugin()\Functions\Event_Client_Login = GetFunction(Plugin()\Library_ID, "Event_Client_Login")
        Plugin()\Functions\Event_Client_Logout = GetFunction(Plugin()\Library_ID, "Event_Client_Logout")
        Plugin()\Functions\Event_Entity_Add = GetFunction(Plugin()\Library_ID, "Event_Entity_Add")
        Plugin()\Functions\Event_Entity_Delete = GetFunction(Plugin()\Library_ID, "Event_Entity_Delete")
        Plugin()\Functions\Event_Entity_Position_Set = GetFunction(Plugin()\Library_ID, "Event_Entity_Position_Set")
        Plugin()\Functions\Event_Entity_Die = GetFunction(Plugin()\Library_ID, "Event_Entity_Die")
        Plugin()\Functions\Event_Map_Add = GetFunction(Plugin()\Library_ID, "Event_Map_Add")
        Plugin()\Functions\Event_Map_Action_Delete = GetFunction(Plugin()\Library_ID, "Event_Map_Action_Delete")
        Plugin()\Functions\Event_Map_Action_Resize = GetFunction(Plugin()\Library_ID, "Event_Map_Action_Resize")
        Plugin()\Functions\Event_Map_Action_Fill = GetFunction(Plugin()\Library_ID, "Event_Map_Action_Fill")
        Plugin()\Functions\Event_Map_Action_Save = GetFunction(Plugin()\Library_ID, "Event_Map_Action_Save")
        Plugin()\Functions\Event_Map_Action_Load = GetFunction(Plugin()\Library_ID, "Event_Map_Action_Load")
        Plugin()\Functions\Event_Map_Block_Change = GetFunction(Plugin()\Library_ID, "Event_Map_Block_Change")
        Plugin()\Functions\Event_Map_Block_Change_Client = GetFunction(Plugin()\Library_ID, "Event_Map_Block_Change_Client")
        Plugin()\Functions\Event_Map_Block_Change_Player = GetFunction(Plugin()\Library_ID, "Event_Map_Block_Change_Player")
        Plugin()\Functions\Event_Chat_Map = GetFunction(Plugin()\Library_ID, "Event_Chat_Map")
        Plugin()\Functions\Event_Chat_All = GetFunction(Plugin()\Library_ID, "Event_Chat_All")
        Plugin()\Functions\Event_Chat_Private = GetFunction(Plugin()\Library_ID, "Event_Chat_Private")
        
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Deinitialize(Filename.s) ; Deinitialisiert Plugin...
  ForEach Plugin()
    If Plugin()\Filename = Filename
      
      CallCFunction(Plugin()\Library_ID, "Deinit")
      
      ProcedureReturn #True
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Unload(Filename.s) ; Entlädt die Lib, löscht sie aber nicht aus der Liste
  List_Store(*Pointer, Plugin())
  ForEach Plugin()
    If Plugin()\Filename = Filename
      If Plugin()\Library_ID
        Plugin_Deinitialize(Filename)
        CloseLibrary(Plugin()\Library_ID)
        Plugin()\Library_ID = 0
        Log_Add("Plugin", Lang_Get("", "Plugin unloaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        List_Restore(*Pointer, Plugin())
        ProcedureReturn #True
      EndIf
    EndIf
  Next
  
  List_Restore(*Pointer, Plugin())
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Load(Filename.s) ; Lädt die Lib (Wenn in der Liste vorhanden)
  ForEach Plugin()
    If Plugin()\Filename = Filename
      Plugin_Unload(Filename)
      Plugin()\Library_ID = OpenLibrary(#PB_Any, Filename)
      
      If Plugin()\Library_ID
        If Plugin_Initialize(Filename) = #True
          Log_Add("Plugin", Lang_Get("", "Plugin loaded", Filename, Plugin()\Plugin_Info\Name, Plugin()\Plugin_Info\Author), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          ProcedureReturn #True
        Else
          Plugin_Unload(Filename)
          Log_Add("Plugin", Lang_Get("", "Plugin not loaded: Incompatible", Filename, Str(Plugin()\Plugin_Info\Version)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          ProcedureReturn #False
        EndIf
      Else
        Plugin_Unload(Filename)
        Log_Add("Plugin", Lang_Get("", "Plugin not loaded: Can't open it", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        ProcedureReturn #False
      EndIf
    EndIf
  Next
  
  ProcedureReturn #False
EndProcedure

Procedure Plugin_Check_Files(Directory.s)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      Suffix.s = ".x86.dll"
    CompilerElse
      Suffix.s = ".x64.dll"
    CompilerEndIf
  CompilerElse
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      Suffix.s = ".x86.so"
    CompilerElse
      Suffix.s = ".x64.so"
    CompilerEndIf
  CompilerEndIf
  
  ; ##################### gelöschte Plugins entladen + von Liste entfernen
  
  ForEach Plugin()
    If FileSize(Plugin()\Filename) = -1
      If Plugin_Unload(Plugin()\Filename) = #True
        DeleteElement(Plugin())
      EndIf
    EndIf
  Next
  
  ; ##################### neue Plugins zur Liste hinzufügen
  
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  Directory_ID = ExamineDirectory(#PB_Any, Directory, "*.*")
  If Directory_ID
    While NextDirectoryEntry(Directory_ID)
      Entry_Name.s = DirectoryEntryName(Directory_ID)
      Filename.s = Directory + "/" + Entry_Name
      
      If Entry_Name <> "." And Entry_Name <> ".."
        
        If DirectoryEntryType(Directory_ID) = #PB_DirectoryEntry_File
          If LCase(Right(Entry_Name, Len(Suffix))) = Suffix
            Found = 0
            ForEach Plugin()
              If Plugin()\Filename = Filename
                Found = 1
                Break
              EndIf
            Next
            If Found = 0
              AddElement(Plugin())
              Plugin()\Filename = Filename
              Plugin()\Plugin_Info\Name = Left(GetFilePart(Filename), Len(GetFilePart(Filename))-Len(Suffix))
            EndIf
          EndIf
        Else
          Plugin_Check_Files(Filename)
        EndIf
        
      EndIf
      
    Wend
    FinishDirectory(Directory_ID)
  EndIf
  
  ; ################### Plugins laden
  
  ForEach Plugin()
    File_Date = GetFileDate(Plugin()\Filename, #PB_Date_Modified)
    If Plugin()\File_Date_Last <> File_Date
      Plugin()\File_Date_Last = File_Date
      Plugin_Load(Plugin()\Filename)
    EndIf
  Next
  
EndProcedure

Procedure Plugin_Main()
  If Plugin_Main\Timer_File_Check < Milliseconds()
    Plugin_Main\Timer_File_Check = Milliseconds() + 1000
    
    Plugin_Check_Files(Files_Folder_Get("Plugins"))
  EndIf
  
  ; ########## Main bei den Plugins ausführen
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Main
        Plugin()\Functions\Main()
      EndIf
    EndIf
  Next
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 95
; FirstLine = 66
; Folding = ---------
; EnableXP
; DisableDebugger