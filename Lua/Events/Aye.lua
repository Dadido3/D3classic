Event_Add("Aye", "Aye", "Chat_Map", 0, 0, -1)
function Aye(Result, Entity_ID, Message)
	local Client_ID
	
	local Client_Table, Clients = Client_Get_Table()
	local Found = 0
	for i = 1, Clients do
		Client_ID = Client_Table[i]
		if Client_Get_Entity(Client_ID) == Entity_ID then
			Found = 1
			break
		end
	end
	
	if Found == 1 then
		
		local char = Message:sub(1,3)
		local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)

		if char == "aye" and Name == "kaiser_czar" then
			System_Message_Network_Send_2_All(-1, "&dkaiser_czar has said 'aye'<br>&dA puppy has thus been thrown by David Motari.")
		end
	end


	return Result
end