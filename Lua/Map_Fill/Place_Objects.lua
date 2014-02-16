function Place_Palm(Map_ID, Map_X, Map_Y, Map_Z)
	local Size
	local iz
	
	Size = 4 + math.random(3)
	for iz = 1, Size do
		Map_Block_Change(-1, Map_ID, Map_X, Map_Y, Map_Z+iz, 17, 0, 0, 0, 0)
	end
	Map_Block_Change(-1, Map_ID, Map_X+1, Map_Y, Map_Z+Size+1, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X-1, Map_Y, Map_Z+Size+1, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X, Map_Y+1, Map_Z+Size+1, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X, Map_Y-1, Map_Z+Size+1, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X+2, Map_Y, Map_Z+Size, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X-2, Map_Y, Map_Z+Size, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X, Map_Y+2, Map_Z+Size, 18, 0, 0, 0, 0)
	Map_Block_Change(-1, Map_ID, Map_X, Map_Y-2, Map_Z+Size, 18, 0, 0, 0, 0)
	return
end

function Place_Tree(Map_ID, X, Y, Z, Size, Send)
	for i = 1, Size do
		Map_Block_Change(-1, Map_ID, X, Y, Z+i, 17, 5, 0, 0, Send)
	end
	
	local Radius = 3
	for New_X = -Radius, Radius do
		for New_Y = -Radius, Radius do
			for New_Z = -Radius, Radius do
				local Entf = New_X*New_X + New_Y*New_Y + New_Z*New_Z
				if Entf < Radius*Radius then
					local Type = Map_Block_Get_Type(Map_ID, X + New_X, Y + New_Y, Z + Size + New_Z)
					if Type == 0 then
						Map_Block_Change(-1, Map_ID, X + New_X, Y + New_Y, Z + Size + New_Z, 18, 5, 0, 0, Send)
					end
				end
			end
		end
	end
end