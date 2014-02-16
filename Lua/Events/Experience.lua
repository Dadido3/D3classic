-- MONSTERS BLOCKS DECLARATIONS HERE
	Blob = 248
	BlobSpawner = 249
	DirtDog = 250

--Event_Add("Events_EXP", "Events_EXP", "Map_Block_Change_Client", 0, 0, 12)
	
System_Message_Network_Send_2_All(-1, "&eReloading '&7Events_EXP&e' ...")
function Events_EXP(Result, Client_ID, Map_ID, X, Y, Z, Mode, Material)
	System_Message_Network_Send(-1, "&eReloading '&7Events_EXP&e' ...")
	--System_Message_Network_Send_2_All(Map_ID, "&etest.")
	--Entity_ID = Client_Get_Entity(Client_ID)
	--Prefix, Klient, Suffix = Entity_Displayname_Get(Entity_ID)
	Bloczek = Map_Block_Get_Type(Map_ID, X, Y, Z)
	--EXPload = Player_Attribute_Long_Get(Client_ID, "EXP")
	if Bloczek ~= 0 then
		hit = math.random(1, 3)
		if Bloczek == Blob then
			meh = math.random(21, 40)
			if hit == 1 then
				System_Message_Network_Send(Client_ID, "&eYou have got &9"..tostring(meh).."&e Experience.") 
					--EXPsave = EXPload + meh
					--Player_Attribute_Long_Set(Client_ID, "EXP", EXPsave)
					--System_Message_Network_Send(Client_ID, "&eYou have now &9"..tostring(EXPsave).."&e Experience.") 
				return 1
			elseif hit == 2 then 
				System_Message_Network_Send(Client_ID, "&cYou missed!") 
				return 0
			else 
				System_Message_Network_Send(Client_ID, "&c'Blob' avoided your hit!") 
				return 0
			end
		elseif Bloczek == BlobSpawner then
			meh = math.random(31, 40)
			if hit == 1 then 
				System_Message_Network_Send(Client_ID, "&eYou have got &9"..tostring(meh).."&e Experience.") 
					--EXPsave = EXPload + meh
					--Player_Attribute_Long_Set(Client_ID, "EXP", EXPsave)
					--System_Message_Network_Send(Client_ID, "&eYou have now &9"..tostring(EXPsave).."&e Experience.") 
				return 1
			elseif hit == 2 then 
				System_Message_Network_Send(Client_ID, "&cYou missed!") 
				return 0
			else 
				System_Message_Network_Send(Client_ID, "&c'Blob Mother' avoided your hit!") 
				return 0
			end
		elseif Bloczek == DirtDog then
			meh = math.random(1, 10)
			if hit == 1 then
				System_Message_Network_Send(Client_ID, "&eYou have got &9"..tostring(meh).."&e Experience.") 
				--EXPsave = EXPload + meh
				--Player_Attribute_Long_Set(Client_ID, "EXP", EXPsave)
				--System_Message_Network_Send(Client_ID, "&eYou have now &9"..tostring(EXPsave).."&e Experience.") 
				return 1
			elseif hit == 2 then 
				System_Message_Network_Send(Client_ID, "&cYou missed!")
				return 0
			else 
				System_Message_Network_Send(Client_ID, "&c'Dirt Dog' avoided your hit!") 
				return 0
			end
		else
			return 1
		end
	else
		return 1
	end
end
System_Message_Network_Send_2_All(-1, "&eFunction reloaded.")