--                              /\                  ##### ##### ####  ####   ###      ####  #    # ##### #####
--                            _/_ \                   #   #     #   # #   # #   #     #   #  #  #    #   #    
--                          _/     \_  /\		      #   ####  ####  ####  ##### --- ####    ##     #   #### 
--                       __/__/\     \/  \_           #   #     #  #  #  #  #   #     #   #   #      #   #    
--                   ___/       \     \__  \          #   ##### #   # #   # #   #     ####   #       #   #####
--            ______/____________\_______\__\_______                                                          
--^^^^^^^^^^^/_________________                                                                     by Dadido3
--__________/______                                                                                           

-- Documentation:
-- 	- Arguments:
--		prev=	Preview		1:Normal  >1:Preview-mode
-- 		s=		Seed
--		
--		sz=		Scale-Z		Default: 1
--		
-- 		ci=		Climate-Map Iterations
--		
-- 		mi=		Mountain-Map Iterations
-- 		mr=		Mountain-Map Roughness
--		
-- 		ni=		Normal-Map Iterations
-- 		nr=		Normal-Map Roughness


function Terrabyte_Parse(String, Name, Default)
	--System_Message_Network_Send_2_All(-1, "&c> Debug")
	String_2_Find = Name.."="
	
	--System_Message_Network_Send_2_All(-1, "&c> "..String_2_Find)
	
	Start, End = string.find(String, String_2_Find)
	
	--System_Message_Network_Send_2_All(-1, "&c> "..tostring(Start).." -> "..tostring(End))
	
	if Start and End then
		Space_Start, Space_End = string.find(String, " ", End+1)
		if Space_Start == nil then
			Space_Start = string.len(String)
		end
		--System_Message_Network_Send_2_All(-1, "&c>Parsed: "..string.sub(String, End+1, Space_Start))
		return string.sub(String, End+1, Space_Start)
	else
		--System_Message_Network_Send_2_All(-1, "&c>Default: "..Default)
		return Default
	end
end

function Mapfill_terrabyte(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Argumentstring)
	
	-- ##################################### Randomseed
	
	if Terrabyte_Parse(Argumentstring, "s", "off") ~= "off" then
		math.randomseed(tonumber(Terrabyte_Parse(Argumentstring, "s", "0")))
	end
	
	-- ##################################### Declare Counter variables / Zählervariablen deklarieren
	
	local i
	local ix
	local iy
	local iz
	
	-- ##################################### Materials / Materialien
	
	local Mat_Stone = 1
	local Mat_Grass = 2
	local Mat_Dirt = 3
	local Mat_Water = 8
	local Mat_Sand = 12
	local Mat_Gravel = 13
	
	-- ##################################### Set the map-variables / Kartenvariablen setzen
	
	local Map_Climate_Roughness_Constant = 0.0000 -- 1.0: very Rought 0.0: Smooth
	
	local Map_Ocean_Z_Offset = Map_Size_Z / 2 - 1
	
	local Map_Normal_Roughness_Constant = tonumber(Terrabyte_Parse(Argumentstring, "nr", "0.01")) -- 1.0: very Rought 0.0: Smooth
	local Map_Normal_Z_Offset = Map_Size_Z * 0.6 -- Grass & Dirt / Gras und Erde
	
	local Map_Mountain_Roughness_Constant = tonumber(Terrabyte_Parse(Argumentstring, "mr", "0.05")) -- 1.0: very Rought 0.0: Smooth
	local Map_Mountain_Z_Offset =  Map_Size_Z / 2
	
	-- Scale Z:
	local Map_Size_Z = Map_Size_Z*tonumber(Terrabyte_Parse(Argumentstring, "sz", "1"))
	
	-- ##################################### Other variable / Andere Variablen
	
	local Fill_Step = tonumber(Terrabyte_Parse(Argumentstring, "prev", "1"))
	local Time_Start = os.clock()
	
