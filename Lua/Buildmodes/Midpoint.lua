function Command_Build_Mode_Get_Midpoint(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Get Midpoint started"))
	Build_Mode_Set(Client_ID, "Get Midpoint")
	Build_Mode_State_Set(Client_ID, 0)
end

function Build_Mode_Get_Midpoint(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			
			
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			local Mid_X, Mid_Y, Mid_Z = math.floor((X_0+X_1)/2), math.floor((Y_0+Y_1)/2), math.floor((Z_0+Z_1)/2)
			Map_Block_Change_Player(Player_Number, Map_ID, Mid_X, Mid_Y, Mid_Z, Block_Type, 1, 1, 1, 10)
			local Mid_X, Mid_Y, Mid_Z = math.floor((X_0+X_1)/2+0.5), math.floor((Y_0+Y_1)/2+0.5), math.floor((Z_0+Z_1)/2+0.5)
			Map_Block_Change_Player(Player_Number, Map_ID, Mid_X, Mid_Y, Mid_Z, Block_Type, 1, 1, 1, 10)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Midpoint created"))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
end

System_Message_Network_Send_2_All(-1, "&eMidpoint reloaded")