function Command_Map_Resend(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	Map_ID = Client_Get_Map_ID(Client_ID)
	Map_Resend(Map_ID)
end
