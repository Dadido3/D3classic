; ########################################## Variablen ##########################################

#Map_Filename_Data = "Data-Layer.gz"
#Map_Filename_Rank = "Rank-Layer.txt"
#Map_Filename_Overview = "Overview.png"
#Map_Filename_Config = "Config.txt"
#Map_Filename_Teleporter = "Teleporter.txt"

#Map_File_Version = 1050

#Map_Block_Element_Size = 4

Structure Map_Main
  Blockchanging_Thread_ID.i   ; ID des Blockchanging-Threads
  Physic_Thread_ID.i          ; ID des Physic-Threads
  Action_Thread_ID.i          ; ID des Action-Threads
  Save_File.b                 ; Zeigt an, ob gespeichert werden soll (Map-Liste)
  Save_File_Timer.l           ; Zeigt an, ob gespeichert werden soll (Map-Liste)
  Temp_Filename.s             ; Temporärer Dateiname für Threadübergabe
  Temp_ID.i                   ; Temporäre ID für Threadübergabe
  Temp_Overview_Filename.s    ; Temporärer Dateiname für Threadübergabe
  File_Date_Last.l            ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
  Timer_Stats.l               ; Timer für die HTML-Statistiken
EndStructure
Global Map_Main.Map_Main

Structure Map_Settings
  File_Date_Last.l            ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
  Max_Changes_Per_s.l         ; Maximale Blockänderungen pro Sekunde
EndStructure
Global Map_Settings.Map_Settings

Structure Map_Block         ; Blocks, aus welchen die Karte besteht
  Type.a                    ; Typ des Blocks
  Extra.a                   ; Extra-Daten
  Player_Last_Change.w      ; Spieler, welcher zuletzt eine Änderung gemacht hat
EndStructure

; #######################################################
; !!! Strukturen befinden sich in Main_Structures.pbi !!!
; #######################################################

Structure Map_Action_List
  ID.l                      ; Aktions-ID einmalig (für Lua-Rückgabe)
  Client_ID.i               ; Client_ID für Fehlerrückgabe beim Resizen...
  Map_ID.l
  Action.a                  ; 0=Speichern 1=Laden 5=Reszie 6=Fill 10=Löschen 
  Function_Name.s           ;
  Directory.s
  X.u
  Y.u
  Z.u
  Argument_String.s         ; Zum Beispiel bei Mapfill
EndStructure
Global NewList Map_Action_List.Map_Action_List() ; Liste mit Karten von denen Aktionen ausgeführt werden sollen

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

Declare Map_Block_Do_Add(*Map_Data.Map_Data, X.l, Y.l, Z.l)
Declare Map_Block_Changed_Add(*Map_Data.Map_Data, X, Y, Z, Priority.a, Old_Material.w)
Declare Map_Block_Get_Type(*Map_Data.Map_Data, X.l, Y.l, Z.l)
Declare Map_Block_Get_Rank(*Map_Data.Map_Data, X.l, Y.l, Z.l)

; ########################################## Proceduren ##########################################

