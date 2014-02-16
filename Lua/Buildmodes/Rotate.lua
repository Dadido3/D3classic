-- ############################ Rotate #############################

function Build_Mode_Rotate_Do(Map_ID, X_0, X_1, Y_0, Y_1, Z_0, Z_1, RX, RY, RZ, Scale)
	-- Rotation midpoint
	local X, Y, Z = math.floor((X_0 + X_1)/2+0.5), math.floor((Y_0 + Y_1)/2+0.5), math.floor((Z_0 + Z_1)/2+0.5)
	
	-- Size Destination
	local SDX, SDY, SDZ = 100, 100, 1
	
	-- Offset Destination
	local ODX, ODY, ODZ = 100, 64, 64
	
	-- Offset Source
	local OSX, OSY, OSZ = 23, 23, 64
	
	-- Move Blocks (Later it should use a array as buffer!)
	for ix = -SDX/2, SDX/2 do
		for iy = -SDY/2, SDY/2 do
			for iz = -SDZ/2, SDZ/2 do
				Angle_Z = math.atan2(iy,ix) + math.rad(RZ)
				Distance_Z = math.sqrt(math.pow(ix, 2) + math.pow(iy, 2)) * Scale
				
				R_X = OSX + math.floor(Distance_Z*math.cos(Angle_Z) +0.5)
				R_Y = OSY + math.floor(Distance_Z*math.sin(Angle_Z) +0.5)
				R_Z = OSZ + iz
				--if R_X >= X_0 and R_X <= X_1 and R_Y >= Y_0 and R_Y <= Y_1 and R_Z >= Z_0 and R_Z <= Z_1 then
					Type = Map_Block_Get_Type(Map_ID, R_X, R_Y, R_Z)
					if Type == -1 then Type = 0 end
					Map_Block_Change_Fast(-1, Map_ID, ODX+ix, ODY+iy, ODZ+iz, Type, 5, 0, 0, 1)
					
				--end
			end
		end
	end
	
	--System_Message_Network_Send_2_All(Map_ID, "debug")
end


-- ############## to test it #################
if Temprot == nil then
	Temprot = 1
end

function Temp_Timer(Map_ID)
	Temprot = Temprot + 0.003
	Build_Mode_Rotate_Do(Map_ID, 64-20, 64+21, 64-21, 64+20, 64-1, 64+9, 0, 0, math.cos(Temprot)*180, math.cos(Temprot))
end
-- ############## to test it #################


function Command_Build_Mode_Rotate(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	--Build_Mode_Set(Client_ID, 300)
	--Build_Mode_State_Set(Client_ID, 0)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Rotate Started"))
	
	Map_ID = Client_Get_Map_ID(Client_ID)
	
	Build_Mode_Rotate_Do(Map_ID, 64-20, 64+20, 64-20, 64+20, 0, 10, 0, 0, 45)
end

function Build_Mode_Rotate(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Point_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Point_Get(Client_ID, 0)
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			local Hollow = Build_Mode_Long_Get(Client_ID, 1)
			
			local Blocks = math.abs(X_0-X_1)*math.abs(Y_0-Y_1)*math.abs(Z_0-Z_1)
			
			Build_Mode_Set(Client_ID, 0)
		end
		
	end
	
end