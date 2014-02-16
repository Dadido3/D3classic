function Mapfill_math(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
	Radius_0 = 38
	Radius_1 = 40
	Radius_2 = 50
	
	Material = 21
	
	Genauigkeit = 0.0000000000001
	
	Offset_X = Map_Size_X/2
	Offset_Y = Map_Size_Y/2
	Offset_Z = Map_Size_Z/2
	
	function Equalation(X)
		--return math.tan(X/10)*4
		--return X*X
		return math.sin(X/10)*20 + math.tan(X/12)*4
	end
	
	for New_X = 0, Map_Size_X/2 do
		for New_Y = -Map_Size_Y/2, Map_Size_Y/2 do
			--for New_Z = -Radius_2, Radius_2 do
				--Entf = New_X*New_X + New_Y*New_Y + New_Z*New_Z + math.cos(math.atan(New_X/New_Y)*2)*500 + math.sin(math.atan(New_X/New_Y)*5)*800
				--Entf = math.sin(math.atan(New_Z/New_Y)*3)*1000 + math.sin(math.atan(New_X/New_Y)*2)*1000
				--if Entf <= Radius_1*Radius_1 and Entf >= Radius_0*Radius_0 then
				--	if Map_Block_Get_Type(Map_ID, Offset_X + New_X, Offset_Y + New_Y, Offset_Z + New_Z) == 0 then
				--		Map_Block_Change(0, Map_ID, Offset_X + New_X, Offset_Y + New_Y, Offset_Z + New_Z, 1, Material, 5)
				--	end
				--end
				Entf = math.sqrt(New_X*New_X + New_Y*New_Y)
				New_Z = Equalation(Entf)
				m_0 = math.abs( Equalation(Entf) - Equalation(Entf-Genauigkeit) )
				m_1 = math.abs( Equalation(Entf) - Equalation(Entf+Genauigkeit) )
				
				if m_0 < m_1 then
					m = m_0
				else
					m = m_1
				end
				
				if m < 100*Genauigkeit then
					m = m / Genauigkeit
				else
					m = 100
				end
				
				m = math.ceil(m)
				
				for iz = 1-m/2, m/2 do
					Map_Block_Change(-1, Map_ID, Offset_X + New_X, Offset_Y + New_Y, Offset_Z + New_Z - iz, Material, 0, 0, 0, 0)
				end
			--end
		end
	end
	
	System_Message_Network_Send_2_All(Map_ID, "&c Map done.")
	
end
