local function Get_Height(Map_ID, X, Y, Z_Start)
	for iz = Z_Start, 0, -1 do
		local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, iz)
		if Block_Type ~= 0 then
			return iz+1
		end
	end
	return 0
end

function Mapstyle_shadow(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Arguments)
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			Map_Block_Change(-1, Map_ID, ix, iy, Map_Size_Z-1, 0, 0, 0, 1, 1)
		end
	end
	
	for ix = 0, Map_Size_X-2 do
		for iy = 0, Map_Size_Y-2 do
			local Diff = (Get_Height(Map_ID, ix, iy, Map_Size_Z-2) - Get_Height(Map_ID, ix+0, iy+1, Map_Size_Z-2))*1
			if Diff > 0 then
				for i = 1, Diff do
					Map_Block_Change(-1, Map_ID, ix+i*0, iy+i*1, Map_Size_Z-1, 1, 0, 0, 1, 1)
				end
			end
		end
	end
end