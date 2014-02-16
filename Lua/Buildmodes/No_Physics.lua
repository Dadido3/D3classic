-- ############################ Paint #############################

function Command_Build_Mode_No_Physics(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: No Physics started"))
	Build_Mode_Set(Client_ID, "No_Physics")
end

function Build_Mode_No_Physics(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	if Mode == 0 then
		Block_Type = 0
	end
	
	Map_Block_Change_Player(Player_Number, Map_ID, X, Y, Z, Block_Type, 1, 0, 1, 250)
	
	--Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
end