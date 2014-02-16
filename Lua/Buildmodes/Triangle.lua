function Build_Triangle_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, X_2, Y_2, Z_2, Material, Replace_Material, Hollow)
	local Min_X, Min_Y, Min_Z, Max_X, Max_Y, Max_Z
	Max_X = math.max(X_0, X_1)
	Max_X = math.max(Max_X, X_2)
	Max_Y = math.max(Y_0, Y_1)
	Max_Y = math.max(Max_Y, Y_2)
	Max_Z = math.max(Z_0, Z_1)
	Max_Z = math.max(Max_Z, Z_2)
	Min_X = math.min(X_0, X_1)
	Min_X = math.min(Min_X, X_2)
	Min_Y = math.min(Y_0, Y_1)
	Min_Y = math.min(Min_Y, Y_2)
	Min_Z = math.min(Z_0, Z_1)
	Min_Z = math.min(Min_Z, Z_2)
	
	local D_X, D_Y, D_Z = math.abs(Max_X-Min_X), math.abs(Max_Y-Min_Y), math.abs(Max_Z-Min_Z)
	
	--local X_Side = 0
	--local Y_Side = 0
	--local Z_Side = 0
	--if D_X >= D_Y and D_X >= D_Z then X_Side = 2 end
	--if D_Y >= D_X and D_Y >= D_Z then Y_Side = 2 end
	--if D_Z >= D_X and D_Z >= D_Y then Z_Side = 2 end
	
	--if X_Side == 0 and (D_X >= D_Y or D_X >= D_Z) then X_Side = 1 end
	--if Y_Side == 0 and (D_Y >= D_X or D_Y >= D_Z) then Y_Side = 1 end
	--if Z_Side == 0 and (D_Z >= D_X or D_Z >= D_Y) then Z_Side = 1 end
	
	local XY_Side = D_X*D_Y
	local XZ_Side = D_X*D_Z
	local YZ_Side = D_Y*D_Z
	
	if Hollow == 0 then
		local Dist_0, Dist_1, Dist_2 = Dist_Line_Point_2D(X_0, Y_0, X_1, Y_1, X_2, Y_2), Dist_Line_Point_2D(X_1, Y_1, X_0, Y_0, X_2, Y_2), Dist_Line_Point_2D(X_2, Y_2, X_1, Y_1, X_0, Y_0)
		for ix = Min_X, Max_X do
			for iy = Min_Y, Max_Y do
				if Is_Point_In_Triangle(ix, iy, X_0, Y_0, X_1, Y_1, X_2, Y_2) == true then
					local U, V = Dist_Line_Point_2D(ix, iy, X_0, Y_0, X_2, Y_2)/Dist_1, Dist_Line_Point_2D(ix, iy, X_0, Y_0, X_1, Y_1)/Dist_2
					local Z = Z_0 + U*(Z_1-Z_0) + V*(Z_2-Z_0)
					Map_Block_Change_Player(Player_Number, Map_ID, ix, iy, Z, Material, 1, 1, 1, 10)
				end
			end
		end
		local Dist_0, Dist_1, Dist_2 = Dist_Line_Point_2D(X_0, Z_0, X_1, Z_1, X_2, Z_2), Dist_Line_Point_2D(X_1, Z_1, X_0, Z_0, X_2, Z_2), Dist_Line_Point_2D(X_2, Z_2, X_1, Z_1, X_0, Z_0)
		for ix = Min_X, Max_X do
			for iz = Min_Z, Max_Z do
				if Is_Point_In_Triangle(ix, iz, X_0, Z_0, X_1, Z_1, X_2, Z_2) == true then
					local U, V = Dist_Line_Point_2D(ix, iz, X_0, Z_0, X_2, Z_2)/Dist_1, Dist_Line_Point_2D(ix, iz, X_0, Z_0, X_1, Z_1)/Dist_2
					local Y = Y_0 + U*(Y_1-Y_0) + V*(Y_2-Y_0)
					Map_Block_Change_Player(Player_Number, Map_ID, ix, Y, iz, Material, 1, 1, 1, 10)
				end
			end
		end
		local Dist_0, Dist_1, Dist_2 = Dist_Line_Point_2D(Y_0, Z_0, Y_1, Z_1, Y_2, Z_2), Dist_Line_Point_2D(Y_1, Z_1, Y_0, Z_0, Y_2, Z_2), Dist_Line_Point_2D(Y_2, Z_2, Y_1, Z_1, Y_0, Z_0)
		for iy = Min_Y, Max_Y do
			for iz = Min_Z, Max_Z do
				if Is_Point_In_Triangle(iy, iz, Y_0, Z_0, Y_1, Z_1, Y_2, Z_2) == true then
					local U, V = Dist_Line_Point_2D(iy, iz, Y_0, Z_0, Y_2, Z_2)/Dist_1, Dist_Line_Point_2D(iy, iz, Y_0, Z_0, Y_1, Z_1)/Dist_2
					local X = X_0 + U*(X_1-X_0) + V*(X_2-X_0)
					Map_Block_Change_Player(Player_Number, Map_ID, X, iy, iz, Material, 1, 1, 1, 10)
				end
			end
		end
	end
	
	Build_Line_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, 10, 1, 1)
	Build_Line_Player(Player_Number, Map_ID, X_1, Y_1, Z_1, X_2, Y_2, Z_2, Material, 10, 1, 1)
	Build_Line_Player(Player_Number, Map_ID, X_2, Y_2, Z_2, X_0, Y_0, Z_0, Material, 10, 1, 1)
end

function Command_Build_Mode_Triangle(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Triangle started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Build_Mode_Set(Client_ID, "Triangle")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 0)
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Triangle started"))
		Build_Mode_Set(Client_ID, "Triangle")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 0)
	end
end

function Command_Build_Mode_Hollow_Triangle(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Triangle started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Build_Mode_Set(Client_ID, "Triangle")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Build_Mode_Long_Set(Client_ID, 1, 1)
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Triangle started"))
		Build_Mode_Set(Client_ID, "Triangle")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 1)
	end
end

function Build_Mode_Triangle(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 1, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 2)
			
		elseif State == 2 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0 = Build_Mode_Coordinate_Get(Client_ID, 0)
			local X_1, Y_1, Z_1 = Build_Mode_Coordinate_Get(Client_ID, 1)
			local X_2, Y_2, Z_2 = X, Y, Z
			
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			local Hollow = Build_Mode_Long_Get(Client_ID, 1)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			Build_Triangle_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, X_2, Y_2, Z_2, Block_Type, Replace_Material, Hollow)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Triangle created"))
			
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
end

System_Message_Network_Send_2_All(-1, "&eTriangle reloaded")