local function Get_Height(Map_ID, X, Y, Z_Start)
	for iz = Z_Start, 0, -1 do
		local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, iz)
		if Block_Type ~= 0 then
			return iz+1
		end
	end
end

function Mapstyle_winter(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Arguments)
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			local iz = Get_Height(Map_ID, ix, iy, Map_Size_Z-1)
			local Type, Lower_Type = Map_Block_Get_Type(Map_ID, ix, iy, iz), Map_Block_Get_Type(Map_ID, ix, iy, iz-1)
			if Lower_Type == 8 or Lower_Type == 9 or Lower_Type == 206 then
				Map_Block_Change(-1, Map_ID, ix, iy, iz-1, 79, 0, 1, 1, 1) -- Ice
			else
				Map_Block_Change(-1, Map_ID, ix, iy, iz, 78, 0, 1, 1, 1) -- Snow
			end
		end
	end
end