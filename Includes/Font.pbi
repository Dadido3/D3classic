; ########################################## Variablen ##########################################

Structure Font_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Font_Main.Font_Main

Structure Font
  ID.s                      ; Font-ID
  Char_Width_Ind.a [256]    ; Breite eines Zeichens (für jedes individuell)
  Char_Width.a              ; Breite eines Zeichens
  Char_Height.a             ; Höhe eines Zeichens
  Image_File.s              ; Datei des Font-Sprites
  *Buffer                   ; Speicher für die Schriftart
EndStructure
Global NewList Font.Font()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Font_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ForEach Font()
      Mem_Free(Font()\Buffer)
      DeleteElement(Font())
    Next
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Font())
        Font()\ID = PreferenceGroupName()
        Font()\Image_File = ReadPreferenceString("Image_File", "")
        Temp_Image_ID = LoadImage(#PB_Any, Font()\Image_File)
        If IsImage(Temp_Image_ID)
          
          Font()\Char_Width = ImageWidth(Temp_Image_ID)/16
          Font()\Char_Height = ImageHeight(Temp_Image_ID)/16
          
          Font()\Buffer = Mem_Allocate(Font()\Char_Width*Font()\Char_Height*256, #PB_Compiler_File, #PB_Compiler_Line, "Font()\Buffer")
          
          If Font()\Buffer
            If StartDrawing(ImageOutput(Temp_Image_ID))
              
              For Char = 0 To 255
                Font()\Char_Width_Ind[Char] = 1
                For ox = 0 To Font()\Char_Width-1
                  For oy = 0 To Font()\Char_Height-1
                    cx = (Char % 16) * Font()\Char_Width
                    cy = (Char / 16) * Font()\Char_Height
                    *Buffer_Adress = Font()\Buffer + Char*Font()\Char_Width*Font()\Char_Height + ox + oy * Font()\Char_Width
                    If Point(cx+ox, cy+oy)
                      PokeB(*Buffer_Adress, 255)
                    Else
                      PokeB(*Buffer_Adress, 0)
                      If Font()\Char_Width_Ind[Char] < ox + 2
                        Font()\Char_Width_Ind[Char] = ox + 2
                      EndIf
                    EndIf
                  Next
                Next
              Next
              
              ; ######## Leerzeichen
              Font()\Char_Width_Ind[32] = Font()\Char_Width
              
              StopDrawing()
            EndIf
          Else
            Log_Add("Font", Lang_Get("", "Font not loaded: Memory-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
            DeleteElement(Font())
          EndIf
          
          FreeImage(Temp_Image_ID)
        Else
          Log_Add("Font", Lang_Get("", "Font not loaded: Can't load image", Font()\Image_File), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          DeleteElement(Font())
        EndIf
        
      Wend
    EndIf
    
    Font_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Font", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure Font_Select_ID(Font_ID.s)
  If ListIndex(Font()) <> -1 And LCase(Font()\ID) = LCase(Font_ID)
    ProcedureReturn #True
  Else
    ForEach Font()
      If LCase(Font()\ID) = LCase(Font_ID)
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure Font_Draw_Character(Player_Number, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, Char.a, Material_F, Material_B)
  If Font_Select_ID(Font_ID)
    Width = Font()\Char_Width_Ind[Char]
    If Width > Font()\Char_Width : Width = Font()\Char_Width : EndIf
    For ox = 0 To Width-1
      For oy = 0 To Font()\Char_Height-1
        *Buffer_Adress = Font()\Buffer + Char*Font()\Char_Width*Font()\Char_Height + ox + (Font()\Char_Height-oy-1) * Font()\Char_Width
        vox.f = ox * V_X
        voy.f = ox * V_Y
        If PeekB(*Buffer_Adress)
          Map_Block_Change(Player_Number, Map_Get_Pointer(Map_ID), X+vox, Y+voy, Z+oy, Material_B, 0, 0, 1, 1)
        Else
          Map_Block_Change(Player_Number, Map_Get_Pointer(Map_ID), X+vox, Y+voy, Z+oy, Material_F, 0, 0, 1, 1)
        EndIf
      Next
    Next
  EndIf
EndProcedure

Procedure Font_Draw_Character_Player(*Player.Player_List, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, Char.a, Material_F, Material_B)
  If Font_Select_ID(Font_ID)
    Width = Font()\Char_Width_Ind[Char]
    If Width > Font()\Char_Width : Width = Font()\Char_Width : EndIf
    For ox = 0 To Width-1
      For oy = 0 To Font()\Char_Height-1
        *Buffer_Adress = Font()\Buffer + Char*Font()\Char_Width*Font()\Char_Height + ox + (Font()\Char_Height-oy-1) * Font()\Char_Width
        vox.f = ox * V_X
        voy.f = ox * V_Y
        If PeekB(*Buffer_Adress)
          Map_Block_Change_Player(*Player, Map_Get_Pointer(Map_ID), X+vox, Y+voy, Z+oy, Material_B, 1, 0, 1, 1)
        Else
          Map_Block_Change_Player(*Player, Map_Get_Pointer(Map_ID), X+vox, Y+voy, Z+oy, Material_F, 1, 0, 1, 1)
        EndIf
      Next
    Next
  EndIf
EndProcedure

Procedure Font_Draw_Text(Player_Number, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, String.s, Material_F, Material_B)
  If Font_Select_ID(Font_ID)
    X_Offset.f = 0
    Y_Offset.f = 0
    
    For i = 1 To Len(String)
      Char.a = Asc(Mid(String, i, 1))
      Font_Draw_Character(Player_Number, Font_ID, Map_ID, X+X_Offset, Y+Y_Offset, Z, V_X, V_Y, Char, Material_F, Material_B)
      X_Offset.f + V_X * Font()\Char_Width_Ind[Char]
      Y_Offset.f + V_Y * Font()\Char_Width_Ind[Char]
    Next
  EndIf
EndProcedure

Procedure Font_Draw_Text_Player(*Player.Player_List, Font_ID.s, Map_ID, X, Y, Z, V_X.f, V_Y.f, String.s, Material_F, Material_B)
  If Font_Select_ID(Font_ID)
    X_Offset.f = 0
    Y_Offset.f = 0
    
    For i = 1 To Len(String)
      Char.a = Asc(Mid(String, i, 1))
      Font_Draw_Character_Player(*Player, Font_ID, Map_ID, X+X_Offset, Y+Y_Offset, Z, V_X, V_Y, Char, Material_F, Material_B)
      X_Offset.f + V_X * Font()\Char_Width_Ind[Char]
      Y_Offset.f + V_Y * Font()\Char_Width_Ind[Char]
    Next
  EndIf
EndProcedure

Procedure Font_Main()
  If Font_Main\Timer_File_Check < Milliseconds()
    Font_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Font"), #PB_Date_Modified)
    If Font_Main\File_Date_Last <> File_Date
      Font_Load(Files_File_Get("Font"))
    EndIf
  EndIf
  
  
  ; ############################# Debug
  Global Timer_Debug
  If 0;Timer_Debug < Milliseconds()
    Timer_Debug = Milliseconds() + 500
    
    LockMutex(Mem_Main\Mutex_ID)
    Max = 1
    Min = 2147483647
    ForEach Mem_Usage_Chronic()
      If Max < Mem_Usage_Chronic()\Page
        Max = Mem_Usage_Chronic()\Page
      EndIf
      If Min > Mem_Usage_Chronic()\Page
        Min = Mem_Usage_Chronic()\Page
      EndIf
      If ListIndex(Mem_Usage_Chronic()) >= 30
        Break
      EndIf
    Next
    Offset_X = 170
    Offset_Y = 20 ; (Z)
    ForEach Mem_Usage_Chronic()
      Factor_Real.f = (Mem_Usage_Chronic()\Page-Min)/(Max-Min)
      For iy = 0 To 99
        If iy > Factor_Real*100
          Map_Block_Change(-1, Map_Get_Pointer(0), ListIndex(Mem_Usage_Chronic())+Offset_X, 0, iy+Offset_Y, 34, 0, 0, 1, 1)
        Else
          Map_Block_Change(-1, Map_Get_Pointer(0), ListIndex(Mem_Usage_Chronic())+Offset_X, 0, iy+Offset_Y, 21, 0, 0, 1, 1)
        EndIf
      Next
      If ListIndex(Mem_Usage_Chronic()) >= 30
        Break
      EndIf
    Next
    UnlockMutex(Mem_Main\Mutex_ID)
    
    i = 10
    Font_Draw_Text(-1, "minecraft" , 0, 2, 0, i, 1, 0, "Mem: "+StrF(Mem_Get_PagefileUsage()/1000000, 6)+"MB   ", 41, 49)
    i + 10
    Font_Draw_Text(-1, "minecraft" , 0, 2, 0, i, 1, 0, Str((Mem_Main\Timer_Stats-Milliseconds())/1000)+"s   ", 41, 49)
    i + 10
    
    LockMutex(Watchdog_Main\Mutex_ID)
    ForEach Watchdog_Module()
      Font_Draw_Text(-1, "minecraft" , 0, 2, 0, i, 1, 0, Watchdog_Module()\Name + ": " + StrF(Watchdog_Module()\CPU_Usage,2) + "%   ", 42, 49)
      i + 10
    Next
    UnlockMutex(Watchdog_Main\Mutex_ID)
    Font_Draw_Text(-1, "minecraft" , 0, 2, 0, i, 1, 0, "Time: "+Str(Milliseconds()/1000)+"s   ", 41, 49)
    i + 10
    Font_Draw_Text(-1, "minecraft" , 0, 2, 0, i, 1, 0, "Upload: "+StrD(Network_Main\Upload_Rate/1000, 3)+"kB/s   ", 41, 49)
    i + 10
    Font_Draw_Text(-1, "standart" , 0, 2, 0, i, 1, 0, "This is an old text!   ", 41, 49)
    i + 10
  EndIf
  ; ##############################
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 223
; FirstLine = 193
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0