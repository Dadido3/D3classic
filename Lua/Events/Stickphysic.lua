-- ################################################################################################
-- ##                                  Stickphysic by Dadido3                                    ##
-- ##                                                                                            ##
-- ################################################################################################
-- Types: 0=Statik(Anchor) 1=Point 10=Line(2Points)

Event_Add("Stickphysic_Timer", "Stickphysic_Event_Timer", "Timer", 0, 20, -1)
Event_Add("Stickphysic_Blockchange", "Stickphysic_Event_Blockchange", "Map_Block_Change_Client", 0, 0, -1)

local Physic_Stopped = 0
local Physic_Timestep = 0.1/5 -- in seconds
local Physic_Gravity = -9.81 -- in m/s²
local Physic_Velocity_Max = 1.00/Physic_Timestep -- in m/s

local Physic_Stiffness = 10 -- Factor
local Physic_Damping = 0.996 -- Factor
local Physic_Wobble_Max = 100.0 -- (Needs a better name :/ ) in 1

local Entities_Max = 200
if Entity == nil then
	Entity = {}
end

function Stickphysic_Check_Line(X_0, Y_0, Z_0, X_1, Y_1, Z_1, X, Y, Z)
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
	
	local i
	for i = 0, Blocks do
		if math.floor(X_0+M_X*i) == X and math.floor(Y_0+M_Y*i) == Y and math.floor(Z_0+M_Z*i) == Z then
			return 1
		end
	end
	return 0
end

function Stickphysic_Draw_Line(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material)
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
	
	local i
	for i = 0, Blocks do
		if Map_Block_Get_Type(Map_ID, math.floor(X_0+M_X*i), math.floor(Y_0+M_Y*i), math.floor(Z_0+M_Z*i)) == 0 then
			Map_Block_Change(Player_Number, Map_ID, math.floor(X_0+M_X*i), math.floor(Y_0+M_Y*i), math.floor(Z_0+M_Z*i), Material, 0, 0, 1, 5)
		end
	end
end

function Stickphysic_Undraw_Line(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material)
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
	
	local i
	for i = 0, Blocks do
		if Map_Block_Get_Type(Map_ID, math.floor(X_0+M_X*i), math.floor(Y_0+M_Y*i), math.floor(Z_0+M_Z*i)) == Material then
			Map_Block_Change(Player_Number, Map_ID, math.floor(X_0+M_X*i), math.floor(Y_0+M_Y*i), math.floor(Z_0+M_Z*i), 0, 0, 0, 1, 5)
		end
	end
end

function Stickphysic_Entities_Move()
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 1 then -- Point
				Entity[i].VZ = Entity[i].VZ + Physic_Gravity * Physic_Timestep
				Entity[i].VX = Entity[i].VX * Physic_Damping
				Entity[i].VY = Entity[i].VY * Physic_Damping
				Entity[i].VZ = Entity[i].VZ * Physic_Damping
				if Entity[i].VX > Physic_Velocity_Max then Entity[i].VX = Physic_Velocity_Max end
				if Entity[i].VX < -Physic_Velocity_Max then Entity[i].VX = -Physic_Velocity_Max end
				if Entity[i].VY > Physic_Velocity_Max then Entity[i].VY = Physic_Velocity_Max end
				if Entity[i].VY < -Physic_Velocity_Max then Entity[i].VY = -Physic_Velocity_Max end
				if Entity[i].VZ > Physic_Velocity_Max then Entity[i].VZ = Physic_Velocity_Max end
				if Entity[i].VZ < -Physic_Velocity_Max then Entity[i].VZ = -Physic_Velocity_Max end
				local New_X = Entity[i].X + Entity[i].VX * Physic_Timestep
				local New_Y = Entity[i].Y + Entity[i].VY * Physic_Timestep
				local New_Z = Entity[i].Z + Entity[i].VZ * Physic_Timestep
				if Map_Block_Get_Type(Entity[i].Map_ID, math.floor(New_X), math.floor(Entity[i].Y), math.floor(Entity[i].Z)) == 0 then
					Entity[i].X = New_X
				end
				if Map_Block_Get_Type(Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(New_Y), math.floor(Entity[i].Z)) == 0 then
					Entity[i].Y = New_Y
				end
				if Map_Block_Get_Type(Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(Entity[i].Y), math.floor(New_Z)) == 0 then
					Entity[i].Z = New_Z
				end
			elseif Entity[i].Type == 2 then -- Line
				local i_1 = Entity[i].P_1
				local i_2 = Entity[i].P_2
				if Entity[i_1] ~= nil and Entity[i_2] ~= nil then
					local Delta_X = Entity[i_1].X-Entity[i_2].X
					local Delta_Y = Entity[i_1].Y-Entity[i_2].Y
					local Delta_Z = Entity[i_1].Z-Entity[i_2].Z
					local Distance = math.sqrt(math.pow(Delta_X,2)+math.pow(Delta_Y,2)+math.pow(Delta_Z,2))
					local Delta_Distance = Entity[i].Length - Distance -- >0 Distance should be bigger   <0 Distance should be smaller
					local Wobble = Delta_Distance * Physic_Stiffness
					if Wobble > Physic_Wobble_Max then Wobble = Physic_Wobble_Max end
					if Wobble < -Physic_Wobble_Max then Wobble = -Physic_Wobble_Max end
					Entity[i_1].VX = Entity[i_1].VX + (Delta_X/Distance) * Wobble
					Entity[i_1].VY = Entity[i_1].VY + (Delta_Y/Distance) * Wobble
					Entity[i_1].VZ = Entity[i_1].VZ + (Delta_Z/Distance) * Wobble
					Entity[i_2].VX = Entity[i_2].VX - (Delta_X/Distance) * Wobble
					Entity[i_2].VY = Entity[i_2].VY - (Delta_Y/Distance) * Wobble
					Entity[i_2].VZ = Entity[i_2].VZ - (Delta_Z/Distance) * Wobble
				end
			end
		end
	end
