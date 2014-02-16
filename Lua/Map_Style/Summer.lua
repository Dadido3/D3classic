local function Get_Height(Map_ID, X, Y, Z_Start)
	for iz = Z_Start, 0, -1 do
		local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, iz)
		if Block_Type ~= 0 then
			return iz
		end
	end
end

function Mapstyle_summer(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Arguments)
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			local iz = Get_Height(Map_ID, ix, iy, Map_Size_Z-1)
			local Type, Lower_Type = Map_Block_Get_Type(Map_ID, ix, iy, iz), Map_Block_Get_Type(Map_ID, ix, iy, iz-1)
			if Type == 79 then
				Map_Block_Change(-1, Map_ID, ix, iy, iz, 8, 0, 0, 1, 1) -- Water
			elseif Type == 78 then
				Map_Block_Change(-1, Map_ID, ix, iy, iz, 0, 0, 0, 1, 1) -- Air
				if Lower_Type == 3 then
					Map_Block_Change(-1, Map_ID, ix, iy, iz-1, 2, 0, 0, 1, 1) -- Grass
				end
			end
		end
	end
end