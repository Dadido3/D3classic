function Mapfill_wireworld(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Argumentstring)
	for x=0,Map_Size_X-1 do
		for y=0,Map_Size_Y-1 do
			Map_Block_Change(-1, Map_ID, x, y, z, 34, 0, 0, 0, 0)
		end
	end
	--[[for z=1,Map_Size_Z/2-1 do
		for x=0,Map_Size_X-1 do
			for y=0,Map_Size_Y-1 do
				Map_Block_Change_Fast(-1, Map_ID, x, y, z, 9, 0, 0, 0, 0)
			end
		end
	end]]
end