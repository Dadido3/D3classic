-- ############################ Brush #############################

function Command_Build_Mode_Brush(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local Size = tonumber(Arg_0)
	
	if Size > 0 and Size <= 15 then
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Brush started"))
		
		Build_Mode_Long_Set(Client_ID, 0, Size) -- Size
		Build_Mode_Set(Client_ID, "Brush")
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Brush: Define a size"))
	end
end

function Build_Mode_Brush(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	
	local Size = Build_Mode_Long_Get(Client_ID, 0)
	
	local Map_Part = {}
	
	for ix = -Size-2, Size+2 do
		Map_Part[ix] = {}
		for iy = -Size-2, Size+2 do
			Map_Part[ix][iy] = {}
			for iz = -Size-2, Size+2 do
				Map_Part[ix][iy][iz] = 0.0
			end
		end
	end
	
	Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
	
	if Mode == 1 then
		
		for ix = -Size-1, Size+1 do
			for iy = -Size-1, Size+1 do
				for iz = -Size-1, Size+1 do
					if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) > 0 then
						entf = math.sqrt(ix*ix + iy*iy + iz*iz)
						if entf <= Size then
							for iix = -1, 1 do
								for iiy = -1, 1 do
									for iiz = -1, 1 do
										Map_Part[ix+iix][iy+iiy][iz+iiz] = Map_Part[ix+iix][iy+iiy][iz+iiz] + math.random(100)/250
									end
								end
							end
						end
					end
				end
			end
		end
		
		for ix = -Size, Size do
			for iy = -Size, Size do
				for iz = -Size, Size do
					if Map_Part[ix][iy][iz] > 1 and Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
						--Map_Block_Change_Fast(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Type, 1, 1, 0, 1)
						Map_Block_Change_Player(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Block_Type, 1, 1, 1, 10)
					end
				end
			end
		end
	
	elseif Mode == 0 then
		
		for ix = -Size-1, Size+1 do
			for iy = -Size-1, Size+1 do
				for iz = -Size-1, Size+1 do
					if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
						entf = math.sqrt(ix*ix + iy*iy + iz*iz)
						if entf <= Size then
							for iix = -1, 1 do
								for iiy = -1, 1 do
									for iiz = -1, 1 do
										Map_Part[ix+iix][iy+iiy][iz+iiz] = Map_Part[ix+iix][iy+iiy][iz+iiz] + math.random(100)/250
									end
								end
							end
						end
					end
				end
			end
		end
		
		for ix = -Size, Size do
			for iy = -Size, Size do
				for iz = -Size, Size do
					if Map_Part[ix][iy][iz] > 1 and Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == Block_Type then
						--Map_Block_Change_Fast(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Type, 1, 1, 0, 1)
						Map_Block_Change_Player(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, 0, 1, 1, 1, 10)
					end
					if Block_Type == 3 and Map_Part[ix][iy][iz] > 1 and Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 2 then
						-- Dirt/Grass
						Map_Block_Change_Player(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, 0, 1, 1, 1, 10)
					end
				end
			end
		end
		
	end
	
	Build_Mode_Set(Client_ID, Build_Mode_Get(Client_ID))
end