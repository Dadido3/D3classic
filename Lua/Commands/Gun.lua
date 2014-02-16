
local Client_List = {}

function Command_Gun(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Client_List[Client_ID] == nil then
		Client_List[Client_ID] = {}
		System_Message_Network_Send(Client_ID, "&eYou've pulled out your gun")
	else
		if Client_List[Client_ID].G_Map_ID ~= nil and Client_List[Client_ID].G_X ~= nil and Client_List[Client_ID].G_Y ~= nil and Client_List[Client_ID].G_Z ~= nil then
			Network_Out_Block_Set(Client_ID, Client_List[Client_ID].G_X, Client_List[Client_ID].G_Y, Client_List[Client_ID].G_Z, Map_Block_Get_Type(Client_List[Client_ID].G_Map_ID, Client_List[Client_ID].G_X, Client_List[Client_ID].G_Y, Client_List[Client_ID].G_Z))
		end
		Client_List[Client_ID] = nil
		System_Message_Network_Send(Client_ID, "&eYou've put your gun back into pocket")
	end
end

Event_Add("Gun_Event_Blockchange_Client", "Gun_Event_Blockchange_Client", "Map_Block_Change_Client", 0, 0, -1)
function Gun_Event_Blockchange_Client(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	if Client_List[Client_ID] ~= nil and Mode == 0 then
		local Entity_ID = Client_Get_Entity(Client_ID)
		local Player_Number = Entity_Get_Player(Entity_ID)
		local Map_ID = Entity_Get_Map_ID(Entity_ID)
		
		local X, Y, Z, Rotation, Look = Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID),Entity_Get_Rotation(Entity_ID),Entity_Get_Look(Entity_ID)
		
		local M_X, M_Y, M_Z = math.cos(math.rad(Rotation-90))*math.cos(math.rad(Look))*3, math.sin(math.rad(Rotation-90))*math.cos(math.rad(Look))*3, -math.sin(math.rad(Look))*3
		
		Physic_Directional_Projectile_Add(Player_Number, Map_ID, X+M_X, Y+M_Y, Z+1.6+M_Z, Rotation, Look)
		
		Result = 0
	end
	
	return Result
end

Event_Add("Gun_Event_Timer", "Gun_Event_Timer", "Timer", 0, 100, -1)
function Gun_Event_Timer(Map_ID)
	for i,v in pairs(Client_List) do
		local Client_ID = i
		local Entity_ID = Client_Get_Entity(Client_ID)
		local Map_ID = Entity_Get_Map_ID(Entity_ID)
		
		if Entity_ID ~= -1 then
			
			local X,Y,Z,Rotation,Look = Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID),Entity_Get_Rotation(Entity_ID),Entity_Get_Look(Entity_ID)
			
			
			local M_X, M_Y, M_Z = math.cos(math.rad(Rotation-90))*math.cos(math.rad(Look))*4, math.sin(math.rad(Rotation-90))*math.cos(math.rad(Look))*4, -math.sin(math.rad(Look))*4
			
			local G_X, G_Y, G_Z = math.floor(X+M_X), math.floor(Y+M_Y), math.floor(Z+1.6+M_Z)
			
			if v.G_X ~= nil and v.G_Y ~= nil and v.G_Z ~= nil then
				Network_Out_Block_Set(Client_ID, v.G_X, v.G_Y, v.G_Z, Map_Block_Get_Type(Map_ID, v.G_X, v.G_Y, v.G_Z))
			end
			
			if Map_Block_Get_Type(Map_ID, G_X,G_Y,G_Z) == 0 then
				Network_Out_Block_Set(Client_ID, G_X,G_Y,G_Z, 20)
				v.G_Map_ID, v.G_X, v.G_Y, v.G_Z = Map_ID, G_X, G_Y, G_Z
			end
		else
			Client_List[Client_ID] = nil
		end
		
	end
end