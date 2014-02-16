local Fun_Map_ID = 3

Event_Add("Fun", "Fun_Event_Blockchange", "Map_Block_Change_Client", 0, 0, Fun_Map_ID)
function Fun_Event_Blockchange(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	if Mode == 1 and Type == 46 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 227, 1, 1, 1, 10)
		Result = 0
	end
	return Result
end

Event_Add("Fun_Event_Entity_Die", "Fun_Event_Entity_Die", "Entity_Die", 1, 0, -1)
function Fun_Event_Entity_Die(Result, Entity_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
	local Spawn_X, Spawn_Y, Spawn_Z = 0.5+math.random()*(Map_Size_X-1.5), 0.5+math.random()*(Map_Size_Y-1.5), Map_Size_Z-2
	
	if Map_ID == Fun_Map_ID then
		Entity_Position_Set(Entity_ID, Map_ID, Spawn_X, Spawn_Y, Spawn_Z, 0, 0, 255, 1)
		Result = 0
	end
	
	return Result
end