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



; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Version = 503

; ################################################### Variables/Structures ##################################

Structure Plugin_Info
  Name.s{16}                  ; Name of the Plugin (16 Chars!)
  Version.l                   ; Pluginversion (Wird geändert wenn ältere Plugins nicht mehr kompatibel sind)
  Author.s{16}                ; Author of the Plugin (16 Chars!)
EndStructure

Structure Plugin_Result_Element
  *Pointer
  ID.l
EndStructure

XIncludeFile "../../Shared Includes/Plugin_Functions.pbi"

XIncludeFile "../../Shared Includes/Main_Structures.pbi"

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

Prototype   Client_Count_Elements()
Prototype   Client_Get_Array(*Memory)
Prototype   Client_Get_Pointer(Client_ID, Log=1)
Prototype   Client_Kick(Client_ID, Message.s, Hide)

Prototype   Network_Settings_Get_Port()

Prototype   Build_Mode_Set(Client_ID, Build_Mode.s)
Prototype.i Build_Mode_Get(Client_ID)
Prototype   Build_Mode_State_Set(Client_ID, Build_State)
Prototype   Build_Mode_State_Get(Client_ID)
Prototype   Build_Mode_Coordinate_Set(Client_ID, Index, X, Y, Z)
Prototype   Build_Mode_Coordinate_Get_X(Client_ID, Index)
Prototype   Build_Mode_Coordinate_Get_Y(Client_ID, Index)
Prototype   Build_Mode_Coordinate_Get_Z(Client_ID, Index)
Prototype   Build_Mode_Long_Set(Client_ID, Index, Value)
Prototype   Build_Mode_Long_Get(Client_ID, Index)
Prototype   Build_Mode_Float_Set(Client_ID, Index, Value.f)
Prototype.f Build_Mode_Float_Get(Client_ID, Index)
Prototype   Build_Mode_String_Set(Client_ID, Index, Value.s)
Prototype.i Build_Mode_String_Get(Client_ID, Index)

Prototype   Build_Line_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Priority, Undo, Physic)
Prototype   Build_Box_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Replace_Material, Hollow, Priority, Undo, Physic)
Prototype   Build_Sphere_Player(Player_Number, Map_ID, X, Y, Z, R.f, Material, Replace_Material, Hollow, Priority, Undo, Physic)
Prototype   Build_Rank_Box(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank, Max_Rank)

Prototype   Font_Draw_Text(Player_Number, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, String.s, Material_F, Material_B)
Prototype   Font_Draw_Text_Player(*Player.Player_List, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, String.s, Material_F, Material_B)

