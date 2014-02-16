local function X_Ray(Player_Number, Map_ID, X, Y, Z, Rot, Look, Send_Priority, TTL, Radius, Ignore_Material)
	local M_X, M_Y, M_Z = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	for i = 1, Radius do
		local Block_Type = Map_Block_Get_Type(Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i)
		if Block_Type == 7 then
			break
		elseif Block_Type ~= 0 and Block_Type ~= Ignore_Material and Block_Type ~= 51 then
			if math.random(5) == 1 then
				Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, 232, 1, 1, 1, Send_Priority) -- Ash
			else
				Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, 0, 1, 0, 1, Send_Priority) -- Air
			end
			TTL = TTL - 1
			if TTL == 0 then
				break
			end
		end
		if math.random(i*50) == 1 and Block_Type == 0 then 
			Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, 51, 1, 1, 1, Send_Priority+1) -- Fire
		end
	end
end

function Explosion(Player_Number, Map_ID, X, Y, Z, Size, Ignore_Material, Send_Priority)
	local Step = 30/Size
	
	if Step < 1 then Step = 1 end
	if Size > 15 then Size = 15 end
	-- Destruction
	for il = 90, -90, -Step do
		local Step = Step/(0.001+math.cos(math.rad(il)))
		for ir = 0, 360, Step do
			X_Ray(Player_Number, Map_ID, X, Y, Z, ir, il+math.random()*0.5, Send_Priority, math.ceil(0.2*Size), Size*2, Ignore_Material)
		end
	end
	
	-- Killing
	if Player_Number ~= -1 then
		local Player_Name = Player_Get_Name(Player_Number)
		
		local Entity_Table, Entities = Entity_Get_Table()
		for i = 1, Entities do
			local Entity_ID = Entity_Table[i]
			local Entity_Player_Number = Entity_Get_Player(Entity_ID)
			local Entity_Map_ID = Entity_Get_Map_ID(Entity_ID)
			if Map_ID == Entity_Map_ID then
				local Entity_X = Entity_Get_X(Entity_ID)
				local Entity_Y = Entity_Get_Y(Entity_ID)
				local Entity_Z = Entity_Get_Z(Entity_ID)
				local Entity_Prefix, Entity_Name, Entity_Suffix = Entity_Displayname_Get(Entity_ID)
				local Dist_X, Dist_Y, Dist_Z = (Entity_X-X), (Entity_Y-Y), (Entity_Z-Z)
				local Dist = math.sqrt(Dist_X^2 + Dist_Y^2 + Dist_Z^2)
				if Dist <= Size then
					System_Message_Network_Send_2_All(Map_ID, "&c"..Entity_Name.." killed by "..Player_Name)
					Entity_Kill(Entity_ID)
				end
			end
		end
	end
end

local function Recursive_Search(Map_ID, X, Y, Z, Material, Deepness)
	local Found = 1
	if Deepness > 0 then
		for New_X = -1, 1 do
			for New_Y = -1, 1 do
				for New_Z = -1, 1 do
					local Type = Map_Block_Get_Type(Map_ID, X + New_X, Y + New_Y, Z + New_Z)
					if Type == Material then
						Map_Block_Change(Player_Number, Map_ID, X + New_X, Y + New_Y, Z + New_Z, 0, 0, 0, 1, 5)
						Found = Found + Recursive_Search(Map_ID, X + New_X, Y + New_Y, Z + New_Z, Material, Deepness-1)
					end
				end
			end
		end
	end
	
	return Found
end

function Physic_Special_TNT(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	local Radius = 0
	
	if math.random(30) == 1 then
		--Radius = 10 + math.random(8)
		Radius = 4 + math.random(2)
	else
		Radius = 3 + math.random(2)
	end
	
	if Map_Block_Get_Type(Map_ID, X, Y, Z-1) == 0 then
		Map_Block_Move(Map_ID, X, Y, Z, X, Y, Z-1, 1, 1, 5)
	else
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
		
		local Amount = Recursive_Search(Map_ID, X, Y, Z, Block_Type, 7)
		if Amount > 25 then Amount = 25 end
		Radius = Radius * (1+(Amount-1)*0.2)
		
		Explosion(Player_Number, Map_ID, X, Y, Z, Radius, Block_Type, 10)
		
		--for New_X = -Radius, Radius do
		--	for New_Y = -Radius, Radius do
		--		for New_Z = -Radius, Radius do
		--			Entf = New_X*New_X + New_Y*New_Y + New_Z*New_Z
		--			if Entf < Radius*Radius then
		--				New_Type = Map_Block_Get_Type(Map_ID, X + New_X, Y + New_Y, Z + New_Z)
		--				if New_Type ~= Block_Type then
		--					Map_Block_Change(Player_Number, Map_ID, X + New_X, Y + New_Y, Z + New_Z, Material, 1, 0, 1, 5)
		--				end
		--			end
		--		end
		--	end
		--end
		for i = 0, 40, 1 do
			New_X = X + math.random(Radius) - Radius/2
			New_Y = Y + math.random(Radius) - Radius/2
			New_Z = Z + math.random(Radius) - Radius/2
			if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
				--Map_Block_Change(Player_Number, Map_ID, New_X, New_Y, New_Z, 51, 1, 1, 1, 6)
			end
		end
	end
	
end

System_Message_Network_Send_2_All(-1, "&cAdmin TNT reloaded")