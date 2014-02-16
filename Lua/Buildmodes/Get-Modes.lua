-- ############################ Get Block-Type #############################

function Command_Build_Mode_Get_Blocktype(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Blocktype started"))
	Build_Mode_Set(Client_ID, "Get Block-Type")
end

function Build_Mode_Get_Blocktype(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	Block_Name = Block_Get_Name(Block_Type)
	
	if Block_Type >= 0 and Block_Type <= 255 then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Blocktype: Material is '[Field_0]'", Block_Name, tostring(Block_Type)))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: No information found"))
	end
	
	Build_Mode_Set(Client_ID, "Normal")
end

-- ############################ Get Rank #############################

function Command_Build_Mode_Get_Rank(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Rank started"))
	Build_Mode_Set(Client_ID, "Get Rank")
end

function Build_Mode_Get_Rank(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	Rank = Map_Block_Get_Rank(Map_ID, X, Y, Z)
	
	-- Check if Maprank is higher than Blockrank
	if Rank < Map_Get_Rank_Build(Map_ID) then Rank = Map_Get_Rank_Build(Map_ID) end
	
	Rank_Name = Rank_Get_Prefix(Rank, 0)..Rank_Get_Name(Rank, 0)..Rank_Get_Suffix(Rank, 0)
	
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Rank: Rank is '[Field_0]<c>' ([Field_1])", Rank_Name, tostring(Rank)))
	
	Build_Mode_Set(Client_ID, "Normal")
end

-- ############################ Get Last-Player #############################

function Command_Build_Mode_Get_Player(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Player started"))
	Build_Mode_Set(Client_ID, "Get Last-Player")
end

function Build_Mode_Get_Player(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	Player_Name = Player_Get_Prefix(Player_Number)..Player_Get_Name(Player_Number)..Player_Get_Suffix(Player_Number)
	
	if Player_Number ~= -1 then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Player: Player is '[Field_0]<c>'", Player_Name, tostring(Player_Number)))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: No information found"))
	end
	
	Build_Mode_Set(Client_ID, "Normal")
end

-- ############################ Get Teleporter #############################

function Command_Build_Mode_Get_Teleporter(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Teleporter started"))
	Build_Mode_Set(Client_ID, "Get Teleporter")
end

function Build_Mode_Get_Teleporter(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Found = 0
	
	Teleporter_Table, Teleporters = Teleporter_Get_Table(Map_ID)
	for i = 1, Teleporters do
		local TP_ID = Teleporter_Table[i]
		local TP_X_0, TP_Y_0, TP_Z_0, TP_X_1, TP_Y_1, TP_Z_1 = Teleporter_Get_Box(Map_ID, TP_ID)
		if X >= TP_X_0 and X <= TP_X_1 and Y >= TP_Y_0 and Y <= TP_Y_1 and Z >= TP_Z_0 and Z <= TP_Z_1 then
			Found = 1
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get_Teleporter: Teleportername is '[Field_0]'", TP_ID))
			break
		end
	end
	
	if Found == 0 then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: No teleporter found"))
	else
		Build_Mode_Set(Client_ID, "Normal")
	end
	
end