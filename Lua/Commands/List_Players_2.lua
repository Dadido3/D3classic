function Command_List_Players_2(cClient_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local players = {}
	Client_Table, Clients = Client_Get_Table()
	for i = 1, Clients do
		local Client_ID = Client_Table[i]
		local map = Client_Get_Map_ID(Client_ID)
		--local hmode = Client_Hidemode_Get(Client_ID)
		--if hmode < 20 then
			if not players[map] then
				players[map] = {}
			end
			table.insert(players[map],Client_ID)
		--end
	end
	System_Message_Network_Send(cClient_ID, "&ePlayerlist:")
	for i,v in pairs(players) do
		--System_Message_Network_Send(cClient_ID, "&e"..Map_Get_Name(i).." - ")
		local Text = "&e"..Map_Get_Name(i).." - "
		for i2,Client_ID in pairs(v) do
			local Entity_ID = Client_Get_Entity(Client_ID)
			local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
			local Text_Add = Prefix..Name..Suffix.." &f| "
			if 64 - #Text >= #Text_Add then
				Text = Text..Text_Add
			else
				System_Message_Network_Send(cClient_ID, Text)
				Text = Text_Add
			end
		end
		if #Text > 0 then
			System_Message_Network_Send(cClient_ID, Text)
		end
	end
end