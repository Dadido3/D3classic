local function tonum(x)
	if x==nil then return 0 else return x end
end

function Event_Timer_Wireworld(Map_ID)
	
	local Type_Empty = 0
	local Type_Wire = 41
	local Type_Electron_Head = 27
	local Type_Electron_Tail = 21
	
	local Size_X = 128
	local Size_Y = 128
	local Size_Z = 0
	local iz = 1
	local Counter = {}
	
	--[[for i = 0, (Size_X+Size_Y*Size_X) do
		Counter[i] = 0
	end]]
	
	for ix = 0, Size_X do
		for iy = 0, Size_Y do
			--for iz = 1, Size_Z do
				if Map_Block_Get_Type(Map_ID, ix, iy, iz) == Type_Electron_Head then
					for ixx = -1, 1 do
						New_X = ix + ixx
						if New_X >= 0 and New_X <= Size_X then
							for iyy = -1, 1 do
								New_Y = iy + iyy
								if New_Y >= 0 and New_Y <= Size_Y then
									if ixx ~= 0 or iyy ~= 0 then
										--(New_X+New_Y*Size_X)
										--local number = (iz * Size_Y + New_Y) * Size_X + New_X
										local number = (iz * Size_X * Size_Y) + (New_X+New_Y*Size_X)
										Counter[number] = tonum(Counter[number]) + 1
									end
								end
							end
						end
					end
				end
			--end
		end
	end
	
	for ix = 0, Size_X do
		for iy = 0, Size_Y do
			--for iz = 1, Size_Z do
				--local number = (iz * Size_Y + iy) * Size_X + ix
				local number = (iz * Size_X * Size_Y) + (ix+iy*Size_X)
				local temp = tonum(Counter[number])
				local Type = Map_Block_Get_Type(Map_ID, ix, iy, iz)
				if Type == Type_Wire then
					if temp > 0 and temp <= 2 then
						Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, Type_Electron_Head, 4, 0, 0, 1)
					end
				--[[elseif Type == 17 then
					if temp > 0 and temp <= 2 then
						for iz=1, Size_Z do
							if Map_Block_Get_Type(Map_ID, ix, iy, iz) ~= 17 then
								Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, Type_Electron_Head, 4, 0, 0, 1)
								break
							end
						end
					end]]
				elseif Type == Type_Electron_Head then
					Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, Type_Electron_Tail, 4, 0, 0, 1)
				elseif Type == Type_Electron_Tail then
					Map_Block_Change_Fast(-1, Map_ID, ix, iy, iz, Type_Wire, 4, 0, 0, 1)
				end
			--end
		end
	end
	
end
