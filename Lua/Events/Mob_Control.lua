
local Mobcontrol_Gravity =    -6.0 -- m/s²
local Mobcontrol_Timer =       0.1 -- s
local Mobcontrol_Max_Speed =  10.00 -- m/s
local Mobcontrol_Jump_Speed = 7.00 -- m/s

local Mobcontrol_Entity
if Mobcontrol_Entity == nil then
	Mobcontrol_Entity = {}
end

Event_Add("Mobcontrol_Event_Entity_Delete", "Mobcontrol_Event_Entity_Delete", "Entity_Delete", 0, 0, -1)
function Mobcontrol_Event_Entity_Delete(Result, Entity_ID)
	Mobcontrol_Entity[Entity_ID] = nil
end

local Mobcontrol_Realtime_Timer = os.clock()
Event_Add("Mobcontrol_Event_Timer", "Mobcontrol_Event_Timer", "Timer", 0, Mobcontrol_Timer*1000, -1)
function Mobcontrol_Event_Timer(Map_ID)
	if os.clock() - Mobcontrol_Realtime_Timer > 1 then
		Mobcontrol_Realtime_Timer = os.clock()
	end
	
	local Max_Counter = 2
	while os.clock() - Mobcontrol_Realtime_Timer > 0 and Max_Counter > 0 do
		Max_Counter = Max_Counter - 1
		Mobcontrol_Realtime_Timer = Mobcontrol_Realtime_Timer + Mobcontrol_Timer
		
		local Entity_Table, Entities = Entity_Get_Table()
		for i = 1, Entities do
			local Entity_ID = Entity_Table[i]
			local Player_Number = Entity_Get_Player(Entity_ID)
			
			--local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
			
			if Player_Number == -1 then
				
				--Entity_Delete(Entity_ID)
				
				if Mobcontrol_Entity[Entity_ID] == nil then
					Mobcontrol_Entity[Entity_ID] = {}
					Mobcontrol_Entity[Entity_ID].DX = 0
					Mobcontrol_Entity[Entity_ID].DY = 0
					Mobcontrol_Entity[Entity_ID].DZ = 0
					Mobcontrol_Entity[Entity_ID].Walk_Rotation = 0 -- °
					Mobcontrol_Entity[Entity_ID].Walk_Speed = 0    -- m/s
				end
				
				Mobcontrol_Do_Walk_2_Player(Entity_ID)
				Mobcontrol_Do_Physics(Entity_ID)
				Mobcontrol_Do_Move(Entity_ID)
				Mobcontrol_Kill(Entity_ID)
				
			end
		end
		
	end
end

function Mobcontrol_Kill(Entity_ID)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local X = Entity_Get_X(Entity_ID)
	local Y = Entity_Get_Y(Entity_ID)
	local Z = Entity_Get_Z(Entity_ID)
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	
	local Found = 0
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Other_Entity_ID = Entity_Table[i]
		local Other_Player_Number = Entity_Get_Player(Other_Entity_ID)
		local Other_Prefix, Other_Name, Other_Suffix = Entity_Displayname_Get(Other_Entity_ID)
		--if Other_Entity_ID ~= Entity_ID and Other_Player_Number ~= -1 then
		if Other_Entity_ID ~= Entity_ID and Other_Name ~= Name then
			local Other_Map_ID = Entity_Get_Map_ID(Other_Entity_ID)
			if Other_Map_ID == Map_ID then
				local Other_X = Entity_Get_X(Other_Entity_ID)
				local Other_Y = Entity_Get_Y(Other_Entity_ID)
				local Other_Z = Entity_Get_Z(Other_Entity_ID)
				local Dist_X, Dist_Y, Dist_Z = (Other_X-X), (Other_Y-Y), (Other_Z-Z)
				if math.abs(Dist_X) < 1.20 and math.abs(Dist_Y) < 1.2 and math.abs(Dist_Z) < 1.6 then
					local Dist = math.sqrt(Dist_X^2 + Dist_Y^2)
					if Dist < 1.2 then
						
						--local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
						--local Spawn_X, Spawn_Y, Spawn_Z = 0.5+math.random()*(Map_Size_X-1.5), 0.5+math.random()*(Map_Size_Y-1.5), Map_Size_Z-2
						--Entity_Position_Set(Other_Entity_ID, Map_ID, Spawn_X, Spawn_Y, Spawn_Z, math.random()*360, 0, 2, 1)
						
						System_Message_Network_Send_2_All(Map_ID, "&c"..Other_Name.." killed by "..Name)
						Entity_Kill(Other_Entity_ID)
						
						Found = 1
						break
					end
				end
			end
		end
	end
	
	if Found == 1 then
		--local Map_Size_X, Map_Size_Y, Map_Size_Z = Map_Get_Dimensions(Map_ID)
		--local Spawn_X, Spawn_Y, Spawn_Z = 0.5+math.random()*(Map_Size_X-1.5), 0.5+math.random()*(Map_Size_Y-1.5), Map_Size_Z-2
		--Entity_Position_Set(Entity_ID, Map_ID, Spawn_X, Spawn_Y, Spawn_Z, math.random()*360, 0, 2, 0)
		
		--Explosion(-1, Map_ID, X, Y, Z, 3, -1, 20)
	end
