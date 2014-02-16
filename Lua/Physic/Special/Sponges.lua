function Physic_Special_Sponge_Drain(Map_ID, X, Y, Z)
	local Radius = 2
	local Material = 0
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)

	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				local Type = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz)
				if Type == 8 or Type == 10 or Type == 209 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
end

function Physic_Special_Super_Sponge_Drain(Map_ID, X, Y, Z)
	local Radius = 4
	local Material = 0
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				local Type = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz)
				if Type == 8 or Type == 10 or Type == 209 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
	
end