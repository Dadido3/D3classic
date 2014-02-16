function Physic_Standart_Dirt_2_Grass(Map_ID, X, Y, Z)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local i = 0
	local Quit = 0
	local Block_Type = 0
	
	local Found_Grass = 0
	for ix = -1, 1 do
		for iy = -1, 1 do
			for iz = -1, 1 do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 2 then
					Found_Grass = 1
					break
				end
			end
		end
	end
	
	if Found_Grass == 1 then
		repeat
			i = i + 1
			Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z+i)
			if Block_Type == -1 then
				Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 2, 1, 1, 1, 5)
			elseif Block_Type ~= 0 and Block_Type ~= 6 and Block_Type ~= 18 and Block_Type ~= 20 and Block_Type ~= 37 and Block_Type ~= 38 and Block_Type ~= 39 and Block_Type ~= 40 and Block_Type ~= 251 then
				break
			end
		until Block_Type == -1
	end
end

function Physic_Standart_Grass_2_Dirt(Map_ID, X, Y, Z)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local i = 0
	local Quit = 0
	local Block_Type = 0
	
	repeat
		i = i + 1
		Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z+i)
		if Block_Type == -1 then
			break
		elseif Block_Type ~= 0 and Block_Type ~= 6 and Block_Type ~= 18 and Block_Type ~= 20 and Block_Type ~= 37 and Block_Type ~= 38 and Block_Type ~= 39 and Block_Type ~= 40 and Block_Type ~= 251 then
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 3, 1, 1, 1, 5)
		end
    until Block_Type == -1
end

-- ##################### Simple and Fast variation: ###################

function Physic_Standart_Dirt_2_Grass_Fast(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Found_Grass = 0
	for ix = -1, 1 do
		for iy = -1, 1 do
			for iz = -1, 1 do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 2 then
					Found_Grass = 1
					break
				end
			end
		end
	end
	
	if Found_Grass == 1 then
		local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z+i)
		if Block_Type == -1 and Block_Type == 0 or Block_Type == 6 or Block_Type == 18 or Block_Type == 20 or Block_Type == 37 or Block_Type == 38 or Block_Type == 39 or Block_Type == 40 or Block_Type == 251 then
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 2, 1, 1, 1, 5)
		end
	end
end

function Physic_Standart_Grass_2_Dirt_Fast(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z+1)
	if Block_Type ~= -1 and Block_Type ~= 0 and Block_Type ~= 6 and Block_Type ~= 18 and Block_Type ~= 20 and Block_Type ~= 37 and Block_Type ~= 38 and Block_Type ~= 39 and Block_Type ~= 40 and Block_Type ~= 251 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 3, 1, 1, 1, 5)
	end
end