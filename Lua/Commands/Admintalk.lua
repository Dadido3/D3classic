function Command_Message_Admins(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)

	local Prefix, Name, Suffix = Entity_Displayname_Get(Client_Get_Entity(Client_ID))

	local Rank = Player_Get_Rank(Entity_Get_Player(Client_Get_Entity(Client_ID)))

	local tcol = "&e"
	
	if Rank > 1000 then

		tcol = "&7"

	elseif Rank >= 250 then

		tcol = "&a"

	elseif Rank >= 200 then

		tcol = "&1"

	elseif Rank >= 150 then

		tcol = "&6"

	end
	
	if Name == "Knuk" then
		tcol = "&b"
	end

	
	Client_Table, Clients = Client_Get_Table()
	for i = 1, Clients do
		local Temp_Client_ID = Client_Table[i]

		local Player_Number = Entity_Get_Player(Client_Get_Entity(Temp_Client_ID))

		local Rank = Player_Get_Rank(Player_Number)

		if  Rank >= 149 or Temp_Client_ID == Client_ID then --Check ranks

			System_Message_Network_Send(Temp_Client_ID ,Prefix..Name..Suffix.." &c>>".." "..tcol..Text_0)

		end

	end

end

Event_Delete("Admin_Talk")
Event_Add("Admin_Talk", "Admin_Talk", "Chat_Map", 0, 1, -1)
function Admin_Talk(Result, Entity_ID, Message)
	local Client_ID
	
	Client_Table, Clients = Client_Get_Table()
	local Found = 0
	for i = 1, Clients do
		Client_ID = Client_Table[i]
		if Client_Get_Entity(Client_ID) == Entity_ID then
			Found = 1
			break
		end
	end
	
	if Found == 1 then
		local char = Message:sub(1,1)
		
		if char == "'" then
			Command_Message_Admins(Client_ID,"mad",Message:sub(2))
			Result = 0
		end
	end


	return Result
end

System_Message_Network_Send_2_All(-1, "&eMad Script reloaded.")