Event_Add("Message_To_New_Players", "Message_To_New_Players", "Client_Login", 0, 0, -1)

local Text = "&bThis is your first visit here.<br>"
Text = Text.."&bRead &e/Rules /Help&b and &e/Faq<br>"
Text = Text.."&bTo get a list of commands, use &e/Commands<br>"
Text = Text.."&bTo get a list of players, use &e/Players<br>"
Text = Text.."&bTo talk globally, use a &c#&b in front of your Message.<br>"
Text = Text.."&bIf you want to build something, go to the guest map.<br>"
Text = Text.."&bIf you built something, ask a staffmember to get promoted.<br>"
Text = Text.."&bAlso, &cdon't grief&b and respect other people buildings!<br>"

function Message_To_New_Players(Result, Client_ID)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	
	local On_Time = Player_Get_Ontime(Player_Number)
	if On_Time < 1800 then
		System_Message_Network_Send(Client_ID, Text)
	end
	return Result
end