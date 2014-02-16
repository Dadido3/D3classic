function Command_Build_Mode_BCount(Client_ID, Command, Text_0, Text_1, ...)
	System_Message_Network_Send(Client_ID, "&eBuildmode: Block Count Box.<br>&eBuild at the start and endpoint.")
	Build_Mode_Set(Client_ID, "BCount")
	Build_Mode_State_Set(Client_ID, 0)
end

function Build_Mode_BCount(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local X_0,X_1 = math.min(X_0,X_1),math.max(X_0,X_1)
			local Y_0,Y_1 = math.min(Y_0,Y_1),math.max(Y_0,Y_1)
			local Z_0,Z_1 = math.min(Z_0,Z_1),math.max(Z_0,Z_1)
			local blocks = {}
			for X=X_0,X_1 do
				for Y=Y_0,Y_1 do
					for Z=Z_0,Z_1 do
						local block = Map_Block_Get_Type(Map_ID, X, Y, Z)
						blocks[block] = (blocks[block] or 0) + 1
					end
				end
			end
			local Text = "&e"
			local Text_Add = ""
			--table.sort(players)
			for Block_Type,count in pairs(blocks) do
				local Name = Block_Get_Name(Block_Type)
				Text_Add = Name.."x"..count.." "
				if 64 - #Text >= #Text_Add then
					Text = Text..Text_Add
				else
					System_Message_Network_Send(Client_ID, Text)
					Text = "&e"..Text_Add
				end
			end
			
			if #Text > 0 then
				System_Message_Network_Send(Client_ID, Text)
			end
			Build_Mode_Set(Client_ID, "Normal")
		end
	end
end
--[[function Build_Mode_BCount(...)
	print(pcall(Build_Mode_BCount2,...))
end]]
System_Message_Network_Send_2_All(-1, "&0dbg bcbox")
