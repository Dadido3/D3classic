function Command_Build_Mode_Cancel(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Canceled"))
	Build_Mode_Set(Client_ID, "Normal")
end