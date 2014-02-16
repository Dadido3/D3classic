-- ############################ Build Line #############################

function Command_Build_Mode_Stick(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Stick started"))
	Build_Mode_Set(Client_ID, "Stick")
	Build_Mode_State_Set(Client_ID, 0)
	
	local Segments = 1
	local Length = -1
	if tonumber(Arg_0) ~= nil then
		Segments = tonumber(Arg_0)
	end
	if tonumber(Arg_1) ~= nil then
		Length = tonumber(Arg_1)
	end
	if Segments < 1 then
		Segments = 1
	end
	Build_Mode_Long_Set(Client_ID, 0, Segments)
	Build_Mode_Float_Set(Client_ID, 0, Length)
end

function Build_Mode_Stick(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local Segment_Size_Max = 50
			
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local D_X = X_1 - X_0
			local D_Y = Y_1 - Y_0
			local D_Z = Z_1 - Z_0
			
			local Distance = math.sqrt(math.pow(D_X,2)+math.pow(D_Y,2)+math.pow(D_Z,2))
			local Segments = Build_Mode_Long_Get(Client_ID, 0)--math.ceil(Distance / Segment_Size_Max)
			local Length = Build_Mode_Float_Get(Client_ID, 0) / Segments
			
			local M_X = D_X / Segments
			local M_Y = D_Y / Segments
			local M_Z = D_Z / Segments
			
			local P_1 = Stickphysic_Entity_Add_Point(-1, Map_ID, X_0+0.5, Y_0+0.5, Z_0+0.5, 1)
			local i
			for i = 1, Segments do
				local P_2 = Stickphysic_Entity_Add_Point(-1, Map_ID, X_0+M_X*i+0.5, Y_0+M_Y*i+0.5, Z_0+M_Z*i+0.5, 1)
				Stickphysic_Entity_Add_Line(-1, Map_ID, P_1, P_2, Block_Type, Length)
				P_1 = P_2
			end
			
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Stick created"))
			
			--Build_Mode_Set(Client_ID, "Normal")
			Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
			Build_Mode_State_Set(Client_ID, 0)
		end
		
	end
	
end

-- ############################ Build Anchor #############################

function Command_Build_Mode_Anchor(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Anchor started"))
	Build_Mode_Set(Client_ID, "Anchor")
	Build_Mode_State_Set(Client_ID, 0)
end

function Build_Mode_Anchor(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		Stickphysic_Entity_Add_Anchor(-1, Map_ID, X+0.5, Y+0.5, Z+0.5, Block_Type)
		
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Anchor created"))
		
		Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
		
	end
	
end