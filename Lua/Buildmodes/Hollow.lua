function Command_Build_Mode_Hollow(Client_ID, Command, Text_0, Text_1, Arg_0, Arg_1, Arg_2, Arg_3, Arg_4)
	System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow started"))
	Build_Mode_Set(Client_ID, "Hollow")
	Build_Mode_State_Set(Client_ID, 0)
	--Build_Mode_Long_Set(Client_ID, 0, tonumber(Arg_0))
end

local tmats = {
	[-1]=true,
	[0]=true,
	[8]=true,
	[9]=true,
	[10]=true,
	[11]=true,
	[20]=true
}

function Build_Mode_Hollow(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
	if Mode == 1 then
		
		local State = Build_Mode_State_Get(Client_ID)
		
		if State == 0 then -- Ersten Punkt wählen
			Build_Mode_Coordinate_Set(Client_ID, 0, X, Y, Z)
			Build_Mode_State_Set(Client_ID, 1)
			
		elseif State == 1 then -- Zweiten Punkt wählen und bauen
			local Time = os.clock()
			local X_0, Y_0, Z_0, X_1, Y_1, Z_1 = X, Y, Z, Build_Mode_Coordinate_Get(Client_ID, 0)
			local X_0,X_1 = math.min(X_0,X_1),math.max(X_0,X_1)
			local Y_0,Y_1 = math.min(Y_0,Y_1),math.max(Y_0,Y_1)
			local Z_0,Z_1 = math.min(Z_0,Z_1),math.max(Z_0,Z_1)
														
			local Player_Number = Entity_Get_Player(Client_Get_Entity(Client_ID))
			local Player_Rank = Player_Get_Rank(Player_Number)
			
			local blocks = {}
			for X=X_0,X_1 do
				for Y=Y_0,Y_1 do
					for Z=Z_0,Z_1 do
						if Map_Block_Get_Rank(Map_ID, X, Y, Z) <= Player_Rank then
							local Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
							if Type ~= 0 then
								--print(6)
								local count = 0
								if tmats[Map_Block_Get_Type(Map_ID, X+1, Y, Z)] then count = count + 1 end
								if tmats[Map_Block_Get_Type(Map_ID, X-1, Y, Z)] then count = count + 1 end
								if tmats[Map_Block_Get_Type(Map_ID, X, Y+1, Z)] then count = count + 1 end
								if tmats[Map_Block_Get_Type(Map_ID, X, Y-1, Z)] then count = count + 1 end
								if tmats[Map_Block_Get_Type(Map_ID, X, Y, Z+1)] then count = count + 1 end
								if tmats[Map_Block_Get_Type(Map_ID, X, Y, Z-1)] then count = count + 1 end
								if count == 0 then
									table.insert(blocks,{X, Y, Z})
								else
									--Map_Block_Change_Fast(Player_Number, Map_ID, X, Y, Z, 21, 0, 0, 0, 1)
								end
							end
						end
					end
				end
			end
			for i,v in pairs(blocks) do
				local X,Y,Z = unpack(v)
				Map_Block_Change_Player(Player_Number, Map_ID, X, Y, Z, 0, 1, 0, 1, 5)
			end
			Time = (os.clock()-Time)*1000
			--System_Message_Network_Send(Client_ID, "&eArea hollowed. ("...."ms)")
			System_Message_Network_Send(Client_ID, Lang_Get("", "Buildmode: Hollow done ([Field_0]ms)", tostring(math.floor(Time*3)/3)))
			
			Build_Mode_Set(Client_ID, "Normal")
		end
		
	end
	
end