-- #########################################################################################################
-- #                                                                                                       #
-- #                                        Climatemap / Klimakarte                                        #
-- #                                                                                                       #
-- #         0=Ocean   1=Normal   2=Mountain   3=Desert                                                    #
-- #                                                                                                       #
-- #########################################################################################################
	
	-- ##################################### Prepare the cliemate-map / Klimakarte vorbereiten
	local Climate_Iterations = tonumber(Terrabyte_Parse(Argumentstring, "ci", "8"))
	if Climate_Iterations > 10 then Climate_Iterations = 10 end
	local Climate_Chunk_Size = math.pow(2, Climate_Iterations)
	
	local Climate_Layer_Size_X = math.ceil(Map_Size_X/Climate_Chunk_Size)*Climate_Chunk_Size
	local Climate_Layer_Size_Y = math.ceil(Map_Size_Y/Climate_Chunk_Size)*Climate_Chunk_Size
	local Climate_Iteration_Size_X = math.ceil(Map_Size_X/Climate_Chunk_Size)
	local Climate_Iteration_Size_Y = math.ceil(Map_Size_Y/Climate_Chunk_Size)
	
	local Climate_Map = {}
	for i = 0, Climate_Layer_Size_X do
		Climate_Map[i] = {}
	end
	
	-- ##################################### Create startarray / Startarray erstellen
	for ix = 0, Climate_Iteration_Size_X do
		for iy = 0, Climate_Iteration_Size_Y do
			Climate_Map[ix][iy] = math.random()*3
		end
	end
	
	-- ##################################### Calculate the climatemap / Klimakarte berechnen
	for i = Climate_Iterations-1, 0, -1 do
		-- ##################################### Upsize the array / Array vergrößern
		for ix = Climate_Iteration_Size_X, 0, -1 do
			for iy = Climate_Iteration_Size_Y, 0, -1 do
				Climate_Map[ix*2][iy*2] = Climate_Map[ix][iy] 
			end
		end
		Climate_Iteration_Size_X = Climate_Iteration_Size_X * 2
		Climate_Iteration_Size_Y = Climate_Iteration_Size_Y * 2
		-- ##################################### The diamond step
		for ix = 1, Climate_Iteration_Size_X-1, 2 do
			for iy = 1, Climate_Iteration_Size_Y-1, 2 do
				Climate_Map[ix][iy] = (Climate_Map[ix+1][iy+1] + Climate_Map[ix-1][iy+1] + Climate_Map[ix+1][iy-1] + Climate_Map[ix-1][iy-1]) / 4
				--Climate_Map[ix][iy] = Climate_Map[ix][iy] + (math.random()*2-1)*(i/(Climate_Iterations-1))*Map_Size_Z*Map_Climate_Roughness_Constant
			end
		end
		-- ##################################### The square step
		for ix = 0, Climate_Iteration_Size_X, 2 do
			for iy = 1, Climate_Iteration_Size_Y-1, 2 do
				Climate_Map[ix][iy] = (Climate_Map[ix][iy+1] + Climate_Map[ix][iy-1]) / 2
				Climate_Map[ix][iy] = Climate_Map[ix][iy] + (math.random()*2-1)*(i/(Climate_Iterations-1))*Map_Size_Z*Map_Climate_Roughness_Constant
			end
		end
		for ix = 1, Climate_Iteration_Size_X-1, 2 do
			for iy = 0, Climate_Iteration_Size_Y, 2 do
				Climate_Map[ix][iy] = (Climate_Map[ix+1][iy] + Climate_Map[ix-1][iy]) / 2
				Climate_Map[ix][iy] = Climate_Map[ix][iy] + (math.random()*2-1)*(i/(Climate_Iterations-1))*Map_Size_Z*Map_Climate_Roughness_Constant
			end
		end
		-- ##################################### Round values if its the 7th-last iteration
		if i == 6 then
			for ix = 0, Climate_Iteration_Size_X do
				for iy = 0, Climate_Iteration_Size_Y do
					Climate_Map[ix][iy] = math.floor(Climate_Map[ix][iy] + 0.5)
				end
			end
		end
	end
	
	-- ##################################### round Climate-Map / Klimakarte runden
	--for ix = 0, Climate_Iteration_Size_X-1 do
	--	for iy = 0, Climate_Iteration_Size_Y-1 do
	--		Climate_Map[ix][iy] = math.floor(Climate_Map[ix][iy] + 0.5)
	--	end
	--end
	
