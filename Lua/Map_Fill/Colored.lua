local function Get_Mat(X, Y, Z)
	local Factor = 1
	
	for i = 1, Points do
		local Dist = math.sqrt((Point[i].X-X)^2 + (Point[i].Y-Y)^2 + (Point[i].Z-Z)^2)
		Factor = Factor * (math.sin(Dist*Point[i].Freq))
	end
	
	Factor = (1+Factor)/2
	return 21 + math.floor(12*Factor) -- 21 to 33
end

function Mapfill_colored(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Arguments)
	
	Points = 2
	Point = {}
	for i = 1, Points do
		Point[i] = {}
		Point[i].X = math.random()*100
		Point[i].Y = math.random()*100
		Point[i].Z = math.random()*100
		Point[i].Freq = 0.1+math.random()*0.2
	end
	
	if Map_Size_X*Map_Size_Y*Map_Size_Z >= 128^3 and Arguments ~= "sure" then
		System_Message_Network_Send_2_All(Map_ID, "&cThis Mapfill lags like hell on big maps. If you are sure type /mapfill colored sure")
		return
	end
	
	local ix, iy, iz
	for ix = 0, Map_Size_X-1 do
		for iy = 0, Map_Size_Y-1 do
			for iz = 0, Map_Size_Z/2-1 do
				local Material = Get_Mat(ix, iy, iz)
				if Material < 30 then
					Map_Block_Change(-1, Map_ID, ix, iy, iz, Material, 0, 0, 0, 0)
				end
			end
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Map done.")
	
end
