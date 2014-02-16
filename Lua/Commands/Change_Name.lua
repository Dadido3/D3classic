function Command_Change_Name(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	
	local Prefix, Name, Suffix = Arg_0, Arg_1, Arg_2
	
	--Prefix = string.gsub(Prefix, "\%", "&")
	
	if Name == "" then
		Name = Prefix
		Prefix = "&f"
	end
	if Name ~= "" then
		Entity_Displayname_Set(Entity_ID, Prefix, Name, Suffix)
		System_Message_Network_Send(Client_ID, "&eName changed to: "..Prefix..Name..Suffix)
	else
		System_Message_Network_Send(Client_ID, "&eEmpty name is not allowed")
	end
end

function Command_Reset_Name(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local Prefix, Name, Suffix = Player_Get_Prefix(Player_Number), Player_Get_Name(Player_Number), Player_Get_Suffix(Player_Number)
	
	Entity_Displayname_Set(Entity_ID, Prefix, Name, Suffix)

	System_Message_Network_Send(Client_ID, "&eName changed back to: "..Prefix..Name..Suffix)
end