-- #########################################################################################################
-- #                                                                                                       #
-- #                                   Mountain generator / Bergenerator                                   #
-- #                                                                                                       #
-- #########################################################################################################
	
	-- ##################################### Prepare the mountain-generator / Bergenerator vorbereiten
	local Mountain_Iterations = tonumber(Terrabyte_Parse(Argumentstring, "mi", "7"))
	local Mountain_Chunk_Size = math.pow(2, Mountain_Iterations)
	
	local Mountain_Layer_Size_X = math.ceil(Map_Size_X/Mountain_Chunk_Size)*Mountain_Chunk_Size
	local Mountain_Layer_Size_Y = math.ceil(Map_Size_Y/Mountain_Chunk_Size)*Mountain_Chunk_Size
	local Mountain_Iteration_Size_X = math.ceil(Map_Size_X/Mountain_Chunk_Size)
	local Mountain_Iteration_Size_Y = math.ceil(Map_Size_Y/Mountain_Chunk_Size)
	
	local Mountain_Heightmap = {}
	for i = 0, Mountain_Layer_Size_X do
		Mountain_Heightmap[i] = {}
	end
	
	-- ##################################### Create startarray / Startarray erstellen
	for ix = 0, Mountain_Iteration_Size_X do
		for iy = 0, Mountain_Iteration_Size_Y do
			Mountain_Heightmap[ix][iy] = math.random(Map_Size_Z)-Map_Size_Z/2
		end
	end
	
	-- ##################################### calculate the heightmap / Höhenkarte berechnen (Map_Mountain)
	for i = Mountain_Iterations-1, 0, -1 do
		-- ##################################### Upsize the array / Array vergrößern
		for ix = Mountain_Iteration_Size_X, 0, -1 do
			for iy = Mountain_Iteration_Size_Y, 0, -1 do
				Mountain_Heightmap[ix*2][iy*2] = Mountain_Heightmap[ix][iy] 
			end
		end
		Mountain_Iteration_Size_X = Mountain_Iteration_Size_X * 2
		Mountain_Iteration_Size_Y = Mountain_Iteration_Size_Y * 2
		-- ##################################### The diamond step
		for ix = 1, Mountain_Iteration_Size_X-1, 2 do
			for iy = 1, Mountain_Iteration_Size_Y-1, 2 do
				Mountain_Heightmap[ix][iy] = (Mountain_Heightmap[ix+1][iy+1] + Mountain_Heightmap[ix-1][iy+1] + Mountain_Heightmap[ix+1][iy-1] + Mountain_Heightmap[ix-1][iy-1]) / 4
				Mountain_Heightmap[ix][iy] = Mountain_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Mountain_Iterations-1))*Map_Size_Z*Map_Mountain_Roughness_Constant
			end
		end
		
		-- ##################################### The square step
		for ix = 0, Mountain_Iteration_Size_X, 2 do
			for iy = 1, Mountain_Iteration_Size_Y-1, 2 do
				Mountain_Heightmap[ix][iy] = (Mountain_Heightmap[ix][iy+1] + Mountain_Heightmap[ix][iy-1]) / 2
				Mountain_Heightmap[ix][iy] = Mountain_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Mountain_Iterations-1))*Map_Size_Z*Map_Mountain_Roughness_Constant
			end
		end
		for ix = 1, Mountain_Iteration_Size_X-1, 2 do
			for iy = 0, Mountain_Iteration_Size_Y, 2 do
				Mountain_Heightmap[ix][iy] = (Mountain_Heightmap[ix+1][iy] + Mountain_Heightmap[ix-1][iy]) / 2
				Mountain_Heightmap[ix][iy] = Mountain_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Mountain_Iterations-1))*Map_Size_Z*Map_Mountain_Roughness_Constant
			end
		end
	end
	
	-- ##################################### manipulate the heightmap / Höhenkarte manipulieren (Map_Mountain)
	for ix = 0, Mountain_Iteration_Size_X do
		for iy = 0, Mountain_Iteration_Size_Y do
			local Climate_Factor = math.abs(2-Climate_Map[ix][iy]) -- Climate_Factor: Entfernung zur Klimazone 2 (Berge)
			Mountain_Heightmap[ix][iy] = Mountain_Heightmap[ix][iy]*math.pow(5, -Climate_Factor) - Climate_Factor*Map_Size_Z*0.2
		end
	end
	
