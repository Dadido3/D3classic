local Turret_Material_Projectile = 51

function Physic_Turret_Shoot(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	local M_X, M_Y, M_Z = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	local i = 2
	if Map_Block_Get_Type(Map_ID, X+M_X*1, Y+M_Y*1, Z+M_Z*1) == 0 then
		--Physic_Directional_Rocket_Add(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, Rot, Look)
		Physic_Directional_Projectile_Add(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, Rot, Look)
	end
end

function Physic_Turret(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	--Physic_Directional_Rocket_Explode(Player_Number, Map_ID, X, Y, Z, 4)
	--System_Message_Network_Send_2_All(Map_ID, "&c"..Player_Get_Name(Player_Number).." is CHEATING (NO TURRETS)!!!!")
	
	-- ############# Find the entity standing near the Turret
	local Max_Distance = 130
	local Choosed_Entity_ID = -1
	local Entity_Table, Entitys = Entity_Get_Table()
	for i = 1, Entitys do
		local Entity_ID = Entity_Table[i]
		local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Entity_ID),Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
		local Distance = math.sqrt((Entity_X-X)^2+(Entity_Y-Y)^2+(Entity_Z-Z)^2)
		
		if Entity_Map_ID == Map_ID and Distance < Max_Distance then--and Entity_Get_Player(Entity_ID) ~= Player_Number then
			Max_Distance = Distance
			Choosed_Entity_ID = Entity_ID
		end
	end
	if Choosed_Entity_ID ~= -1 then
		local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Choosed_Entity_ID),Entity_Get_X(Choosed_Entity_ID),Entity_Get_Y(Choosed_Entity_ID),Entity_Get_Z(Choosed_Entity_ID)
		local Distance = math.sqrt((Entity_X-X)^2+(Entity_Y-Y)^2)
		local Rot, Look = math.deg(math.atan2((Entity_Y-Y), (Entity_X-X)))+90, -math.deg(math.atan2(Entity_Z-Z, Distance))
		Physic_Turret_Shoot(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	end
end