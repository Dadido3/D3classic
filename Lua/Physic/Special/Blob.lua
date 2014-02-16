--System_Message_Network_Send_2_All(-1, "&eBlobs loaded..")
function Physic_Special_Blob(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z)
	--[[----------------------
	------SETTINGS------------
	----------------------]]--
	local priority = 4 --priority, this affects lag of different things.
	local moveRadius= 64 --they'll only move within this distance.
	local dieRadius = 256 --they'll die if outside this distance from nearest player.

	
	
	local Block_Type = Map_Block_Get_Type(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z)
	local Player_Number = Map_Block_Get_Player_Last(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z)
	local NearEntity = -1
	local NearDist = -1
	
	local pX,pY,pZ = 0, 0, 0
	local Prefix, Name, Suffix = "", "", ""
	
	local Entity_Table, Entities = Entity_Get_Table()
	for i = 1, Entities do
		local Entity_ID = Entity_Table[i]
		Prefix, Name, Suffix = Entity_Displayname_Get(Entity_ID)
		local Map_ID = Entity_Get_Map_ID(Entity_ID)
		if Map_ID == Physic_Map_ID then
		--if Name == "Dadido3" then
			local X,Y,Z = Entity_Get_X(Entity_ID),Entity_Get_Y(Entity_ID),Entity_Get_Z(Entity_ID)
			
			local distance = math.sqrt(math.pow(Physic_X-X,2)+math.pow(Physic_Y-Y,2)+math.pow(Physic_Z-Z,2))
			if NearDist == -1 or distance < NearDist then
				NearDist = distance
				NearEntity = Entity_ID
				pX,pY,pZ = Entity_Get_X(NearEntity),Entity_Get_Y(NearEntity),Entity_Get_Z(NearEntity)
				Prefix, Name, Suffix = Entity_Displayname_Get(NearEntity)
			end
		end
	end
	if  NearPlayer == -1 then return end
	if NearDist > dieRadius then
		Map_Block_Change(Player_Number, Physic_Map_ID, Physic_X, Physic_Y, Physic_Z, 0, 0, 1, 1, priority)
		return
	end
	
	local Vector_X = 0
	local Vector_Y = 0
	if NearDist < moveRadius then
		
		if math.floor(pX) == Physic_X then
			Vector_X = 0
		elseif pX < Physic_X then
			Vector_X = -1
		else
			Vector_X = 1
		end
		if math.floor(pY) == Physic_Y then
			Vector_Y = 0
		elseif pY < Physic_Y then
			Vector_Y = -1
		else
			Vector_Y = 1
		end
	end
	--[[if Name == "ylt" or Name == "JAKE0809" then
		Vector_X = 1 - Vector_X
		Vector_Y = 1 - Vector_Y
	end]]
	--Map_Block_Change(Player_Number, Physic_Map_ID, Physic_X, Physic_Y, Physic_Z, 0, 255, 0, 1, 1) --i use this line for killing them all :p
	local below = Map_Block_Get_Type(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z-1)
	if below == 0 then
		Map_Block_Move(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z, Physic_X, Physic_Y, Physic_Z-1, 0, 1 ,priority)
	elseif not (Vector_X == 0 and Vector_Y == 0) then
		for i=-1, 1 do
			local Type = Map_Block_Get_Type(Physic_Map_ID, Physic_X+Vector_X, Physic_Y+Vector_Y, Physic_Z+i)
			if Type == 0 then
				Map_Block_Move(Physic_Map_ID, Physic_X, Physic_Y, Physic_Z, Physic_X+Vector_X, Physic_Y+Vector_Y, Physic_Z+i, 0, 1, priority)
				return
			end
		end
		--hmm, couldnt move in direction..
		--[[local count = 0
		for ix=-1, 1 do
			for iy=-1, 1 do
				for iz=-1, 1 do
					local Type = Map_Block_Get_Type(Physic_Map_ID, Physic_X+ix, Physic_Y+iy, Physic_Z+iz)
					if Type ~= 0 then
						count = count+1
					end
				end
			end
		end
		--all sides = 27
		if count > 25 then
			Map_Block_Change(Player_Number, Physic_Map_ID, Physic_X, Physic_Y, Physic_Z, 0, 255, 0, 1, 1)
		end]]
	end
end

function Physic_Special_Blob_Source(Map_ID, X, Y, Z)
	local Radius = 1
	local Material = 248
	local Player_Number = Map_Block_Get_Player_Last(Map_ID, X, Y, Z)
	
	for ix = -Radius, Radius do
		for iy = -Radius, Radius do
			for iz = -Radius, Radius do
				if Map_Block_Get_Type(Map_ID, X+ix, Y+iy, Z+iz) == 0 then
					Map_Block_Change(Player_Number, Map_ID, X+ix, Y+iy, Z+iz, Material, 1, 1, 1, 2)
				end
			end
		end
	end
	
end

System_Message_Network_Send_2_All(-1, "&cBlobs reloaded")