-- #########################################################################################################
-- #                                                                                                       #
-- #                     Normal-landscape-generator / Normallandschafts-generator                          #
-- #                                                                                                       #
-- #########################################################################################################
	
	-- ##################################### Prepare the mountain-generator / Bergenerator vorbereiten
	local Normal_Iterations = tonumber(Terrabyte_Parse(Argumentstring, "ni", "6"))
	local Normal_Chunk_Size = math.pow(2, Normal_Iterations)
	
	local Normal_Layer_Size_X = math.ceil(Map_Size_X/Normal_Chunk_Size)*Normal_Chunk_Size
	local Normal_Layer_Size_Y = math.ceil(Map_Size_Y/Normal_Chunk_Size)*Normal_Chunk_Size
	local Normal_Iteration_Size_X = math.ceil(Map_Size_X/Normal_Chunk_Size)
	local Normal_Iteration_Size_Y = math.ceil(Map_Size_Y/Normal_Chunk_Size)
	
	local Normal_Heightmap = {}
	for i = 0, Normal_Layer_Size_X do
		Normal_Heightmap[i] = {}
	end
	
	-- ##################################### Create startarray / Startarray erstellen
	for ix = 0, Normal_Iteration_Size_X do
		for iy = 0, Normal_Iteration_Size_Y do
			Normal_Heightmap[ix][iy] = math.random()*Map_Size_Z*0.05
		end
	end
	
	-- ##################################### calculate the heightmap / Höhenkarte berechnen (Map_Mountain)
	for i = Normal_Iterations-1, 0, -1 do
		-- ##################################### Upsize the array / Array vergrößern
		for ix = Normal_Iteration_Size_X, 0, -1 do
			for iy = Normal_Iteration_Size_Y, 0, -1 do
				Normal_Heightmap[ix*2][iy*2] = Normal_Heightmap[ix][iy] 
			end
		end
		Normal_Iteration_Size_X = Normal_Iteration_Size_X * 2
		Normal_Iteration_Size_Y = Normal_Iteration_Size_Y * 2
		-- ##################################### The diamond step
		for ix = 1, Normal_Iteration_Size_X-1, 2 do
			for iy = 1, Normal_Iteration_Size_Y-1, 2 do
				Normal_Heightmap[ix][iy] = (Normal_Heightmap[ix+1][iy+1] + Normal_Heightmap[ix-1][iy+1] + Normal_Heightmap[ix+1][iy-1] + Normal_Heightmap[ix-1][iy-1]) / 4
				--Normal_Heightmap[ix][iy] = Normal_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Normal_Iterations-1))*Map_Size_Z*Map_Normal_Roughness_Constant
			end
		end
		
		-- ##################################### The square step
		for ix = 0, Normal_Iteration_Size_X, 2 do
			for iy = 1, Normal_Iteration_Size_Y-1, 2 do
				Normal_Heightmap[ix][iy] = (Normal_Heightmap[ix][iy+1] + Normal_Heightmap[ix][iy-1]) / 2
				Normal_Heightmap[ix][iy] = Normal_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Normal_Iterations-1))*Map_Size_Z*Map_Normal_Roughness_Constant
			end
		end
		for ix = 1, Normal_Iteration_Size_X-1, 2 do
			for iy = 0, Normal_Iteration_Size_Y, 2 do
				Normal_Heightmap[ix][iy] = (Normal_Heightmap[ix+1][iy] + Normal_Heightmap[ix-1][iy]) / 2
				Normal_Heightmap[ix][iy] = Normal_Heightmap[ix][iy] + (math.random()*2-1)*(i/(Normal_Iterations-1))*Map_Size_Z*Map_Normal_Roughness_Constant
			end
		end
	end
	
	-- ##################################### manipulate the heightmap / Höhenkarte manipulieren (Map_Normal)
	for ix = 0, Normal_Iteration_Size_X do
		for iy = 0, Normal_Iteration_Size_Y do
			local Climate_Factor = math.abs(2-Climate_Map[ix][iy]) -- Climate_Factor: Entfernung zur Klimazone 2 (Mountain)
			Normal_Heightmap[ix][iy] = Normal_Heightmap[ix][iy] - Climate_Factor*Map_Size_Z*0.1
		end
	end
	-- ##################################### manipulate the heightmap / Höhenkarte manipulieren (Map_Normal)
	for ix = 0, Normal_Iteration_Size_X do
		for iy = 0, Normal_Iteration_Size_Y do
			Normal_Heightmap[ix][iy] = Normal_Heightmap[ix][iy] + Mountain_Heightmap[ix][iy]*0.2
		end
	end
	
