; ########################################## Variablen ##########################################

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Map_Overview_Save_2D(*Map_Data_Element.Map_Data, Directory.s) ; Speichert ein Abbild der Karte als Image
  
  *Pointer.Map_Block
  
  If 1 ; Hier sollte das Element geprüft werden!
    Map_Size_X = *Map_Data_Element\Size_X
    Map_Size_Y = *Map_Data_Element\Size_Y
    Map_Size_Z = *Map_Data_Element\Size_Z
    Map_Spawn_X = *Map_Data_Element\Spawn_X
    Map_Spawn_Y = *Map_Data_Element\Spawn_Y
    Map_Spawn_Z = *Map_Data_Element\Spawn_Z
    Map_Spawn_Rot = *Map_Data_Element\Spawn_Rot
    Map_Spawn_Look = *Map_Data_Element\Spawn_Look
    *Map_Data = *Map_Data_Element\Data
    Map_Data_Size = Map_Get_Size(Map_Size_X, Map_Size_Y, Map_Size_Z, #Map_Block_Element_Size)
    If Directory.s = ""
      Directory.s = *Map_Data_Element\Directory
    EndIf
    Filename.s = Directory+#Map_Filename_Overview
    
    Image_ID.i = CreateImage(#PB_Any, Map_Size_X, Map_Size_Y)
    
    If IsImage(Image_ID)
      If StartDrawing(ImageOutput(Image_ID))
        
        Counter_Max = 50
        
        For iy = 0 To Map_Size_Y-1
          For ix = 0 To Map_Size_X-1
            Break_Var = 0
            For iz = Map_Size_Z-1 To 0 Step -1
              If Counter_Max > 0
                UnlockMutex(Main\Mutex)
                *Pointer = *Map_Data + Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, #Map_Block_Element_Size)
                Type = *Pointer\Type & 255
                LockMutex(Main\Mutex)
                Counter_Max = 50
              Else
                *Pointer = *Map_Data + Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, #Map_Block_Element_Size)
                Type = *Pointer\Type & 255
              EndIf
              Counter_Max - 1
              If Type <> 0
                Color = Block(Type)\Color_Overview
                If Color <> -1
                  R = Red(Color)
                  G = Green(Color)
                  B = Blue(Color)
                  Color_0 = RGB(R*0.8, G*0.8, B*0.8)
                  Color_1 = RGB(R*0.6, G*0.6, B*0.6)
                  
                  X = Offset_X + ix - iy
                  Y = Offset_Y + iy + ix
                  
                  Plot(ix, iy, Color)
                  
                EndIf
                
                Break
              EndIf
            Next
          Next
        Next
        
        StopDrawing()
      EndIf
      
      If SaveImage(Image_ID, Filename, #PB_ImagePlugin_PNG)
        Log_Add("Map_Overview", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Else
        Log_Add("Map_Overview", Lang_Get("", "File not saved", Filename), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
      
      FreeImage(Image_ID)
    EndIf
  EndIf
EndProcedure

Procedure Map_Overview_Save_Iso_Fast(*Map_Data_Element.Map_Data, Filename.s) ; Speichert ein Abbild der Karte als Image (Isometrisch)
  
  *Pointer.Map_Block
  
  If 1 ; Hier sollte das Element geprüft werden!
    Map_Size_X = *Map_Data_Element\Size_X
    Map_Size_Y = *Map_Data_Element\Size_Y
    Map_Size_Z = *Map_Data_Element\Size_Z
    Map_Spawn_X = *Map_Data_Element\Spawn_X
    Map_Spawn_Y = *Map_Data_Element\Spawn_Y
    Map_Spawn_Z = *Map_Data_Element\Spawn_Z
    Map_Spawn_Rot = *Map_Data_Element\Spawn_Rot
    Map_Spawn_Look = *Map_Data_Element\Spawn_Look
    *Map_Data = *Map_Data_Element\Data
    Map_Data_Size = Map_Get_Size(Map_Size_X, Map_Size_Y, Map_Size_Z, #Map_Block_Element_Size)
    If Directory.s = ""
      Directory.s = *Map_Data_Element\Directory
    EndIf
    Filename.s = Directory+#Map_Filename_Overview
    
    
    Image_Size_X = Map_Size_X+Map_Size_Y
    Image_Size_Y = Map_Size_X+Map_Size_Y + Map_Size_Z
    Offset_X = Map_Size_Y
    Offset_Y = Map_Size_Z
    
    
    Image_ID.i = CreateImage(#PB_Any, Image_Size_X, Image_Size_Y)
    
    If IsImage(Image_ID)
      If StartDrawing(ImageOutput(Image_ID))
        
        Box(0, 0, Image_Size_X, Image_Size_Y, RGB(255,255,255))
        
        Counter_Max = 50
        
        For iy = 0 To Map_Size_Y-1
          For ix = 0 To Map_Size_X-1
            Break_Var = 0
            For iz = Map_Size_Z-1 To 0 Step -1
              If Counter_Max > 0
                UnlockMutex(Main\Mutex)
                *Pointer = *Map_Data + Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, #Map_Block_Element_Size)
                Type = *Pointer\Type
                LockMutex(Main\Mutex)
                Counter_Max = 50
              Else
                *Pointer = *Map_Data + Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, #Map_Block_Element_Size)
                Type = *Pointer\Type
              EndIf
              Counter_Max - 1
              
              If Type <> 0
                Color = Block(Type)\Color_Overview
                If Color <> -1
                  R = Red(Color)
                  G = Green(Color)
                  B = Blue(Color)
                  Color_0 = RGB(R*0.8, G*0.8, B*0.8)
                  Color_1 = RGB(R*0.6, G*0.6, B*0.6)
                  
                  X = Offset_X + ix - iy
                  Y = Offset_Y + iy + ix
                  
                  LineXY(X, Y-1, X, Y-iz-1, Color_1)
                  LineXY(X+1, Y, X+1, Y-iz, Color_0)
                  LineXY(X, Y, X, Y-iz, Color)
                  
                EndIf
                
                Break
              EndIf
            Next
          Next
        Next
        
        StopDrawing()
      EndIf
      
      If SaveImage(Image_ID, Filename, #PB_ImagePlugin_PNG)
        Log_Add("Map_Overview", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Else
        Log_Add("Map_Overview", Lang_Get("", "File not saved", Filename), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
      
      FreeImage(Image_ID)
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 168
; FirstLine = 123
; Folding = -
; EnableThread
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0