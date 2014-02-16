function Physic_Fireworks_Fire_Fountain(Map_ID, X, Y, Z)
	
	Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	for i = 0, 30, 1 do
		Z_2 = math.random(10)
		New_Z = Z + Z_2
		New_X = X + (math.random(20) - 10)*Z_2/30
		New_Y = Y + (math.random(20) - 10)*Z_2/30
		
		if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
			Map_Block_Change(-1, Map_ID, New_X, New_Y, New_Z, 225, 0, 1, 1, 5)
		end
	end
	
end
