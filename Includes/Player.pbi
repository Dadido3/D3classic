; ########################################## Variablen ##########################################

Structure Player_Main
  List_Thread_ID.i            ; ID des List-Threads
  Save_File.b                 ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l            ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
  Timer_Ontime_Counter.l      ; Timer für den Ontime_Counter
  Message_Welcome.s           ; Nachricht welche dem eingeloggten Benutzer erscheint.
  Players_Max.u               ; Maximale Anzahl spieler
  Name_Verification.b         ; Namensüberprüfung aktiv
  Kill_Mode.a                 ; Sterbe-art (0=Map-Spawn, 1=Global Kill-Spawn, 2=Kick, 3=Ban)
  Kill_Spawn_Map_ID.l         ; Spawnpoint beim Sterben
  Kill_Spawn_X.f              ; Spawnpoint beim Sterben
  Kill_Spawn_Y.f              ; Spawnpoint beim Sterben
  Kill_Spawn_Z.f              ; Spawnpoint beim Sterben
  Kill_Spawn_Rot.f            ; Spawnpoint beim Sterben
  Kill_Spawn_Look.f           ; Spawnpoint beim Sterben
  Spawn_Map_ID.l              ; Spawnmap beim Betreten des Servers
EndStructure
Global Player_Main.Player_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Player_Save(Filename.s) ; Speichert die Einstellungen
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; Kill_Modes: 0=Map-Spawn, 1=Global Kill-Spawn, 2=Kick, 3=Ban")
    WriteStringN(File_ID, "")
    
    WriteStringN(File_ID, "Message_Welcome = "+Player_Main\Message_Welcome)
    WriteStringN(File_ID, "Players_Max = "+Str(Player_Main\Players_Max))
    WriteStringN(File_ID, "Name_Verification = "+Str(Player_Main\Name_Verification))
    
    WriteStringN(File_ID, "Kill_Mode = "+Str(Player_Main\Kill_Mode))
    WriteStringN(File_ID, "Kill_Spawn_Map_ID = "+Str(Player_Main\Kill_Spawn_Map_ID))
    WriteStringN(File_ID, "Kill_Spawn_X = "+StrF(Player_Main\Kill_Spawn_X, 2))
    WriteStringN(File_ID, "Kill_Spawn_Y = "+StrF(Player_Main\Kill_Spawn_Y, 2))
    WriteStringN(File_ID, "Kill_Spawn_Z = "+StrF(Player_Main\Kill_Spawn_Z, 2))
    WriteStringN(File_ID, "Kill_Spawn_Rot = "+StrF(Player_Main\Kill_Spawn_Rot, 2))
    WriteStringN(File_ID, "Kill_Spawn_Look = "+StrF(Player_Main\Kill_Spawn_Look, 2))
    
    WriteStringN(File_ID, "Spawn_Map_ID = "+Str(Player_Main\Spawn_Map_ID))
    
    Player_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Player", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Player_Load(Filename.s) ; Lädt die Einstellungen
  If OpenPreferences(Filename)
    
    Player_Main\Message_Welcome = ReadPreferenceString("Message_Welcome", "")
    Player_Main\Players_Max = ReadPreferenceLong("Players_Max", 255)
    Player_Main\Name_Verification = ReadPreferenceLong("Name_Verification", 1)
    
    Player_Main\Kill_Mode = ReadPreferenceLong("Kill_Mode", 0)
    Player_Main\Kill_Spawn_Map_ID = ReadPreferenceLong("Kill_Spawn_Map_ID", 0)
    Player_Main\Kill_Spawn_X = ReadPreferenceFloat("Kill_Spawn_X", 0)
    Player_Main\Kill_Spawn_Y = ReadPreferenceFloat("Kill_Spawn_Y", 0)
    Player_Main\Kill_Spawn_Z = ReadPreferenceFloat("Kill_Spawn_Z", 0)
    Player_Main\Kill_Spawn_Rot = ReadPreferenceFloat("Kill_Spawn_Rot", 0)
    Player_Main\Kill_Spawn_Look = ReadPreferenceFloat("Kill_Spawn_Look", 0)
    
    Player_Main\Spawn_Map_ID = ReadPreferenceLong("Spawn_Map_ID", 0)
    
    Player_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Player", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
    
  EndIf
EndProcedure

Procedure Player_Attribute_Long_Set(Player_Number, Attribute.s, Value.l) ; Speichert ein Attribut (Long)
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  If Player_List_Select_Number(Player_Number)
    
    Found = 0
    
    For i = 0 To #Player_Attributes-1
      If Player_List()\Attribute [i] = Attribute
        If Value = 0
          Player_List()\Attribute [i] = ""
        EndIf
        Player_List()\Attribute_Long [i] = Value
        Found = 1
        Break
      EndIf
    Next
    
    If Found = 0
      For i = 0 To #Player_Attributes-1
        If Player_List()\Attribute [i] = ""
          If Value
            Player_List()\Attribute [i] = Attribute
          EndIf
          Player_List()\Attribute_Long [i] = Value
          Break
        EndIf
      Next
    EndIf
    
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
  
