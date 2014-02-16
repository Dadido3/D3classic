local Atomic_Material = 202
local Atomic_Bomb_Radius = 100
local Atomic_Shroom_Material_1 = 51
local Atomic_Shroom_Material_2 = 203
local Atomic_Kill_Deepness = 5

local Atomic_List = {}

local function Atomic_Add(Map_ID, X, Y, Z, Timer)
	for i = 0, 10 do
		if Atomic_List[i] ~= nil and Atomic_List[i].Map_ID == Map_ID and Atomic_List[i].X == X and Atomic_List[i].Y == Y and Atomic_List[i].Z == Z and Map_Block_Get_Type(Atomic_List[i].Map_ID, math.floor(Atomic_List[i].X), math.floor(Atomic_List[i].Y), math.floor(Atomic_List[i].Z)) == Atomic_Material and math.floor(Atomic_List[i].Timer) > 0 then
			Atomic_List[i].Timer = Atomic_List[i].Timer - 0.1
			return Atomic_List[i].Timer
		end
	end
	for i = 0, 10 do
		if Atomic_List[i] == nil or Map_Block_Get_Type(Atomic_List[i].Map_ID, math.floor(Atomic_List[i].X), math.floor(Atomic_List[i].Y), math.floor(Atomic_List[i].Z)) ~= Atomic_Material then
			Atomic_List[i] = {}
			Atomic_List[i].Map_ID = Map_ID
			Atomic_List[i].X = X
			Atomic_List[i].Y = Y
			Atomic_List[i].Z = Z
			Atomic_List[i].Timer = Timer
			return Timer
		end
	end
	return 0
end

local function Circle(Player_Number, Material, Map_ID, X, Y, Z, Size, Send_Priority)
	local Size_Rounded = math.ceil(Size)
	local Size_Square = Size^2
	
	for ix = -Size_Rounded, Size_Rounded do
		for iy = -Size_Rounded, Size_Rounded do
			local Dist_Square = ix^2 + iy^2
			if Dist_Square <= Size_Square then
				local Allowed = 0
				if     (ix+1)^2 + (iy  )^2 > Size_Square then Allowed = 1
				elseif (ix-1)^2 + (iy  )^2 > Size_Square then Allowed = 1
				elseif (ix  )^2 + (iy+1)^2 > Size_Square then Allowed = 1
				elseif (ix  )^2 + (iy-1)^2 > Size_Square then Allowed = 1
				end
				
				if Allowed == 1 and Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z) == 0 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z, Material, 1, 0, 1, Send_Priority)
				end
			end
		end
	end
end

local function X_Ray(Player_Number, Map_ID, X, Y, Z, Rot, Look, Send_Priority)
	local M_X, M_Y, M_Z = math.cos(math.rad(Rot-90))*math.cos(math.rad(Look)), math.sin(math.rad(Rot-90))*math.cos(math.rad(Look)), -math.sin(math.rad(Look))
	for i = 1, Atomic_Bomb_Radius do
		local Block_Type = Map_Block_Get_Type(Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i)
		if Block_Type == 7 then
			break
		end
		if Block_Type ~= 0 and Block_Type ~= Atomic_Shroom_Material_1 and Block_Type ~= Atomic_Shroom_Material_2 then
			if math.random(4) == 1 then
				Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, 0, 1, 0, 1, Send_Priority) -- Air
			else
				Map_Block_Change(Player_Number, Map_ID, X+M_X*i, Y+M_Y*i, Z+M_Z*i, 232, 1, 1, 1, Send_Priority) -- Ash
			end
			if math.random(3) == 1 then
				break
			end
		end
	end
end

local function Check_Ray(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1)
	local D_X = X_1 - X_0
	local D_Y = Y_1 - Y_0
	local D_Z = Z_1 - Z_0

	local Blocks = 1

	if Blocks < math.abs(D_X) then Blocks = math.abs(D_X) end
	if Blocks < math.abs(D_Y) then Blocks = math.abs(D_Y) end
	if Blocks < math.abs(D_Z) then Blocks = math.abs(D_Z) end

	local M_X = D_X / Blocks
	local M_Y = D_Y / Blocks
	local M_Z = D_Z / Blocks
	
	local Deepness = Atomic_Kill_Deepness
	
	for i = 0, Blocks do
		local Block_Type = Map_Block_Get_Type(Map_ID, X_0+M_X*i, Y_0+M_Y*i, Z_0+M_Z*i)
		if Block_Type ~= 0 then
			Deepness = Deepness - 1
		end
		if Block_Type == 7 or Deepness == 0 then
			return 0
		end
	end
	
	return 1
