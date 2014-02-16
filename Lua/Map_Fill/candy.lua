local function tonum(x)
	if x==nil then return 0 else return x end
end
local function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

local Map_Block_Change_Fast = Map_Block_Change_Fast
local Map_Block_Get_Type = Map_Block_Get_Type

local function HMap_Number(X,Y,HMap_Size_X,HMap_Size_Y,HMap_Fields)
	if X == nil or Y == nil then return false end --somethings broken somewhere..
	if X < 0 or X >= HMap_Size_X or
	   Y < 0 or Y >= HMap_Size_Y then return false end
	
	return (X+Y*HMap_Size_X)*HMap_Fields
end

local function HMap_Get_Building(X,Y,HMap_Size_X,HMap_Size_Y,HMap_Fields)
	local Number = HMap_Number(X,Y,HMap_Size_X,HMap_Size_Y)
	if Number == false then return false end
	out = {}
	for i=1,HMap_Fields do
		table.insert(out,MBuildings[number+i-1])
	end
	return unpack(out)
end
local function HMap_Set_Building(X,Y,HMap_Size_X,HMap_Size_Y,HMap_Fields,...)
	local Number = HMap_Number(X,Y,HMap_Size_X,HMap_Size_Y)
	if Number == false then return false end
	out = {}
	for i=0,HMap_Fields do
		MBuildings[number+i] = tonum(arg[i])
	end
end

function Mapfill_candy(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z, arguments)
	System_Message_Network_Send_2_All(Map_ID, "&3arguments: "..arguments)
	local arguments = explode(" ",arguments)
	
	local HMap_Scale = 6
	local area = 4
	local priority = 0
	if arguments[1] and arguments[1] ~= "" then HMap_Scale = tonumber(arguments[1]) end
	if arguments[2] and arguments[2] ~= "" then area = tonumber(arguments[2]) end
	if arguments[3] and arguments[3] ~= "" then priority = tonumber(arguments[3]) end
	
	local ttime = os.clock()
	local time = os.clock()

	--local HMap_Scale = 1
	--System_Message_Network_Send_2_All(Map_ID, "&3Building size: &b".. HMap_Scale)
	local HMap_Size_X = Map_Size_X/HMap_Scale
	local HMap_Size_Y = Map_Size_Y/HMap_Scale
	local MBuildings = {}
	local HMap_Fields = 1
	for x=0, HMap_Size_X do --generate all sizes
		for y = 0, HMap_Size_Y do
			local number = (x+y*HMap_Size_X)*HMap_Fields
			MBuildings[number] = math.random(0,Map_Size_Z)
		end
	end

	local time = os.clock()
	for x=0, HMap_Size_X do
		for y = 0, HMap_Size_Y do
			--local priority = 0
			local number = (x+y*HMap_Size_X)*HMap_Fields
			local oheight = MBuildings[number]
			local height = oheight*priority
			--local area = 4
			
			
			local count = 0
			for ax=-area, area do
				for ay=-area, area do
					--local number = x+ax+(y+ay)*HMap_Size_X*HMap_Fields
					--height = height+tonum(MBuildings[number])
					if x+ax < 0 or x+ax >= HMap_Size_X or
						y+ay < 0 or y+ay >= HMap_Size_Y then
					else
						local number = x+ax+(y+ay)*HMap_Size_X*HMap_Fields
						local bheight = tonum(MBuildings[number])
						height = height+bheight
						count = count+1
					end
				end
			end
			height = math.floor(height/(count+priority))
			local bx = x*HMap_Scale
			local by = y*HMap_Scale
			local mat = 21
			for iz=0,height do
				if mat > 33 then mat = 21 end
				for ix=0,HMap_Scale-1 do
					for iy=0,HMap_Scale-1 do
						Map_Block_Change(-1, Map_ID, bx+ix,by+iy,iz, mat, 0, 0, 0, 0)
					end
				end
				mat = mat+1
			end
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&2Constructed \"candy\" in &a"..os.clock()-time.."&2s.")
	System_Message_Network_Send_2_All(Map_ID, "&2Took a total of &a"..os.clock()-ttime.."&2s.")
end
System_Message_Network_Send_2_All(-1, "&0dbg4")

--[[function Mapfill_candy(...)
	print(pcall(Mapfill_candy2,...))
end]]