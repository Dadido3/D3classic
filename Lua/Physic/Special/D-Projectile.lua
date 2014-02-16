local Directional_Projectile_List = {}

function Physic_Directional_Projectile_Add(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	local Rot, Look = Rot + math.random()-0.5, Look + math.random()-0.5
	local VX, VY, VZ = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	if Map_Block_Get_Type(Map_ID, math.floor(X), math.floor(Y), math.floor(Z)) == 0 then
		for i = 0, 100 do
			if Directional_Projectile_List[i] == nil or Map_Block_Get_Type(Directional_Projectile_List[i].Map_ID, math.floor(Directional_Projectile_List[i].X), math.floor(Directional_Projectile_List[i].Y), math.floor(Directional_Projectile_List[i].Z)) ~= 252 then
				Map_Block_Change(Player_Number, Map_ID, math.floor(X), math.floor(Y), math.floor(Z), 252, 0, 1, 1, 1)
				Directional_Projectile_List[i] = {}
				Directional_Projectile_List[i].Map_ID = Map_ID
				Directional_Projectile_List[i].X = X
				Directional_Projectile_List[i].Y = Y
				Directional_Projectile_List[i].Z = Z
				Directional_Projectile_List[i].VX = VX
				Directional_Projectile_List[i].VY = VY
				Directional_Projectile_List[i].VZ = VZ
				break
			end
		end
	end
end

function Physic_Directional_Projectile_Kill(Player_Number, Map_ID, X, Y, Z, Radius)
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
				if Dist <= Radius then
					System_Message_Network_Send_2_All(Map_ID, "&c"..Entity_Name.." killed by "..Player_Name)
					Entity_Kill(Entity_ID)
					return 1
				end
			end
		end
	end
	
	return 0
end

function Physic_Directional_Projectile(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	local Found = 0
	local i = 0
	for i, v in pairs(Directional_Projectile_List) do
		if Directional_Projectile_List[i].Map_ID == Map_ID and math.floor(Directional_Projectile_List[i].X) == X and math.floor(Directional_Projectile_List[i].Y) == Y and math.floor(Directional_Projectile_List[i].Z) == Z then
			local VX, VY, VZ = Directional_Projectile_List[i].VX, Directional_Projectile_List[i].VY, Directional_Projectile_List[i].VZ
			local RX, RY, RZ = Directional_Projectile_List[i].X, Directional_Projectile_List[i].Y, Directional_Projectile_List[i].Z
			Map_Block_Change(Player_Number, Map_ID, math.floor(RX), math.floor(RY), math.floor(RZ), 0, 0, 1, 1, 9)
			Directional_Projectile_List[i].X = RX + VX
			Directional_Projectile_List[i].Y = RY + VY
			Directional_Projectile_List[i].Z = RZ + VZ
			--Directional_Projectile_List[i].VZ = Directional_Projectile_List[i].VZ - 0.003 -- Gravity
			local SX, SY, SZ = Directional_Projectile_List[i].X, Directional_Projectile_List[i].Y, Directional_Projectile_List[i].Z
			local S_Type = Map_Block_Get_Type(Map_ID, math.floor(SX), math.floor(SY), math.floor(SZ))
			if S_Type == 0 or S_Type == 51 then
				if Physic_Directional_Projectile_Kill(Player_Number, Map_ID, X, Y, Z, 1.5) == 0 then
					Map_Block_Change(Player_Number, Map_ID, math.floor(SX), math.floor(SY), math.floor(SZ), Block_Type, 0, 1, 1, 9)
				end
			else
				--Explosion(Player_Number, Map_ID, math.floor(RX), math.floor(RY), math.floor(RZ), 2, -1, 5)
			end
			Found = 1
			break
		end
	end
	
	if Found == 0 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 0, 1, 9)
		--Physic_Directional_Projectile_Add(Player_Number, Map_ID, X, Y, Z, math.random()*360, math.random()*180-90)
	end
end

System_Message_Network_Send_2_All(-1, "&eD3-Projectile Script Reloaded!")