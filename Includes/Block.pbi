; ########################################## Dokumentation ##########################################

; Physikalische Eigenschaften:
; 0 = Keine Physik
; 10 = Fällt gerade herunter
; 11 = Lässt maximal 45° Schrägen zu (Bildet Pyramiden)
; 20 = Minecraft original Fluidphysik (Block dupliziert sich seitlich und nach unten)
; 21 = Realistischeres Fluid (Block Fällt nach unten und füllt flächen aus)

; ########################################## Variablen ##########################################

Structure Block_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Block_Main.Block_Main

; #################################################################
; !!! Struktur mit Blöcken befindet sich in Main_Structures.pbi !!!
; #################################################################
Global Dim Block.Block(255)

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Block_Load(Filename.s)
  If OpenPreferences(Filename.s)
    
    For i = 0 To 255
      PreferenceGroup(Str(i))
      Block(i)\Name = ReadPreferenceString("Name", "")
      Block(i)\On_Client = ReadPreferenceLong("On_Client", 46)
      Block(i)\Physic = ReadPreferenceLong("Physic", 0)
      Block(i)\Physic_Plugin = ReadPreferenceString("Physic_Plugin", "")
      Block(i)\Do_Time = ReadPreferenceLong("Do_Time", 1000)
      Block(i)\Do_Time_Random = ReadPreferenceLong("Do_Time_Random", 100)
      Block(i)\Do_Repeat = ReadPreferenceLong("Do_Repeat", 0)
      Block(i)\Do_By_Load = ReadPreferenceLong("Do_By_Load", 0)
      Block(i)\Create_Plugin = ReadPreferenceString("Create_Plugin", "")
      Block(i)\Delete_Plugin = ReadPreferenceString("Delete_Plugin", "")
      Block(i)\Replace_By_Load = ReadPreferenceLong("Replace_By_Load", -1)
      Block(i)\Rank_Place = ReadPreferenceLong("Rank_Place", 32767)
      Block(i)\Rank_Delete = ReadPreferenceLong("Rank_Delete", 0)
      Block(i)\After_Delete = ReadPreferenceLong("After_Delete", 0)
      Block(i)\Killer = ReadPreferenceLong("Killer", 0)
      Block(i)\Special = ReadPreferenceLong("Special", 0)
      Block(i)\Color_Overview = ReadPreferenceLong("Color_Overview", RGB(i,i,i))
    Next
    
    Block_Main\Save_File = 1
    
    Block_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Block", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure Block_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; Physic: 0  = Physic Off")
    WriteStringN(File_ID, ";         10 = Original Sand (Falling)")
    WriteStringN(File_ID, ";         11 = New Sand")
    WriteStringN(File_ID, ";         20 = Infinite Water")
    WriteStringN(File_ID, ";         21 = Finite Water")
    WriteStringN(File_ID, "")
    
    For i = 0 To 255
      WriteStringN(File_ID, "["+Str(i)+"]")
      If Block(i)\Name <> ""
        WriteStringN(File_ID, "Name = "+Block(i)\Name)
        WriteStringN(File_ID, "On_Client = "+Str(Block(i)\On_Client))
        WriteStringN(File_ID, "Physic = "+Str(Block(i)\Physic))
        WriteStringN(File_ID, "Physic_Plugin = "+Block(i)\Physic_Plugin)
        WriteStringN(File_ID, "Do_Time = "+Str(Block(i)\Do_Time))
        WriteStringN(File_ID, "Do_Time_Random = "+Str(Block(i)\Do_Time_Random))
        WriteStringN(File_ID, "Do_Repeat = "+Str(Block(i)\Do_Repeat))
        WriteStringN(File_ID, "Do_By_Load = "+Str(Block(i)\Do_By_Load))
        WriteStringN(File_ID, "Create_Plugin = "+Block(i)\Create_Plugin)
        WriteStringN(File_ID, "Delete_Plugin = "+Block(i)\Delete_Plugin)
        WriteStringN(File_ID, "Rank_Place = "+Str(Block(i)\Rank_Place))
        WriteStringN(File_ID, "Rank_Delete = "+Str(Block(i)\Rank_Delete))
        WriteStringN(File_ID, "After_Delete = "+Str(Block(i)\After_Delete))
        WriteStringN(File_ID, "Killer = "+Str(Block(i)\Killer))
        WriteStringN(File_ID, "Special = "+Str(Block(i)\Special))
        WriteStringN(File_ID, "Color_Overview = "+Str(Block(i)\Color_Overview))
      EndIf
      If Block(i)\Replace_By_Load <> -1
        WriteStringN(File_ID, "Replace_By_Load = "+Str(Block(i)\Replace_By_Load))
      EndIf
      WriteStringN(File_ID, "")
    Next
    
    Block_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Block", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

;-######################################################################################

Procedure Block_Get_Pointer(Number) ; Gibt den Pointer zum Element zurück
  If Number >= 0 And Number <= 255
    ProcedureReturn @Block(Number)
  EndIf
  
  ProcedureReturn 0
EndProcedure

;-######################################################################################

Procedure Block_Main()
  If Block_Main\Save_File
    Block_Main\Save_File = 0
    Block_Save(Files_File_Get("Block"))
  EndIf
  
  If Block_Main\Timer_File_Check < Milliseconds()
    Block_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Block"), #PB_Date_Modified)
    If Block_Main\File_Date_Last <> File_Date
      Block_Load(Files_File_Get("Block"))
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 125
; FirstLine = 84
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0