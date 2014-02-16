--Event_Add("Test", "Event_Test", "Timer", 0, 500, -1)
--Event_Delete("Test")

--System_Message_Network_Send_2_All(-1, "&cRestoring Names...")
Entity_Table, Entities = Entity_Get_Table()
for i = 1, Entities do
	local Entity_ID = Entity_Table[i]
	local Player_Number = Entity_Get_Player(Entity_ID)
	if Player_Number == -1 then
		--Entity_Delete(Entity_ID)
	else
		--Entity_Displayname_Set(Entity_ID, Player_Get_Prefix(Player_Number), Player_Get_Name(Player_Number), Player_Get_Suffix(Player_Number))
	end
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	--System_Message_Network_Send_2_All(-1, "Entity_ID "..tostring(Entity_ID).." is "..Prefix..Name..Suffix)
end

local Text_History = {}
Event_Delete("Event_Text_Test")
--Event_Add("Event_Text_Test", "Event_Text_Test", "Chat_Map", 0, 0, -1)
function Event_Text_Test(Result, Entity_ID, Message)
	local Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
	
	for i = 3, 0, -1 do
		if Text_History[i] ~= nil then
			Text_History[i+1] = Text_History[i]
		end
	end
	
	Text_History[0] = Name..": "..Message
	
	for i = 0, 4 do
		if Text_History[i] ~= nil then
			Font_Draw_Text(-1, "minecraft", 4, 0, 0, 64+i*8, 1, 0, Text_History[i].."                          ", 36, 49)
		end
	end
	
	return Result
end

--System_Message_Network_Send_2_All(-1, "&ePlayer '&fNotch&e' logged in.")
--Entity_Displayname_Set(0, "&f", "Notch", "")
--Entity_Displayname_Set(2, "&8", "rasield", "")
--Entity_Add("Notch", 0, 54, 38, 24.6, 0, 180)
--print(Entity_Displayname_Get(3))
--Entity_Delete(1)
--Player_Set_Rank(0, 32767)
--System_Message_Network_Send_2_All(0, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
--Map_Action_Add_Delete(8)

function Event_Test(Map_ID)
	Prefix, Name, Suffix = Entity_Displayname_Get(1)
	--Entity_Displayname_Set(0, Prefix, Name, " &cThe Master")
	Entity_Displayname_Set(1, "&"..tostring(math.random(8)-1), Name, Suffix)
end

--Event_Add("Meh", "Event_Resend", "Timer", 0, 1000, 6)
--Event_Delete("Meh")
function Event_Resend(Map_ID)
	Map_Resend(Map_ID)
end


--System_Message_Network_Send_2_All(-1, "Knuk: !eventroll")
--System_Message_Network_Send_2_All(-1, "Knuk: XD")