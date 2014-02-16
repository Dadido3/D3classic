-- ############################ Build Line #############################

function Command_Build_Mode_Line(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Line started"))
	Build_Mode_Set(Client_ID, "Line")
	Build_Mode_State_Set(Client_ID, 0)
end

function Build_Mode_Line(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			Build_Line_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Block_Type, 10, 1, 1)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Line created"))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end

-- ############################ Build Box (And Hollow) #############################

function Command_Build_Mode_Box(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				Build_Mode_Set(Client_ID, "Box")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 0)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Box started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		
		Build_Mode_Set(Client_ID, "Box")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 0)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Box started"))
	end
end

function Command_Build_Mode_Hollow_Box(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				Build_Mode_Set(Client_ID, "Box")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 1)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Box started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\\Name = [Field_0]", Text_0))
		end
	else
		
		Build_Mode_Set(Client_ID, "Box")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 1)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Box started"))
	end
end

function Build_Mode_Box(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			local Hollow = Build_Mode_Long_Get(Client_ID, 1)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			local Blocks = math.abs(X_0-X_1)*math.abs(Y_0-Y_1)*math.abs(Z_0-Z_1)
			
			if Hollow == 0 and Blocks < 500000 then
				Build_Box_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Block_Type, Replace_Material, Hollow, 2, 1, 0)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Box created"))
			elseif Hollow == 1 and Blocks < 5000000 then
				Build_Box_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Block_Type, Replace_Material, Hollow, 2, 1, 0)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Box created"))
			else
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Box too big"))
			end
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end

-- ############################ Build Rank-Box #############################

function Command_Build_Mode_Rank_Box(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Rank_Box started"))
		Build_Mode_Set(Client_ID, "Rank-Box")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, tonumber(Arg_0))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Rank_Box: Define a rank"))
	end
end

function Build_Mode_Rank_Box(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local Rank = Build_Mode_Long_Get(Client_ID, 0)
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			local Player_Rank = Player_Get_Rank(Player_Number)
			
			Build_Rank_Box(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank, Player_Rank)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Rank_Box created"))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end

-- ############################ Build Teleporter-Box #############################

function Command_Build_Mode_Teleporter_Box(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		
		local Entity_ID = Client_Get_Entity(Client_ID)
		
		local Map_ID, X, Y, Z, Rot, Look = Entity_Get_Map_ID(Entity_ID), Entity_Get_X(Entity_ID), Entity_Get_Y(Entity_ID), Entity_Get_Z(Entity_ID), Entity_Get_Rotation(Entity_ID), Entity_Get_Look(Entity_ID)
		local Map_Unique_ID = Map_Get_Unique_ID(Map_ID)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Teleport_Box started"))
		Build_Mode_Set(Client_ID, "Teleporter-Box")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_String_Set(Client_ID, 0, Arg_0)
		Build_Mode_String_Set(Client_ID, 1, Map_Unique_ID)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Float_Set(Client_ID, 0, X)
		Build_Mode_Float_Set(Client_ID, 1, Y)
		Build_Mode_Float_Set(Client_ID, 2, Z)
		Build_Mode_Float_Set(Client_ID, 3, Rot)
		Build_Mode_Float_Set(Client_ID, 4, Look)
		--Build_Mode_Long_Set(Client_ID, 5, Entity_Add(Arg_0.." Destination", Map_ID, X, Y, Z, Rot, Look))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Teleport_Box: Define a name"))
	end
end

function Command_Build_Mode_Old_Teleporter_Box(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		
		local Entity_ID = Client_Get_Entity(Client_ID)
		
		local Map_ID, X, Y, Z, Rot, Look = Entity_Get_Map_ID(Entity_ID), Entity_Get_X(Entity_ID), Entity_Get_Y(Entity_ID), Entity_Get_Z(Entity_ID), Entity_Get_Rotation(Entity_ID), Entity_Get_Look(Entity_ID)
		local Map_Unique_ID = ""--Map_Get_Unique_ID(Map_ID)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Teleport_Box started"))
		Build_Mode_Set(Client_ID, "Teleporter-Box")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_String_Set(Client_ID, 0, Arg_0)
		Build_Mode_String_Set(Client_ID, 1, Map_Unique_ID)
		Build_Mode_Long_Set(Client_ID, 0, Map_ID)
		Build_Mode_Float_Set(Client_ID, 0, X)
		Build_Mode_Float_Set(Client_ID, 1, Y)
		Build_Mode_Float_Set(Client_ID, 2, Z)
		Build_Mode_Float_Set(Client_ID, 3, Rot)
		Build_Mode_Float_Set(Client_ID, 4, Look)
		--Build_Mode_Long_Set(Client_ID, 5, Entity_Add(Arg_0.." Destination", Map_ID, X, Y, Z, Rot, Look))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Teleport_Box: Define a name"))
	end
end

function Build_Mode_Teleporter_Box(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local Dest_Map_Unique_ID, Dest_X, Dest_Y, Dest_Z, Dest_Rot, Dest_Look = Build_Mode_String_Get(Client_ID, 1), Build_Mode_Float_Get(Client_ID, 0), Build_Mode_Float_Get(Client_ID, 1), Build_Mode_Float_Get(Client_ID, 2), Build_Mode_Float_Get(Client_ID, 3), Build_Mode_Float_Get(Client_ID, 4)
			local Dest_Map_ID = Build_Mode_Long_Get(Client_ID, 0)
			local Name = Build_Mode_String_Get(Client_ID, 0)
			
			Teleporter_Add(Map_ID, Name, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Dest_Map_Unique_ID, Dest_Map_ID, Dest_X, Dest_Y, Dest_Z, Dest_Rot, Dest_Look)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Teleport_Box created"))
			
			--Entity_Delete(Build_Mode_Long_Get(Client_ID, 5))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end

-- ############################ Build Sphere (Hollow too) #############################

function Command_Build_Mode_Sphere(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				Build_Mode_Set(Client_ID, "Sphere")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 0)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Sphere started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		
		Build_Mode_Set(Client_ID, "Sphere")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 0)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Sphere started"))
	end
end

function Command_Build_Mode_Hollow_Sphere(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				Build_Mode_Set(Client_ID, "Sphere")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 1)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Sphere started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		
		Build_Mode_Set(Client_ID, "Sphere")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 1)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Sphere started"))
	end
end

function Build_Mode_Sphere(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local R = math.sqrt(math.pow(X_0-X_1,2)+math.pow(Y_0-Y_1,2)+math.pow(Z_0-Z_1,2))
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			local Hollow = Build_Mode_Long_Get(Client_ID, 1)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			if R < 50 then
				--System_Message_Network_Send(Client_ID, "&c"..tostring(R))
				Build_Sphere_Player(Player_Number, Map_ID, X_1, Y_1, Z_1, R, Block_Type, Replace_Material, Hollow, 2, 1, 0)
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Sphere created"))
			else
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Sphere too big"))
			end
			
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end