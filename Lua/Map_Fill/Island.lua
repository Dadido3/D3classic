function Mapfill_island(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Argumentstring)
	
	if tonumber(Argumentstring) then
		math.randomseed(tonumber(Argumentstring))
	end
	
	if Map_Size_X <= 512 and Map_Size_Y <= 512 then
		Iterations = 8
	end
	if Map_Size_X <= 256 and Map_Size_Y <= 256 then
		Iterations = 7
	end
	if Map_Size_X <= 128 and Map_Size_Y <= 128 then
		Iterations = 6
	end
	if Map_Size_X <= 64 and Map_Size_Y <= 64 then
		Iterations = 5
	end
	if Map_Size_X <= 32 and Map_Size_Y <= 32 then
		Iterations = 4
	end
	if Map_Size_X <= 16 and Map_Size_Y <= 16 then
		Iterations = 3
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Iterations:"..tostring(Iterations))
	
	local Counter = {}
	for i = 0, 600 do
		Counter[i] = {}
	end
	
	local Size = 2
	
	local Height_Dunes = Map_Size_Z * 0.52
	local Height_Sand = Map_Size_Z * 0.52
	local Height_Water = Map_Size_Z * 0.5
	local Height_Dirt = Map_Size_Z * 0.3
	local Height_Mountain = Map_Size_Z * 0.7
	
	local ix
	local iy
	local iz
	
	local RND_Factor
	local RND_Factor_2
	
	System_Message_Network_Send_2_All(Map_ID, "&c test")
	
	for ix = 0, Size do
		for iy = 0, Size do
			Counter[ix][iy] = math.random(Height_Dunes)
			if Counter[ix][iy] < Height_Dunes then
				Counter[ix][iy] = (Counter[ix][iy] + Height_Dunes*10) / 11

					
			end

		end

	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c test1")
	
	for i = 1, Iterations do
		if i >= Iterations-3 then
			RND_Factor = 0
		else
			RND_Factor = 0.010*(Iterations-i)
		end
		
		for ix = Size, 0, -1 do
			for iy = Size, 0, -1 do
				Counter[ix*2][iy*2] = Counter[ix][iy]
			end
		end
		for ix = 0, Size-1 do
			for iy = 0, Size-1 do
				if Counter[ix*2][iy*2] <= Height_Water then
					RND_Factor_2 = RND_Factor * 0.5
				elseif Counter[ix*2][iy*2] <= Height_Sand then
					RND_Factor_2 = RND_Factor * 0.4
				elseif Counter[ix*2][iy*2] <= Height_Mountain then
					RND_Factor_2 = RND_Factor * 1.2
				else
					RND_Factor_2 = RND_Factor
				end
				Counter[ix*2][iy*2+1] = (Counter[ix*2][iy*2] + Counter[ix*2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				Counter[ix*2+2][iy*2+1] = (Counter[ix*2+2][iy*2] + Counter[ix*2+2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				
				Counter[ix*2+1][iy*2] = (Counter[ix*2][iy*2] + Counter[ix*2+2][iy*2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				Counter[ix*2+1][iy*2+2] = (Counter[ix*2][iy*2+2] + Counter[ix*2+2][iy*2+2]) / 2 + ((math.random(255)-128)*RND_Factor_2)
				
				Counter[ix*2+1][iy*2+1] = (Counter[ix*2][iy*2] + Counter[ix*2+2][iy*2] + Counter[ix*2][iy*2+2] + Counter[ix*2+2][iy*2+2]) / 4 + ((math.random(255)-128)*RND_Factor_2)
			end
		end
		Size = Size * 2
	end
	
	for ix = 0, Size do
		for iy = 0, Size do
			Height = math.ceil(Counter[ix][iy])
			X = ix
			Y = iy
			if Height > Height_Water then
				for iz = 0, Height do
					Z = iz
					if iz > Height - 5 then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 2, 0, 0, 0, 0)
					elseif iz > Height_Dirt then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 3, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, X, Y, Z, 1, 0, 0, 0, 0)
					end
				end
			else
				for iz = 0, Height_Water do
					Z = iz
					if iz > Height then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 8, 0, 0, 0, 0)
					elseif iz == Height_Water then
						if math.random(20) == 1 then
							Place_Palm(Map_ID, X, Y, Z)
						end
						Map_Block_Change(-1, Map_ID, X, Y, Z, 12, 0, 0, 0, 0)
					elseif iz > Height_Dirt then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 3, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, X, Y, Z, 1, 0, 0, 0, 0)
					end
				end
			end
		end
	end

	for ix = 0, Size do
		for iy = 0, size do
			Height = math.ceil(Counter[ix][iy])
			X = ix
			Y = iy
			if Height > Height_Dunes then 
				for iz = 3, Height do
					Z = iz
					if iz > Height - 6 then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 1, 0, 0, 0, 0)
					elseif iz > Height_Sand then
						Map_Block_Change(-1, Map_ID, X, Y, Z, 2, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, X, Y, Z, 1, 0, 0, 0, 0)
					
					end
				end
			end
		end
	end
						
	System_Message_Network_Send_2_All(Map_ID, "&c Map done.")
	
end