Procedure Map_HTML_Stats()
  Generation_Time = Milliseconds()
  
  File_ID = CreateFile(#PB_Any, Files_File_Get("Map_HTML"))
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "<html>")
    WriteStringN(File_ID, "  <head>")
    WriteStringN(File_ID, "    <title>Minecraft-Server Map</title>")
    WriteStringN(File_ID, "  </head>")
    WriteStringN(File_ID, "  <body>")
    
    ;WriteStringN(File_ID, "      <b><u>Overview:</u></b><br>")
    ;WriteStringN(File_ID, "      Size of Map_Block_Do: "+Str(ListSize(Map_Block_Do()))+".<br>")
    ;WriteStringN(File_ID, "      Size of Map_Block_Changed: "+Str(ListSize(Map_Block_Changed()))+".<br>")
    ;WriteStringN(File_ID, "      <br>")
    ;WriteStringN(File_ID, "      <br>")
    
    WriteStringN(File_ID, "      <b><u>Maps:</u></b><br>")
    WriteStringN(File_ID, "      <br>")
    WriteString(File_ID,  "      <table border=1>")
    WriteStringN(File_ID, "        <tr>")
    WriteStringN(File_ID, "          <th><b>ID</b></th>")
    WriteStringN(File_ID, "          <th><b>U-ID</b></th>")
    WriteStringN(File_ID, "          <th><b>Name</b></th>")
    WriteStringN(File_ID, "          <th><b>Directory</b></th>")
    WriteStringN(File_ID, "          <th><b>Save Intervall</b></th>")
    WriteStringN(File_ID, "          <th><b>Ranks (B,J,S)</b></th>")
    WriteStringN(File_ID, "          <th><b>Size (X,Y,Z)</b></th>")
    WriteStringN(File_ID, "          <th><b>Memory</b></th>")
    WriteStringN(File_ID, "          <th><b>Physic_Queue</b></th>")
    WriteStringN(File_ID, "          <th><b>Send_Queue</b></th>")
    WriteStringN(File_ID, "          <th><b>Physics</b></th>")
    WriteStringN(File_ID, "          <th><b>Blockchange</b></th>")
    WriteStringN(File_ID, "        </tr>")
    ForEach Map_Data()
      WriteStringN(File_ID, "        <tr>")
      WriteStringN(File_ID, "          <td>"+Str(Map_Data()\ID)+"</td>")
      WriteStringN(File_ID, "          <td>"+Map_Data()\Unique_ID+"</td>")
      WriteStringN(File_ID, "          <td>"+Map_Data()\Name+"</td>")
      WriteStringN(File_ID, "          <td>"+Map_Data()\Directory+"</td>")
      WriteStringN(File_ID, "          <td>"+Str(Map_Data()\Save_Intervall)+"min</td>")
      WriteStringN(File_ID, "          <td>"+Str(Map_Data()\Rank_Build)+","+Str(Map_Data()\Rank_Join)+","+Str(Map_Data()\Rank_Show)+"</td>")
      WriteStringN(File_ID, "          <td>"+Str(Map_Data()\Size_X)+","+Str(Map_Data()\Size_Y)+","+Str(Map_Data()\Size_Z)+"</td>")
      WriteStringN(File_ID, "          <td>"+StrF((MemorySize(Map_Data()\Data)+MemorySize(Map_Data()\Blockchange_Data)+MemorySize(Map_Data()\Physic_Data))/1000000, 3) + "MB</td>")
      Counter = ListSize(Map_Data()\Map_Block_Do())
      WriteStringN(File_ID, "          <td>"+Str(Counter)+"</td>")
      Counter = ListSize(Map_Data()\Map_Block_Changed())
      WriteStringN(File_ID, "          <td>"+Str(Counter)+"</td>")
      If Map_Data()\Physic_Stopped
        WriteStringN(File_ID, "          <td><font color="+Chr(34)+"#FF0000"+Chr(34)+">Stopped</font></td>")
      Else
        WriteStringN(File_ID, "          <td><font color="+Chr(34)+"#00FF00"+Chr(34)+">Started</font></td>")
      EndIf
      If Map_Data()\Blockchange_Stopped
        WriteStringN(File_ID, "          <td><font color="+Chr(34)+"#FF0000"+Chr(34)+">Stopped</font></td>")
      Else
        WriteStringN(File_ID, "          <td><font color="+Chr(34)+"#00FF00"+Chr(34)+">Started</font></td>")
      EndIf
      WriteStringN(File_ID, "        </tr>")
    Next
    WriteString(File_ID,  "      </table>")
    
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    WriteStringN(File_ID, "      <br>")
    
    WriteStringN(File_ID, "    Site generated in "+Str(Milliseconds()-Generation_Time)+" ms. "+FormatDate("%hh:%ii:%ss  %dd.%mm.%yyyy", Date())+" ("+Str(Date())+")<br>")
    
    WriteStringN(File_ID, "  </body>")
    WriteStringN(File_ID, "</html>")
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Map_Select_ID(Map_ID, Log=1)
  If ListIndex(Map_Data()) <> -1 And Map_Data()\ID = Map_ID
    ProcedureReturn #True
  Else
    ForEach Map_Data()
      If Map_Data()\ID = Map_ID
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    ;Log_Add("Map", Lang_Get("", "Konnte Element '[Field_0]' (ID) in 'Map_Data()' nicht finden.", Str(ID)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure Map_Select_Unique_ID(Unique_ID.s, Log=1)
  If ListIndex(Map_Data()) <> -1 And Map_Data()\Unique_ID = Unique_ID
    ProcedureReturn #True
  Else
    ForEach Map_Data()
      If Map_Data()\Unique_ID = Unique_ID
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Map", Lang_Get("", "Can't find Map_Data()\Unique_ID = [Field_0]", Unique_ID), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure Map_Select_Name(Name.s)
  If ListIndex(Map_Data()) <> -1 And LCase(Map_Data()\Name) = LCase(Name)
    ProcedureReturn #True
  Else
    ForEach Map_Data()
      If LCase(Map_Data()\Name) = LCase(Name)
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  Log_Add("Map", Lang_Get("", "Can't find Map_Data()\Name = [Field_0]", Name), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  ProcedureReturn #False
EndProcedure

Procedure Map_Get_Pointer(Map_ID)
  If ListIndex(Map_Data()) <> -1 And Map_Data()\ID = Map_ID
    ProcedureReturn Map_Data()
  Else
    ForEach Map_Data()
      If Map_Data()\ID = Map_ID
        ProcedureReturn Map_Data()
      EndIf
    Next
  EndIf
  
  Log_Add("Map", Lang_Get("", "Can't find Map_Data()\ID = [Field_0]", Str(Map_ID)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  ProcedureReturn 0
EndProcedure

Macro Map_Get_Size(X, Y, Z, Block_Size)
  (X * Y * Z) * Block_Size;#Map_Block_Element_Size
EndMacro

Macro Map_Get_Offset(X, Y, Z, Size_X, Size_Y, Block_Size)
  (X + Y * Size_X + Z * Size_X * Size_Y) * Block_Size;#Map_Block_Element_Size
EndMacro

Procedure Map_Get_ID()
  Map_ID = 0
  Repeat
    Found = 0
    ForEach Map_Data()
      If Map_ID = Map_Data()\ID
        Found = 1
        Break
      EndIf
    Next
    If Found = 0
      ProcedureReturn Map_ID
    Else
      Map_ID + 1
    EndIf
  ForEver
  
  ProcedureReturn -1
EndProcedure

Procedure.s Map_Get_Unique_ID()
  ID.s = ""
  
  For i = 1 To 16
    ID.s + Chr(65 + Random(25))
  Next
  
  ProcedureReturn ID
EndProcedure

Procedure.s Map_Get_MOTD_Override(Map_ID)
  If Map_Select_ID(Map_ID)
    ProcedureReturn Map_Data()\MOTD_Override
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

Procedure Map_List_Save(Filename.s)
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Map_Data()
      WriteStringN(File_ID, "["+Str(Map_Data()\ID)+"]")
      WriteStringN(File_ID, "Name = "+Map_Data()\Name)
      WriteStringN(File_ID, "Directory = "+Map_Data()\Directory)
      WriteStringN(File_ID, "Delete = 0")
      WriteStringN(File_ID, "Reload = 0")
    Next
    
    Map_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Map_List", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Map_List_Load(Filename.s)
  If OpenPreferences(Filename)
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        Map_ID = Val(PreferenceGroupName())
        Map_Name.s = ReadPreferenceString("Name", Str(Map_ID))
        Map_Directory.s = ReadPreferenceString("Directory", Files_Folder_Get("Maps")+ReadPreferenceString("Name", Str(Map_ID))+"/") ; "Name" für das Konvertieren der alten Map_List
        Map_Delete = ReadPreferenceLong("Delete", 0)
        Map_Reload = ReadPreferenceLong("Reload", 0)
        
        If Map_Delete
          Map_Action_Add_Delete(0, Map_ID)
        Else
          
          If Map_Select_ID(Map_ID) = #False
            ;Map_Add(Map_ID, 128, 128, 64, Lang_Get("", "New Map [Field_0]", Str(Map_ID)))
            Map_Add(Map_ID, 64, 64, 64, Map_Name)
            Map_Reload = 1
          EndIf
          
          If Map_Select_ID(Map_ID)
            Map_Data()\Directory = Map_Directory
          EndIf
          
          If Map_Reload
            Map_Action_Add_Load(0, Map_ID, "")
          EndIf
          
        EndIf
        
      Wend
    EndIf
    
    Map_Main\Save_File = 1
    
    Map_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Map_List", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure Map_Settings_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "[Blockchanges]")
    WriteStringN(File_ID, "Max_Changes_Per_s = "+Str(Map_Settings\Max_Changes_Per_s))
    
    Map_Settings\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Map_Settings", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Map_Settings_Load(Filename.s)
  If OpenPreferences(Filename)
    
    PreferenceGroup("Blockchanges")
    Map_Settings\Max_Changes_Per_s = ReadPreferenceLong("Max_Changes_Per_s", 1000)
    
    Map_Settings\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Map_Settings", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  EndIf
EndProcedure

;-

Procedure Map_Add(Map_ID, X, Y, Z, Name.s)
  
  If Map_ID = -1
    Map_ID = Map_Get_ID()
  EndIf
  
  If Name <> ""
    If Map_Select_ID(Map_ID) = #False
      If AddElement(Map_Data())
        ;Result = AllocateMemory(Map_Get_Size(X, Y, Z, #Map_Block_Element_Size))
        Result = Mem_Allocate(Map_Get_Size(X, Y, Z, #Map_Block_Element_Size), #PB_Compiler_File, #PB_Compiler_Line, "Map_ID = "+Str(Map_ID))
        If Result
          Result_2 = Mem_Allocate(1+Map_Get_Size(X, Y, Z, 1)/8, #PB_Compiler_File, #PB_Compiler_Line, "Map_ID(Physics) = "+Str(Map_ID))
          If Result_2
            Result_3 = Mem_Allocate(1+Map_Get_Size(X, Y, Z, 1)/8, #PB_Compiler_File, #PB_Compiler_Line, "Map_ID(Blockchange) = "+Str(Map_ID))
            If Result_3
              Map_Data()\ID = Map_ID
              Map_Data()\Unique_ID = Map_Get_Unique_ID()
              Map_Data()\Name = Name
              Map_Data()\Directory = Files_Folder_Get("Maps")+Map_Data()\Name+"/"
              Map_Data()\Overview_Type = 2
              Map_Data()\Save_Intervall = 10
              Map_Data()\Save_Time = Milliseconds()
              Map_Data()\Data = Result
              Map_Data()\Physic_Data = Result_2
              Map_Data()\Blockchange_Data = Result_3
              Map_Data()\Size_X = X
              Map_Data()\Size_Y = Y
              Map_Data()\Size_Z = Z
              Map_Data()\Spawn_X = X/2
              Map_Data()\Spawn_Y = Y/2
              Map_Data()\Spawn_Z = Z/1.5
              For i = 1 To 255
                Map_Data()\Block_Counter [i] = 0
              Next
              Map_Data()\Block_Counter [0] = X*Y*Z
              
              Map_Main\Save_File = 1
              
              Plugin_Event_Map_Add(Map_Data())
              
            Else
              Mem_Free(Result_2)
              Mem_Free(Result)
              DeleteElement(Map_Data())
            EndIf
          Else
            Mem_Free(Result)
            DeleteElement(Map_Data())
          EndIf
        Else
          DeleteElement(Map_Data())
        EndIf
      EndIf
    EndIf
  EndIf
  ProcedureReturn Map_ID
EndProcedure

Procedure Map_Delete(Map_ID)
  If Map_Select_ID(Map_ID) And Map_ID <> 0
    ;FreeMemory(Map_Data()\Data)
    Mem_Free(Map_Data()\Data)
    Mem_Free(Map_Data()\Physic_Data)
    Mem_Free(Map_Data()\Blockchange_Data)
    DeleteElement(Map_Data())
    
    Map_Main\Save_File = 1
  EndIf
EndProcedure

Procedure Map_Resize(Map_ID, X, Y, Z) ; Ändert die Größe der Karte
  
  *Pointer_Old.Map_Block
  *Pointer_New.Map_Block
  
  Procedureresult = 0
  
  If Map_Select_ID(Map_ID)
    
    If X >= 16  And Y >= 16  And Z >= 16 And X <= 32767 And Y <= 32767 And Z <= 32767
      
      ;New_Memory = AllocateMemory(Map_Get_Size(X, Y, Z, #Map_Block_Element_Size))
      New_Memory = Mem_Allocate(Map_Get_Size(X, Y, Z, #Map_Block_Element_Size), #PB_Compiler_File, #PB_Compiler_Line, "Map_ID = "+Str(Map_ID))
      
      If New_Memory
        
        New_Memory_2 = Mem_Allocate(1+Map_Get_Size(X, Y, Z, 1)/8, #PB_Compiler_File, #PB_Compiler_Line, "Map_ID(Physics) = "+Str(Map_ID))
        
        If New_Memory_2
          
          New_Memory_3 = Mem_Allocate(1+Map_Get_Size(X, Y, Z, 1)/8, #PB_Compiler_File, #PB_Compiler_Line, "Map_ID(Blockchange) = "+Str(Map_ID))
          
          If New_Memory_3
            
            Copy_Area_X = Map_Data()\Size_X
            Copy_Area_Y = Map_Data()\Size_Y
            Copy_Area_Z = Map_Data()\Size_Z
            If Copy_Area_X > X : Copy_Area_X = X : EndIf
            If Copy_Area_Y > Y : Copy_Area_Y = Y : EndIf
            If Copy_Area_Z > Z : Copy_Area_Z = Z : EndIf
            
            Block_Size = SizeOf(Map_Block)
            
            For i = 1 To 255
              Map_Data()\Block_Counter [i] = 0
            Next
            Map_Data()\Block_Counter [0] = X*Y*Z - (Copy_Area_X*Copy_Area_Y*Copy_Area_Z)
            
            For ix = 0 To Copy_Area_X-1
              For iy = 0 To Copy_Area_Y-1
                For iz = 0 To Copy_Area_Z-1
                  ; ############################################### Movememory von dem Karteninhalt
                  *Pointer_Old = Map_Data()\Data + Map_Get_Offset(ix, iy, iz, Map_Data()\Size_X, Map_Data()\Size_Y, #Map_Block_Element_Size)
                  *Pointer_New = New_Memory + Map_Get_Offset(ix, iy, iz, X, Y, #Map_Block_Element_Size)
                  
                  Map_Data()\Block_Counter [*Pointer_Old\Type] + 1
                  
                  MoveMemory(*Pointer_Old, *Pointer_New, Block_Size)
                  
                Next
              Next
            Next
            
            ; ######################## Physic und Blockchange Speicher neu füllen
            ForEach Map_Data()\Map_Block_Do()
              If Map_Data()\Map_Block_Do()\X < Copy_Area_X And Map_Data()\Map_Block_Do()\Y < Copy_Area_Y And Map_Data()\Map_Block_Do()\Z < Copy_Area_Z
                Bool_Offset = Map_Get_Offset(Map_Data()\Map_Block_Do()\X, Map_Data()\Map_Block_Do()\Y, Map_Data()\Map_Block_Do()\Z, X, Y, 1)
                *Bool_Pointer = New_Memory_2 + Bool_Offset/8
                PokeB(*Bool_Pointer, PeekA(*Bool_Pointer) | (1 << (Bool_Offset % 8)))
              Else
                DeleteElement(Map_Data()\Map_Block_Do())
              EndIf
            Next
            ForEach Map_Data()\Map_Block_Changed()
              If Map_Data()\Map_Block_Changed()\X < Copy_Area_X And Map_Data()\Map_Block_Changed()\Y < Copy_Area_Y And Map_Data()\Map_Block_Changed()\Z < Copy_Area_Z
                Bool_Offset = Map_Get_Offset(Map_Data()\Map_Block_Changed()\X, Map_Data()\Map_Block_Changed()\Y, Map_Data()\Map_Block_Changed()\Z, X, Y, 1)
                *Bool_Pointer = New_Memory_3 + Bool_Offset/8
                PokeB(*Bool_Pointer, PeekA(*Bool_Pointer) | (1 << (Bool_Offset % 8)))
              Else
                DeleteElement(Map_Data()\Map_Block_Changed())
              EndIf
            Next
            
            ; ######################### Spawn limitieren
            
            If Map_Data()\Spawn_X > X-1
              Map_Data()\Spawn_X = X-1
            EndIf
            If Map_Data()\Spawn_Y > Y-1
              Map_Data()\Spawn_Y = Y-1
            EndIf
            
            Procedureresult = 1
            
            Map_Data()\Size_X = X
            Map_Data()\Size_Y = Y
            Map_Data()\Size_Z = Z
            
            Mem_Free(Map_Data()\Data)
            Mem_Free(Map_Data()\Physic_Data)
            Mem_Free(Map_Data()\Blockchange_Data)
            Map_Data()\Data = New_Memory
            Map_Data()\Physic_Data = New_Memory_2
            Map_Data()\Blockchange_Data = New_Memory_3
            
            Map_Resend(Map_ID)
            
            Map_Main\Save_File = 1
            
          Else
            
            Log_Add("Map", Lang_Get("", "Can't resize map."), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
            
            Mem_Free(New_Memory)
            Mem_Free(New_Memory_2)
            
          EndIf
          
        Else
          
          Log_Add("Map", Lang_Get("", "Can't resize map."), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          
          Mem_Free(New_Memory)
          
        EndIf
        
      Else
        
        Log_Add("Map", Lang_Get("", "Can't resize map."), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        
      EndIf
      
    EndIf
    
  EndIf
  
  ProcedureReturn Procedureresult
EndProcedure

Procedure Map_Fill(Map_ID, Function_Name.s, Argument_String.s) ; Füllt die Karte mit einer Landschaft
  
  Procedureresult = 0
  
  *Pointer.Map_Block
  
  If Map_Select_ID(Map_ID)
    X = Map_Data()\Size_X
    Y = Map_Data()\Size_Y
    Z = Map_Data()\Size_Z
    
    For i = 1 To 255
      Map_Data()\Block_Counter [i] = 0
    Next
    Map_Data()\Block_Counter [0] = X*Y*Z
    
    For ix = 0 To X - 1
      For iy = 0 To Y - 1
        For iz = 0 To Z - 1
          *Pointer = Map_Data()\Data + Map_Get_Offset(ix, iy, iz, X, Y, #Map_Block_Element_Size)
          *Pointer\Type = 0
          *Pointer\Player_Last_Change = -1
        Next
      Next
    Next
    
    Map_Data()\Unique_ID = Map_Get_Unique_ID()
    
    ClearList(Map_Data()\Rank())
    ClearList(Map_Data()\Teleporter())
    
    Undo_Clear_Map(Map_Data()\ID)
    
    ;Lua_Do_Function(Function_Name+"("+Str(Map_ID)+","+Str(Map_Data()\Size_X)+","+Str(Map_Data()\Size_Y)+","+Str(Map_Data()\Size_Z)+",'"+Argument_String+"')")
    
    Plugin_Event_Map_Fill("*:"+Function_Name, Map_Data(), Argument_String.s)
    
    ;Lua_Do_Function_Map_Fill(Function_Name, Map_ID, Map_Data()\Size_X, Map_Data()\Size_Y, Map_Data()\Size_Z, Argument_String)
    
    
    Procedureresult = 1
    
    Map_Resend(Map_ID)
    
    Log_Add("Map", Lang_Get("", "Map filled", Str(Map_Data()\Size_X), Str(Map_Data()\Size_Y), Str(Map_Data()\Size_Z)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
  EndIf
  
  ProcedureReturn Procedureresult
EndProcedure

Procedure Map_Save(*Map_Data_Element.Map_Data, Directory.s) ; Komprimiert und Speichert die Karte (Gewählt über Pointer zum Element) (Thread)
  
  ProcedureResult = 0
  
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
    CreateDirectory(Directory)
    Filename_Data.s = Directory+#Map_Filename_Data
    Filename_Rank.s = Directory+#Map_Filename_Rank
    Filename_Config.s = Directory+#Map_Filename_Config
    Filename_Teleporter.s = Directory+#Map_Filename_Teleporter
    
    Save_Result = 1
    
    File_ID = CreateFile(#PB_Any, Filename_Config)
    If IsFile(File_ID)
      
      WriteStringN(File_ID, "; Overview_Types: 0=Nothing, 1=2D, 2=Iso(fast)")
      WriteStringN(File_ID, "; Save_Intervall: in minutes (0 = Disabled)")
      WriteStringN(File_ID, ";")
      
      WriteStringN(File_ID, "Server_Version = "+Str(Main\Version))
      WriteStringN(File_ID, "Unique_ID = "+*Map_Data_Element\Unique_ID)
      WriteStringN(File_ID, "Name = "+*Map_Data_Element\Name)
      WriteStringN(File_ID, "Rank_Build = "+Str(*Map_Data_Element\Rank_Build))
      WriteStringN(File_ID, "Rank_Join = "+Str(*Map_Data_Element\Rank_Join))
      WriteStringN(File_ID, "Rank_Show = "+Str(*Map_Data_Element\Rank_Show))
      WriteStringN(File_ID, "Physic_Stopped = "+Str(*Map_Data_Element\Physic_Stopped))
      WriteStringN(File_ID, "MOTD_Override = "+*Map_Data_Element\MOTD_Override)
      WriteStringN(File_ID, "Save_Intervall = "+Str(*Map_Data_Element\Save_Intervall))
      WriteStringN(File_ID, "Overview_Type = "+Str(*Map_Data_Element\Overview_Type))
      WriteStringN(File_ID, "Size_X = "+Str(*Map_Data_Element\Size_X))
      WriteStringN(File_ID, "Size_Y = "+Str(*Map_Data_Element\Size_Y))
      WriteStringN(File_ID, "Size_Z = "+Str(*Map_Data_Element\Size_Z))
      WriteStringN(File_ID, "Spawn_X = "+StrF(*Map_Data_Element\Spawn_X))
      WriteStringN(File_ID, "Spawn_Y = "+StrF(*Map_Data_Element\Spawn_Y))
      WriteStringN(File_ID, "Spawn_Z = "+StrF(*Map_Data_Element\Spawn_Z))
      WriteStringN(File_ID, "Spawn_Rot = "+StrF(*Map_Data_Element\Spawn_Rot))
      WriteStringN(File_ID, "Spawn_Look = "+StrF(*Map_Data_Element\Spawn_Look))
      
      CloseFile(File_ID)
    Else
      Log_Add("Map", Lang_Get("", "File not saved", Filename_Config), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Save_Result = 0
    EndIf
    
    File_ID = CreateFile(#PB_Any, Filename_Rank)
    If IsFile(File_ID)
      ForEach *Map_Data_Element\Rank()
        WriteStringN(File_ID, "[Element]")
        WriteStringN(File_ID, "Rank = "+Str(*Map_Data_Element\Rank()\Rank))
        WriteStringN(File_ID, "X_0 = "+Str(*Map_Data_Element\Rank()\X_0))
        WriteStringN(File_ID, "Y_0 = "+Str(*Map_Data_Element\Rank()\Y_0))
        WriteStringN(File_ID, "Z_0 = "+Str(*Map_Data_Element\Rank()\Z_0))
        WriteStringN(File_ID, "X_1 = "+Str(*Map_Data_Element\Rank()\X_1))
        WriteStringN(File_ID, "Y_1 = "+Str(*Map_Data_Element\Rank()\Y_1))
        WriteStringN(File_ID, "Z_1 = "+Str(*Map_Data_Element\Rank()\Z_1))
      Next
      
      CloseFile(File_ID)
    Else
      Log_Add("Map", Lang_Get("", "File not saved", Filename_Rank), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Save_Result = 0
    EndIf
    
    File_ID = CreateFile(#PB_Any, Filename_Teleporter)
    If IsFile(File_ID)
      ForEach *Map_Data_Element\Teleporter()
        WriteStringN(File_ID, "["+*Map_Data_Element\Teleporter()\ID+"]")
        WriteStringN(File_ID, "X_0 = "+Str(*Map_Data_Element\Teleporter()\X_0))
        WriteStringN(File_ID, "Y_0 = "+Str(*Map_Data_Element\Teleporter()\Y_0))
        WriteStringN(File_ID, "Z_0 = "+Str(*Map_Data_Element\Teleporter()\Z_0))
        WriteStringN(File_ID, "X_1 = "+Str(*Map_Data_Element\Teleporter()\X_1))
        WriteStringN(File_ID, "Y_1 = "+Str(*Map_Data_Element\Teleporter()\Y_1))
        WriteStringN(File_ID, "Z_1 = "+Str(*Map_Data_Element\Teleporter()\Z_1))
        
        WriteStringN(File_ID, "Dest_Map_Unique_ID = "+*Map_Data_Element\Teleporter()\Dest_Map_Unique_ID)
        WriteStringN(File_ID, "Dest_Map_ID = "+Str(*Map_Data_Element\Teleporter()\Dest_Map_ID))
        WriteStringN(File_ID, "Dest_X = "+StrF(*Map_Data_Element\Teleporter()\Dest_X, 2))
        WriteStringN(File_ID, "Dest_Y = "+StrF(*Map_Data_Element\Teleporter()\Dest_Y, 2))
        WriteStringN(File_ID, "Dest_Z = "+StrF(*Map_Data_Element\Teleporter()\Dest_Z, 2))
        WriteStringN(File_ID, "Dest_Rot = "+StrF(*Map_Data_Element\Teleporter()\Dest_Rot, 2))
        WriteStringN(File_ID, "Dest_Look = "+StrF(*Map_Data_Element\Teleporter()\Dest_Look, 2))
      Next
      
      ;Log_Add("Teleporter", Lang_Get("", "File saved", Filename_Teleporter), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      
      CloseFile(File_ID)
    Else
      Log_Add("Teleporter", Lang_Get("", "File not saved", Filename_Teleporter), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
    UnlockMutex(Main\Mutex)
    
    If GZip_Compress_2_File(*Map_Data, Map_Data_Size, Files_File_Get("Map_Save_Temp"))
      If CopyFile(Files_File_Get("Map_Save_Temp"), Filename_Data)
        Log_Add("Map", Lang_Get("", "File saved", Filename_Data), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Else
        Log_Add("Map", Lang_Get("", "File not saved", Filename_Data), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
    Else
      Log_Add("Map", Lang_Get("", "Can't compress the data", Filename_Data), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Save_Result = 0
    EndIf
    
    LockMutex(Main\Mutex)
    
  Else
    Log_Add("Map", Lang_Get("", "Can't save", Str(Map_ID)), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  ProcedureReturn Save_Result
EndProcedure

Procedure Map_Load(Map_ID, Directory.s) ; Dekomprimiert und lädt die Informationen in die aktuelle Karte
  
  *Pointer.Map_Block
  
  ProcedureResult = 0
  
  If Map_ID = -1
    Map_ID = Map_Get_ID()
  EndIf
  
  If Map_Select_ID(Map_ID) = #False
    Map_Add(Map_ID, 16, 16, 16, Str(Map_ID))
  EndIf
  
  If Map_Select_ID(Map_ID)
    
    If Directory.s = ""
      Directory.s = Map_Data()\Directory
    EndIf
    Filename_Data.s = Directory+#Map_Filename_Data
    Filename_Rank.s = Directory+#Map_Filename_Rank
    Filename_Config.s = Directory+#Map_Filename_Config
    Filename_Teleporter.s = Directory+#Map_Filename_Teleporter
    
    If OpenPreferences(Filename_Config)
      Map_Size_X = ReadPreferenceLong("Size_X", 0)
      Map_Size_Y = ReadPreferenceLong("Size_Y", 0)
      Map_Size_Z = ReadPreferenceLong("Size_Z", 0)
      Map_Size = Map_Size_X*Map_Size_Y*Map_Size_Z
      
      If Map_Resize(Map_ID, Map_Size_X, Map_Size_Y, Map_Size_Z)
        Map_Data()\Unique_ID = ReadPreferenceString("Unique_ID", Map_Get_Unique_ID())
        ;Map_Data()\Name = ReadPreferenceString("Name", Str(Map_ID))
        Map_Data()\Rank_Build = ReadPreferenceLong("Rank_Build", 0)
        Map_Data()\Rank_Join = ReadPreferenceLong("Rank_Join", 0)
        Map_Data()\Rank_Show = ReadPreferenceLong("Rank_Show", 0)
        Map_Data()\Physic_Stopped = ReadPreferenceLong("Physic_Stopped", 0)
        Map_Data()\MOTD_Override = ReadPreferenceString("MOTD_Override", "")
        Map_Data()\Save_Intervall = ReadPreferenceLong("Save_Intervall", 10)
        Map_Data()\Overview_Type = ReadPreferenceLong("Overview_Type", 2)
        Map_Data()\Spawn_X = ReadPreferenceFloat("Spawn_X", 1)
        Map_Data()\Spawn_Y = ReadPreferenceFloat("Spawn_Y", 1)
        Map_Data()\Spawn_Z = ReadPreferenceFloat("Spawn_Z", 0)
        Map_Data()\Spawn_Rot = ReadPreferenceFloat("Spawn_Rot", 0)
        Map_Data()\Spawn_Look = ReadPreferenceFloat("Spawn_Look", 0)
        If GZip_Decompress_From_File(Filename_Data, Map_Data()\Data, Map_Size*#Map_Block_Element_Size) = Map_Size*#Map_Block_Element_Size
          
          Undo_Clear_Map(Map_Data()\ID)
          
          For i = 0 To 255
            Map_Data()\Block_Counter [i] = 0
          Next
          
          For iz = 0 To Map_Data()\Size_Z-1
            For iy = 0 To Map_Data()\Size_Y-1
              For ix = 0 To Map_Data()\Size_X-1
                *Pointer = Map_Data()\Data + Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, #Map_Block_Element_Size)
                If Block(*Pointer\Type)\Replace_By_Load >= 0
                  *Pointer\Type = Block(*Pointer\Type)\Replace_By_Load
                EndIf
                Map_Data()\Block_Counter [*Pointer\Type] + 1
                If Block(*Pointer\Type)\Do_By_Load
                  Map_Block_Do_Add(Map_Data(), ix, iy, iz)
                EndIf
                
              Next
            Next
          Next
          
          Log_Add("Map", Lang_Get("", "Map loaded", Filename_Data, Str(Map_Data()\Size_X), Str(Map_Data()\Size_Y), Str(Map_Data()\Size_Z)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          ProcedureResult = 1
        Else
          Log_Add("Map", Lang_Get("", "Map not loaded: Filesize is wrong", Filename_Data), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        EndIf
      EndIf
      ClosePreferences()
    Else
      Log_Add("Map", Lang_Get("", "File not loaded", Filename_Config), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
    ClearList(Map_Data()\Rank())
    
    If OpenPreferences(Filename_Rank)
      If ExaminePreferenceGroups()
        While NextPreferenceGroup()
          AddElement(Map_Data()\Rank())
          Map_Data()\Rank()\Rank = ReadPreferenceLong("Rank", 0)
          Map_Data()\Rank()\X_0 = ReadPreferenceLong("X_0", 0)
          Map_Data()\Rank()\Y_0 = ReadPreferenceLong("Y_0", 0)
          Map_Data()\Rank()\Z_0 = ReadPreferenceLong("Z_0", 0)
          Map_Data()\Rank()\X_1 = ReadPreferenceLong("X_1", 0)
          Map_Data()\Rank()\Y_1 = ReadPreferenceLong("Y_1", 0)
          Map_Data()\Rank()\Z_1 = ReadPreferenceLong("Z_1", 0)
        Wend
      EndIf
      ClosePreferences()
    Else
      Log_Add("Map", Lang_Get("", "File not loaded", Filename_Rank), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
    ClearList(Map_Data()\Teleporter())
    
    If OpenPreferences(Filename_Teleporter)
      If ExaminePreferenceGroups()
        While NextPreferenceGroup()
          AddElement(Map_Data()\Teleporter())
          Map_Data()\Teleporter()\ID = PreferenceGroupName()
          Map_Data()\Teleporter()\X_0 = ReadPreferenceLong("X_0", 0)
          Map_Data()\Teleporter()\Y_0 = ReadPreferenceLong("Y_0", 0)
          Map_Data()\Teleporter()\Z_0 = ReadPreferenceLong("Z_0", 0)
          Map_Data()\Teleporter()\X_1 = ReadPreferenceLong("X_1", 0)
          Map_Data()\Teleporter()\Y_1 = ReadPreferenceLong("Y_1", 0)
          Map_Data()\Teleporter()\Z_1 = ReadPreferenceLong("Z_1", 0)
          Map_Data()\Teleporter()\Dest_Map_Unique_ID = ReadPreferenceString("Dest_Map_Unique_ID", "")
          Map_Data()\Teleporter()\Dest_Map_ID = ReadPreferenceLong("Dest_Map_ID", -1)
          Map_Data()\Teleporter()\Dest_X = ReadPreferenceFloat("Dest_X", -1)
          Map_Data()\Teleporter()\Dest_Y = ReadPreferenceFloat("Dest_Y", -1)
          Map_Data()\Teleporter()\Dest_Z = ReadPreferenceFloat("Dest_Z", -1)
          Map_Data()\Teleporter()\Dest_Rot = ReadPreferenceFloat("Dest_Rot", 0)
          Map_Data()\Teleporter()\Dest_Look = ReadPreferenceFloat("Dest_Look", 0)
        Wend
      EndIf
      
      ;Log_Add("Teleporter", Lang_Get("", "File loaded", Filename_Teleporter), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      
      ClosePreferences()
    Else
      Log_Add("Teleporter", Lang_Get("", "File not loaded", Filename_Teleporter), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
  EndIf
  
  ProcedureReturn ProcedureResult
EndProcedure

Procedure Map_Send(Client_ID, Map_ID)        ; Komprimiert und sendet die Karte an Client
  
  ProcedureResult = 0
  
  If Network_Client_Select(Client_ID)
    
    If Map_Select_ID(Map_ID)
      *Map_Data.Map_Data = Map_Data()
      
      ; Anzahl Blöcke
      Map_Size_X = *Map_Data\Size_X
      Map_Size_Y = *Map_Data\Size_Y
      Map_Size_Z = *Map_Data\Size_Z
      Map_Size = Map_Size_X * Map_Size_Y * Map_Size_Z
      
      ;*Temp_Buffer = AllocateMemory(Map_Size+10)
      *Temp_Buffer = Mem_Allocate(Map_Size+10, #PB_Compiler_File, #PB_Compiler_Line, "Temp")
      
      If *Temp_Buffer
        
        Temp_Buffer_Offset = 0
        
        PokeB(*Temp_Buffer+Temp_Buffer_Offset, Map_Size/16777216) : Temp_Buffer_Offset + 1
        PokeB(*Temp_Buffer+Temp_Buffer_Offset, Map_Size/65536) : Temp_Buffer_Offset + 1
        PokeB(*Temp_Buffer+Temp_Buffer_Offset, Map_Size/256) : Temp_Buffer_Offset + 1
        PokeB(*Temp_Buffer+Temp_Buffer_Offset, Map_Size) : Temp_Buffer_Offset + 1
        
        For i = 0 To Map_Size_X*Map_Size_Y*Map_Size_Z-1
          *Pointer.Map_Block = *Map_Data\Data + i * #Map_Block_Element_Size
          PokeB(*Temp_Buffer+Temp_Buffer_Offset, Block(*Pointer\Type)\On_Client) : Temp_Buffer_Offset + 1
        Next
        
        Temp_Buffer_2_Size = GZip_CompressBound(Temp_Buffer_Offset) + 1024 + 512
        *Temp_Buffer_2 = Mem_Allocate(Temp_Buffer_2_Size, #PB_Compiler_File, #PB_Compiler_Line, "Temp")
        
        If *Temp_Buffer_2
          
          *Map_Data\Blockchange_Stopped = 1
          UnlockMutex(Main\Mutex)
          
          ;GZip_Compress_2_File(*Temp_Buffer, Temp_Buffer_Offset, "Temp/Send.gz")
          
          Compressed_Size = GZip_Compress(*Temp_Buffer_2, Temp_Buffer_2_Size, *Temp_Buffer, Temp_Buffer_Offset)
          
          Mem_Free(*Temp_Buffer)
          
          LockMutex(Main\Mutex)
          If Map_Select_ID(Map_ID)
            *Map_Data.Map_Data = Map_Data()
            *Map_Data\Blockchange_Stopped = 0
          EndIf
          
          If Compressed_Size <> -1
            If Network_Client_Select(Client_ID)
              
              Compressed_Size + (1024 - (Compressed_Size % 1024))
              
              Network_Client_Output_Write_Byte(Network_Client()\ID, 02)
              
              Bytes_2_Send = Compressed_Size
              Bytes_Sent = 0
              While Bytes_2_Send > 0
                Bytes_In_Block = Bytes_2_Send
                If Bytes_In_Block > 1024 : Bytes_In_Block = 1024 : EndIf
                Network_Client_Output_Write_Byte(Network_Client()\ID, 03)
                Network_Client_Output_Write_Word(Network_Client()\ID, Bytes_In_Block) ; Menge der Bytes
                Network_Client_Output_Write_Buffer(Network_Client()\ID, *Temp_Buffer_2 + Bytes_Sent, Bytes_In_Block)
                Bytes_Sent + Bytes_In_Block
                Network_Client_Output_Write_Byte(Network_Client()\ID, Bytes_Sent*100/Compressed_Size)
                Bytes_2_Send - Bytes_In_Block
                
              Wend
              
              Network_Client_Output_Write_Byte(Network_Client()\ID, 4)
              Network_Client_Output_Write_Word(Network_Client()\ID, Map_Size_X)
              Network_Client_Output_Write_Word(Network_Client()\ID, Map_Size_Z)
              Network_Client_Output_Write_Word(Network_Client()\ID, Map_Size_Y)
              
              ProcedureResult = 1
            EndIf
            Mem_Free(*Temp_Buffer_2)
          Else ; Wenn die Datei nicht komprimiert wurde
            Log_Add("Map", Lang_Get("", "Can't send the map: GZip-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
            Network_Client_Kick(Client_ID, Lang_Get("", "Mapsending error"), 0)
            Mem_Free(*Temp_Buffer_2)
          EndIf
        Else ; Wenn der Speicher nicht allokiert wurde
          Log_Add("Map", Lang_Get("", "Can't send the map: Memory-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          Network_Client_Kick(Client_ID, Lang_Get("", "Mapsending error"), 0)
          Mem_Free(*Temp_Buffer)
        EndIf
      Else ; Wenn der Speicher nicht allokiert wurde
        Log_Add("Map", Lang_Get("", "Can't send the map: Memory-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        Network_Client_Kick(Client_ID, Lang_Get("", "Mapsending error"), 0)
      EndIf
      
    EndIf
    
  EndIf
  
  ProcedureReturn ProcedureResult
EndProcedure

Procedure Map_Export(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Filename.s)
  
  *Pointer.Map_Block
  
  ProcedureResult = 0
  
  If Map_Select_ID(Map_ID)
    
    If X_0 > X_1
      X_2 = X_0
      X_0 = X_1
      X_1 = X_2
    EndIf
    If Y_0 > Y_1
      Y_2 = Y_0
      Y_0 = Y_1
      Y_1 = Y_2
    EndIf
    If Z_0 > Z_1
      Z_2 = Z_0
      Z_0 = Z_1
      Z_1 = Z_2
    EndIf
    
    Size_X = X_1 - X_0 + 1
    Size_Y = Y_1 - Y_0 + 1
    Size_Z = Z_1 - Z_0 + 1
    
    Version = 1000
    
    Map_Size = Size_X * Size_Y * Size_Z
    
    ;*Temp_Buffer = AllocateMemory(Map_Size+10)
    *Temp_Buffer = Mem_Allocate(Map_Size+10, #PB_Compiler_File, #PB_Compiler_Line, "Temp")
    
    If *Temp_Buffer
      
      Temp_Buffer_Offset = 0
      
      PokeL(*Temp_Buffer+Temp_Buffer_Offset, Version) : Temp_Buffer_Offset + 4
      PokeW(*Temp_Buffer+Temp_Buffer_Offset, Size_X) : Temp_Buffer_Offset + 2
      PokeW(*Temp_Buffer+Temp_Buffer_Offset, Size_Y) : Temp_Buffer_Offset + 2
      PokeW(*Temp_Buffer+Temp_Buffer_Offset, Size_Z) : Temp_Buffer_Offset + 2
        
      For iz = Z_0 To Z_1
        For iy = Y_0 To Y_1
          For ix = X_0 To X_1
            If ix >= 0 And ix < Map_Data()\Size_X And iy >= 0 And iy < Map_Data()\Size_Y And iz >= 0 And iz < Map_Data()\Size_Z
              *Pointer = Map_Data()\Data + Map_Get_Offset(ix, iy, iz, Map_Data()\Size_X, Map_Data()\Size_Y, #Map_Block_Element_Size)
              PokeB(*Temp_Buffer+Temp_Buffer_Offset, *Pointer\Type) : Temp_Buffer_Offset + 1
            Else
              PokeB(*Temp_Buffer+Temp_Buffer_Offset, 0) : Temp_Buffer_Offset + 1
            EndIf
          Next
        Next
      Next
      
      GZip_Compress_2_File(*Temp_Buffer, Temp_Buffer_Offset, Filename)
      
      ProcedureResult = 1
      
      ;FreeMemory(*Temp_Buffer)
      Mem_Free(*Temp_Buffer)
      
      Log_Add("Map", Lang_Get("", "Map exported", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    Else
      Log_Add("Map", Lang_Get("", "Map not exported: Memory-error", Filename), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
  EndIf
  
  ProcedureReturn ProcedureResult
EndProcedure

Procedure Map_Import_Player(Player_Number, Filename.s, Map_ID, X, Y, Z, SX, SY, SZ) ; Dekomprimiert und importiert die Karte an X, Y, Z
  
  *Pointer.Map_Block
  
  ProcedureResult = 0
  
  If Map_Select_ID(Map_ID)
    If Player_List_Select_Number(Player_Number)
      
      X_0 = X
      Y_0 = Y
      Z_0 = Z
      
      *Temp_Buffer = Mem_Allocate(10, #PB_Compiler_File, #PB_Compiler_Line, "Temp")
      
      If *Temp_Buffer
        
        Temp_Buffer_Offset = 0
        
        Result = GZip_Decompress_From_File(Filename, *Temp_Buffer, 10)
        If Result = 10
          File_Version = PeekL(*Temp_Buffer+Temp_Buffer_Offset) : Temp_Buffer_Offset + 4
          Map_Size_X = PeekW(*Temp_Buffer+Temp_Buffer_Offset) : Temp_Buffer_Offset + 2
          Map_Size_Y = PeekW(*Temp_Buffer+Temp_Buffer_Offset) : Temp_Buffer_Offset + 2
          Map_Size_Z = PeekW(*Temp_Buffer+Temp_Buffer_Offset) : Temp_Buffer_Offset + 2
          Map_Size = Map_Size_X * Map_Size_Y * Map_Size_Z
          
          X_1 = X_0 + Map_Size_X * SX
          Y_1 = Y_0 + Map_Size_Y * SY
          Z_1 = Z_0 + Map_Size_Z * SZ
          
          Select File_Version
            Case 1000
              ;*Temp_Buffer_2 = AllocateMemory(10+Map_Size)
              *Temp_Buffer_2 = Mem_Allocate(10+Map_Size, #PB_Compiler_File, #PB_Compiler_Line, "Temp")
              If *Temp_Buffer_2
                If GZip_Decompress_From_File(Filename, *Temp_Buffer_2, 10+Map_Size) = 10+Map_Size
                  For jz = Z_0 To Z_1-1
                    iz = (jz-Z_0) / SZ
                    For jy = Y_0 To Y_1-1
                      iy = (jy-Y_0) / SY
                      For jx = X_0 To X_1-1
                        ix = (jx-X_0) / SX
                        
                        Type.a = PeekA(*Temp_Buffer_2+10+Map_Get_Offset(ix, iy, iz, Map_Size_X, Map_Size_Y, 1))
                        Map_Block_Change_Player(Player_List(), Map_Data(), jx, jy, jz, Type.a, 1, 0, 1, 10)
                        
                      Next
                    Next
                  Next
                  
                  ProcedureResult = 1
                  
                  Log_Add("Map", Lang_Get("", "Map imported", Filename, Str(Map_Size_X), Str(Map_Size_Y), Str(Map_Size_Z)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
                Else
                  Log_Add("Map", Lang_Get("", "Map not imported: Filesize is wrong", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
                EndIf
                ;FreeMemory(*Temp_Buffer_2)
                Mem_Free(*Temp_Buffer_2)
              Else
                Log_Add("Map", Lang_Get("", "Can't import the map: Memory-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
              EndIf
              
            Default
              Log_Add("Map", Lang_Get("", "Map not imported: Unknown version", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
              
          EndSelect
        Else
          Log_Add("Map", Lang_Get("", "Map not imported: Filesize is wrong", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        EndIf
        ;FreeMemory(*Temp_Buffer)
        Mem_Free(*Temp_Buffer)
      Else
        Log_Add("Map", Lang_Get("", "Can't import the map: Memory-error"), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
      
    EndIf
  EndIf
  
  ProcedureReturn ProcedureResult
EndProcedure

Procedure Map_Resend(Map_ID) ; Sendet die Karte an alle neu
  ForEach Network_Client()
    If Network_Client()\Player\Map_ID = Map_ID
      Network_Client()\Player\Map_ID = -1 ; Setzt den Client auf eine ungültige Karte.
    EndIf
  Next
  
  If Map_Select_ID(Map_ID)
    ForEach Entity()
      If Entity()\Map_ID = Map_ID
        If Entity()\X > Map_Data()\Size_X-0.5
          Entity()\X = Map_Data()\Size_X-0.5
        EndIf
        If Entity()\X < 0.5
          Entity()\X = 0.5
        EndIf
        If Entity()\Y > Map_Data()\Size_Y-0.5
          Entity()\Y = Map_Data()\Size_Y-0.5
        EndIf
        If Entity()\Y < 0.5
          Entity()\Y = 0.5
        EndIf
      EndIf
    Next
  EndIf
  
  ; ################ Lösche die Blockchange-Elemente
  If Map_Select_ID(Map_ID)
    ForEach Map_Data()\Map_Block_Changed()
      X = Map_Data()\Map_Block_Changed()\X
      Y = Map_Data()\Map_Block_Changed()\Y
      Z = Map_Data()\Map_Block_Changed()\Z
      DeleteElement(Map_Data()\Map_Block_Changed())
      
      Blockchange_Offset = Map_Get_Offset(X, Y, Z, Map_Data()\Size_X, Map_Data()\Size_Y, 1)
      If Blockchange_Offset < Map_Get_Size(Map_Data()\Size_X, Map_Data()\Size_Y, Map_Data()\Size_Z, 1)
        *Blockchange_Pointer = Map_Data()\Blockchange_Data + Blockchange_Offset/8
        PokeB(*Blockchange_Pointer, (PeekB(*Blockchange_Pointer)&255) & ~(1 << (Blockchange_Offset % 8)))
      EndIf
      
    Next
  EndIf
EndProcedure

;-

Procedure Map_Action_Add_Save(Client_ID, Map_ID, Directory.s)
  Found = 0
  Action = 0
  
  Action_ID = 0
  ForEach Map_Action_List()
    If Action_ID <= Map_Action_List()\ID
      Action_ID = Map_Action_List()\ID + 1
    EndIf
  Next
  
  ForEach Map_Action_List()
    If Map_Action_List()\Map_ID = Map_ID And Map_Action_List()\Action&255 = Action And Map_Action_List()\Directory = Directory
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    LastElement(Map_Action_List())
    AddElement(Map_Action_List())
    Map_Action_List()\ID = Action_ID
    Map_Action_List()\Client_ID = Client_ID
    Map_Action_List()\Map_ID = Map_ID
    Map_Action_List()\Action = Action
    Map_Action_List()\Directory = Directory
    
    ProcedureReturn Action_ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Action_Add_Load(Client_ID, Map_ID, Directory.s)
  Found = 0
  Action = 1
  
  Action_ID = 0
  ForEach Map_Action_List()
    If Action_ID <= Map_Action_List()\ID
      Action_ID = Map_Action_List()\ID + 1
    EndIf
  Next
  
  ForEach Map_Action_List()
    If Map_Action_List()\Map_ID = Map_ID And Map_Action_List()\Action&255 = Action And Map_Action_List()\Directory = Directory
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    FirstElement(Map_Action_List())
    AddElement(Map_Action_List())
    Map_Action_List()\ID = Action_ID
    Map_Action_List()\Client_ID = Client_ID
    Map_Action_List()\Map_ID = Map_ID
    Map_Action_List()\Action = Action
    Map_Action_List()\Directory = Directory
    
    ProcedureReturn Action_ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Action_Add_Resize(Client_ID, Map_ID, X, Y, Z)
  Found = 0
  Action = 5
  
  Action_ID = 0
  ForEach Map_Action_List()
    If Action_ID <= Map_Action_List()\ID
      Action_ID = Map_Action_List()\ID + 1
    EndIf
  Next
  
  ForEach Map_Action_List()
    If Map_Action_List()\Map_ID = Map_ID And Map_Action_List()\Action&255 = Action
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    FirstElement(Map_Action_List())
    AddElement(Map_Action_List())
    Map_Action_List()\ID = Action_ID
    Map_Action_List()\Client_ID = Client_ID
    Map_Action_List()\Map_ID = Map_ID
    Map_Action_List()\Action = Action
    Map_Action_List()\X = X
    Map_Action_List()\Y = Y
    Map_Action_List()\Z = Z
    
    ProcedureReturn Action_ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Action_Add_Fill(Client_ID, Map_ID, Function_Name.s, Argument_String.s)
  Found = 0
  Action = 6
  
  Action_ID = 0
  ForEach Map_Action_List()
    If Action_ID <= Map_Action_List()\ID
      Action_ID = Map_Action_List()\ID + 1
    EndIf
  Next
  
  ForEach Map_Action_List()
    If Map_Action_List()\Map_ID = Map_ID And Map_Action_List()\Action&255 = Action
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    FirstElement(Map_Action_List())
    AddElement(Map_Action_List())
    Map_Action_List()\ID = Action_ID
    Map_Action_List()\Client_ID = Client_ID
    Map_Action_List()\Map_ID = Map_ID
    Map_Action_List()\Action = Action
    Map_Action_List()\Function_Name = Function_Name
    Map_Action_List()\Argument_String = Argument_String
    
    ProcedureReturn Action_ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Action_Add_Delete(Client_ID, Map_ID)
  Found = 0
  Action = 10
  
  Action_ID = 0
  ForEach Map_Action_List()
    If Action_ID <= Map_Action_List()\ID
      Action_ID = Map_Action_List()\ID + 1
    EndIf
  Next
  
  ForEach Map_Action_List()
    If Map_Action_List()\Map_ID = Map_ID And Map_Action_List()\Action = Action
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    LastElement(Map_Action_List())
    AddElement(Map_Action_List())
    Map_Action_List()\ID = Action_ID
    Map_Action_List()\Client_ID = Client_ID
    Map_Action_List()\Map_ID = Map_ID
    Map_Action_List()\Action = Action
    
    ProcedureReturn Action_ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Action_Thread(*Dummy)
  Repeat
    LockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Action", "Begin Thread-Slope", 0)
    
    If FirstElement(Map_Action_List())
      Action_ID = Map_Action_List()\ID
      Client_ID = Map_Action_List()\Client_ID
      Map_ID = Map_Action_List()\Map_ID
      Action = Map_Action_List()\Action
      Function_Name.s = Map_Action_List()\Function_Name
      Directory.s = Map_Action_List()\Directory
      X = Map_Action_List()\X
      Y = Map_Action_List()\Y
      Z = Map_Action_List()\Z
      Argument_String.s = Map_Action_List()\Argument_String
      
      DeleteElement(Map_Action_List())
      
      If Map_Select_ID(Map_ID)
        Select Action
          Case 0 ; Speichern
            Watchdog_Watch("Map_Action", "Begin: Map_Save()", 1)
            If Map_Save(Map_Data(), Directory) ; Vorsicht, mutex ist unlocked
              If Map_Select_ID(Map_ID)
                If Client_ID
                  System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map saved", Map_Data()\Name))
                EndIf
                Plugin_Event_Map_Action_Save(Action_ID, Map_Data())
              EndIf
            EndIf
            If Map_Select_ID(Map_ID)
              Select Map_Data()\Overview_Type
                Case 0 ; Keiner
                Case 1 ; 2D
                  Watchdog_Watch("Map_Action", "Begin: Map_Overview_Save_2D()", 1)
                  Map_Overview_Save_2D(Map_Data(), Directory)
                Case 2 ; Iso_Fast
                  Watchdog_Watch("Map_Action", "Begin: Map_Overview_Save_Iso_Fast()", 1)
                  Map_Overview_Save_Iso_Fast(Map_Data(), Directory)
              EndSelect
            EndIf
            
          Case 1 ; Laden
            Watchdog_Watch("Map_Action", "Begin: Map_Load()", 1)
            If Map_Load(Map_ID, Directory)
              If Client_ID And Map_Select_ID(Map_ID)
                System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map loaded", Map_Data()\Name))
              EndIf
              If Map_Select_ID(Map_ID)
                Plugin_Event_Map_Action_Load(Action_ID, Map_Data())
              EndIf
            EndIf
            
          Case 5 ; Resize
            Watchdog_Watch("Map_Action", "Begin: Map_Resize()", 1)
            If Map_Resize(Map_ID, X, Y, Z)
              If Client_ID And Map_Select_ID(Map_ID)
                System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map resized", Map_Data()\Name))
              EndIf
              If Map_Select_ID(Map_ID)
                Plugin_Event_Map_Action_Resize(Action_ID, Map_Data())
              EndIf
            EndIf
            
          Case 6 ; Fill
            Watchdog_Watch("Map_Action", "Begin: Map_Fill()", 1)
            If Map_Fill(Map_ID, Function_Name, Argument_String)
              If Client_ID And Map_Select_ID(Map_ID)
                System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map filled", Map_Data()\Name))
              EndIf
              If Map_Select_ID(Map_ID)
                Plugin_Event_Map_Action_Fill(Action_ID, Map_Data())
              EndIf
            EndIf
            
          Case 10 ; Löschen
            Watchdog_Watch("Map_Action", "Begin: Map_Delete()", 1)
            Plugin_Event_Map_Action_Delete(Action_ID, Map_Data())
            Map_Name.s = Map_Data()\Name
            Map_Delete(Map_ID)
            If Client_ID
              System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Map deleted", Map_Name))
            EndIf
            
          Default
            Log_Add("Map_Action", Lang_Get("", "Can't find Map_Action_List()\ID = [Field_0]", Str(Action)), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
            
        EndSelect
        
      EndIf
    EndIf
    
    UnlockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Action", "End Thread-Slope", 2)
    
    Delay(100)
    
  ForEver
EndProcedure

;-

Procedure Map_Block_Changed_Add(*Map_Data.Map_Data, X, Y, Z, Priority.a, Old_Material.w)
  If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
    ;Found = 0
    
    Blockchange_Offset = Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, 1)
    *Blockchange_Pointer = *Map_Data\Blockchange_Data + Blockchange_Offset/8
    Blockchange_Found = PeekA(*Blockchange_Pointer) & (1 << (Blockchange_Offset % 8))
    
    If Blockchange_Found = 0
      
      PokeB(*Blockchange_Pointer, PeekA(*Blockchange_Pointer) | (1 << (Blockchange_Offset % 8)))
      
      If ListSize(*Map_Data\Map_Block_Changed()) > 0
        If ListIndex(*Map_Data\Map_Block_Changed()) = -1
          FirstElement(*Map_Data\Map_Block_Changed())
        EndIf
        If *Map_Data\Map_Block_Changed()\Priority < Priority
          Repeat 
            If PreviousElement(*Map_Data\Map_Block_Changed()) = 0
              Break
            EndIf
          Until *Map_Data\Map_Block_Changed()\Priority >= Priority
        ElseIf *Map_Data\Map_Block_Changed()\Priority >= Priority
          Repeat
            If NextElement(*Map_Data\Map_Block_Changed()) = 0
              LastElement(*Map_Data\Map_Block_Changed())
              Break
            EndIf
          Until *Map_Data\Map_Block_Changed()\Priority < Priority
          If *Map_Data\Map_Block_Changed()\Priority < Priority
            PreviousElement(*Map_Data\Map_Block_Changed())
          EndIf
        EndIf
      EndIf
      
      AddElement(*Map_Data\Map_Block_Changed())
      *Map_Data\Map_Block_Changed()\X = X
      *Map_Data\Map_Block_Changed()\Y = Y
      *Map_Data\Map_Block_Changed()\Z = Z
      *Map_Data\Map_Block_Changed()\Priority = Priority
      *Map_Data\Map_Block_Changed()\Old_Material = Old_Material
      
    EndIf
    
  EndIf
  
EndProcedure

Procedure Map_Block_Change(Player_Number, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a) ; Blockänderung, kein prüfen des Ranks
  If *Map_Data
    If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
      *Pointer.Map_Block = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
      
      ; ###### Event
      Plugin_Event_Map_Block_Change(Player_Number, *Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
      
      ; ###### Alter Blocktyp auslesen
      Block_Old_Type.a = *Pointer\Type
      Player_Old = *Pointer\Player_Last_Change
      
      ; ###### Undo
      If Type <> *Pointer\Type And Undo
        Undo_Add(Player_Number, *Map_Data\ID, X, Y, Z, *Pointer\Type, *Pointer\Player_Last_Change)
      EndIf
      
      ; ###### Blocktyp und Last_Player ändern
      *Map_Data\Block_Counter [*Pointer\Type] - 1
      *Pointer\Type = Type
      *Pointer\Player_Last_Change = Player_Number
      *Map_Data\Block_Counter [*Pointer\Type] + 1
      
      ; ###### Physic
      If Physic
        For ix = -1 To 1
          For iy = -1 To 1
            For iz = -1 To 1
              Map_Block_Do_Add(*Map_Data, X+ix, Y+iy, Z+iz)
            Next
          Next
        Next
      EndIf
      
      ; ###### Send
      If Block_Old_Type <> *Pointer\Type And Send
        Map_Block_Changed_Add(*Map_Data, X, Y, Z, Send_Priority, Block_Old_Type)
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Map_Block_Change_Client(*Client.Network_Client, *Map_Data.Map_Data, X, Y, Z, Mode.a, Type.a) ; Blockänderung durch Klient, prüfen des Ranks (+Nachricht)
  If *Client And *Map_Data
    If *Client\Player\Entity
      If *Client\Player\Entity\Player_List
        If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
          *Pointer.Map_Block = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
          
          ; ###### Alter Blocktyp und Rang auslesen
          Block_Old_Type.a = *Pointer\Type
          Block_Rank = Map_Block_Get_Rank(*Map_Data, X, Y, Z)
          
          ; ###### Last_Material setzen
          *Client\Player\Entity\Last_Material = Type
          
          ; ###### Löschen oder Bauen...
          If Mode
            Block_New_Type = Type
          Else
            Block_New_Type = Block(Block_Old_Type)\After_Delete
          EndIf
          
          ; ###### Block zurücksenden
          Map_Block_Changed_Add(*Map_Data, X, Y, Z, 250, -1)
          
          ; ###### Überprüfen ob Bauen erlaubt
          If *Client\Player\Entity\Player_List\Stopped
            System_Message_Network_Send(*Client\ID, Lang_Get("", "Ingame: You are not allowed to build. (Stopped)"))
          ElseIf *Client\Player\Entity\Player_List\Rank < Block_Rank
            System_Message_Network_Send(*Client\ID, Lang_Get("", "Ingame: You are not allowed to build here."))
          ElseIf *Client\Player\Entity\Player_List\Rank < Block(Block_New_Type)\Rank_Place
            System_Message_Network_Send(*Client\ID, Lang_Get("", "Ingame: You are not allowed to build this block."))
          ElseIf *Client\Player\Entity\Player_List\Rank < Block(Block_Old_Type)\Rank_Delete
            System_Message_Network_Send(*Client\ID, Lang_Get("", "Ingame: You are not allowed to delete this block."))
          ElseIf Plugin_Event_Map_Block_Change_Client(*Client, *Map_Data, X, Y, Z, Mode.a, Type.a) = #False
            
          Else
            Map_Block_Change(*Client\Player\Entity\Player_List\Number, *Map_Data, X, Y, Z, Block_New_Type, 1, 1, 1, 250)
            ; ###### Create Block Function
            If Block(Block_New_Type)\Create_Plugin
              Plugin_Event_Block_Create(Block(Block_New_Type)\Create_Plugin, *Map_Data, X, Y, Z, Block_Old_Type, *Client)
            EndIf
            ; ###### Delete Block Function
            If Block(Block_Old_Type)\Delete_Plugin
              Plugin_Event_Block_Create(Block(Block_Old_Type)\Delete_Plugin, *Map_Data, X, Y, Z, Block_Old_Type, *Client)
            EndIf
          EndIf
          
          ; ###### Block zurücksenden
          ;Network_Out_Block_Set(*Client\ID, X, Y, Z, *Pointer\Type)
          
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Map_Block_Change_Player(*Player.Player_List, *Map_Data.Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a) ; Blockänderung eines Players, prüfen des Ranks
  If *Player And *Map_Data
    If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
      *Pointer.Map_Block = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
      
      ; ###### Alter Blocktyp und Rang auslesen
      Block_Old_Type = *Pointer\Type
      Block_Rank = Map_Block_Get_Rank(*Map_Data, X, Y, Z)
      
      ; ###### Überprüfen ob Bauen erlaubt
      If *Player\Stopped
        
      ElseIf *Player\Rank < Block_Rank
        
      ElseIf *Player\Rank < Block(Type)\Rank_Place
        
      ElseIf *Player\Rank < Block(Block_Old_Type)\Rank_Delete
        
      ElseIf Plugin_Event_Map_Block_Change_Player(*Player, *Map_Data, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a) = #False
        
      Else
        Map_Block_Change(*Player\Number, *Map_Data, X, Y, Z, Type, Undo, Physic, Send, Send_Priority)
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Map_Block_Move(*Map_Data.Map_Data, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Undo, Physic, Send_Priority)
  If *Map_Data
    If X_0 >= 0 And X_0 < *Map_Data\Size_X And Y_0 >= 0 And Y_0 < *Map_Data\Size_Y And Z_0 >= 0 And Z_0 < *Map_Data\Size_Z And X_1 >= 0 And X_1 < *Map_Data\Size_X And Y_1 >= 0 And Y_1 < *Map_Data\Size_Y And Z_1 >= 0 And Z_1 < *Map_Data\Size_Z
      
      *Pointer_0.Map_Block = *Map_Data\Data + Map_Get_Offset(X_0, Y_0, Z_0, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
      *Pointer_1.Map_Block = *Map_Data\Data + Map_Get_Offset(X_1, Y_1, Z_1, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
      
      ; ###### Alten Blocktyp auslesen
      Block_Old_Type_0 = *Pointer_0\Type
      Block_Old_Type_1 = *Pointer_1\Type
      
      ; ###### Undo
      If Undo
        If *Pointer_0\Type <> 0
          Undo_Add(*Pointer_0\Player_Last_Change, *Map_Data\ID, X_0, Y_0, Z_0, *Pointer_0\Type, *Pointer_0\Player_Last_Change)
        EndIf
        If *Pointer_1\Type <> *Pointer_0\Type
          Undo_Add(*Pointer_0\Player_Last_Change, *Map_Data\ID, X_1, Y_1, Z_1, *Pointer_1\Type, *Pointer_1\Player_Last_Change)
        EndIf
      EndIf
      
      ; ###### Block verschieben
      *Map_Data\Block_Counter [*Pointer_0\Type] - 1
      *Map_Data\Block_Counter [*Pointer_1\Type] - 1
      *Pointer_1\Type = *Pointer_0\Type
      *Pointer_1\Player_Last_Change = *Pointer_0\Player_Last_Change
      *Pointer_0\Type = 0
      *Pointer_0\Player_Last_Change = -1
      *Map_Data\Block_Counter [*Pointer_0\Type] + 1
      *Map_Data\Block_Counter [*Pointer_1\Type] + 1
      
      ; ###### Senden
      If Block_Old_Type_0 <> 0
        Map_Block_Changed_Add(*Map_Data, X_0, Y_0, Z_0, Send_Priority, Block_Old_Type_0)
      EndIf
      If Block_Old_Type_1 <> Block_Old_Type_0
        Map_Block_Changed_Add(*Map_Data, X_1, Y_1, Z_1, Send_Priority, Block_Old_Type_1)
      EndIf
      
      ; ###### Physic
      If Physic
        For ix = -1 To 1
          For iy = -1 To 1
            For iz = -1 To 1
              Map_Block_Do_Add(*Map_Data, X_0+ix, Y_0+iy, Z_0+iz)
              Map_Block_Do_Add(*Map_Data, X_1+ix, Y_1+iy, Z_1+iz)
            Next
          Next
        Next
      EndIf
      
    EndIf
    
  EndIf
EndProcedure

Procedure Map_Block_Get_Type(*Map_Data.Map_Data, X.l, Y.l, Z.l)
  
  *Pointer.Map_Block
  
  If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
    *Pointer = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
    ProcedureReturn *Pointer\Type
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Block_Get_Rank(*Map_Data.Map_Data, X.l, Y.l, Z.l)
  
  Rank = *Map_Data\Rank_Build
  ForEach *Map_Data\Rank()
    If X >= *Map_Data\Rank()\X_0 And X <= *Map_Data\Rank()\X_1 And Y >= *Map_Data\Rank()\Y_0 And Y <= *Map_Data\Rank()\Y_1 And Z >= *Map_Data\Rank()\Z_0 And Z <= *Map_Data\Rank()\Z_1
      ProcedureReturn *Map_Data\Rank()\Rank
    EndIf
  Next
  
  ProcedureReturn Rank
EndProcedure

Procedure Map_Block_Get_Player_Number(*Map_Data.Map_Data, X.l, Y.l, Z.l)
  
  *Pointer.Map_Block
  
  If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
    *Pointer = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
    ProcedureReturn *Pointer\Player_Last_Change
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Map_Block_Set_Rank_Box(*Map_Data.Map_Data, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank.w)
  
  If X_0 > X_1
    X_2 = X_0
    X_0 = X_1
    X_1 = X_2
  EndIf
  If Y_0 > Y_1
    Y_2 = Y_0
    Y_0 = Y_1
    Y_1 = Y_2
  EndIf
  If Z_0 > Z_1
    Z_2 = Z_0
    Z_0 = Z_1
    Z_1 = Z_2
  EndIf
  
  ForEach *Map_Data\Rank()
    If *Map_Data\Rank()\X_0 >= X_0 And *Map_Data\Rank()\X_1 <= X_1 And *Map_Data\Rank()\Y_0 >= Y_0 And *Map_Data\Rank()\Y_1 <= Y_1 And *Map_Data\Rank()\Z_0 >= Z_0 And *Map_Data\Rank()\Z_1 <= Z_1
      DeleteElement(*Map_Data\Rank())
    EndIf
  Next
  
  FirstElement(*Map_Data\Rank())
  InsertElement(*Map_Data\Rank())
  *Map_Data\Rank()\Rank = Rank
  *Map_Data\Rank()\X_0 = X_0
  *Map_Data\Rank()\Y_0 = Y_0
  *Map_Data\Rank()\Z_0 = Z_0
  *Map_Data\Rank()\X_1 = X_1
  *Map_Data\Rank()\Y_1 = Y_1
  *Map_Data\Rank()\Z_1 = Z_1
  
EndProcedure

Procedure Map_Block_Do_Add(*Map_Data.Map_Data, X.l, Y.l, Z.l) ; Fügt einen Block in die Abarbeitungsschleife ein (Filtert blöcke, welche nichts tun)
  
  *Pointer.Map_Block
  
  If ListIndex(*Map_Data\Map_Block_Do()) <> -1
    *Map_Block_Do_Old = *Map_Data\Map_Block_Do()
  Else
    *Map_Block_Do_Old = 0
  EndIf
  
  If X >= 0 And X < *Map_Data\Size_X And Y >= 0 And Y < *Map_Data\Size_Y And Z >= 0 And Z < *Map_Data\Size_Z
    
    Physic_Offset = Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, 1)
    *Physics_Pointer = *Map_Data\Physic_Data + Physic_Offset/8
    Physic_Found = PeekA(*Physics_Pointer) & (1 << (Physic_Offset % 8))
    
    If Physic_Found = 0
      
      *Pointer = *Map_Data\Data + Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
      Block_Type.a = *Pointer\Type
      Physic.a = Block(Block_Type)\Physic
      Physic_Plugin.s = Block(Block_Type)\Physic_Plugin
      
      If Physic > 0 Or Physic_Plugin <> ""
        
        PokeB(*Physics_Pointer, PeekA(*Physics_Pointer) | (1 << (Physic_Offset % 8)))
        
        LastElement(*Map_Data\Map_Block_Do())
        AddElement(*Map_Data\Map_Block_Do())
        *Map_Data\Map_Block_Do()\Time = Milliseconds() + Block(Block_Type)\Do_Time + Random(Block(Block_Type)\Do_Time_Random)
        *Map_Data\Map_Block_Do()\X = X
        *Map_Data\Map_Block_Do()\Y = Y
        *Map_Data\Map_Block_Do()\Z = Z
        
      EndIf
    EndIf
    
    If *Map_Block_Do_Old
      ChangeCurrentElement(*Map_Data\Map_Block_Do(), *Map_Block_Do_Old)
    EndIf
    
  EndIf
EndProcedure

Procedure Map_Block_Do_Distribute(*Map_Data.Map_Data, X, Y, Z)
  
  *Pointer.Map_Block
  
  Offset = Map_Get_Offset(X, Y, Z, *Map_Data\Size_X, *Map_Data\Size_Y, #Map_Block_Element_Size)
  
  If Offset < Map_Get_Size(*Map_Data\Size_X, *Map_Data\Size_Y, *Map_Data\Size_Z, #Map_Block_Element_Size)
    *Pointer = *Map_Data\Data + Offset
    
    Block_Type.a = *Pointer\Type
    Physic.a = Block(Block_Type)\Physic
    Physic_Plugin.s = Block(Block_Type)\Physic_Plugin
    Do_Repeat = Block(Block_Type)\Do_Repeat
    
    Select Physic
      Case 10 ; Physic: Fällt gerade herunter
        Physic_Block_Compute_10(*Map_Data, X, Y, Z)
        
      Case 11 ; Physic: Lässt maximal 45° Schrägen zu (Bildet Pyramiden)
        Physic_Block_Compute_11(*Map_Data, X, Y, Z)
        
      Case 20 ; Physic: Minecraft original Fluidphysik (Block dupliziert sich seitlich und nach unten)
        Physic_Block_Compute_20(*Map_Data, X, Y, Z)
        
      Case 21 ; Physic: Realistischeres Fluid (Block Fällt nach unten und füllt flächen aus)
        Physic_Block_Compute_21(*Map_Data, X, Y, Z)
        
    EndSelect
    
    If Physic_Plugin <> ""
      Plugin_Event_Block_Physics(Physic_Plugin, *Map_Data, X, Y, Z)
    EndIf
    
    If Do_Repeat
      Map_Block_Do_Add(*Map_Data, X, Y, Z)
    EndIf
    
  EndIf
EndProcedure

Procedure Map_Physic_Thread(*Dummy) ; Thread, für Physik
  Repeat
    
    LockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Physic", "Begin Thread-Slope", 0)
    
    If ListIndex(Map_Data()) <> -1
      *Map_Data_Old = Map_Data()
    Else
      *Map_Data_Old = 0
    EndIf
    
    ForEach Map_Data()
      If Map_Data()\Physic_Stopped = 0
        SortStructuredList(Map_Data()\Map_Block_Do(), #PB_Sort_Ascending, OffsetOf(Map_Block_Do\Time), #PB_Long)
        
        Watchdog_Watch("Map_Physic", "After: SortStructuredList(Map_Block_Do())", 1)
        
        Counter = 0
        
        If ListIndex(Map_Data()) <> -1
          *Map_Data_Old_2 = Map_Data()
        Else
          *Map_Data_Old_2 = 0
        EndIf
        
        *Map_Data_Element.Map_Data = Map_Data()
        While FirstElement(*Map_Data_Element\Map_Block_Do())
          If *Map_Data_Element\Map_Block_Do()\Time < Milliseconds()
            X = *Map_Data_Element\Map_Block_Do()\X
            Y = *Map_Data_Element\Map_Block_Do()\Y
            Z = *Map_Data_Element\Map_Block_Do()\Z
            DeleteElement(*Map_Data_Element\Map_Block_Do(), 1)
            Physic_Offset = Map_Get_Offset(X, Y, Z, *Map_Data_Element\Size_X, *Map_Data_Element\Size_Y, 1)
            *Physics_Pointer = *Map_Data_Element\Physic_Data + Physic_Offset/8
            PokeB(*Physics_Pointer, PeekA(*Physics_Pointer) & ~(1 << (Physic_Offset % 8)))
            Map_Block_Do_Distribute(*Map_Data_Element, X, Y, Z)
            Counter + 1
          Else
            Break
          EndIf
          
          If Counter > 1000
            Break
          EndIf
        Wend
        
        If *Map_Data_Old_2
          ChangeCurrentElement(Map_Data(), *Map_Data_Old_2)
        EndIf
        
      EndIf
    Next
    
    If *Map_Data_Old
      ChangeCurrentElement(Map_Data(), *Map_Data_Old)
    EndIf
    
    UnlockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Physic", "End Thread-Slope", 2)
    
    Delay(3)
    
  ForEver
EndProcedure

Procedure Map_Blockchanging_Thread(*Dummy) ; In diesem Thread werden alle Blockänderungen nacheinander gesendet
  Blockchange_Timer = Milliseconds()
  
  Repeat
    
    LockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Blockchanging", "Begin Thread-Slope", 0)
    
    While Blockchange_Timer < Milliseconds()
      Blockchange_Timer + 100
      
      ForEach Map_Data()
        If Map_Data()\Blockchange_Stopped = 0
          
          List_Store(*Map_Data_Old, Map_Data())
          
          Max_Changes = Map_Settings\Max_Changes_Per_s / 10
          
          *Map_Data_Element.Map_Data = Map_Data()
          ForEach *Map_Data_Element\Map_Block_Changed()
            
            X = *Map_Data_Element\Map_Block_Changed()\X
            Y = *Map_Data_Element\Map_Block_Changed()\Y
            Z = *Map_Data_Element\Map_Block_Changed()\Z
            Old_Material.w = *Map_Data_Element\Map_Block_Changed()\Old_Material
            Material.a = Map_Block_Get_Type(*Map_Data_Element, X, Y, Z)
            DeleteElement(*Map_Data_Element\Map_Block_Changed())
            
            Blockchange_Offset = Map_Get_Offset(X, Y, Z, *Map_Data_Element\Size_X, *Map_Data_Element\Size_Y, 1)
            If Blockchange_Offset < Map_Get_Size(*Map_Data_Element\Size_X, *Map_Data_Element\Size_Y, *Map_Data_Element\Size_Z, 1)
              *Blockchange_Pointer = *Map_Data_Element\Blockchange_Data + Blockchange_Offset/8
              PokeB(*Blockchange_Pointer, PeekA(*Blockchange_Pointer) & ~(1 << (Blockchange_Offset % 8)))
            EndIf
            
            If Material <> Old_Material
              Network_Out_Block_Set_2_Map(*Map_Data_Element\ID, X, Y, Z, Material)
              Max_Changes - 1
              If Max_Changes <= 0
                Break
              EndIf
            EndIf
          Next
          
          List_Restore(*Map_Data_Old, Map_Data())
          
        EndIf
      Next
      
    Wend
    
    UnlockMutex(Main\Mutex)
    
    Watchdog_Watch("Map_Blockchanging", "End Thread-Slope", 2)
    
    Delay(3)
    
  ForEver
EndProcedure

Procedure Map_Main()
  If Map_Main\Timer_File_Check < Milliseconds()
    Map_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Map_List"), #PB_Date_Modified)
    If Map_Main\File_Date_Last <> File_Date
      Map_List_Load(Files_File_Get("Map_List"))
    EndIf
  EndIf
 
  If Map_Main\Save_File And Map_Main\Save_File_Timer < Milliseconds()
    Map_Main\Save_File_Timer = Milliseconds() + 10000
    Map_Main\Save_File = 0
    Map_List_Save(Files_File_Get("Map_List"))
  EndIf
  ForEach Map_Data()
    If Map_Data()\Save_Intervall > 0 And Map_Data()\Save_Time + Map_Data()\Save_Intervall*60000 < Milliseconds()
      Map_Data()\Save_Time = Milliseconds()
      Map_Action_Add_Save(0, Map_Data()\ID, "")
    EndIf
  Next
  
  If Map_Settings\Timer_File_Check < Milliseconds()
    Map_Settings\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Map_Settings"), #PB_Date_Modified)
    If Map_Settings\File_Date_Last <> File_Date
      Map_Settings_Load(Files_File_Get("Map_Settings"))
    EndIf
  EndIf
  
  If Map_Main\Timer_Stats < Milliseconds()
    Map_Main\Timer_Stats = Milliseconds() + 5000
    
    Map_HTML_Stats()
    
  EndIf
EndProcedure
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 1843
; FirstLine = 1832
; Folding = --------
; EnableThread
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0