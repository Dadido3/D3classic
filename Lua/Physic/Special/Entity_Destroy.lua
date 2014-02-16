local Temp_Destroy_Element = {}

Event_Add("Entity_Temp_Destroy_Restore", "Entity_Temp_Destroy_Restore", "Timer", 0, 1000, -1)
function Entity_Temp_Destroy_Restore(Map_ID)
	for i, v in pairs(Temp_Destroy_Element) do
		local Player_Number, Map_ID, X, Y, Z, Type, Time = Temp_Destroy_Element[i].Player_Number, Temp_Destroy_Element[i].Map_ID, Temp_Destroy_Element[i].X, Temp_Destroy_Element[i].Y, Temp_Destroy_Element[i].Z, Temp_Destroy_Element[i].Type, Temp_Destroy_Element[i].Time
		local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
		if Time < os.clock() and Block_Type == 0 then
			Temp_Destroy_Element[i] = nil
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, Type, 1, 1, 1, 5)
		end
	end
end

function Physic_Entity_Temp_Destroy(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	local Entity_Table, Entitys = Entity_Get_Table()
	for i = 1, Entitys do
		local Entity_ID = Entity_Table[i]
		local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Entity_ID),Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
		
		if Entity_Map_ID == Map_ID and Entity_X > X-0.4 and Entity_X < X+1.4 and Entity_Y > Y-0.4 and Entity_Y < Y+1.4 and Entity_Z > Z-1.6 and Entity_Z < Z+1 then
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 0, 1, 5)
			for j = 0, 100 do
				if Temp_Destroy_Element[j] == nil then
					Temp_Destroy_Element[j] = {}
					Temp_Destroy_Element[j].Player_Number = Player_Number
					Temp_Destroy_Element[j].Map_ID = Map_ID
					Temp_Destroy_Element[j].X = X
					Temp_Destroy_Element[j].Y = Y
					Temp_Destroy_Element[j].Z = Z
					Temp_Destroy_Element[j].Type = Block_Type
					Temp_Destroy_Element[j].Time = os.clock() + 10
					break
				end
			end
		end
	end
end

function Physic_Entity_Destroy(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Entity_Table, Entitys = Entity_Get_Table()
	for i = 1, Entitys do
		local Entity_ID = Entity_Table[i]
		local Entity_Map_ID, Entity_X, Entity_Y, Entity_Z = Entity_Get_Map_ID(Entity_ID),Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
		
		if Entity_Map_ID == Map_ID and Entity_X > X-0.4 and Entity_X < X+1.4 and Entity_Y > Y-0.4 and Entity_Y < Y+1.4 and Entity_Z > Z-1.6 and Entity_Z < Z+1 then
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 0, 1, 5)
		end
	end
end