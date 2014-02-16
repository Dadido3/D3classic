-- Gun Gamemode

local Gun_Entity = {}
local Gun_Settings = {}

function Gun_Entity_Add(Entity_ID)
	Gun_Entity[Temp_Entity_ID] = {}
	Gun_Entity[Temp_Entity_ID].State = 0 -- 0=Living 1=Dead
end

function Gun_Entity_Die(Entity_ID)
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	local Map_ID = Gun_Settings.Map_ID
	
	Gun_Entity[Temp_Entity_ID].State = 1
	System_Message_Network_Send_2_All(Map_ID, Prefix..Name..Suffix.."&c lost")
end

function Gun_Entity_Delete(Entity_ID)
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	local Map_ID = Gun_Settings.Map_ID
	
	Gun_Entity[Temp_Entity_ID] = {}
	
	System_Message_Network_Send_2_All(Map_ID, Prefix..Name..Suffix.."&c left the game")
	
	Entity_Message_2_Clients(Entity_ID, "&cYou left the game")
end

function Command_Gamemode_Gun_Start(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	
	Gun_Entity = {}
	Gun_Settings.Map_ID = Map_ID
	Gun_Settings.State = 1
	
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Temp_Entity_ID = Entity_Table[i]
		if Entity_Get_Map_ID(Temp_Entity_ID) == Map_ID then
			
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&eGamemode Gun started")
end

Event_Add("Gun_Event_Entity_Die", "Gun_Event_Entity_Die", "Entity_Die", 1, 0, -1)
function Gun_Event_Entity_Die(Result, Entity_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
	
	if Gun_Entity[Entity_ID] ~= nil then
		if Map_ID == Gun_Settings.Map_ID then
			Entity_Position_Set(Entity_ID, Map_ID, Spawn_X, Spawn_Y, Spawn_Z, 0, 0, 255, 1)
		else
			Gun_Entity_Delete(Entity_ID)
		end
		Result = 0
	end
	
	return Result
end

--[[Event_Add("Gun_Event_Move", "Gun_Event_Move", "Entity_Position_Set", 0, 0, 3)
function Gun_Event_Move(Result, Entity_ID, Map_ID, X, Y, Z, Rotation, Look, Priority)
	
	if Gun_Entity[Entity_ID] ~= nil then
		if Map_ID == Gun_Settings.Map_ID then
			local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
			
		else
			Gun_Entity_Delete(Entity_ID)
		end
	end
	
	return Result
end]]
