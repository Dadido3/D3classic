
local Griefgrave_Showrank = 200
local Ignore_Rank = 60

local Playerlist

if Playerlist == nil then
	Playerlist = {}
end

local function Griefgrave_Player_Add(Player_Number)
	if Playerlist[Player_Number] == nil then
		Playerlist[Player_Number] = {}
		Playerlist[Player_Number].Last_Map_ID = -1
		Playerlist[Player_Number].Last_X = 0
		Playerlist[Player_Number].Last_Y = 0
		Playerlist[Player_Number].Last_Z = 0
		Playerlist[Player_Number].Last_Mode = -1
		Playerlist[Player_Number].Last_Type = -1
		Playerlist[Player_Number].Last_Time = os.clock()
		Playerlist[Player_Number].Statistic_Random = 0			-- Statistics for random Building/Deleting
		Playerlist[Player_Number].Statistic_Grief_Others = 0	-- Statistics for Build/Delete other player blocks
		Playerlist[Player_Number].Statistic_Far = 0				-- Statistics for Building/Deleting far away from the entity
		Playerlist[Player_Number].Statistic_Fast_Build = 0		-- Statistics for Building fast
		Playerlist[Player_Number].Statistic_Fast_Delete = 0		-- Statistics for Deleting fast
		Playerlist[Player_Number].Last_Message_Time = os.clock()-- Statistics for Deleting fast
	end
end

local function Griefgrave_Blockchange(Client_ID, Map_ID, X, Y, Z, Mode, Type)
	local Entity_ID = Client_Get_Entity(Client_ID)
	local Player_Number = Entity_Get_Player(Entity_ID)
	local Block_Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	Griefgrave_Player_Add(Player_Number)
	
	local Time_Diff = os.clock() - Playerlist[Player_Number].Last_Time
	
	-- Check: random Building/Deleting
	local Dist = math.sqrt((Playerlist[Player_Number].Last_X - X)^2 + (Playerlist[Player_Number].Last_Y - Y)^2 + (Playerlist[Player_Number].Last_Z - Z)^2)
	if Mode == 0 and Block_Player_Number ~= Player_Number and Block_Player_Number ~= 0 and Dist > 1.5 and Time_Diff < 0.6 then
		Playerlist[Player_Number].Statistic_Random = Mix(Playerlist[Player_Number].Statistic_Random, 1, 0.9)
	elseif Mode == 1 and Block_Player_Number ~= Player_Number and Dist > 1.5 and Time_Diff < 0.6 then
		Playerlist[Player_Number].Statistic_Random = Mix(Playerlist[Player_Number].Statistic_Random, 1, 0.9)
	else
		Playerlist[Player_Number].Statistic_Random = Mix(Playerlist[Player_Number].Statistic_Random, 0, 0.9)
	end
	
	-- Check: Build/Delete other player blocks
	if Block_Player_Number ~= Player_Number and Block_Player_Number ~= -1 and Time_Diff < 1.5 then
		Playerlist[Player_Number].Statistic_Grief_Others = Mix(Playerlist[Player_Number].Statistic_Grief_Others, 1, 0.9)
	else
		Playerlist[Player_Number].Statistic_Grief_Others = Mix(Playerlist[Player_Number].Statistic_Grief_Others, 0, 0.9)
	end
	
	-- Check: Building/Deleting far away from the entity
	local Dist = math.sqrt((X-Entity_Get_X(Entity_ID))^2 + (Y-Entity_Get_Y(Entity_ID))^2 + (Z-Entity_Get_Z(Entity_ID))^2)
	if Dist > 10 then
		Playerlist[Player_Number].Statistic_Far = 1
	else
		Playerlist[Player_Number].Statistic_Far = 0
	end
	
	-- Check: Building/Deleting fast
	if Block_Player_Number ~= Player_Number and Time_Diff < 0.2 then
		if Mode == 1 then
			Playerlist[Player_Number].Statistic_Fast_Build = Mix(Playerlist[Player_Number].Statistic_Fast_Build, 1, 0.9)
		else
			Playerlist[Player_Number].Statistic_Fast_Delete = Mix(Playerlist[Player_Number].Statistic_Fast_Delete, 1, 0.9)
		end
	else
		if Mode == 1 then
			Playerlist[Player_Number].Statistic_Fast_Build = Mix(Playerlist[Player_Number].Statistic_Fast_Build, 0, 0.9)
		else
			Playerlist[Player_Number].Statistic_Fast_Delete = Mix(Playerlist[Player_Number].Statistic_Fast_Delete, 0, 0.9)
		end
	end
	
	Playerlist[Player_Number].Last_Map_ID = Map_ID
	Playerlist[Player_Number].Last_X = X
	Playerlist[Player_Number].Last_Y = Y
	Playerlist[Player_Number].Last_Z = Z
	Playerlist[Player_Number].Last_Mode = Mode
	Playerlist[Player_Number].Last_Type = Type
	Playerlist[Player_Number].Last_Time = os.clock()
end

Event_Add("Griefgrave_Event_Blockchange_Client", "Griefgrave_Event_Blockchange_Client", "Map_Block_Change_Client", 0, 0, -1)
function Griefgrave_Event_Blockchange_Client(Result, Client_ID, Map_ID, X, Y, Z, Mode, Type)
	
	Griefgrave_Blockchange(Client_ID, Map_ID, X, Y, Z, Mode, Type)
	
	--System_Message_Network_Send_2_All(Map_ID, X.." "..Y.." "..Z.." mat"..Type.." mode"..Mode)
	return Result
end

function Griefgrave_Message_Grief(Player_Number, Message)
	local Player_Displayname = Player_Get_Prefix(Player_Number)..Player_Get_Name(Player_Number)..Player_Get_Suffix(Player_Number)
	
	Client_Table, Clients = Client_Get_Table()
	for i = 1, Clients do
		local Client_ID = Client_Table[i]
		local Entity_ID = Client_Get_Entity(Client_ID)
		local Player_Number = Entity_Get_Player(Entity_ID)
		if Player_Get_Rank(Player_Number) >= Griefgrave_Showrank then
			System_Message_Network_Send(Client_ID, "&c'"..Player_Displayname.."&c' is possibly griefing: &e"..Message)
		end
	end
end

Event_Add("Griefgrave_Event_Timer", "Griefgrave_Event_Timer", "Timer", 0, 1000, -1)
function Griefgrave_Event_Timer(Map_ID)
	for i,v in pairs(Playerlist) do
		local Player_Number = i
		if Player_Get_Online(Player_Number) == 1 then
			if Player_Get_Rank(Player_Number) < Ignore_Rank then
				if os.clock() - v.Last_Message_Time > 30 then
					v.Last_Message_Time = os.clock()
					
					if v.Statistic_Random > 0.3 and v.Statistic_Grief_Others > 0.7 then
						Griefgrave_Message_Grief(Player_Number, "Griefed other players")
						v.Statistic_Grief_Others = 0
					end
					if v.Statistic_Random > 0.5 then
						Griefgrave_Message_Grief(Player_Number, "Random building")
						v.Statistic_Random = 0
					end
					if v.Statistic_Far > 0.5 then
						Griefgrave_Message_Grief(Player_Number, "Blockchanges far away from entity")
						v.Statistic_Far = 0
					end
				end
			end
		else
			Playerlist[Player_Number] = nil
		end
	end
end

--System_Message_Network_Send_2_All(-1,"&eGriefgrave reloaded")