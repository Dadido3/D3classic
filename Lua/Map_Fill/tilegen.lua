function Mapfill_tilegen2(Map_ID,Map_Size_X,Map_Size_Y,Map_Size_Z,args)
	local Tile_Size = 64
	local time = os.clock()
	local xrand = 4
	if args ~= "" then
		xrand = tonumber(args)
	end
	local sea = Map_Size_Z/2-1
	local z = sea
	local heights = {[0]=z}
	for y=0,Map_Size_Y do
		--z = (Map_Size_Z-1)*(y%2) --was to test it ;)
		for x=0,Tile_Size do
			if heights[x] == nil then heights[x] = z end
			local dif = heights[x]-z
			if math.abs(dif) > 1 then
				if z > heights[x] then
					z = z-1
				else
					z = z+1
				end
			else
				if math.random(1,xrand) == 1 then
					local rand = math.random(0,Map_Size_Z)
					if rand > z then
						z = z+1
					else
						z = z-1
					end
				end
			end
			for iz=0,z-1 do
				Map_Block_Change(-1, Map_ID, x,y,iz, 3, 0, 0, 0, 0)
			end
			if z > sea then
				Map_Block_Change(-1, Map_ID, x,y,z, 2, 0, 0, 0, 0)
			else
				for iz=z,sea do
					Map_Block_Change(-1, Map_ID, x,y,iz, 8, 0, 0, 0, 0)
				end
				Map_Block_Change(-1, Map_ID, x,y,z, 12, 0, 0, 0, 0)
			end
			heights[x] = z
		end
	end
	time = os.clock()-time
	System_Message_Network_Send_2_All(Map_ID, string.format("&eInitial gen took: %sms",time*1000))
	time = os.clock()
	local Tiles = math.floor(Map_Size_X/Tile_Size)
	for ix=0,Tile_Size do
		for i=0,Tiles do
			for iy=0,Map_Size_Y do
				for iz=0,Map_Size_Z do
					local eX = (i*Tile_Size)+ix
					local Type = Map_Block_Get_Type(Map_ID, ix, iy, iz)
					Map_Block_Change(-1, Map_ID, eX, iy+i, iz, Type, 0, 0, 0, 0)
				end
			end
		end
	end
	time = os.clock()-time
	System_Message_Network_Send_2_All(Map_ID, string.format("&ecopying took: %sms",time*1000))
end
function Mapfill_tilegen(...)
	print(pcall(Mapfill_tilegen2,...))
end
--Map_Fill(123, "yltgen")

System_Message_Network_Send_2_All(-1, "&etilegen reloaded")
