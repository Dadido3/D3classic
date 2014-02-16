function Command_Player_List_Ranks(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Arg_0, Arg_1 = tonumber(Arg_0), tonumber(Arg_1)
	local lower = math.min(Arg_0, Arg_1)
	local higher = math.max(Arg_0, Arg_1)
	local count = 0
	local lnumber = -1
	Player_Examine()
	while Player_Next() ~= 0 do
		local Player_Number = Player_Get_Number()
		if Player_Number == lnumber then
			break
		end
		lnumber = Player_Number

		local rank = Player_Get_Rank(Player_Number)
		if rank >= lower and rank <= higher then
			count = count+1
		end
	end
	System_Message_Network_Send(Client_ID, "&eFound &f"..count.." &eplayers with the specified rank range.")
end