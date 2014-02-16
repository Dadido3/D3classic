function Build_Circle_Player(Player_Number, Map_ID, X, Y, Z, R, Rot, Look, Material, Replace_Material, Hollow)
	local R_Rounded = math.ceil(R)
	local R_Pow = R^2
	local R_Pow_Small = (R-3)^2
	
	local Rot = math.floor(Rot/90+0.5)*90
	
	local M_X, M_Z = math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	
	local Allowed
	
	for i = -R_Rounded, R_Rounded do
		for j = -R_Rounded, R_Rounded do
			
			local ix, iy, iz = (i*M_X)*math.cos(math.rad(Rot-90)) + j*math.sin(math.rad(Rot-90)), j*math.cos(math.rad(Rot-90)) + (i*M_X)*math.sin(math.rad(Rot-90)), i*M_Z
			
			local Square_Dist = ix^2 + iy^2 + iz^2
			
			if Square_Dist <= R_Pow then
				if Hollow == 1 then
					Allowed = 0
					if Square_Dist > R_Pow_Small then
						if     (ix+1)^2 + (iy  )^2 + (iz  )^2 > R_Pow then Allowed = 1
						elseif (ix-1)^2 + (iy  )^2 + (iz  )^2 > R_Pow then Allowed = 1
						elseif (ix  )^2 + (iy+1)^2 + (iz  )^2 > R_Pow then Allowed = 1
						elseif (ix  )^2 + (iy-1)^2 + (iz  )^2 > R_Pow then Allowed = 1
						elseif (ix  )^2 + (iy  )^2 + (iz+1)^2 > R_Pow then Allowed = 1
						elseif (ix  )^2 + (iy  )^2 + (iz-1)^2 > R_Pow then Allowed = 1
						end
					end
				else
					Allowed = 1
				end
				if Allowed == 1 then
					if Replace_Material == -1 or Replace_Material == Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) then
						Map_Block_Change_Player(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 10)
					end
				end
			end
		end
	end
end


function Command_Build_Mode_Circle(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Circle started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Build_Mode_Set(Client_ID, "Circle")
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
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Circle started"))
		Build_Mode_Set(Client_ID, "Circle")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 0)
	end
end

function Command_Build_Mode_Hollow_Circle(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Circle started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Build_Mode_Set(Client_ID, "Circle")
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
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow_Circle started"))
		Build_Mode_Set(Client_ID, "Circle")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
		Build_Mode_Long_Set(Client_ID, 1, 1)
	end
end

function Build_Mode_Circle(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local H_Dist = math.sqrt(math.pow(X_0-X_1,2)+math.pow(Y_0-Y_1,2))
			local R = math.sqrt(math.pow(X_0-X_1,2)+math.pow(Y_0-Y_1,2)+math.pow(Z_0-Z_1,2))
			local Rotation, Look = math.deg(math.atan2((Y_0-Y_1), (X_0-X_1)))+90, -math.deg(math.atan2(Z_0-Z_1, H_Dist))
			if math.abs(Look) > 60 and Entity_ID ~= -1 then
				Rotation = -Entity_Get_Rotation(Entity_ID)
			end
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			local Hollow = Build_Mode_Long_Get(Client_ID, 1)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			Build_Circle_Player(Player_Number, Map_ID, X_1, Y_1, Z_1, R, Rotation, Look, Block_Type, Replace_Material, Hollow)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Circle created"))
			
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
end

System_Message_Network_Send_2_All(-1, "&eCircle reloaded")