end

function Stickphysic_Entities_Draw()
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 0 or Entity[i].Type == 1 then
				if Map_Block_Get_Type(Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(Entity[i].Y), math.floor(Entity[i].Z)) == 0 then
					Map_Block_Change(Entity[i].Player_Number, Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(Entity[i].Y), math.floor(Entity[i].Z), Entity[i].Material, 0, 0, 1, 5)
				end
			elseif Entity[i].Type == 2 then
				local i_1 = Entity[i].P_1
				local i_2 = Entity[i].P_2
				if Entity[i_1] ~= nil and Entity[i_2] ~= nil then
					Stickphysic_Draw_Line(Entity[i].Player_Number, Entity[i].Map_ID, Entity[i_1].X, Entity[i_1].Y, Entity[i_1].Z, Entity[i_2].X, Entity[i_2].Y, Entity[i_2].Z, Entity[i].Material)
				end
			end
		end
	end
end

function Stickphysic_Entities_Undraw()
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 0 or Entity[i].Type == 1 then
				if Map_Block_Get_Type(Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(Entity[i].Y), math.floor(Entity[i].Z)) == Entity[i].Material then
					Map_Block_Change(Entity[i].Player_Number, Entity[i].Map_ID, math.floor(Entity[i].X), math.floor(Entity[i].Y), math.floor(Entity[i].Z), 0, 0, 0, 1, 5)
				end
			elseif Entity[i].Type == 2 then
				local i_1 = Entity[i].P_1
				local i_2 = Entity[i].P_2
				if Entity[i_1] ~= nil and Entity[i_2] ~= nil then
					Stickphysic_Undraw_Line(Entity[i].Player_Number, Entity[i].Map_ID, Entity[i_1].X, Entity[i_1].Y, Entity[i_1].Z, Entity[i_2].X, Entity[i_2].Y, Entity[i_2].Z, Entity[i].Material)
				end
			end
		end
	end
end

function Stickphysic_Entity_Find(Map_ID, X, Y, Z, Range)
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 0 or Entity[i].Type == 1 then
				local Distance = math.sqrt(math.pow(Entity[i].X-X,2)+math.pow(Entity[i].Y-Y,2)+math.pow(Entity[i].Z-Z,2))
				if Distance < Range then
					return i
				end
			end
		end
	end
	
	return 0 -- No Entity found
end

function Stickphysic_Entity_Add_Anchor(Player_Number, Map_ID, X, Y, Z, Material)
	
	local i = Stickphysic_Entity_Find(Map_ID, X, Y, Z, 2)
	
	if i == 0 then
		for i = 1, Entities_Max do
			if Entity[i] == nil then
				Entity[i] = {}
				Entity[i].Type = 0
				Entity[i].Player_Number = Player_Number
				Entity[i].Map_ID = Map_ID
				Entity[i].X = X
				Entity[i].Y = Y
				Entity[i].Z = Z
				Entity[i].VX = 0
				Entity[i].VY = 0
				Entity[i].VZ = 0
				Entity[i].Material = Material
				return i
			end
		end
	end
	
	return i
