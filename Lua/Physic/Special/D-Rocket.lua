local Directional_Rocket_List = {}

function Physic_Directional_Rocket_Add(Player_Number, Map_ID, X, Y, Z, Rot, Look)
	local Rot, Look = Rot + math.random()-0.5, Look + math.random()-0.5
	local VX, VY, VZ = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	local i
	for i = 0, 100 do
		if Directional_Rocket_List[i] == nil or Map_Block_Get_Type(Directional_Rocket_List[i].Map_ID, math.floor(Directional_Rocket_List[i].X), math.floor(Directional_Rocket_List[i].Y), math.floor(Directional_Rocket_List[i].Z)) ~= 246 then
			Map_Block_Change(Player_Number, Map_ID, math.floor(X), math.floor(Y), math.floor(Z), 246, 0, 1, 1, 1)
			Directional_Rocket_List[i] = {}
			Directional_Rocket_List[i].Map_ID = Map_ID
			Directional_Rocket_List[i].X = X
			Directional_Rocket_List[i].Y = Y
			Directional_Rocket_List[i].Z = Z
			Directional_Rocket_List[i].VX = VX
			Directional_Rocket_List[i].VY = VY
			Directional_Rocket_List[i].VZ = VZ
			break
		end
	end
end

function Physic_Directional_Rocket_Explode(Player_Number, Map_ID, X, Y, Z, Radius)
	for New_X = -Radius, Radius do
		for New_Y = -Radius, Radius do
			for New_Z = -Radius, Radius do
				Entf = New_X*New_X + New_Y*New_Y + New_Z*New_Z
				if Entf < Radius*Radius then
					Map_Block_Change(Player_Number, Map_ID, X + New_X, Y + New_Y, Z + New_Z, 0, 1, 0, 1, 5)
				end
			end
		end
	end
	for i = 0, 60, 1 do
		New_X = X + math.random(Radius*2) - Radius
		New_Y = Y + math.random(Radius*2) - Radius
		New_Z = Z + math.random(Radius) - 1
		if Map_Block_Get_Type(Map_ID, New_X, New_Y, New_Z) == 0 then
			Map_Block_Change(Player_Number, Map_ID, New_X, New_Y, New_Z, 51, 1, 1, 1, 6)
		end
	end
end

function Physic_Directional_Rocket(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	local Found = 0
	local i = 0
	for i, v in pairs(Directional_Rocket_List) do
		if Directional_Rocket_List[i].Map_ID == Map_ID and math.floor(Directional_Rocket_List[i].X) == X and math.floor(Directional_Rocket_List[i].Y) == Y and math.floor(Directional_Rocket_List[i].Z) == Z then
			local VX, VY, VZ = Directional_Rocket_List[i].VX, Directional_Rocket_List[i].VY, Directional_Rocket_List[i].VZ
			local RX, RY, RZ = Directional_Rocket_List[i].X, Directional_Rocket_List[i].Y, Directional_Rocket_List[i].Z
			Map_Block_Change(Player_Number, Map_ID, math.floor(RX), math.floor(RY), math.floor(RZ), 0, 0, 1, 1, 9)
			Directional_Rocket_List[i].X = RX + VX
			Directional_Rocket_List[i].Y = RY + VY
			Directional_Rocket_List[i].Z = RZ + VZ
			--Directional_Rocket_List[i].VZ = Directional_Rocket_List[i].VZ - 0.003 -- Gravity
			local SX, SY, SZ = Directional_Rocket_List[i].X, Directional_Rocket_List[i].Y, Directional_Rocket_List[i].Z
			local S_Type = Map_Block_Get_Type(Map_ID, math.floor(SX), math.floor(SY), math.floor(SZ))
			if S_Type == 0 or S_Type == 51 then
				Map_Block_Change(Player_Number, Map_ID, math.floor(SX), math.floor(SY), math.floor(SZ), Block_Type, 0, 1, 1, 9)
			else
				--Physic_Directional_Rocket_Explode(Player_Number, Map_ID, math.floor(RX), math.floor(RY), math.floor(RZ), 3)
				Explosion(Player_Number, Map_ID, math.floor(RX), math.floor(RY), math.floor(RZ), 3, -1, 5)
			end
			Found = 1
			break
		end
	end
	
	if Found == 0 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 0, 1, 9)
		--Physic_Directional_Rocket_Add(Player_Number, Map_ID, X, Y, Z, math.random()*360, math.random()*180-90)
	end
end

System_Message_Network_Send_2_All(-1, "&eD3-Rocket Script Reloaded!")