Prototype   Entity_Count_Elements()
Prototype   Entity_Get_Array(*Memory)
Prototype   Entity_Get_Pointer(ID)
Prototype   Entity_Add(Name.s, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f)
Prototype   Entity_Delete(ID)
Prototype   Entity_Resend(ID)
Prototype   Entity_Message_2_Clients(ID, Message.s)
Prototype.i Entity_Displayname_Get(ID)
Prototype   Entity_Displayname_Set(ID, Prefix.s, Name.s, Suffix.s)
Prototype   Entity_Position_Set(ID, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
Prototype   Entity_Kill(ID)

Prototype   Player_Count_Elements()
Prototype   Player_Get_Array(*Memory)
Prototype   Player_Get_Pointer(Number, Log=1)
Prototype   Player_Get_Players_Max()
Prototype   Player_Attribute_Long_Set(Player_Number, Attribute.s, Value.l)
Prototype   Player_Attribute_Long_Get(Player_Number, Attribute.s)
Prototype   Player_Attribute_String_Set(Player_Number, Attribute.s, Value.s)
Prototype.i Player_Attribute_String_Get(Player_Number, Attribute.s)
Prototype   Player_Inventory_Set(Player_Number, Material, Number)
Prototype   Player_Inventory_Get(Player_Number, Material)
Prototype   Player_Rank_Set(Player_Number, Rank, Reason.s)
Prototype   Player_Kick(Player_Number, Reason.s, Count, Log, Show)
Prototype   Player_Ban(Player_Number, Reason.s)
Prototype   Player_Unban(Player_Number)
Prototype   Player_Stop(Player_Number, Reason.s)
Prototype   Player_Unstop(Player_Number)
Prototype   Player_Mute(Player_Number, Minutes, Reason.s)
Prototype   Player_Unmute(Player_Number)
Prototype   Player_Get_Prefix(Player_Number)
Prototype   Player_Get_Name(Player_Number)
Prototype   Player_Get_Suffix(Player_Number)

Prototype   Map_Count_Elements()
Prototype   Map_Get_Array(*Memory)
Prototype   Map_Get_Pointer(Map_ID)
Prototype   Map_Block_Change(Player_Number, *Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
Prototype   Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a)
Prototype   Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
Prototype   Map_Block_Move(*Map_Data.Map_Data, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Undo, Physic, Send_Priority)
Prototype   Map_Block_Get_Type(*Map_Data.Map_Data, X.l, Y.l, Z.l)
Prototype   Map_Block_Get_Rank(*Map_Data.Map_Data, X.l, Y.l, Z.l)
Prototype   Map_Block_Get_Player_Number(*Map_Data.Map_Data, X.l, Y.l, Z.l)
Prototype   Map_Block_Set_Rank_Box(*Map_Data.Map_Data, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank.w)
Prototype   Map_Add(Map_ID, X, Y, Z, Name.s)
Prototype   Map_Action_Add_Save(Client_ID, Map_ID, Directory.s)
Prototype   Map_Action_Add_Load(Client_ID, Map_ID, Directory.s)
Prototype   Map_Action_Add_Resize(Client_ID, Map_ID, X, Y, Z)
Prototype   Map_Action_Add_Fill(Client_ID, Map_ID, Function_Name.s, Argument_String.s)
Prototype   Map_Action_Add_Delete(Client_ID, Map_ID)
Prototype   Map_Export(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Filename.s)
Prototype   Map_Import_Player(Player_Number, Filename.s, Map_ID, X, Y, Z, SX, SY, SZ)
Prototype   Map_Resend(Map_ID)

Prototype   Block_Count_Elements()
Prototype   Block_Get_Array(*Memory)
Prototype   Block_Get_Pointer(Number)

Prototype   Rank_Count_Elements()
Prototype   Rank_Get_Array(*Memory)
Prototype   Rank_Get_Pointer(Rank, Exact=0)
Prototype   Rank_Add(Rank, Name.s, Prefix.s, Suffix.s)
Prototype   Rank_Delete(Rank, Exact=0)

Prototype   Teleporter_Count_Elements(*Map_Data.Map_Data)
Prototype   Teleporter_Get_Array(*Map_Data.Map_Data, *Memory)
Prototype   Teleporter_Get_Pointer(*Map_Data.Map_Data, ID.s)
Prototype   Teleporter_Add(*Map_Data.Map_Data, ID.s, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Dest_Map_Unique_ID.s, Dest_Map_ID, X.f, Y.f, Z.f, Rot.f, Look.f)
Prototype   Teleporter_Delete(*Map_Data.Map_Data, ID.s)

Prototype   System_Message_Network_Send_2_All(Map_ID, Message.s)
Prototype   System_Message_Network_Send(Client_ID, Message.s)
Prototype.i System_Get_Server_Name()

Prototype   Network_Out_Block_Set(Client_ID, X, Y, Z, Type.a)

Prototype   Main_LockMutex()
Prototype   Main_UnlockMutex()

Prototype.i Lang_Get(Language.s, Input.s, Field_0.s = "", Field_1.s = "", Field_2.s = "", Field_3.s = "")

Prototype.i Files_File_Get(File.s)
Prototype.i Files_Folder_Get(Name.s)

Prototype   Log_Add(Module_.s, Message.s, Type, PB_File.s, PB_Line, PB_Procedure.s)

; ################################################### Macros ################################################

; ################################################### Procedures ############################################

Procedure Define_Prototypes(*Pointer.Plugin_Function)
  Global Client_Count_Elements.Client_Count_Elements = *Pointer\Client_Count_Elements
  Global Client_Get_Array.Client_Get_Array = *Pointer\Client_Get_Array
  Global Client_Get_Pointer.Client_Get_Pointer = *Pointer\Client_Get_Pointer
  Global Client_Kick.Client_Kick = *Pointer\Client_Kick
  
  Global Network_Settings_Get_Port.Network_Settings_Get_Port = *Pointer\Network_Settings_Get_Port
  
  Global Build_Mode_Set.Build_Mode_Set = *Pointer\Build_Mode_Set
  Global Build_Mode_Get.Build_Mode_Get = *Pointer\Build_Mode_Get
  Global Build_Mode_State_Set.Build_Mode_State_Set = *Pointer\Build_Mode_State_Set
  Global Build_Mode_State_Get.Build_Mode_State_Get = *Pointer\Build_Mode_State_Get
  Global Build_Mode_Coordinate_Set.Build_Mode_Coordinate_Set = *Pointer\Build_Mode_Coordinate_Set
  Global Build_Mode_Coordinate_Get_X.Build_Mode_Coordinate_Get_X = *Pointer\Build_Mode_Coordinate_Get_X
  Global Build_Mode_Coordinate_Get_Y.Build_Mode_Coordinate_Get_Y = *Pointer\Build_Mode_Coordinate_Get_Y
  Global Build_Mode_Coordinate_Get_Z.Build_Mode_Coordinate_Get_Z = *Pointer\Build_Mode_Coordinate_Get_Z
  Global Build_Mode_Long_Set.Build_Mode_Long_Set = *Pointer\Build_Mode_Long_Set
  Global Build_Mode_Long_Get.Build_Mode_Long_Get = *Pointer\Build_Mode_Long_Get
  Global Build_Mode_Float_Set.Build_Mode_Float_Set = *Pointer\Build_Mode_Float_Set
  Global Build_Mode_Float_Get.Build_Mode_Float_Get = *Pointer\Build_Mode_Float_Get
  Global Build_Mode_String_Set.Build_Mode_String_Set = *Pointer\Build_Mode_String_Set
  Global Build_Mode_String_Get.Build_Mode_String_Get = *Pointer\Build_Mode_String_Get
  
  Global Build_Line_Player.Build_Line_Player = *Pointer\Build_Line_Player
  Global Build_Box_Player.Build_Box_Player = *Pointer\Build_Box_Player
  Global Build_Sphere_Player.Build_Sphere_Player = *Pointer\Build_Sphere_Player
  Global Build_Rank_Box.Build_Rank_Box = *Pointer\Build_Rank_Box
  
  Global Font_Draw_Text.Font_Draw_Text = *Pointer\Font_Draw_Text
  Global Font_Draw_Text_Player.Font_Draw_Text_Player = *Pointer\Font_Draw_Text_Player
  
  Global Entity_Count_Elements.Entity_Count_Elements = *Pointer\Entity_Count_Elements
  Global Entity_Get_Array.Entity_Get_Array = *Pointer\Entity_Get_Array
  Global Entity_Get_Pointer.Entity_Get_Pointer = *Pointer\Entity_Get_Pointer
  Global Entity_Add.Entity_Add = *Pointer\Entity_Add
  Global Entity_Delete.Entity_Delete = *Pointer\Entity_Delete
  Global Entity_Resend.Entity_Resend = *Pointer\Entity_Resend
  Global Entity_Message_2_Clients.Entity_Message_2_Clients = *Pointer\Entity_Message_2_Clients
  Global Entity_Displayname_Get.Entity_Displayname_Get = *Pointer\Entity_Displayname_Get
  Global Entity_Displayname_Set.Entity_Displayname_Set = *Pointer\Entity_Displayname_Set
  Global Entity_Position_Set.Entity_Position_Set = *Pointer\Entity_Position_Set
  Global Entity_Kill.Entity_Kill = *Pointer\Entity_Kill
  
  Global Player_Count_Elements.Player_Count_Elements = *Pointer\Player_Count_Elements
  Global Player_Get_Array.Player_Get_Array = *Pointer\Player_Get_Array
  Global Player_Get_Pointer.Player_Get_Pointer = *Pointer\Player_Get_Pointer
  Global Player_Get_Players_Max.Player_Get_Players_Max = *Pointer\Player_Get_Players_Max
  Global Player_Attribute_Long_Set.Player_Attribute_Long_Set = *Pointer\Player_Attribute_Long_Set
  Global Player_Attribute_Long_Get.Player_Attribute_Long_Get = *Pointer\Player_Attribute_Long_Get
  Global Player_Attribute_String_Set.Player_Attribute_String_Set = *Pointer\Player_Attribute_String_Set
  Global Player_Attribute_String_Get.Player_Attribute_String_Get = *Pointer\Player_Attribute_String_Get
  Global Player_Inventory_Set.Player_Inventory_Set = *Pointer\Player_Inventory_Set
  Global Player_Inventory_Get.Player_Inventory_Get = *Pointer\Player_Inventory_Get
  Global Player_Rank_Set.Player_Rank_Set = *Pointer\Player_Rank_Set
  Global Player_Kick.Player_Kick = *Pointer\Player_Kick
  Global Player_Ban.Player_Ban = *Pointer\Player_Ban
  Global Player_Unban.Player_Unban = *Pointer\Player_Unban
  Global Player_Stop.Player_Stop = *Pointer\Player_Stop
  Global Player_Unstop.Player_Unstop = *Pointer\Player_Unstop
  Global Player_Mute.Player_Mute = *Pointer\Player_Mute
  Global Player_Unmute.Player_Unmute = *Pointer\Player_Unmute
  Global Player_Get_Prefix.Player_Get_Prefix = *Pointer\Player_Get_Prefix
  Global Player_Get_Name.Player_Get_Name = *Pointer\Player_Get_Name
  Global Player_Get_Suffix.Player_Get_Suffix = *Pointer\Player_Get_Suffix
  
  Global Map_Count_Elements.Map_Count_Elements = *Pointer\Map_Count_Elements
  Global Map_Get_Array.Map_Get_Array = *Pointer\Map_Get_Array
  Global Map_Get_Pointer.Map_Get_Pointer = *Pointer\Map_Get_Pointer
  Global Map_Block_Change.Map_Block_Change = *Pointer\Map_Block_Change
  Global Map_Block_Change_Client.Map_Block_Change_Client = *Pointer\Map_Block_Change_Client
  Global Map_Block_Change_Player.Map_Block_Change_Player = *Pointer\Map_Block_Change_Player
  Global Map_Block_Move.Map_Block_Move = *Pointer\Map_Block_Move
  Global Map_Block_Get_Type.Map_Block_Get_Type = *Pointer\Map_Block_Get_Type
  Global Map_Block_Get_Rank.Map_Block_Get_Rank = *Pointer\Map_Block_Get_Rank
  Global Map_Block_Get_Player_Number.Map_Block_Get_Player_Number = *Pointer\Map_Block_Get_Player_Number
  Global Map_Block_Set_Rank_Box.Map_Block_Set_Rank_Box = *Pointer\Map_Block_Set_Rank_Box
  Global Map_Add.Map_Add = *Pointer\Map_Add
  Global Map_Action_Add_Save.Map_Action_Add_Save = *Pointer\Map_Action_Add_Save
  Global Map_Action_Add_Load.Map_Action_Add_Load = *Pointer\Map_Action_Add_Load
  Global Map_Action_Add_Resize.Map_Action_Add_Resize = *Pointer\Map_Action_Add_Resize
  Global Map_Action_Add_Fill.Map_Action_Add_Fill = *Pointer\Map_Action_Add_Fill
  Global Map_Action_Add_Delete.Map_Action_Add_Delete = *Pointer\Map_Action_Add_Delete
  Global Map_Export.Map_Export = *Pointer\Map_Export
  Global Map_Import_Player.Map_Import_Player = *Pointer\Map_Import_Player
  Global Map_Resend.Map_Resend = *Pointer\Map_Resend
  
  Global Block_Count_Elements.Block_Count_Elements = *Pointer\Block_Count_Elements
  Global Block_Get_Array.Block_Get_Array = *Pointer\Block_Get_Array
  Global Block_Get_Pointer.Block_Get_Pointer = *Pointer\Block_Get_Pointer
  
  Global Rank_Count_Elements.Rank_Count_Elements = *Pointer\Rank_Count_Elements
  Global Rank_Get_Array.Rank_Get_Array = *Pointer\Rank_Get_Array
  Global Rank_Get_Pointer.Rank_Get_Pointer = *Pointer\Rank_Get_Pointer
  Global Rank_Add.Rank_Add = *Pointer\Rank_Add
  Global Rank_Delete.Rank_Delete = *Pointer\Rank_Delete
  
  Global Teleporter_Count_Elements.Teleporter_Count_Elements = *Pointer\Teleporter_Count_Elements
  Global Teleporter_Get_Array.Teleporter_Get_Array = *Pointer\Teleporter_Get_Array
  Global Teleporter_Get_Pointer.Teleporter_Get_Pointer = *Pointer\Teleporter_Get_Pointer
  Global Teleporter_Add.Teleporter_Add = *Pointer\Teleporter_Add
  Global Teleporter_Delete.Teleporter_Delete = *Pointer\Teleporter_Delete
  
  Global System_Message_Network_Send_2_All.System_Message_Network_Send_2_All = *Pointer\System_Message_Network_Send_2_All
  Global System_Message_Network_Send.System_Message_Network_Send = *Pointer\System_Message_Network_Send
  Global System_Get_Server_Name.System_Get_Server_Name = *Pointer\System_Get_Server_Name
  
  Global Network_Out_Block_Set.Network_Out_Block_Set = *Pointer\Network_Out_Block_Set
  
  Global Main_LockMutex.Main_LockMutex = *Pointer\Main_LockMutex
  Global Main_UnlockMutex.Main_UnlockMutex = *Pointer\Main_UnlockMutex
  
  Global Lang_Get.Lang_Get = *Pointer\Lang_Get
  
  Global Files_File_Get.Files_File_Get = *Pointer\Files_File_Get
  Global Files_Folder_Get.Files_Folder_Get = *Pointer\Files_Folder_Get
  
  Global Log_Add.Log_Add = *Pointer\Log_Add
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 163
; FirstLine = 120
; Folding = -
; EnableXP
; DisableDebugger