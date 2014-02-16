function Physic_Fireworks_Spark(Map_ID, X, Y, Z)
	
	Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	if Map_Block_Get_Type(Map_ID, X, Y, Z-1) == 0 then
		if math.random(10) ~= 1 then
			Map_Block_Move(Map_ID, X, Y, Z, X, Y, Z-1, 0, 1, 5)
		else
			Map_Block_Change(-1, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
		end
	else
		Map_Block_Change(-1, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
	end
	
end
