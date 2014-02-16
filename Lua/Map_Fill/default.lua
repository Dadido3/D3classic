function Mapfill_default2(Map_ID,SizeX,SizeY,SizeZ)
	local Corner1, Corner2, Corner3, Corner4
	local Heightmap = {}

	--[[
		Island : 0.6, 1, 0.3, 0.35
		Lake : 0.6, 0.9, -0.35, 0.55
		Moutain : 1, 0.5,0.1, 0.5
		Hills :1, 0.5, 0, 0.5
	]]
	local smoothingOver = 1
	local smoothingUnder = 0.5
	local midpoint = 0.5
	local sides = 0.5

	function FIllLayer(Z,Block)
		for IndexX=SizeX-1,0,-1 do
			for IndexY=SizeY-1,0,-1 do
				Map_Block_Change(-1, Map_ID, IndexX, IndexY, Z, Block, 0, 0, 0, 0)
			end
		end
	end

	--Converted from http://www.ic.sunysb.edu/Stu/jseyster/plasma/source.html
	--AND code from fCraft [fcraft.sourceforge.net]

	--Randomly displaces value for midpoint depending on size
	--of grid piece.
	function Displace(num)
		return (math.random() - 0.5) * (num / (SizeX + SizeY) * 3)
	end

	--This is the recursive function that implements the random midpoint
	--displacement algorithm.  It will call itself until the grid pieces
	--become smaller than one pixel.
	function DivideGrid(X, Y, Width, Height, C1, C2, C3, C4, isTop)
		local Edge1, Edge2, Edge3, Edge4, Middle
		local newWidth = Width / 2
		local newHeight = Height / 2

		if (Width > 1 or Height > 1) then
			local Middle
			if isTop then
				Middle = (C1 + C2 + C3 + C4) / 4 + midpoint
			else
				Middle = (C1 + C2 + C3 + C4) / 4 + Displace( newWidth + newHeight )	--Randomly displace the midpoint!
			end
			local Edge1 = (C1 + C2) / 2	--Calculate the edges by averaging the two corners of each edge.
			local Edge2 = (C2 + C3) / 2
			local Edge3 = (C3 + C4) / 2
			local Edge4 = (C4 + C1) / 2

			--Make sure that the midpoint doesn't accidentally "randomly displaced" past the boundaries!
			if Middle < 0 then
				Middle = 0
			elseif (Middle > 1.0) then
				Middle = 1.0
			end

			--Do the operation over again for each of the four new grids.
			DivideGrid(X, Y, newWidth, newHeight, C1, Edge1, Middle, Edge4, False)
			DivideGrid(X + newWidth, Y, newWidth, newHeight, Edge1, C2, Edge2, Middle, False)
			DivideGrid(X + newWidth, Y + newHeight, newWidth, newHeight, Middle, Edge2, C3, Edge3, False)
			DivideGrid(X, Y + newHeight, newWidth, newHeight, Edge4, Middle, Edge3, C4, False)

		else	--This is the "base case," where each grid piece is less than the size of a pixel.
			--The four corners of the grid piece will be averaged and drawn as a single pixel.
			Heightmap[X][Y] = ((C1 + C2 + C3 + C4) / 4)
			if Width == 2 then
				Heightmap[X+1][Y] = C;
			end
			if Height == 2 then
				Heightmap[X][Y+1] = C;
			end
			if Width == 2 and Height == 2 then
				Heightmap[X+1][Y+1] = C;
			end
			--Alert((C1 + C2 + C3 + C4) / 4)
		end
	end

	--Get better pseudo random number
	math.random()
	math.random()
	math.random()

	--InitPerlinNoise(math.random(2000000000))

	--Grass flat
	--[[
	for IndexZ=(SizeZ/2-10),0,-1 do
		FIllLayer(IndexZ,1)
	end
	for IndexZ=(SizeZ/2-10),(SizeZ/2-1) do
		FIllLayer(IndexZ,3)
	end
	FIllLayer(SizeZ/2-1,2)
	]]

	for IndexX=SizeX-1,0,-1 do
		Heightmap[IndexX] = {}
	end
	--Generate Heighmap

	--[[
	for IndexX=SizeX-1,0,-1 do
		Heightmap[IndexX] = {}
		for IndexY=SizeY-1,0,-1 do
			Heightmap[IndexX][IndexY] = PerlinNoise2D(IndexX,IndexY)
		end
	end
	]]

	Corner1 = sides +(math.random() - 0.5) * 0.5;
	Corner2 = sides +(math.random() - 0.5) * 0.5;
	Corner3 = sides +(math.random() - 0.5) * 0.5;
	Corner4 = sides +(math.random() - 0.5) * 0.5;

	DivideGrid(0, 0, SizeX, SizeY, Corner1, Corner2, Corner3, Corner4, True);


	local Water = 0.50
	
	for IndexX=SizeX-1,0,-1 do
		for IndexY= SizeY-1, 0, -1 do
			Height = Heightmap[IndexX][IndexY]
			if Height > Water then
				Height = (Height - Water) * smoothingOver + Water;
				Map_Block_Change(-1, Map_ID, IndexX,  IndexY, math.floor(Height * SizeZ), 2 , 0, 0, 0, 0)
				for Index = math.floor(Height * SizeZ)- 1, 0, -1 do
					if Height * SizeZ - Index < 5  then
						Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, Index, 3 , 0, 0, 0, 0)
					else
						Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, Index, 1 , 0, 0, 0, 0)
					end
				end
            else
            	Height = (Height - Water) * smoothingUnder + Water;
                Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, math.floor(Water * Height), 9 , 0, 0, 0, 0)
            	for Index = math.floor(Water * SizeZ) - 1, (Height * SizeZ), -1 do
                    Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, Index, 9 , 0, 0, 0, 0)
                end
                Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, math.floor( Height * SizeZ ), 12 , 0, 0, 0, 0);
                for Index = math.floor(Height * SizeZ) - 1, 0, -1 do
                    Map_Block_Change(-1, Map_ID,  IndexX,  IndexY, Index, 1 , 0, 0, 0, 0);
                end
            end
		end
	end

end
function Mapfill_default(...)
	print(pcall(Mapfill_default2,...))
end

System_Message_Network_Send_2_All(-1, "&edefault reloaded.")