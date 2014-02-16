local function tonum(x)
	if x==nil then return 0 else return x end
end
local Map_Block_Change_Fast = Map_Block_Change_Fast
local Map_Block_Get_Type = Map_Block_Get_Type

function Mapfill_city2(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
	local ttime = os.clock()
	local time = os.clock()
	local Water_Height = Map_Size_Z*0.5
	for x = 0, Map_Size_X-1 do
		for y = 0, Map_Size_Y-1 do
			for z=0, Water_Height-1 do
				local mat = 1
				if z == Water_Height-1 then
					mat = 49
				end
				Map_Block_Change(-1, Map_ID, x, y, z, mat, 0, 0, 0, 0)
			end
		end
	end

	local time = os.clock()
	local HMap_Scale = 16
	System_Message_Network_Send_2_All(Map_ID, "&3Building size: &b".. HMap_Scale)
	local HMap_Size_X = Map_Size_X/HMap_Scale
	local HMap_Size_Y = Map_Size_Y/HMap_Scale
	local MBuildings = {}
	local HMap_Fields = 5
	local BGap = math.random(1,8)
	for x=0, HMap_Size_X do --generate all sizes
		for y = 0, HMap_Size_Y do
			local number = (x+y*HMap_Size_X)*HMap_Fields
			local maxh = Water_Height
			MBuildings[number] = math.floor(math.sqrt(math.random(0,maxh)))^2
			
			local size_x = math.random(HMap_Scale/3,HMap_Scale-4)
			local size_y = math.random(HMap_Scale/3,HMap_Scale-4)
			if (size_x == HMap_Scale-BGap) then
				size_x = HMap_Scale
			end
			if (size_y == HMap_Scale-BGap) then
				size_y = HMap_Scale
			end
			MBuildings[number+1] = size_x
			MBuildings[number+2] = size_y
			
			MBuildings[number+3] = 5
			MBuildings[number+4] = 1
		end
	end

	local time = os.clock()
	for x=0, HMap_Size_X do
		for y = 0, HMap_Size_Y do
			local priority = math.random(1,10)
			local number = (x+y*HMap_Size_X)*HMap_Fields
			local oheight = MBuildings[number]
			local height = oheight*priority
			local size_x = MBuildings[number+1]
			local size_y = MBuildings[number+2]
			local floor_h =MBuildings[number+3]
			local material=MBuildings[number+4]
			for ax=-1, 1 do
				for ay=-1, 1 do
					local number = x+ax+(y+ay)*HMap_Size_X*HMap_Fields
					height = height+tonum(MBuildings[number])
				end
			end
			height = math.floor(height/(9+priority)/floor_h)*floor_h-1
			if height > 3 then
				do
					local gap_x = HMap_Scale - size_x
					local gap_y = HMap_Scale - size_y
					local p_x = 2
					local p_y = 2
					if gap_x < 9 and gap_x ~= 0 then p_x = 1 end
					if gap_y < 9 and gap_y ~= 0 then p_y = 1 end
					
					for ix=0, size_x+p_x do
						for iy=1, p_y do
							local oldmat = Map_Block_Get_Type(Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+size_y+iy, Water_Height)
							if oldmat == 0 then
								Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+size_y+iy, Water_Height, 44, 0, 0, 0, 0)
							end
						end
					end
					for ix=1, p_x do
						for iy=0, size_y+p_y do
							local oldmat = Map_Block_Get_Type(Map_ID, (x*HMap_Scale)+size_x+ix, (y*HMap_Scale)+iy, Water_Height)
							if oldmat == 0 then
								Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+size_x+ix, (y*HMap_Scale)+iy, Water_Height, 44, 0, 0, 0, 0)
							end
						end
					end
				end
				for ix=0, size_x do
					for iy=0, size_y do
						for iz=0, height do
							local z=Water_Height+iz+1
							local oldmat = Map_Block_Get_Type(Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, z)
							if (ix == size_x or iy == size_y or ix == 0 or iy == 0) then
								local mat = material
								if (iz) % floor_h == 1 then
									mat = 20
								end
								if (ix == 0 and iy == 0) or (ix == size_x and iy == size_y) or
								   (ix == 0 and iy == size_y) or (ix == size_x and iy == 0) then
									Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, z, material, 0, 0, 0, 0)
								elseif oldmat ~= 0 then
									Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, z, 0, 0, 0, 0, 0)
								else
									Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, z, mat, 0, 0, 0, 0)
								end
							end
							if (iz+2) % floor_h == 1 then
								Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, z, material, 0, 0, 0, 0)
							end
						end
						Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, Water_Height, material, 0, 0, 0, 0) --stone ground..
						--Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+ix, (y*HMap_Scale)+iy, Water_Height+oheight, 21, 0, 0, 0, 0)
					end
				end
				--Map_Block_Change(-1, Map_ID, (x*HMap_Scale)+1, (y*HMap_Scale)+1, Water_Height+height+1, 227, 0, 0, 1, 0) --fan
			end
		end
	end
	System_Message_Network_Send_2_All(Map_ID, "&2Constructed buildings in &a"..os.clock()-time.."&2s.")
	System_Message_Network_Send_2_All(Map_ID, "&2Took a total of &a"..os.clock()-ttime.."&2s.")
end

function Mapfill_city(...)
	print(pcall(Mapfill_city2,...))
end