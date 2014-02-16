--Event_Add("Event-S", "Event_S_Event_Blockchange", "Map_Block_Change_Client", 0, 1, 8)
--Event_Delete("Event-S")

function Event_S_Event_Blockchange(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	local Name = Player_Get_Name(Player_Number)
	
	if Name ~= "Serekalen" then
		if Mode == 0 or Type == 0 then
			System_Message_Network_Send(Client_ID, "&cNo deleting!")
			Result = 0
		end
		if Type == 7 then
			System_Message_Network_Send(Client_ID, "&cNo solid!")
			Result = 0
		end
	end
	return Result
end

--Event_Add("Event-S_2", "Event_S_Event_Blockchange_Player", "Map_Block_Change_Player", 0, 1, 8)
function Event_S_Event_Blockchange_Player(Result, Player_Number, Map_ID, X, Y, Z, Type, Undo, Physic, Send, Send_Priority)
	local Name = Player_Get_Name(Player_Number)
	
	if Name ~= "Serekalen" then
		Result = 0
	end
	return Result
end