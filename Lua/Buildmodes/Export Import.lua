-- ############################ Export #############################

function Command_Build_Mode_Export(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		local Filename = Arg_0
		if string.lower(string.sub(Filename, string.len(Filename)-3)) ~= ".map" then
			Filename = Filename..".map"
		end
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Export started"))
		Build_Mode_Set(Client_ID, "Export Map-Area")
		Build_Mode_State_Set(Client_ID, 0)
		Build_Mode_String_Set(Client_ID, 0, Files_Folder_Get("Usermaps")..Filename)
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Export: Define a file"))
	end
end

function Build_Mode_Export(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local Filename = Build_Mode_String_Get(Client_ID, 0)
			
			Map_Export(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Filename)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Export: Saved"))
			
			Build_Mode_Set(Client_ID, "Normal")
			
		end
		
	end

end

-- ############################ Import #############################

function Command_Build_Mode_Import(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		local Filename = Arg_0
		if string.lower(string.sub(Filename, string.len(Filename)-3)) ~= ".map" then
			Filename = Filename..".map"
		end
		local Temp_File = io.open(Files_Folder_Get("Usermaps")..Filename)
		if Temp_File ~= nil then
			io.close(Temp_File)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Import started"))
			Build_Mode_Set(Client_ID, "Import Map-Area")
			Build_Mode_String_Set(Client_ID, 0, Files_Folder_Get("Usermaps")..Filename)
			Build_Mode_Long_Set(Client_ID, 0, 1)
			Build_Mode_Long_Set(Client_ID, 1, 1)
			Build_Mode_Long_Set(Client_ID, 2, 1)
		else
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Import: File '[Field_0]' not found", Filename))
		end
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Import: Define a file"))
	end
end

function Command_Build_Mode_Scaleimport(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	if Arg_0 ~= "" then
		
		local SX, SY, SZ = tonumber(Arg_1), tonumber(Arg_2), tonumber(Arg_3)
		if SX <= 1 then SX = 1 end
		if SY <= 1 then SY = 1 end
		if SZ <= 1 then SZ = 1 end
		
		local Filename = Arg_0
		if string.lower(string.sub(Filename, string.len(Filename)-3)) ~= ".map" then
			Filename = Filename..".map"
		end
		local Temp_File = io.open(Files_Folder_Get("Usermaps")..Filename)
		if Temp_File ~= nil then
			io.close(Temp_File)
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Scaleimport started"))
			Build_Mode_Set(Client_ID, "Import Map-Area")
			Build_Mode_String_Set(Client_ID, 0, Files_Folder_Get("Usermaps")..Filename)
			Build_Mode_Long_Set(Client_ID, 0, SX)
			Build_Mode_Long_Set(Client_ID, 1, SY)
			Build_Mode_Long_Set(Client_ID, 2, SZ)
		else
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Scaleimport: File '[Field_0]' not found", Filename))
		end
	else
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Scaleimport: Define a file"))
	end
end

function Build_Mode_Import(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		local Filename = Build_Mode_String_Get(Client_ID, 0)
		local SX, SY, SZ = Build_Mode_Long_Get(Client_ID, 0), Build_Mode_Long_Get(Client_ID, 1), Build_Mode_Long_Get(Client_ID, 2)
		
		local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
		
		Map_Import_Player(Player_Number, Filename, Map_ID, X, Y, Z, SX, SY, SZ)
		System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Import: Imported"))
		
		Build_Mode_Set(Client_ID, "Normal")
		
	end
	
end