end

function Mobcontrol_Do_Walk_2_Player(Entity_ID)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local X = Entity_Get_X(Entity_ID)
	local Y = Entity_Get_Y(Entity_ID)
	local Z = Entity_Get_Z(Entity_ID)
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	
	local Found_Entity_ID = -1
	local Max_Dist = 30
	
	-- Find nearest player
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Other_Entity_ID = Entity_Table[i]
		local Other_Player_Number = Entity_Get_Player(Other_Entity_ID)
		local Other_Prefix, Other_Name, Other_Suffix = Entity_Displayname_Get(Other_Entity_ID)
		--if Other_Player_Number ~= -1 then
		if Other_Name ~= Name then
			local Other_Map_ID = Entity_Get_Map_ID(Other_Entity_ID)
			if Other_Map_ID == Map_ID then
				local Other_X = Entity_Get_X(Other_Entity_ID)
				local Other_Y = Entity_Get_Y(Other_Entity_ID)
				local Other_Z = Entity_Get_Z(Other_Entity_ID)
				local Dist_X, Dist_Y, Dist_Z = (Other_X-X), (Other_Y-Y), (Other_Z-Z)
				if math.abs(Dist_X) < Max_Dist and math.abs(Dist_Y) < Max_Dist and math.abs(Dist_Z) < Max_Dist then
					local Dist = math.sqrt(Dist_X^2 + Dist_Y^2 + Dist_Z^2)
					if Max_Dist > Dist then
						Max_Dist = Dist
						Found_Entity_ID = Other_Entity_ID
					end
				end
			end
		end
	end
	
	if Found_Entity_ID == -1 then -- Random Walk
		if math.abs(Mobcontrol_Entity[Entity_ID].DX) < 0.05 and math.abs(Mobcontrol_Entity[Entity_ID].DY) < 0.05 and math.abs(Mobcontrol_Entity[Entity_ID].DZ) < 0.01 then
			Mobcontrol_Entity[Entity_ID].Walk_Rotation = math.random()*360
		else
			Mobcontrol_Entity[Entity_ID].Walk_Rotation = Mobcontrol_Entity[Entity_ID].Walk_Rotation + (math.random()-0.5)*20
		end
		Mobcontrol_Entity[Entity_ID].Walk_Speed = 4 -- m/s
		local Rotation, Look = Mobcontrol_Entity[Entity_ID].Walk_Rotation, 0
		Entity_Position_Set(Entity_ID, Map_ID, X, Y, Z, Rotation, Look, 1, 0)
	else -- Walk to other entity
		local Other_X = Entity_Get_X(Found_Entity_ID)
		local Other_Y = Entity_Get_Y(Found_Entity_ID)
		local Other_Z = Entity_Get_Z(Found_Entity_ID)
		local Dist = math.sqrt((Other_X-X)^2 + (Other_Y-Y)^2)
		local Rotation, Look = math.deg(math.atan2((Other_Y-Y), (Other_X-X)))+90, -math.deg(math.atan2(Other_Z-Z, Dist))
		Mobcontrol_Entity[Entity_ID].Walk_Rotation = Rotation
		if Dist > 1 then
			Mobcontrol_Entity[Entity_ID].Walk_Speed = 4.0 -- m/s
		else
			Mobcontrol_Entity[Entity_ID].Walk_Speed = 0.2 -- m/s
		end
		Entity_Position_Set(Entity_ID, Map_ID, X, Y, Z, Rotation, Look, 1, 0)
	end
	
end

