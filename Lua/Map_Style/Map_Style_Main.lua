function Map_Style_Main(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local Function_Name = "Mapstyle_"..string.lower(Arg_0)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local Size_X, Size_Y, Size_Z = Map_Get_Dimensions(Map_ID)
	local Arguments = Text_1
	
	if Arg_0 ~= "" then
		local Function = _G[Function_Name]
		Function(Map_ID, Size_X, Size_Y, Size_Z, Arguments)
		
		System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map styled"))
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Please define a function"))
	end
end