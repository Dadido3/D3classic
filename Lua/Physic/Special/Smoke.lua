function Physic_Special_Slow_Smoke(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Delta_X = math.random(3)-2
	local Delta_Y = math.random(3)-2
	local Delta_Z = 1
	
	if math.random(5) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 1, 1, 5)
	elseif Map_Block_Get_Type(Map_ID, X+Delta_X, Y+Delta_Y, Z+Delta_Z) == 0 then
		Map_Block_Move(Map_ID, X, Y, Z, X+Delta_X, Y+Delta_Y, Z+Delta_Z, 1, 1, 5)
	else
		Delta_Z = 0
		if Map_Block_Get_Type(Map_ID, X+Delta_X, Y+Delta_Y, Z+Delta_Z) == 0 then
			Map_Block_Move(Map_ID, X, Y, Z, X+Delta_X, Y+Delta_Y, Z+Delta_Z, 1, 1, 5)
		else
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 1, 1, 5)
		end
	end
end

function Physic_Special_Smoke(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	local Delta_X = math.random(3)-2
	local Delta_Y = math.random(3)-2
	local Delta_Z = 1
	
	if math.random(10) == 1 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 1, 1, 5)
	elseif Map_Block_Get_Type(Map_ID, X+Delta_X, Y+Delta_Y, Z+Delta_Z) == 0 then
		Map_Block_Move(Map_ID, X, Y, Z, X+Delta_X, Y+Delta_Y, Z+Delta_Z, 1, 1, 5)
	else
		Delta_Z = 0
		if Map_Block_Get_Type(Map_ID, X+Delta_X, Y+Delta_Y, Z+Delta_Z) == 0 then
			Map_Block_Move(Map_ID, X, Y, Z, X+Delta_X, Y+Delta_Y, Z+Delta_Z, 1, 1, 5)
		elseif math.random(4) == 1 then
			Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 0, 1, 1, 1, 5)
		end
	end
end
