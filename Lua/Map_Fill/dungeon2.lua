function Mapfill_dungeon(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, Argumentstring)
	for X=0,Map_Size_X-1 do
		for Y=0,Map_Size_Y-1 do
			local Z = 0
			--for Z=0,Map_Size_Z-1 do
				Map_Block_Change(-1, Map_ID, X, Y, Z, 49, 0, 0, 0, 0)
			--end
		end
	end
	local size = 10
	local midsize = math.ceil(size/2)
	for mX=0,math.ceil(Map_Size_X/size) do
		for mY=0,Map_Size_Y/size do
			local sX = mX*size
			local sY = mY*size
			local mX = midsize
			local mY = midsize
			
			local lsx = math.random(1,2) --0 = 0, 1 = .5, 2 = 1
			local lex = math.random(1,2)
			
			local lsy = math.random(1,2)
			local ley = math.random(1,2)
			if Map_Block_Get_Type(Map_ID, sX-1, sY+midsize, 0) == 21 then
				lsx = 0
				--[[if math.random(1,20) == 1 then
					lex = 2
				elseif math.random(1,20) == 1 then
					if lsy ~= 0 then lsy = 1 end
					ley = 2
				elseif math.random(1,20) == 1 then
					lex = 2
					if lsy ~= 0 then lsy = 1 end
					ley = 2
				end]]
				--lex = 2
			end
			if Map_Block_Get_Type(Map_ID, sX+midsize, sY-1, 0) == 21 then
				lsy = 0
				--[[if math.random(1,20) == 1 then
					ley = 2
				elseif math.random(1,20) == 1 then
					if lsx ~= 0 then lsx = 1 end
					lex = 2
				elseif math.random(1,20) == 1 then
					if lsx ~= 0 then lsx = 1 end
					lex = 2
					ley = 2
				end]]
			end
			
			lsx,lex = math.min(lsx,lex)*midsize,math.max(lsx,lex)*midsize
			lsy,ley = math.min(lsx,lex)*midsize,math.max(lsx,lex)*midsize
			
			if (lex == 1 or ley == 1) then
				local rsize = math.random(1,midsize)
				for x=-rsize,rsize do
					for y=-rsize,rsize do
						Map_Block_Change(-1, Map_ID, sX+midsize+x, sY+midsize+y, iz, 21, 0, 0, 0, 0)
					end
				end
			end
			
			
			--if lsx ~= lex then
				for i=lsx,lex do
					local iz = 0
					--for iz=0,Map_Size_Z-1 do
						Map_Block_Change(-1, Map_ID, sX+i, sY+midsize, iz, 21, 0, 0, 0, 0)
						Map_Block_Change(-1, Map_ID, sX+i, sY+midsize+1, iz, 21, 0, 0, 0, 0)
					--end
				end
			--end
			--if lsy ~= ley then
				for i=lsy,ley do
					local iz = 0
					--for iz=0,Map_Size_Z-1 do
						Map_Block_Change(-1, Map_ID, sX+midsize, sY+i, iz, 21, 0, 0, 0, 0)
						Map_Block_Change(-1, Map_ID, sX+midsize+1, sY+i, iz, 21, 0, 0, 0, 0)
					--end
				end
			--end
			Map_Block_Change(-1, Map_ID, sX, sY, 0, 36, 0, 0, 0, 0)
		end
	end
end
System_Message_Network_Send_2_All(-1, "&edungeon reloaded.")
