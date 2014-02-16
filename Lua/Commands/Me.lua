function Command_Me(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	local Map_ID = Client_Get_Map_ID(Client_ID)
	
	--local Mute_Time = Player_Get_Mute_Time(Player_Number)
	
	if Text_0 ~= "" then
		--if Mute_Time > os.time() then
			System_Message_Network_Send_2_All(Map_ID, "&c*"..Prefix..Name..Suffix.." "..Text_0)
		--else
		--	System_Message_Network_Send_2_All(Map_ID, "&cMuted*"..Prefix..Name..Suffix.." "..Text_0)
		--end
	end
end
