function Physic_Standart_Sponge(Map_ID, X, Y, Z)
	local Radius = 2
	local Repel_Material = 251
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)

	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				local Type = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz)
				if Type == 0 or Type == 8 or Type == 10 or Type == 209 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Repel_Material, 1, 1, 1, 2)
				end
			end
		end
	end
end

function Physic_Standart_Sponge_Repel_Small(Map_ID, X, Y, Z)
	local Radius = 2
	local Sponge_Material = 19
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == Sponge_Material then
					return 0
				end
			end
		end
	end
	Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 1, 1, 2)
end