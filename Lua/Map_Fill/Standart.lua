function Mapfill_standart(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
	
	local Time_Start = os.clock()
	
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			for iz = 0, Map_Size_Z/2-1 do
				if iz == Map_Size_Z/2-1 then
					Map_Block_Change(-1, Map_ID, ix, iy, iz, 2, 0, 0, 0, 0)
				else
					Map_Block_Change(-1, Map_ID, ix, iy, iz, 3, 0, 0, 0, 0)
				end
			end
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Map created in "..string.sub(tostring(os.clock()-Time_Start), 1, 4).."s.")
	
end
