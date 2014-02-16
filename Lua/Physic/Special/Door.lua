function Physic_Special_Door(Map_ID, X, Y, Z)
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	local Block_Type = Map_Block_Get_Type(Map_ID, X, Y, Z)
	
	local Material_1 = 43 -- Material der Tür (Rand)
	local Material_2 = 20 -- Material der Tür
	local Material_3 = 49 -- Material gibt richtung an
	local Material_4 = 21 -- Material: Tür zu
	local Material_5 = 25 -- Material: Tür auf
	
	local Vector_X = 0
	local Vector_Y = 0
	local Found = 0
	
	for ix = -1, 1 do
		for iy = -1, 1 do
			if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z) == Material_3 then
				Vector_X = ix
				Vector_Y = iy
				Found = 1
			end
		end
	end
	
	if Found == 1 then

		for i = 1, 10 do
			ix = i * Vector_X
			iy = i * Vector_Y
			if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z) == Material_3 then
				Size_X = i
			else
				break
			end
		end
		local Size_Z = Size_X
		local Z_Defined = 0
		for i = 1, 10 do
			ix = i * Vector_X
			iy = i * Vector_Y
			if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z-1) == Material_3 then
				Size_Z = i
				Z_Defined = 1
			else
				break
			end
		end

		local i = Size_X+1
		local ix = i * Vector_X
		local iy = i * Vector_Y
		local Material_1 = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z)
		local i = Size_X+2
		local ix = i * Vector_X
		local iy = i * Vector_Y
		local Material_2 = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z)
		
		if Z_Defined == 1 then
			local i = Size_Z+1
			local ix = i * Vector_X
			local iy = i * Vector_Y
			local Temp_Material_4 = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z-1)
			local i = Size_Z+2
			local ix = i * Vector_X
			local iy = i * Vector_Y
			local Temp_Material_5 = Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z-1)
			if Temp_Material_4 ~= Temp_Material_5 then
				Material_4 = Temp_Material_4
				Material_5 = Temp_Material_5
			end
		end
		
		if Material_1 ~= -1 and Material_2 ~= -1 and Material_4 ~= -1 and Material_5 ~= -1 then
			
			i = 1
			ix = i * Vector_X
			iy = i * Vector_Y
			
			local Offset_Z = 0
			
			if Map_Block_Get_Type(Map_ID, X, Y, Z + 2 + Offset_Z) == Material_5 then
				Open = 1
			elseif Map_Block_Get_Type(Map_ID, X, Y, Z + 2 + Offset_Z) == Material_4 then
				Open = 0
			elseif Map_Block_Get_Type(Map_ID, X + ix, Y + iy, Z + 1 + Offset_Z) == Material_1 then
				Map_Block_Change(Player_Number, Map_ID, X, Y, Z + 2 + Offset_Z, Material_5, 0, 0, 1, 5)
				Open = 1
			else
				Map_Block_Change(Player_Number, Map_ID, X, Y, Z + 2 + Offset_Z, Material_4, 0, 0, 1, 5)
				Open = 0
			end
			
			for i = 1, Size_X do
				ix = i * Vector_X
				iy = i * Vector_Y
				if Open == 1 then
					for iz = 1, Size_Z do
						Map_Block_Change(Player_Number, Map_ID, X + ix, Y + iy, Z + iz + Offset_Z, 0, 0, 0, 1, 5)
					end
				else
					for iz = 1, Size_Z do
						if i == 1 or i == Size_X or iz == 1 or iz == Size_Z then
							Map_Block_Change(Player_Number, Map_ID, X + ix, Y + iy, Z + iz + Offset_Z, Material_1, 0, 0, 1, 5)
						else
							Map_Block_Change(Player_Number, Map_ID, X + ix, Y + iy, Z + iz + Offset_Z, Material_2, 0, 0, 1, 5)
						end
					end
				end
			end
			
		end
	end
	
end
