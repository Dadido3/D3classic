function Mapfill_normal(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Argumentstring)
	
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
	
	local Counter = {}
	for i = 0, 600 do
		Counter[i] = {}
	end
	
	Size = 2
	
	-- Höhen: (Maximale Höhe des Materials)
	Height_Stone = Map_Size_Z * 0.3
	Height_Water = Map_Size_Z * 0.5
	Height_Grass = Map_Size_Z * 0.65
	Height_Mountain = Map_Size_Z * 0.8
	
	for ix = 0, Size do
		for iy = 0, Size do
			Counter[ix][iy] = math.random(Map_Size_Z*0.9)
			if Counter[ix][iy] < Height_Water then
				Counter[ix][iy] = (Counter[ix][iy] + Height_Water*15) / 16
			end
			if Counter[ix][iy] > Height_Water and Counter[ix][iy] < Height_Grass then
				Counter[ix][iy] = (Counter[ix][iy] + Height_Water*80) / 81
			end
		end
	end
	
	--Counter[0][0] = Map_Size_Z*0.9
	--Counter[1][0] = Map_Size_Z*0.9
	--Counter[2][0] = Map_Size_Z*0.9
	--Counter[0][1] = Map_Size_Z*0.5
	--Counter[1][1] = Map_Size_Z*0.5
	--Counter[2][1] = Map_Size_Z*0.5
	--Counter[0][2] = Map_Size_Z*0.3
	--Counter[1][2] = Map_Size_Z*0.3
	--Counter[2][2] = Map_Size_Z*0.3
	
	for i = 1, Iterations do
		if i >= Iterations-1 then
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
				elseif Counter[ix*2][iy*2] <= Height_Grass then
					RND_Factor_2 = RND_Factor * 0.3
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
			
			if Height > Height_Grass then -- Snow and more
				for iz = 0, Height-1 do
					if iz > Height_Mountain-1 then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 36, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 1, 0, 0, 0, 0)
					end
				end
			elseif Height > Height_Water then -- Grass
				for iz = 0, Height-1 do
					if iz == Height-1 then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 2, 0, 0, 0, 0)
					elseif iz > Height_Stone then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 3, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 1, 0, 0, 0, 0)
					end
				end
			elseif Height <= Height_Water then -- Water and under
				for iz = 0, Height_Water-1 do
					if iz > Height-1 then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 8, 0, 0, 0, 0)
					elseif iz == Height_Water-1 then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 12, 0, 0, 0, 0)
					elseif iz > Height_Stone then
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 3, 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID, ix, iy, iz, 1, 0, 0, 0, 0)
					end
				end
			end
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Map done.")
	
end
