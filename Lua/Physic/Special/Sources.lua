function Physic_Special_Water_Source(Map_ID, X, Y, Z)
	local Radius = 1
	local Material = 8
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	if math.random(100) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 1, 0, 0)
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, Type, 0, 1, 0, 0)
	end
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
	
end

function Physic_Special_Lava_Source(Map_ID, X, Y, Z)
	local Radius = 1
	local Material = 10
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	if math.random(100) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 1, 0, 0)
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, Type, 0, 1, 0, 0)
	end
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
	
end

function Physic_Special_Smoke_Source(Map_ID, X, Y, Z)
	local Radius = 1
	local Material = 203
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	if math.random(100) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 1, 0, 0)
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, Type, 0, 1, 0, 0)
	end
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
	
end