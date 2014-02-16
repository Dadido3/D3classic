function Physic_Special_Fire(Map_ID, X, Y, Z)
	
	Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	if math.random(5) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 0, 1, 5)
	else
		rx = math.random(3)-2
		ry = math.random(3)-2
		rz = 1
		Type = Map_Block_Get_Type(Map_ID, X+rx, Y+ry, Z+rz)
		if Type ~= 20 and Type ~= 7 then
			if Type == 0 or math.random(40) == 1 then
				Map_Block_Move(Map_ID, X, Y, Z, X+rx, Y+ry, Z+rz, 1, 1, 5)
			elseif Type ~= Block_Type and Type ~= 5 and Type ~= 17 and Type ~= 47 and math.random(20) == 1 then
				Map_Block_Change(Player_Number, Map_ID, X+rx, Y+ry, Z+rz, 232, 1, 0, 1, 5)
			end
		end
	end
	
	for ix = -1, 1 do
		for iy = -1, 1 do
			for iz = -1, 1 do
				Type = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz)
				if Type == 5 or Type == 17 or Type == 47 then
					for i = 1, 4 do
						rx = math.random(3)-2
						ry = math.random(3)-2
						rz = math.random(3)-2
						Type = Map_Block_Get_Type(Map_ID, X+rx, Y+ry, Z+rz)
						if Type ~= 20 and Type ~= 7 then
							if Type == 0 or math.random(50) == 1 then
								Map_Block_Change(Player_Number, Map_ID, X+rx, Y+ry, Z+rz, Block_Type, 1, 1, 1, 5)
							end
						end
					end
				end
			end
		end
	end
	
end
