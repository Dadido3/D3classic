function Mapfill_fractal(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
	Material = 21
	
	Offset_X = 400--Map_Size_X/2
	Offset_Y = 240--Map_Size_Y/2
	Offset_Z = 0
	
	Max_Z = 75
	
	AZ1 = 0.0
	G = 0.0
	
	for Y = -1.25, 1.25, 1/200 do
		for X = -2.0, 1.255, 1/200 do
			
			AZ = 0.0
			BZ = 0.0
			Z = 0.0
			
			repeat 
				AZ = AZ*AZ - BZ*BZ + X
				BZ = AZ1 * BZ * 2 + Y
				AZ1 = AZ
				G = AZ*AZ + BZ*BZ
				Z = Z + 1
			until G >= 4 or Z >= Max_Z
			
			--for iz = Z, Z do
			--	Map_Block_Change(-1, Map_ID, Offset_X + X*200.0, Offset_Y + Y*200.0, Offset_Z + iz, Material, 0, 0, 0, 0)
			--end
			
			Real_Z = Z / 3
			
			for iz = 0, Real_Z do
				Real_Material = Z * 49 / 75
				Map_Block_Change(-1, Map_ID, Offset_X + X*200.0, Offset_Y + Y*200.0, Offset_Z + iz, Real_Material, 0, 0, 0, 0)
			end
			
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Fractal done.")
	
end
