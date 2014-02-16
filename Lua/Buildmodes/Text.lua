function Command_Build_Mode_Text(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Text started"))
		Build_Mode_Set(Client_ID, "Text")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_String_Set(Client_ID, 0, Text_0)
	else
		System_Message_Network_Send(Client_ID, "&eGive me please some text to write.")
	end
end

function Build_Mode_Text(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			Build_Mode_Long_Set(Client_ID, 0, Block_Type)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			local Text = Build_Mode_String_Get(Client_ID, 0)
			local Mat_F, Mat_B = Build_Mode_Long_Get(Client_ID, 0), Block_Type
			
			if Mat_F == Mat_B then
				Mat_B = 0
			end
			
			local Rot = math.deg(math.atan2((Y_0-Y_1), (X_0-X_1)))+90
			local V_X, V_Y = math.cos(math.rad(Rot-90)), math.sin(math.rad(Rot-90))
			
			if math.abs(V_X) > math.abs(V_Y) then
				V_Y = V_Y * math.abs(1/V_X)
				V_X = V_X * math.abs(1/V_X)
			else
				V_X = V_X * math.abs(1/V_Y)
				V_Y = V_Y * math.abs(1/V_Y)
			end
			
			Font_Draw_Text_Player(Player_Number, "Minecraft", Map_ID, X_1, Y_1, Z_1, V_X, V_Y, Text, Mat_F, Mat_B)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Text created"))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end