end

function Stickphysic_Entity_Add_Point(Player_Number, Map_ID, X, Y, Z, Material)
	
	
	local i = Stickphysic_Entity_Find(Map_ID, X, Y, Z, 2)
	
	if i == 0 then
		for i = 1, Entities_Max do
			if Entity[i] == nil then
				Entity[i] = {}
				Entity[i].Type = 1
				Entity[i].Player_Number = Player_Number
				Entity[i].Map_ID = Map_ID
				Entity[i].X = X
				Entity[i].Y = Y
				Entity[i].Z = Z
				Entity[i].OX = X
				Entity[i].OY = Y
				Entity[i].OZ = Z
				Entity[i].VX = 0
				Entity[i].VY = 0
				Entity[i].VZ = 0
				Entity[i].Material = Material
				return i
			end
		end
	end
	
	return i
end

function Stickphysic_Entity_Add_Line(Player_Number, Map_ID, P_1, P_2, Material, Length)
	local i
	for i = 1, Entities_Max do
		if Entity[i] == nil then
			Entity[i] = {}
			Entity[i].Type = 2
			Entity[i].Player_Number = Player_Number
			Entity[i].Map_ID = Map_ID
			Entity[i].P_1 = P_1
			Entity[i].P_2 = P_2
			Entity[i].Length = math.sqrt(math.pow(Entity[P_1].X-Entity[P_2].X,2)+math.pow(Entity[P_1].Y-Entity[P_2].Y,2)+math.pow(Entity[P_1].Z-Entity[P_2].Z,2))
			if Length > 0 then
				Entity[i].Length = Length
			end
			Entity[i].Material = Material
			return i
		end
	end
	
	return 0 -- No free Entity found
end

function Stickphysic_Entity_Delete(Entity_Number)
	
	Stickphysic_Entities_Undraw()
	
	Entity[Entity_Number] = nil
	
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 0 or Entity[i].Type == 1 then
				
			elseif Entity[i].Type == 2 then
				if Entity[i].P_1 == Entity_Number then
					Stickphysic_Entity_Delete(i)
				elseif Entity[i].P_2 == Entity_Number then
					Stickphysic_Entity_Delete(i)
				end
			end
		end
	end
end

function Stickphysic_Event_Timer(Map_ID)
	
	Stickphysic_Entities_Undraw()
	
	if Physic_Stopped == 0 then
		
		local i
		for i = 1, 5 do
			Stickphysic_Entities_Move()
		end
	end
	
	Stickphysic_Entities_Draw()
end

function Stickphysic_Event_Blockchange(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	if Mode == 0 then
		
		local i = Stickphysic_Entity_Find(Map_ID, X, Y, Z, 1.5)
		if i ~= 0 then
			Stickphysic_Entity_Delete(i)
		end
		
		local i
		for i = 1, Entities_Max do
			if Entity[i] ~= nil then
				if Entity[i].Type == 2 then
					local i_1 = Entity[i].P_1
					local i_2 = Entity[i].P_2
					if Entity[i_1] ~= nil and Entity[i_2] ~= nil then
						if Stickphysic_Check_Line(Entity[i_1].X, Entity[i_1].Y, Entity[i_1].Z, Entity[i_2].X, Entity[i_2].Y, Entity[i_2].Z, X, Y, Z) == 1 then
							Stickphysic_Entity_Delete(i)
						end
					end
				end
			end
		end
		
	end
	return Result
end

function Command_SP_Clear(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	Stickphysic_Entities_Undraw()
	Entity = {}
end

function Command_SP_Stop(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	
	Stickphysic_Entities_Undraw()
	
	local i
	for i = 1, Entities_Max do
		if Entity[i] ~= nil then
			if Entity[i].Type == 1 then
				Entity[i].X = Entity[i].OX
				Entity[i].Y = Entity[i].OY
				Entity[i].Z = Entity[i].OZ
				Entity[i].VX = 0
				Entity[i].VY = 0
				Entity[i].VZ = 0
			end
		end
	end
	
	Physic_Stopped = 1
	
	System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Stickphysics stopped"))
end

function Command_SP_Start(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	Physic_Stopped = 0
	
	System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Stickphysics started"))
end

-- ###################################################################

--Stickphysic_Entities_Undraw()

--Entity = {}

System_Message_Network_Send_2_All(-1,"&eStickphysics reloaded")