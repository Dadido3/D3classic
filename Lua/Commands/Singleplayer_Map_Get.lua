function Command_Singleplayer_Map_Get(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	local mapname = Arg_0.."_"..Arg_1
	--os.execute("del temp.gz server_level.dat maps\\"..mapname)
	os.execute('wget "http://minecraft.net/level/load.html?user='..Arg_0..'&id='..Arg_1..'" -Otemp.gz')
	local fp = io.open("temp.gz","rb")

	local status = fp:read(string.byte(fp:read(2),2))
	print("status: "..status)
	if status == "OK" then
		local fp2 = io.open("server_level.dat","wb")
		local size = 1024
		while true do
		  local block = fp:read(size)
		  if not block then break end
		  fp2:write(block)
		end
		fp2:close()
		
		os.execute("javaw -jar mapconv.jar")
		os.rename("converted_level.gz", "maps\\"..mapname..".map")
		local Map_ID = -1
		Map_Examine()
		while Map_Next() ~= 0 do
			Map_ID = Map_Get_ID()
		end
		Map_ID = Map_ID + 1
		Map_Add(Map_ID, 16, 16, 16, mapname)
		Map_Load(Map_ID, "maps\\"..mapname..".map")
	end
	fp:close()
	os.execute("del temp.gz server_level.dat")
end