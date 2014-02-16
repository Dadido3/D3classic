function Command_List_Mapfills(Client_ID, Command, Text_0, Text_1, ...)
	System_Message_Network_Send(Client_ID, "&eMapfills:")
	local Text = ""
	for i,v in pairs(_G) do
		--print(i)
		if i:sub(1,8) == "Mapfill_" then
			local Text_Add = "&e"..i:sub(9).." &f| "
			if 64 - #Text >= #Text_Add then
				Text = Text..Text_Add
			else
				System_Message_Network_Send(Client_ID, Text)
				Text = Text_Add
			end
		end
	end
	if #Text > 0 then
		System_Message_Network_Send(Client_ID, Text)
	end
end