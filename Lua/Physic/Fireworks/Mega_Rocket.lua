function Physic_Fireworks_Mega_Rocket(Map_ID, X, Y, Z)

	Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	if math.random(40) == 1 then
		--System_Message_Network_Send_2_All(-1, "&e BIG BAM!!!!!")
		Map_Block_Change(-1, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
		for i = 0, 100, 1 do
			New_X = X + math.random(40) - 20
			New_Y = Y + math.random(40) - 20
			New_Z = Z + math.random(40) - 20
			if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
				Map_Block_Change(-1, Map_ID, New_X, New_Y, New_Z, 221, 0, 1, 1, 5)
			end
		end
		for i = 0, 200, 1 do
			New_X = X + math.random(40) - 20
			New_Y = Y + math.random(40) - 20
			New_Z = Z + math.random(40) - 20
			if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
				Map_Block_Change(-1, Map_ID, New_X, New_Y, New_Z, 223, 0, 1, 1, 5)
			end
		end
		for i = 0, 300, 1 do
			New_X = X + math.random(20) - 10
			New_Y = Y + math.random(20) - 10
			New_Z = Z + math.random(60) - 20
			if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
				Map_Block_Change(-1, Map_ID, New_X, New_Y, New_Z, 225, 0, 1, 1, 5)
			end
		end
	else
		if Map_Block_Get_Type(Map_ID, X, Y, Z+1) == 0 then
			Map_Block_Move(Map_ID, X, Y, Z, X, Y, Z+1, 5, 0, 1)
		else
			Map_Block_Change(-1, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
		end
	end
	
end
