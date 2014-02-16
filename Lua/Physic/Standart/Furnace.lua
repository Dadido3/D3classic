function Physic_Standart_Furnace(Map_ID, X, Y, Z)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z+1)
	
	Type = Map_Block_Get_Type(Map_ID, X, Y, Z+1)
	
	New_Material = 0
	
	-- Dirt to Brick
	if Type == 3 then New_Material = 45 end
	-- Goldore to Gold
	if Type == 14 then New_Material = 41 end
	-- Ironore to Ironblock
	if Type == 15 then New_Material = 42 end
	-- Sand to Glass
	if Type == 12 then New_Material = 20 end
	
	if New_Material > 0 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z+1, New_Material, 1, 1, 1, 5)
	end
end