end

function Physic_Special_Atomic_Bomb(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	if Map_Block_Get_Type(Map_ID, X, Y, Z-1) == 0 then
		Map_Block_Move(Map_ID, X, Y, Z, X, Y, Z-1, 1, 1, 5)
	else
		
		local Timer = Atomic_Add(Map_ID, X, Y, Z, 10)
		if math.floor(Timer) > 0 then
			if math.mod(math.floor(Timer*10), 10) == 0 then
				System_Message_Network_Send_2_All(Map_ID, "&cT= -"..tostring(math.floor(Timer)))
			end
		else
			
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 0, 0, 1, 5)
			
			--for i = 0, 20 do
			--	Map_Block_Change(Player_Number, Map_ID, X+(math.random()-0.5)*50, Y+(math.random()-0.5)*50, Z+10, 227, 1, 1, 1, 30)
			--end
			
			-- Killing
			local Entity_Table, Entitys = Entity_Get_Table()
			for i = 1, Entitys do
				local Entity_ID = Entity_Table[i]
				for iz = 0, 5 do
					if Entity_Get_Map_ID(Entity_ID) == Map_ID and Check_Ray(Map_ID, X, Y, Z+iz, Entity_Get_X(Entity_ID), Entity_Get_Y(Entity_ID), Entity_Get_Z(Entity_ID)+1.6) == 1 then
						Entity_Kill(Entity_ID)
					end
				end
			end
			
			-- Atomic Mushroom
			for iz = 0, 40 do
				local Size = 5+math.random()*3
				Circle(Player_Number, Atomic_Shroom_Material_1, Map_ID, X, Y, Z+iz, Size, 21)
				Circle(Player_Number, Atomic_Shroom_Material_2, Map_ID, X, Y, Z+iz, Size-1, 21)
			end
			local iz = 40
			for Size = 5, 30 do
				Circle(Player_Number, Atomic_Shroom_Material_1, Map_ID, X, Y, Z+iz, Size, 21)
				Circle(Player_Number, Atomic_Shroom_Material_2, Map_ID, X, Y, Z+iz+1, Size, 21)
				iz = iz - 0.2
			end
			for Size = 30, 20, -1 do
				Circle(Player_Number, Atomic_Shroom_Material_2, Map_ID, X, Y, Z+iz, Size, 21)
				iz = iz + 1
			end
			for Size = 20, 10, -1 do
				Circle(Player_Number, Atomic_Shroom_Material_2, Map_ID, X, Y, Z+iz, Size, 21)
				iz = iz + 0.5
			end
			for Size = 10, 00, -1 do
				Circle(Player_Number, Atomic_Shroom_Material_2, Map_ID, X, Y, Z+iz, Size, 21)
				iz = iz + 0.1
			end
			
			-- Destruction
			for il = 90, -90, -0.5 do
				local Step = 1/(0.001+math.cos(math.rad(il)))
				for ir = 0, 360, Step do
					X_Ray(Player_Number, Map_ID, X, Y, Z+2, ir, il+math.random()*0.5, 20)
				end
			end
			
			-- Killing
			local Entity_Table, Entitys = Entity_Get_Table()
			for i = 1, Entitys do
				local Entity_ID = Entity_Table[i]
				for iz = 0, 5 do
					if Entity_Get_Map_ID(Entity_ID) == Map_ID and Check_Ray(Map_ID, X, Y, Z+iz, Entity_Get_X(Entity_ID), Entity_Get_Y(Entity_ID), Entity_Get_Z(Entity_ID)+1.6) == 1 then
						Entity_Kill(Entity_ID)
					end
				end
			end
		
		end
		
	end
end

System_Message_Network_Send_2_All(-1, "&cAtomic Bomb reloaded")