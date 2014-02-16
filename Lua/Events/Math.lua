local function Line(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material)
	local D_X = X_1 - X_0
	local D_Y = Y_1 - Y_0
	local D_Z = Z_1 - Z_0
	
	local Blocks = 1
	
	if Blocks < math.abs(D_X) then
		Blocks = math.abs(D_X)
	end
	if Blocks < math.abs(D_Y) then
		Blocks = math.abs(D_Y)
	end
	if Blocks < math.abs(D_Z) then
		Blocks = math.abs(D_Z)
	end
	
	local M_X = D_X / Blocks
	local M_Y = D_Y / Blocks
	local M_Z = D_Z / Blocks
	
	local i
	
	if Blocks > 40 then
		Blocks = 40
	end
	
	for i = 0, Blocks do
		Map_Block_Change(-1, Map_ID, X_0+M_X*i, Y_0+M_Y*i, Z_0+M_Z*i, Material, 0, 0, 1, 1)
	end
end

Event_Add("Minegraph", "Event_Chat_Math", "Chat_Map", 0, 0, -1)
function Event_Chat_Math(Result, Entity_ID, Message)
	local Map_ID = Entity_Get_Map_ID(Entity_ID)
	
	if Map_ID == 258 then
		if string.sub(Message, 1, 3) == "y =" then
			
			local X_Min = -256		-- In blocks, without scale
			local X_Max = 256		-- In blocks, without scale
			local Offset_X = 256	-- In blocks, without scale
			local Offset_Y = 256
			local Offset_Z = 1
			local Scale = 0.05
			
			local Material_Graph = 21
			local Material_Line = 1
			
			local String_0 = string.sub(Message, 4)
			
			if string.find(String_0, "os.", 1, true) ~= nil then
				System_Message_Network_Send_2_All(Map_ID, "&c :/")
				return
			end
			
			local x
			
			for ix = X_Min, X_Max do
				for iy = X_Min, X_Max do
					if math.mod((ix*Scale), 1) == 0 or math.mod((iy*Scale), 1) == 0 then
						Map_Block_Change(-1, Map_ID, Offset_X + ix, Offset_Y + iy, 0, 36, 0, 0, 1, 5)
					else
						Map_Block_Change(-1, Map_ID, Offset_X + ix, Offset_Y + iy, 0, 42, 0, 0, 1, 5)
					end
				end
			end
			
			for ix = X_Min, X_Max do
				for iy = X_Min, X_Max do
					Map_Block_Change(-1, Map_ID, Offset_X + ix, Offset_Y + iy, Offset_Z, 0, 0, 0, 1, 5)
				end
			end
			
			for i = X_Min, X_Max do
				Map_Block_Change(-1, Map_ID, Offset_X - i, Offset_Y, Offset_Z, Material_Line, 0, 0, 1, 5)
				Map_Block_Change(-1, Map_ID, Offset_X, Offset_Y + i, Offset_Z, Material_Line, 0, 0, 1, 5)
			end
			
			for i = 0, X_Max*Scale do
				Map_Block_Change(-1, Map_ID, Offset_X - i/Scale, Offset_Y + 1, Offset_Z, Material_Line, 0, 0, 1, 5)
				Map_Block_Change(-1, Map_ID, Offset_X + i/Scale, Offset_Y + 1, Offset_Z, Material_Line, 0, 0, 1, 5)
				Map_Block_Change(-1, Map_ID, Offset_X - 1, Offset_Y - i/Scale, Offset_Z, Material_Line, 0, 0, 1, 5)
				Map_Block_Change(-1, Map_ID, Offset_X - 1, Offset_Y + i/Scale, Offset_Z, Material_Line, 0, 0, 1, 5)
			end
			
			local Y_Old = 0
			
			for x = X_Min-1, X_Max do
				--lua.dostring(Message)
				local X_Real = x * Scale
				local String = "return "..string.gsub (String_0, "x", "("..tostring(X_Real)..")")
				local Function = loadstring(String)
				local Y_Real = Function()
				if x >= X_Min then
					--Map_Block_Change_Fast(-1, Map_ID, Offset_X - x, Offset_Y + Y_Real/Scale, Offset_Z, Material_Graph, 5, 0, 0, 1)
					Line(Map_ID, Offset_X - x, Offset_Y + Y_Real/Scale, Offset_Z, Offset_X - x + 1, Offset_Y + Y_Old/Scale, Offset_Z, Material_Graph)
				end
				Y_Old = Y_Real
			end
			System_Message_Network_Send_2_All(Map_ID, "&c Done")
		elseif string.find(Message, "=") ~= nil then
			System_Message_Network_Send_2_All(Map_ID, "&c Example: y = x")
		end
	end
	
	return Result
end

System_Message_Network_Send_2_All(258, "&c Script loaded.")
