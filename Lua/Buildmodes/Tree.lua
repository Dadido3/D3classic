-- ############################ Tree #############################

function Command_Build_Mode_Tree(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Size = tonumber(Arg_0)
	
	if Size >= 1 and Size <= 40 then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Tree Started"))
		
		Build_Mode_Long_Set(Client_ID, 0, Size) -- Size
		Build_Mode_Set(Client_ID, "Tree")
	else
		
	end
end

function Build_Client_Line_Thickness(Client_ID, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Thickness, Material, Priority, Undo, Physic)
	local D_X = X_1 - X_0
	local D_Y = Y_1 - Y_0
	local D_Z = Z_1 - Z_0
	
	local Blocks = 1
	
	if Blocks < math.abs(D_X) then Blocks = math.abs(D_X) end
	if Blocks < math.abs(D_Y) then Blocks = math.abs(D_Y) end
	if Blocks < math.abs(D_Z) then Blocks = math.abs(D_Z) end
	
	local M_X = D_X / Blocks
	local M_Y = D_Y / Blocks
	local M_Z = D_Z / Blocks
	
	local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
	
	for i = 0, Blocks+1 do
		--Map_Block_Change(Client_ID, Map_ID, X_0+M_X*i, Y_0+M_Y*i, Z_0+M_Z*i, 1, Material, Priority, Undo, Physic)
		Build_Sphere_Player(Player_Number, Map_ID, X_0+M_X*i, Y_0+M_Y*i, Z_0+M_Z*i, Thickness, Material, 0, 0, Priority, Undo, Physic)
	end
end

function Build_Mode_Tree_Place(Client_ID, Map_ID, X, Y, Z, Rot, VRot, Size, Iteration)
	local Material_Tree = 17
	local Material_Leaves = 18
	
	local Branch_Size = math.floor(Size*0.2/2)
	if Branch_Size > 5 then Branch_Size = 5 end
	
	local X_1, Y_1, Z_1 = X+math.cos(math.rad(Rot))*math.cos(math.rad(VRot))*Size, Y+math.sin(math.rad(Rot))*math.cos(math.rad(VRot))*Size, Z+math.sin(math.rad(VRot))*Size
	--Build_Client_Line(Client_ID, Map_ID, X+ix, Y+iy, Z, X_1+ix, Y_1+iy, Z_1, Material_Tree, 8, 1, 0)
	Build_Client_Line_Thickness(Client_ID, Map_ID, X, Y, Z, X_1, Y_1, Z_1, Branch_Size, Material_Tree, 8-Iteration, 1, 0)
	
	local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
	
	if Iteration <= 1 then
		for i = 0, 30 do
			XR, YR, ZR = X_1+math.random(5)-3, Y_1+math.random(5)-3, Z_1+math.random(5)-3
			if Map_Block_Get_Type(Map_ID, XR, YR, ZR) == 0 then
				Map_Block_Change_Player(Player_Number, Map_ID, XR, YR, ZR, Material_Leaves, 1, 0, 1, 7)
			end
		end
	end
	
	local i
	
	local Branches = Iteration
	if Branches < 2 then Branches = 2 end
	if Branches > 6 then Branches = 6 end
	
	if Iteration >= 0 then
		for i = 1, Branches do
			Build_Mode_Tree_Place(Client_ID, Map_ID, X_1, Y_1, Z_1, Rot+(math.random(361)-181)*0.5, VRot+(math.random(361)-181)*0.3, Size*0.8, Iteration-1)
		end
	end
end

function Build_Mode_Tree(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	
	local Size = Build_Mode_Long_Get(Client_ID, 0)
	
	if Mode == 1 then
		Build_Mode_Tree_Place(Client_ID, Map_ID, X, Y, Z, math.random(361)-1, 90, Size, 5)
	end
	
	Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
end