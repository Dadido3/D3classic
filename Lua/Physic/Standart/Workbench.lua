function Physic_Standart_Workbench(Map_ID, X, Y, Z)
	Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	Table = {}
	
	for i = 0, 3 do
		
		if i == 0 then dx, dy = 1, 0
		elseif i == 1 then dx, dy = 0, 1
		elseif i == 2 then dx, dy = -1, 0
		elseif i == 3 then dx, dy = 0, -1
		end
		
		for ix = 0, 2 do
			for iz = 0, 2 do
				ax = ix-1
				Table[1 + ix + iz*3] = Map_Block_Get_Type(Map_ID, X+ax*dx, Y+ax*dy, Z+3-iz)
			end
		end
		
		Amount = 0
		
		--System_Message_Network_Send_2_All(Map_ID, tostring(unpack(Table)))
		
		-- Workbench
		if Table[1]==5 and Table[2]==5 and Table[3]==0 and Table[4]==5 and Table[5]==5 and Table[6]==0 and Table[7]==0 and Table[8]==0 and Table[9]==0 then
			Material = 58
			Amount = 1
		end
		-- Furnace
		if Table[1]==4 and Table[2]==4 and Table[3]==4 and Table[4]==4 and Table[5]==0 and Table[6]==4 and Table[7]==4 and Table[8]==4 and Table[9]==4 then
			Material = 61
			Amount = 1
		end
		-- Steps
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==4 and Table[8]==4 and Table[9]==4 then
			Material = 44
			Amount = 3
		end
		-- Bookcase
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==5 and Table[8]==23 and Table[9]==5 then
			Material = 47
			Amount = 1
		end
		-- Gravel
		if Table[1]==4 and Table[2]==4 and Table[3]==0 and Table[4]==3 and Table[5]==3 and Table[6]==0 and Table[7]==0 and Table[8]==0 and Table[9]==0 then
			Material = 13
			Amount = 3
		end
		-- Mossy Cobblestone
		if Table[1]==6 and Table[2]==6 and Table[3]==6 and Table[4]==6 and Table[5]==4 and Table[6]==6 and Table[7]==6 and Table[8]==6 and Table[9]==6 then
			Material = 48
			Amount = 1
		end
		-- Yellow Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==37 and Table[8]==37 and Table[9]==37 then
			Material = 23
			Amount = 1
		end
		-- Orange Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==38 and Table[8]==37 and Table[9]==38 then
			Material = 22
			Amount = 1
		end
		-- Red Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==38 and Table[8]==38 and Table[9]==38 then
			Material = 21
			Amount = 1
		end
		-- Light Green Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==6 and Table[8]==37 and Table[9]==6 then
			Material = 24
			Amount = 1
		end
		-- Green Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==6 and Table[8]==6 and Table[9]==6 then
			Material = 25
			Amount = 1
		end
		-- Dark Grey Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==16 and Table[8]==6 and Table[9]==16 then
			Material = 34
			Amount = 3
		end
		-- Light Grey Cloth
		if Table[1]==0 and Table[2]==0 and Table[3]==0 and Table[4]==0 and Table[5]==0 and Table[6]==0 and Table[7]==6 and Table[8]==16 and Table[9]==6 then
			Material = 35
			Amount = 2
		end
		-- Sponge
		if Table[1]==23 and Table[2]==0 and Table[3]==23 and Table[4]==0 and Table[5]==23 and Table[6]==0 and Table[7]==23 and Table[8]==0 and Table[9]==23 then
			Material = 19
			Amount = 1
		end
		
		if Amount ~= 0 then
			for ix = 0, 2 do
				for iz = 0, 2 do
					ax = ix-1
					Map_Block_Change(-1, Map_ID, X+ax*dx, Y+ax*dy, Z+3-iz, 0, 1, 1, 1, 5)
				end
			end
			for i = 1, Amount do
				ax = -2+i
				Map_Block_Change(-1, Map_ID, X+ax*dx, Y+ax*dy, Z+1, Material, 1, 1, 1, 5)
			end
		end
	end
end