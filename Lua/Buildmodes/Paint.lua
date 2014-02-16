-- ############################ Paint #############################

function Command_Build_Mode_Paint(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Paint started"))
	Build_Mode_Set(Client_ID, "Paint")
end

function Build_Mode_Paint(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	
	Map_Block_Change_Client(Client_ID, Map_ID, X, Y, Z, 1, Block_Type)
	
	Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
end