EndProcedure

Procedure Player_Attribute_Long_Get(Player_Number, Attribute.s) ; Gibt ein Attribut (Long) aus
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  If Player_List_Select_Number(Player_Number)
    
    Value = 0
    
    For i = 0 To #Player_Attributes-1
      If Player_List()\Attribute [i] = Attribute
        Value = Player_List()\Attribute_Long [i]
        Break
      EndIf
    Next
    
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
  
  ProcedureReturn Value
EndProcedure

Procedure Player_Attribute_String_Set(Player_Number, Attribute.s, String.s) ; Speichert ein Attribut (String)
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  If Player_List_Select_Number(Player_Number)
    
    Found = 0
    
    For i = 0 To #Player_Attributes-1
      If Player_List()\Attribute [i] = Attribute
        If String = ""
          Player_List()\Attribute [i] = ""
        EndIf
        Player_List()\Attribute_String [i] = String
        Found = 1
        Break
      EndIf
    Next
    
    If Found = 0
      For i = 0 To #Player_Attributes-1
        If Player_List()\Attribute [i] = ""
          If String
            Player_List()\Attribute [i] = Attribute
          EndIf
          Player_List()\Attribute_String [i] = String
          Break
        EndIf
      Next
    EndIf
    
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
EndProcedure

Threaded Player_Attribute_String_Get_Return_String.s = ""
Procedure.s Player_Attribute_String_Get(Player_Number, Attribute.s) ; Gibt ein Attribut (String) aus
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  Player_Attribute_String_Get_Return_String = ""
  
  If Player_List_Select_Number(Player_Number)
    
    For i = 0 To #Player_Attributes-1
      If Player_List()\Attribute [i] = Attribute
        Player_Attribute_String_Get_Return_String = Player_List()\Attribute_String [i]
        Break
      EndIf
    Next
    
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
  
  ProcedureReturn Player_Attribute_String_Get_Return_String
EndProcedure

Procedure.s Player_Inventory_Set(Player_Number, Material, Number) ; Setzt den Inventarswert
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  If Player_List_Select_Number(Player_Number)
    If Material >= 0 And Material <= 255
      Player_List()\Inventory [Material] = Number
      Player_List()\Save = 1
      Player_List_Main\Save_File = 1
    EndIf
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
EndProcedure

Procedure Player_Inventory_Get(Player_Number, Material) ; Gibt den Inventarswert aus
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  Result = -1
  
  If Player_List_Select_Number(Player_Number)
    If Material >= 0 And Material <= 255
      Result = Player_List()\Inventory [Material]
    EndIf
  EndIf
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Player_Rank_Set(Player_Number, Rank, Reason.s)
  If Player_List_Select_Number(Player_Number)
    Player_List()\Rank = Rank
    Player_List()\Message_Rank = Reason
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    If Rank_Select(Rank)
      ForEach Network_Client()
        If Network_Client()\Player\Entity
          If Network_Client()\Player\Entity\Player_List
            If Network_Client()\Player\Entity\Player_List\Number = Player_Number
              Entity_Displayname_Set(Network_Client()\Player\Entity\ID, Player_Get_Prefix(Player_Number), Player_Get_Name(Player_Number), Player_Get_Suffix(Player_Number))
              System_Message_Network_Send(Network_Client()\ID, Lang_Get("", "Ingame: Your rank got changed '[Field_0]' ([Field_1])", Rank()\Name, Str(Rank)))
            EndIf
          EndIf
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

