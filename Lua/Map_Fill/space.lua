function Mapfill_space(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
	local hx,hy,hz = Map_Size_X-1, Map_Size_Y-1, Map_Size_Z-1
	local mat = 49
	for iz=0,1 do
		local z = iz*hz
		for x=0,hx do
			for y=0,hy do
				mat = 49
				if math.random(100) == 1 then
					mat = 36
				end
				Map_Block_Change(-1, Map_ID, x, y, z, mat, 0, 0, 0, 0)
			end
		end
	end
	for ix=0,1 do
		local x = ix*hx
		for z=0,hz do
			for y=0,hy do
				mat = 49
				if math.random(100) == 1 then
					mat = 36
				end
				Map_Block_Change(-1, Map_ID, x, y, z, mat, 0, 0, 0, 0)
			end
		end
	end
	for iy=0,1 do
		local y = iy*hy
		for z=0,hz do
			for x=0,hx do
				mat = 49
				if math.random(100) == 1 then
					mat = 36
				end
				Map_Block_Change(-1, Map_ID, x, y, z, mat, 0, 0, 0, 0)
			end
		end
	end
	local stars = Map_Size_X+Map_Size_Y+Map_Size_Z/3/500
	for i=0,stars do
		Map_Block_Change(-1, Map_ID, math.random(0,hx), math.random(0,hy), math.random(0,hz), 36, 0, 0, 0, 0)
	end
end