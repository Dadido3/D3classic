function Command_Build_Mode_Measure(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, "&eBuildmode: Measure.<br>&eBuild at the start and endpoint.")
	Build_Mode_Set(Client_ID, "Measure")
	Build_Mode_State_Set(Client_ID, 0)
end

function Build_Mode_Measure(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local State = Build_Mode_State_Get(Client_ID)
	Build_Mode_State_Set(Client_ID, State+1)
	Build_Mode_Coordinate_Set(Client_ID, State, X, Y, Z)
	if State == 1 then
		Build_Mode_Set(Client_ID, "Normal") 
		local X1, Y1, Z1, X2, Y2, Z2 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)   
		
		local pyth = Dist_Point_Point_3D(X1,Y1,Z1,X2,Y2,Z2) 
		System_Message_Network_Send(Client_ID, string.format("&eDistance(pyth): %.3fm",pyth))
		local D_X = math.abs(X1 - X2) + 1
		local D_Y = math.abs(Y1 - Y2) + 1
		local D_Z = math.abs(Z1 - Z2) + 1
		local Blocks = 1                     
		if Blocks < math.abs(D_X) then Blocks = math.abs(D_X) end
		if Blocks < math.abs(D_Y) then Blocks = math.abs(D_Y) end
		if Blocks < math.abs(D_Z) then Blocks = math.abs(D_Z) end
		System_Message_Network_Send(Client_ID, string.format("&eAxis Lengths: X: %s, Y: %s, Z: %s",D_X,D_Y,D_Z))
		System_Message_Network_Send(Client_ID, string.format("&eBlock line length: %s",Blocks))
		
	end
end

System_Message_Network_Send_2_All(-1, "&emeasure reloaded")
