function Command_Mobs_Add(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	
	local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
	--local Spawn_X, Spawn_Y, Spawn_Z, Spawn_Rotation, Spawn_Look = 0.5+math.random()*(Map_Size_X-1.5), 0.5+math.random()*(Map_Size_Y-1.5), Map_Size_Z-2, 0, 0
	--local Spawn_X, Spawn_Y, Spawn_Z, Spawn_Rotation, Spawn_Look = Map_Get_Spawn(Map_ID)
	local Spawn_X, Spawn_Y, Spawn_Z, Spawn_Rotation, Spawn_Look = Entity_Get_X(Entity_ID), Entity_Get_Y(Entity_ID), Entity_Get_Z(Entity_ID)-2, Entity_Get_Rotation(Entity_ID), Entity_Get_Look(Entity_ID)
	
	local Amount = 1
	
	if Arg_1 ~= "" then
		Amount = tonumber(Arg_1)
	end
	
	if Amount <= 20 then
		if Arg_0 ~= "" then
			for i = 1, Amount do
				local Entity_ID = Entity_Add(Arg_0, Map_ID, Spawn_X, Spawn_Y, Spawn_Z, Spawn_Rotation, Spawn_Look)
				Entity_Displayname_Set(Entity_ID, "&c", Arg_0, "")
			end
			System_Message_Network_Send(Client_ID, "&eMobs spawned on this map")
		end
	else
		System_Message_Network_Send(Client_ID, "&cDont add too much mobs!")
	end
end

function Command_Mobs_Delete(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Entity_ID = Entity_Table[i]
		local Entity_Map_ID = Entity_Get_Map_ID(Entity_ID)
		if Entity_Map_ID == Map_ID then
			local Player_Number = Entity_Get_Player(Entity_ID)
			if Player_Number == -1 then
				Entity_Delete(Entity_ID)
			end
		end
	end
	System_Message_Network_Send(Client_ID, "&eMobs deleted")
end