Procedure Player_Kick(Player_Number, Reason.s, Count, Log, Show) ; Kickt alle Klienten des Spielers
  List_Store(*Pointer_Network, Network_Client())
  List_Store(*Pointer_Player, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Found = 0
    
    Red_Screen.s = Lang_Get("", "Red_Screen: You got kicked", Reason)
    
    ForEach Network_Client()
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity\Player_List
          If Network_Client()\Player\Entity\Player_List\Number = Player_Number
            Network_Client_Kick(Network_Client()\ID, Red_Screen, 1)
            Found + 1
          EndIf
        EndIf
      EndIf
    Next
    If Found
      Player_List()\Counter_Kick + Count
      Player_List()\Message_Kick = Reason
      Player_List()\Save = 1
      Player_List_Main\Save_File = 1
      
      If Show
        Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player kicked", Display_Name, Reason))
      EndIf
      
      If Log
        Log_Add("Player", Lang_Get("", "Player kicked", Player_Get_Name(Player_Number), Reason), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
    EndIf
  EndIf
  
  List_Restore(*Pointer_Network, Network_Client())
  List_Restore(*Pointer_Player, Player_List())
EndProcedure

Procedure Player_Ban(Player_Number, Reason.s) ; Bannt den Spieler und Kickt alle Klienten
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Player_List()\Banned = 1
    Player_List()\Message_Ban = Reason
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player banned", Display_Name, Reason))
    
    Log_Add("Player", Lang_Get("", "Player banned", Player_Get_Name(Player_Number), Reason), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    Player_Kick(Player_Number, Reason, 0, 1, Show)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Unban(Player_Number) ; Entbannt den Spieler
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Player_List()\Banned = 0
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player unbanned", Display_Name))
    
    Log_Add("Player", Lang_Get("", "Player unbanned", Player_Get_Name(Player_Number)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Stop(Player_Number, Reason.s) ; Stoppt den Spieler
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Player_List()\Stopped = 1
    Player_List()\Message_Stop = Reason
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player stopped", Display_Name, Reason))
    
    Log_Add("Player", Lang_Get("", "Player stopped", Player_Get_Name(Player_Number)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Unstop(Player_Number) ; Entstoppt den Spieler
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Player_List()\Stopped = 0
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player unstopped", Display_Name))
    
    Log_Add("Player", Lang_Get("", "Player unstopped", Player_Get_Name(Player_Number)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Mute(Player_Number, Minutes, Reason.s) ; Stellt den Spieler stumm
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    If Minutes
      Player_List()\Time_Muted = Date() + Minutes*60
      If Minutes = 1
        System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player muted (minute)", Display_Name, Reason, Str(Minutes)))
      Else
        System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player muted (minutes)", Display_Name, Reason, Str(Minutes)))
      EndIf
    Else
      Player_List()\Time_Muted = 2147483647
      System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player muted", Display_Name, Reason))
    EndIf
    Player_List()\Message_Mute = Reason
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Log_Add("Player", Lang_Get("", "Player muted", Player_Get_Name(Player_Number)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Unmute(Player_Number) ; Entstummt den Spieler
  List_Store(*Pointer, Player_List())
  
  If Player_List_Select_Number(Player_Number)
    Player_List()\Time_Muted = 0
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
    
    Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
    System_Message_Network_Send_2_All(-1, Lang_Get("", "Ingame: Player unmuted", Display_Name))
    
    Log_Add("Player", Lang_Get("", "Player unmuted", Player_Get_Name(Player_Number)), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  List_Restore(*Pointer, Player_List())
EndProcedure

Procedure Player_Get_Online(Player_Number, ID_Exception)
  List_Store(*Pointer_Network, Network_Client())
  List_Store(*Pointer_Player, Player_List())
  
  Result = #False
  
  If Player_List_Select_Number(Player_Number)
    ForEach Network_Client()
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity\Player_List
          If Network_Client()\Player\Entity\Player_List\Number = Player_Number And Network_Client()\ID <> ID_Exception
            Result = #True
            Break
          EndIf
        EndIf
      EndIf
    Next
  EndIf
  
  List_Restore(*Pointer_Network, Network_Client())
  List_Restore(*Pointer_Player, Player_List())
  
  ProcedureReturn Result
EndProcedure

Procedure.s Player_Get_Prefix(Player_Number)
  List_Store(*Pointer_Player, Player_List())
  List_Store(*Pointer_Rank, Rank())
  
  Result.s = ""
  
  If Player_List_Select_Number(Player_Number)
    If Rank_Select(Player_List()\Rank)
      Result.s = Rank()\Prefix
    EndIf
  EndIf
  
  List_Restore(*Pointer_Player, Player_List())
  List_Restore(*Pointer_Rank, Rank())
  
  ProcedureReturn Result
EndProcedure

Procedure.s Player_Get_Name(Player_Number)
  List_Store(*Pointer_Player, Player_List())
  
  Result.s = ""
  
  If Player_List_Select_Number(Player_Number)
    Result.s = Player_List()\Name
  EndIf
  
  List_Restore(*Pointer_Player, Player_List())
  
  ProcedureReturn Result
EndProcedure

Procedure.s Player_Get_Suffix(Player_Number)
  List_Store(*Pointer_Player, Player_List())
  List_Store(*Pointer_Rank, Rank())
  
  Result.s = ""
  
  If Player_List_Select_Number(Player_Number)
    If Rank_Select(Player_List()\Rank)
      Result.s = Rank()\Suffix
    EndIf
  EndIf
  
  List_Restore(*Pointer_Player, Player_List())
  List_Restore(*Pointer_Rank, Rank())
  
  ProcedureReturn Result
EndProcedure

Procedure Player_Ontime_Counter_Add(Seconds.d) ; Erhöht den Sekunden Zähler aller Spieler(Online) in der Playerlist
  ForEach Player_List()
    If Player_List()\Online
      Player_List()\Ontime_Counter + Seconds
    EndIf
  Next
EndProcedure

Procedure Player_Main()
  If Player_Main\Timer_File_Check < Milliseconds()
    Player_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Player"), #PB_Date_Modified)
    If Player_Main\File_Date_Last <> File_Date
      Player_Load(Files_File_Get("Player"))
    EndIf
  EndIf
  
  If Player_Main\Timer_Ontime_Counter < Milliseconds()
    Difference = Milliseconds() - Player_Main\Timer_Ontime_Counter
    Player_Main\Timer_Ontime_Counter = Milliseconds() + 1000*10
    Player_Ontime_Counter_Add(10+Difference*0.001)
  EndIf
  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 534
; FirstLine = 491
; Folding = ----
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0