local	Collision_Vertices = {}
		Collision_Vertices[1] = {ix=-0.3 , iy=-0.3 , iz= 0.0}
		Collision_Vertices[2] = {ix= 0.3 , iy=-0.3 , iz= 0.0}
		Collision_Vertices[3] = {ix=-0.3 , iy= 0.3 , iz= 0.0}
		Collision_Vertices[4] = {ix= 0.3 , iy= 0.3 , iz= 0.0}
		Collision_Vertices[5] = {ix=-0.3 , iy=-0.3 , iz= 1.0}
		Collision_Vertices[6] = {ix= 0.3 , iy=-0.3 , iz= 1.0}
		Collision_Vertices[7] = {ix=-0.3 , iy= 0.3 , iz= 1.0}
		Collision_Vertices[8] = {ix= 0.3 , iy= 0.3 , iz= 1.0}
		Collision_Vertices[9] = {ix= 0.0 , iy= 0.0 , iz= 1.6}
local function Check_Collision(Map_ID, X, Y, Z)
	local Result = 1
	
	for i = 1, 9 do
		local ix, iy, iz = Collision_Vertices[i].ix,Collision_Vertices[i].iy,Collision_Vertices[i].iz
		local Mat = Map_Block_Get_Type(Map_ID, math.floor(X+ix), math.floor(Y+iy), math.floor(Z+iz))
		if Mat == 0 then -- Air
			
		elseif Mat == 10 or Mat == 11 or Mat == 200 then -- Lava
			if Result > 0.1 then Result = 0.2 end
		elseif Mat == 8 or Mat == 9 or Mat == 206 or Mat == 209 then -- Water/Acid
			if Result > 0.25 then Result = 0.4 end
		elseif Mat == 44 then -- Stair
			if iz == 0 then
				if (Z)-math.floor(Z) < 0.5 then
					Result = 0
				end
			else
				Result = 0
			end
		else
			Result = 0
		end
	end
	
	return Result
end

