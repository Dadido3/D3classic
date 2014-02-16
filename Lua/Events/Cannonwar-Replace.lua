Event_Add("Cannonwar", "Cannonwar_Event_Blockchange", "Map_Block_Change_Client", 0, 0, 326)
--Event_Delete("Cannonwar")

function Cannonwar_Event_Blockchange(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	if Mode == 1 and Type == 46 then
		Map_Block_Change(Player_Number, Map_ID, X, Y, Z, 247, 1, 1, 1, 10)
		Result = 0
	end
	return Result
end