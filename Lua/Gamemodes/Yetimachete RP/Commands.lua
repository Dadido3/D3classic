function Command_CDRP_Sendmoney(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Player_0_Number = Client_Get_Player_Number(Client_ID)
	local Player_1_Number = Player_Name_2_Number(Arg_0)
	local Money = tonumber(Arg_1)
	
	if Money > 0 then
		local Player_0_Money = Player_Attribute_Long_Get(Player_0_Number, 'Money')
		if Player_0_Money - Money >= 0 then
			Player_Attribute_Long_Set(Player_0_Number, 'Money', Player_0_Money - Money)
			Player_Attribute_Long_Set(Player_1_Number, 'Money', Player_Attribute_Long_Get(Player_1_Number, 'Money') + Money)
			System_Message_Network_Send(Client_ID, "You gave add more text here... "..tostring(Money))
			Client_Examine()
			while Client_Next() ~= 0 do
				local To_Client_ID = Client_Get_ID()
				if Client_Get_Player_Number(To_Client_ID) == Player_1_Number then
					System_Message_Network_Send(To_Client_ID, "&eYou got "..tostring(Money).." money from "..Client_Get_Name(Client_ID))
				end
			end
		end
	end
end

function Command_CDRP_Showmoney(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Player_Number = Client_Get_Player_Number(Client_ID)
	local Money = Player_Attribute_Long_Get(Player_Number, 'Money')
	System_Message_Network_Send(Client_ID, "You have a balance of "..tostring(Money))
end