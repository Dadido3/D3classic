function Command_Player_Block_Reset(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local timeS = os.clock()
	local Map_ID = Client_Get_Map_ID(Client_ID)
	local X,Y,Z = Map_Get_Dimensions(Map_ID)
	for iX = 0, X do
		for iY = 0, Y do
			for iZ = 0, Z do
				Map_Block_Change_Fast(-1, Map_ID, iX, iY, iZ, Map_Block_Get_Type(Map_ID, iX, iY, iZ), 0, 0, 0, 0)
			end
		end
	end
	System_Message_Network_Send_2_All(Map_ID, "&eReset all last players on map in &f"..math.floor((os.clock()-timeS)*1000).."&ems")
end