function Mobcontrol_Do_Physics(Entity_ID)
	
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local X = Entity_Get_X(Entity_ID)
	local Y = Entity_Get_Y(Entity_ID)
	local Z = Entity_Get_Z(Entity_ID)
	local Rotation = Entity_Get_Rotation(Entity_ID)
	local Look = Entity_Get_Look(Entity_ID)
	
	-- Do Walking
	Mobcontrol_Entity[Entity_ID].DX = math.cos(math.rad(Mobcontrol_Entity[Entity_ID].Walk_Rotation-90))*Mobcontrol_Entity[Entity_ID].Walk_Speed*Mobcontrol_Timer
	Mobcontrol_Entity[Entity_ID].DY = math.sin(math.rad(Mobcontrol_Entity[Entity_ID].Walk_Rotation-90))*Mobcontrol_Entity[Entity_ID].Walk_Speed*Mobcontrol_Timer
	
	-- Gravity + Damping
	if math.abs(Mobcontrol_Entity[Entity_ID].DZ) > 0.1 then
		Mobcontrol_Entity[Entity_ID].DX = Mobcontrol_Entity[Entity_ID].DX * 0.1
		Mobcontrol_Entity[Entity_ID].DY = Mobcontrol_Entity[Entity_ID].DY * 0.1
	end
	Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Entity[Entity_ID].DZ + Mobcontrol_Gravity * Mobcontrol_Timer
	
	-- Pushing
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Other_Entity_ID = Entity_Table[i]
		if Other_Entity_ID ~= Entity_ID then
			local Other_Map_ID = Entity_Get_Map_ID(Other_Entity_ID)
			if Other_Map_ID == Map_ID then
				local Other_X = Entity_Get_X(Other_Entity_ID)
				local Other_Y = Entity_Get_Y(Other_Entity_ID)
				local Other_Z = Entity_Get_Z(Other_Entity_ID)
				local Dist_X, Dist_Y, Dist_Z = (Other_X-X), (Other_Y-Y), (Other_Z-Z)
				if math.abs(Dist_X) < 1 and math.abs(Dist_Y) < 1 and math.abs(Dist_Z) < 1.6 then
					local Dist = math.sqrt(Dist_X^2 + Dist_Y^2)
					if Dist < 1 and Dist > 0 then
						Mobcontrol_Entity[Entity_ID].DX = Mobcontrol_Entity[Entity_ID].DX - Dist_X*0.3/Dist
						Mobcontrol_Entity[Entity_ID].DY = Mobcontrol_Entity[Entity_ID].DY - Dist_Y*0.3/Dist
					end
				end
			end
		end
	end
	
	-- Stairs
	if Check_Collision(Map_ID, X+Mobcontrol_Entity[Entity_ID].DX, Y, Z) == 0 then
		if Check_Collision(Map_ID, X+Mobcontrol_Entity[Entity_ID].DX, Y, Z+0.51) ~= 0 then
			Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Jump_Speed/2*Mobcontrol_Timer
		end
	end
	if Check_Collision(Map_ID, X, Y+Mobcontrol_Entity[Entity_ID].DY, Z) == 0 then
		if Check_Collision(Map_ID, X, Y+Mobcontrol_Entity[Entity_ID].DY, Z+0.51) ~= 0 then
			Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Jump_Speed/2*Mobcontrol_Timer
		end
	end
	
	-- Jump
	if Check_Collision(Map_ID, X+Mobcontrol_Entity[Entity_ID].DX, Y, Z) == 0 then
		if Check_Collision(Map_ID, X+Mobcontrol_Entity[Entity_ID].DX, Y, Z+1.1) ~= 0 then
			Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Jump_Speed*Mobcontrol_Timer
		end
	end
	if Check_Collision(Map_ID, X, Y+Mobcontrol_Entity[Entity_ID].DY, Z) == 0 then
		if Check_Collision(Map_ID, X, Y+Mobcontrol_Entity[Entity_ID].DY, Z+1.1) ~= 0 then
			Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Jump_Speed*Mobcontrol_Timer
		end
	end
	
	-- Max Speed
	if Mobcontrol_Entity[Entity_ID].DX >  Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DX =  Mobcontrol_Max_Speed*Mobcontrol_Timer end
	if Mobcontrol_Entity[Entity_ID].DX < -Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DX = -Mobcontrol_Max_Speed*Mobcontrol_Timer end
	if Mobcontrol_Entity[Entity_ID].DY >  Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DY =  Mobcontrol_Max_Speed*Mobcontrol_Timer end
	if Mobcontrol_Entity[Entity_ID].DY < -Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DY = -Mobcontrol_Max_Speed*Mobcontrol_Timer end
	if Mobcontrol_Entity[Entity_ID].DZ >  Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DZ =  Mobcontrol_Max_Speed*Mobcontrol_Timer end
	if Mobcontrol_Entity[Entity_ID].DZ < -Mobcontrol_Max_Speed*Mobcontrol_Timer then Mobcontrol_Entity[Entity_ID].DZ = -Mobcontrol_Max_Speed*Mobcontrol_Timer end
	
	-- Collision
	Mobcontrol_Entity[Entity_ID].DX = Mobcontrol_Entity[Entity_ID].DX * Check_Collision(Map_ID, X+Mobcontrol_Entity[Entity_ID].DX, Y   , Z   )
	Mobcontrol_Entity[Entity_ID].DY = Mobcontrol_Entity[Entity_ID].DY * Check_Collision(Map_ID, X   , Y+Mobcontrol_Entity[Entity_ID].DY, Z   )
	Mobcontrol_Entity[Entity_ID].DZ = Mobcontrol_Entity[Entity_ID].DZ * Check_Collision(Map_ID, X   , Y   , Z+Mobcontrol_Entity[Entity_ID].DZ)
	
	-- Placing Entity on ground
	if Mobcontrol_Entity[Entity_ID].DZ == 0 and Check_Collision(Map_ID, X, Y, Z-0.1) ~= 0 then
		Mobcontrol_Entity[Entity_ID].DZ = -0.1
	end
	
end

function Mobcontrol_Do_Move(Entity_ID)
	
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	local X = Entity_Get_X(Entity_ID)
	local Y = Entity_Get_Y(Entity_ID)
	local Z = Entity_Get_Z(Entity_ID)
	local Rotation = Entity_Get_Rotation(Entity_ID)
	local Look = Entity_Get_Look(Entity_ID)
	
	X = X + Mobcontrol_Entity[Entity_ID].DX
	Y = Y + Mobcontrol_Entity[Entity_ID].DY
	Z = Z + Mobcontrol_Entity[Entity_ID].DZ
	
	Entity_Position_Set(Entity_ID, Map_ID, X, Y, Z, Rotation, Look, 1, 0)
end

System_Message_Network_Send_2_All(-1, "&eMob Script reloaded")