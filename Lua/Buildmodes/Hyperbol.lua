function Build_Hyperbol_Line(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Replace_Material)
	--X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X_0+0.5, Y_0+0.5, Z_0+0.5, X_1+0.5, Y_1+0.5, Z_1+0.5
	
	local D_X = X_1 - X_0
	local D_Y = Y_1 - Y_0
	local D_Z = Z_1 - Z_0
	
	local Blocks = 1
	
	if Blocks < math.abs(D_X) then Blocks = math.abs(D_X) end
	if Blocks < math.abs(D_Y) then Blocks = math.abs(D_Y) end
	if Blocks < math.abs(D_Z) then Blocks = math.abs(D_Z) end
	
	Blocks = math.ceil(Blocks)
	
	local M_X = D_X / Blocks
	local M_Y = D_Y / Blocks
	local M_Z = D_Z / Blocks
	
	for i = 0, Blocks do
		Map_Block_Change_Player(Player_Number, Map_ID, math.floor(X_0+M_X*i), math.floor(Y_0+M_Y*i), math.floor(Z_0+M_Z*i), Material, 1, 1, 1, 10)
	end
end

function Build_Hyperbol_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, X_2, Y_2, Z_2, X_3, Y_3, Z_3, Material, Replace_Material)
	X_0, Y_0, Z_0, X_1, Y_1, Z_1, X_2, Y_2, Z_2, X_3, Y_3, Z_3 = X_0+0.5, Y_0+0.5, Z_0+0.5, X_1+0.5, Y_1+0.5, Z_1+0.5, X_2+0.5, Y_2+0.5, Z_2+0.5, X_3+0.5, Y_3+0.5, Z_3+0.5
	
	local D_X_0 = X_1 - X_0
	local D_Y_0 = Y_1 - Y_0
	local D_Z_0 = Z_1 - Z_0
	
	local D_X_1 = X_3 - X_2
	local D_Y_1 = Y_3 - Y_2
	local D_Z_1 = Z_3 - Z_2
	
	local Blocks = 1
	
	if Blocks < math.abs(D_X_0) then Blocks = math.abs(D_X_0) end
	if Blocks < math.abs(D_Y_0) then Blocks = math.abs(D_Y_0) end
	if Blocks < math.abs(D_Z_0) then Blocks = math.abs(D_Z_0) end
	if Blocks < math.abs(D_X_1) then Blocks = math.abs(D_X_1) end
	if Blocks < math.abs(D_Y_1) then Blocks = math.abs(D_Y_1) end
	if Blocks < math.abs(D_Z_1) then Blocks = math.abs(D_Z_1) end
	
	Blocks = math.ceil(Blocks) * 10
	
	local M_X_0 = D_X_0 / Blocks
	local M_Y_0 = D_Y_0 / Blocks
	local M_Z_0 = D_Z_0 / Blocks
	local M_X_1 = D_X_1 / Blocks
	local M_Y_1 = D_Y_1 / Blocks
	local M_Z_1 = D_Z_1 / Blocks
	
	for i = 0, Blocks-1 do
		Build_Hyperbol_Line(Player_Number, Map_ID, X_0+M_X_0*i, Y_0+M_Y_0*i, Z_0+M_Z_0*i, X_2+M_X_1*i, Y_2+M_Y_1*i, Z_2+M_Z_1*i, Material, 10, 1, 1)
	end
end

function Command_Build_Mode_Hyperbol(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Text_0 ~= "" then
		local Found = 0
		
		for i = 0, 255 do
			local Block_Name = Block_Get_Name(i)
			if string.lower(Block_Name) == string.lower(Text_0) then
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hyperbol started"))
				System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Replace '[Field_0]'", Block_Name))
				Build_Mode_Set(Client_ID, "Hyperbol")
				Build_Mode_State_Set(Client_ID, 0)
				Build_Mode_Long_Set(Client_ID, 0, i)
				Found = 1
				break
			end
		end
		if Found == 0 then
			System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Text_0))
		end
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hyperbol started"))
		Build_Mode_Set(Client_ID, "Hyperbol")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_Long_Set(Client_ID, 0, -1)
	end
end

function Build_Mode_Hyperbol(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 1, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 2)
			
		elseif State == 2 then -- Dritten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 2, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 3)
			
		elseif State == 3 then -- Vierten Punkt wählen und bauen
			local X_0, Y_0, Z_0 = Build_Mode_Coordinate_Get(Client_ID, 0)
			local X_1, Y_1, Z_1 = Build_Mode_Coordinate_Get(Client_ID, 1)
			local X_2, Y_2, Z_2 = Build_Mode_Coordinate_Get(Client_ID, 2)
			local X_3, Y_3, Z_3 = X, Y, Z
			
			local Replace_Material = Build_Mode_Long_Get(Client_ID, 0)
			
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			
			Build_Hyperbol_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, X_2, Y_2, Z_2, X_3, Y_3, Z_3, Block_Type, Replace_Material)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hyperbol created"))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
end


System_Message_Network_Send_2_All(-1, "&eHyperbol reloaded")