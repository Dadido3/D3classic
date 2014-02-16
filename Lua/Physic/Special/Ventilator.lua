function Physic_Special_Ventilator(Map_ID, X, Y, Z)
	
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	local Radius = 3
	local Material = 5
	local Rotation = os.clock() * math.pi / 2
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			if Map_Block_Get_Type(Map_ID, X + ix, Y + iy, Z) == Material then
				Map_Block_Change(-1, Map_ID, X + ix, Y + iy, Z, 0, 0, 0, 1, 5)
			end
		end
	end
	for ir = 1, Radius do
		local Rot_X = math.cos(Rotation) * ir
		local Rot_Y = math.sin(Rotation) * ir
		if math.floor(Rot_X + 0.5) ~= 0 or math.floor(Rot_Y + 0.5) ~= 0 then
			Map_Block_Change(-1, Map_ID, X + math.floor(Rot_X + 0.5), Y + math.floor(Rot_Y + 0.5), Z, Material, 0, 0, 1, 5)
			Map_Block_Change(-1, Map_ID, X - math.floor(Rot_X + 0.5), Y - math.floor(Rot_Y + 0.5), Z, Material, 0, 0, 1, 5)
		end
	end
end
