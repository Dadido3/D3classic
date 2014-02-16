local Flamethrower_Material_Base = 49
local Flamethrower_Material_Front = 21
local Flamethrower_Material_Glass = 20
local Flamethrower_Material_Stair = 44
local Flamethrower_Material_Projectile = 51

function Physic_Flamethrower_Shoot(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	local M_X, M_Y, M_Z = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	for i = 3, 40 do
		if Map_Block_Get_Type(Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i) == 0 or Map_Block_Get_Type(Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i) == Flamethrower_Material_Projectile then
			Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, Flamethrower_Material_Projectile, 1, 1, 1, 1)
		end
	end
end

function Physic_Flamethrower_Build_And_Trigger(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	
	local Glass_Counter = 0
	for ix = -1, 1 do
		for iy = -1, 1 do
			if ix ~= 0 or iy ~= 0 then
				Map_Block_Change(Player_Number, Map_ID, X+ix , Y+iy, Z, Flamethrower_Material_Base, 0, 0, 1, 1)
			end
			for iz = 1, 2 do
				if Map_Block_Get_Type(Map_ID, X+ix , Y+iy, Z+iz) == Flamethrower_Material_Glass then
					Glass_Counter = Glass_Counter + 1
				else
					Map_Block_Change(Player_Number, Map_ID, X+ix , Y+iy, Z+iz, 0, 0, 0, 1, 1)
				end
			end
		end
	end
	
	local Rot_90 = math.floor((Rot-45)/90)
	if Rot_90 == 0 then -- X Direction
		for ix = -1, 1 do
			for iy = -1, 1 do
				if ix ~= 0 or iy ~= 0 then
					for iz = 1, 2 do
						if ix == 1 then
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, Flamethrower_Material_Glass, 0, 0, 1, 12)
						else
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, 0, 0, 0, 1, 11)
						end
					end
				end
			end
		end
		Map_Block_Change(Player_Number, Map_ID, X  , Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X  , Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y  , Z  , Flamethrower_Material_Stair, 0, 0, 1, 5)
	elseif Rot_90 == 1 or Rot_90 == -3 then -- -Y Direction
		for ix = -1, 1 do
			for iy = -1, 1 do
				if ix ~= 0 or iy ~= 0 then
					for iz = 1, 2 do
						if iy == -1 then
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, Flamethrower_Material_Glass, 0, 0, 1, 12)
						else
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, 0, 0, 0, 1, 11)
						end
					end
				end
			end
		end
		Map_Block_Change(Player_Number, Map_ID, X+1, Y  , Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y  , Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X+1, Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X  , Y-1, Z  , Flamethrower_Material_Stair, 0, 0, 1, 5)
	elseif Rot_90 == -2 then -- -X Direction
		for ix = -1, 1 do
			for iy = -1, 1 do
				if ix ~= 0 or iy ~= 0 then
					for iz = 1, 2 do
						if ix == -1 then
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, Flamethrower_Material_Glass, 0, 0, 1, 12)
						else
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, 0, 0, 0, 1, 11)
						end
					end
				end
			end
		end
		Map_Block_Change(Player_Number, Map_ID, X  , Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X  , Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X+1, Y-1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X+1, Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X+1, Y  , Z  , Flamethrower_Material_Stair, 0, 0, 1, 5)
	elseif Rot_90 == -1 then -- Y Direction
		for ix = -1, 1 do
			for iy = -1, 1 do
				if ix ~= 0 or iy ~= 0 then
					for iz = 1, 2 do
						if iy == 1 then
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, Flamethrower_Material_Glass, 0, 0, 1, 12)
						else
							Map_Block_Change(Player_Number, Map_ID, X+ix, Y-iy, Z+iz, 0, 0, 0, 1, 11)
						end
					end
				end
			end
		end
		Map_Block_Change(Player_Number, Map_ID, X+1, Y  , Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y  , Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X+1, Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X-1, Y+1, Z+1, Flamethrower_Material_Front, 0, 0, 1, 5)
		Map_Block_Change(Player_Number, Map_ID, X  , Y+1, Z  , Flamethrower_Material_Stair, 0, 0, 1, 5)
	end
	
	if Glass_Counter == 5 then
		Physic_Flamethrower_Shoot(Player_Number, Map_ID, X, Y, Z+2, Rot, Look)
	end
end

function Physic_Flamethrower(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	--Physic_Directional_Rocket_Explode(Player_Number, Map_ID, X, Y, Z, 5)
	
	-- ############# Find the player standing on the Flamethrower
	
	local Entity_Table, Entitys = Entity_Get_Table()
	for i = 1, Entitys do
		local Entity_ID = Entity_Table[i]
		local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Entity_ID),Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
		
		--if Entity_Get_Player_Number(Entity_ID) == Player_Number then
			if Entity_Map_ID == Map_ID and math.floor(Entity_X) == X and math.floor(Entity_Y) == Y and math.floor(Entity_Z) == Z+1 then
				
				local Rot, Look = Entity_Get_Rotation(Entity_ID), Entity_Get_Look(Entity_ID)
				--System_Message_Network_Send_2_All(-1, "Debug: "..tonumber(Rot).."  "..tonumber(Look))
				Physic_Flamethrower_Build_And_Trigger(Entity_Get_Player(Entity_ID), Map_ID, X, Y, Z, Rot, Look)
				break
			end
		--end
	end
end