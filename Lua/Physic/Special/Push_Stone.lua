function Physic_Special_Pushblock(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	if Map_Block_Get_Type(Map_ID, X, Y, Z-1) == 0 then
		Map_Block_Move(Map_ID, X, Y, Z, X, Y, Z-1, 1, 1, 5)
	elseif Map_Block_Get_Type(Map_ID, X, Y, Z-1) ~= 0 then
		local VX, VY, VZ = 0, 0, 0
		
		local Entity_Table, Entitys = Entity_Get_Table()
		for i = 1, Entitys do
			local Entity_ID = Entity_Table[i]
			local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Entity_ID),Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
			
			for zt = 0, 0 do
				if Entity_Map_ID == Map_ID and math.floor(Entity_X) == X+1 and math.floor(Entity_Y) == Y and math.floor(Entity_Z) == Z+zt then
					if Map_Block_Get_Type(Map_ID, X-1, Y, Z) == 0 then
						VX = -1
					end
				elseif Entity_Map_ID == Map_ID and math.floor(Entity_X) == X and math.floor(Entity_Y) == Y+1 and math.floor(Entity_Z) == Z+zt then
					if Map_Block_Get_Type(Map_ID, X, Y-1, Z) == 0 then
						VY = -1
					end
				elseif Entity_Map_ID == Map_ID and math.floor(Entity_X) == X and math.floor(Entity_Y) == Y-1 and math.floor(Entity_Z) == Z+zt then
					if Map_Block_Get_Type(Map_ID, X, Y+1, Z) == 0 then
						VY = 1
					end
				elseif Entity_Map_ID == Map_ID and math.floor(Entity_X) == X-1 and math.floor(Entity_Y) == Y and math.floor(Entity_Z) == Z+zt then
					if Map_Block_Get_Type(Map_ID, X+1, Y, Z) == 0 then
						VX = 1
					end
				end
			end
		end
		
		if X ~= X+VX or Y ~= Y+VY or Z ~= Z+VZ then
			Map_Block_Move(Map_ID, X, Y, Z, X+VX, Y+VY, Z+VZ, 1, 1, 5)
		end
	end
end