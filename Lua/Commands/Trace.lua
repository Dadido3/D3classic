local us_states = {
	AL="Alabama",
	AK="Alaska", 
	AZ="Arizona", 
	AR="Arkansas", 
	CA="California", 
	CO="Colorado", 
	CT="Connecticut", 
	DE="Delaware", 
	DC="District Of Columbia", 
	FL="Florida", 
	GA="Georgia", 
	HI="Hawaii", 
	ID="Idaho", 
	IL="Illinois", 
	IN="Indiana", 
	IA="Iowa", 
	KS="Kansas", 
	KY="Kentucky", 
	LA="Louisiana", 
	ME="Maine", 
	MD="Maryland", 
	MA="Massachusetts", 
	MI="Michigan", 
	MN="Minnesota", 
	MS="Mississippi", 
	MO="Missouri", 
	MT="Montana",
	NE="Nebraska",
	NV="Nevada",
	NH="New Hampshire",
	NJ="New Jersey",
	NM="New Mexico",
	NY="New York",
	NC="North Carolina",
	ND="North Dakota",
	OH="Ohio", 
	OK="Oklahoma", 
	OR="Oregon", 
	PA="Pennsylvania", 
	RI="Rhode Island", 
	SC="South Carolina", 
	SD="South Dakota",
	TN="Tennessee", 
	TX="Texas", 
	UT="Utah", 
	VT="Vermont", 
	VA="Virginia", 
	WA="Washington", 
	WV="West Virginia", 
	WI="Wisconsin", 
	WY="Wyoming"
}

function Command_Trace(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local playerID = getPlayerByName(Arg_0)
	if playerID == -1 then
		System_Message_Network_Send(Client_ID, "&eError, couldn't find player.")
		return
	end
	local playerIP = Player_Get_IP(playerID)
	--System_Message_Network_Send(Client_ID, "&ePlayer Number: "..playerID)
	System_Message_Network_Send(Client_ID, "&eIP: &f"..playerIP)
	local fp = io.popen('wget -U"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6" "http://whatismyipaddress.com/staticpages/index.php/ip-details?ip='..playerIP..'" -o NUL -Otemp.html >NUL')
	fp:close()
	fp = io.open("temp.html","r")
	local html = ""
	while true do
		local block = fp:read(1024)
		if not block then break end
		html = html..block
	end
	fp:close(fp)
	--print(html)
	local trace = {}
	html:gsub("<TR><TD>(.-)</TD><TD>(.-)</TD></TR>",function(name, value)
		trace[string.sub(name,1,-2)] = value
	end)
	local state = ""
	if us_states[trace["State/Region"]] then
		state = us_states[trace["State/Region"]]..", "
	end
	print(3)
	local country = string.sub(trace.Country,1,(string.find(trace.Country, "<"))-1)
	print(4)
	sendClientMessage(Client_ID,
		"&eISP: &f"..trace.ISP,
		"&eLocation: &f"..trace.City..", "..state..country)
end