-- #########################################################################################################
-- #                                                                                                       #
-- #                    fill the map with the landscape / Karte mit Landschaft füllen                      #
-- #                                                                                                       #
-- #########################################################################################################
	-- ######################################### create mountains / Berge erstellen
	for ix = 0, Mountain_Iteration_Size_X, Fill_Step do
		for iy = 0, Mountain_Iteration_Size_Y, Fill_Step do
			local Z = Map_Mountain_Z_Offset + Mountain_Heightmap[ix][iy]
			for iz = 0, Z do
				Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Stone, 0, 0, 0, 0)
			end
		end
	end
	
	-- ######################################### create dirt, grass and coastline / Erde, Grass und Küste erstellen
	for ix = 0, Normal_Iteration_Size_X, Fill_Step do
		for iy = 0, Normal_Iteration_Size_Y, Fill_Step do
			if Map_Normal_Z_Offset+Normal_Heightmap[ix][iy] > Map_Mountain_Z_Offset+Mountain_Heightmap[ix][iy] then
				local Z = Map_Normal_Z_Offset + math.floor(Normal_Heightmap[ix][iy] + 0.5)
				local SinCos_Value = math.sin(ix/15)*math.cos(iy/10)*0.125+0.125 -- SinCos for dirt around desert
				for iz = Z, 0, -1 do
					if Map_Block_Get_Type(Map_ID, ix, iy, iz) == 0 then
						if iz == Z then -- If it's on top
							if Climate_Map[ix][iy] <= 2+SinCos_Value then -- If it's not near the desert
								if iz <= Map_Ocean_Z_Offset-2 then -- Undea ocean
									Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Gravel, 0, 0, 0, 0)
								elseif iz <= Map_Ocean_Z_Offset+1 then -- At ocean
									Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Sand, 0, 0, 0, 0)
								else -- Above ocean
									Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Grass, 0, 0, 0, 0)
								end
							else -- It's near the desert
								Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Dirt, 0, 0, 0, 0)
							end
						else -- It's under ground
							Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Dirt, 0, 0, 0, 0)
						end
					else
						break
					end
				end
			end
		end
	end
	-- ######################################### create sand (Desert) / Sand (Wüste) erstellen
	for ix = 0, Normal_Iteration_Size_X, Fill_Step do
		for iy = 0, Normal_Iteration_Size_Y, Fill_Step do
			local Climate_Factor = math.abs(3-Climate_Map[ix][iy]) -- Climate_Factor: Entfernung zur Klimazone 3 (Desert)
			local Z = Map_Normal_Z_Offset - Climate_Factor*Map_Size_Z*0.1 + math.sin(ix/35)*Map_Size_Z*0.025 + math.cos(iy/30)*Map_Size_Z*0.025
			for iz = Z, 0, -1 do
				if Map_Block_Get_Type(Map_ID, ix, iy, iz) == 0 then
					Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Sand, 0, 0, 0, 0)
				else
					break
				end
			end
		end
	end
	-- ######################################### create ocean / Ozean erstellen
	for ix = 0, Normal_Iteration_Size_X, Fill_Step do
		for iy = 0, Normal_Iteration_Size_Y, Fill_Step do
			for iz = Map_Ocean_Z_Offset, 0, -1 do
				if Map_Block_Get_Type(Map_ID, ix, iy, iz) == 0 then
					Map_Block_Change(-1, Map_ID, ix, iy, iz, Mat_Water, 0, 0, 0, 0)
				else
					break
				end
			end
		end
	end
	
-- #########################################################################################################
-- #                                                                                                       #
-- #                                            End / Ende                                                 #
-- #                                                                                                       #
-- #########################################################################################################
	
	System_Message_Network_Send_2_All(Map_ID, "&c Values: ci="..tostring(Climate_Iterations).." mi="..tostring(Mountain_Iterations).." mr="..tostring(Map_Mountain_Roughness_Constant).." ni="..tostring(Normal_Iterations).." nr="..tostring(Map_Normal_Roughness_Constant))
	System_Message_Network_Send_2_All(Map_ID, "&c Map created in "..string.sub(tostring(os.clock()-Time_Start), 1, 4).."s. (Terrabyte by Dadido3)")
	
end
