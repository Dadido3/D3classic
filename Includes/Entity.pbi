; ########################################## Konstanten ##########################################

; ########################################## Variablen ###########################################

Structure Entity_Main
  Timer_Send.l                    ; Timer für das Senden der Entities (Pos, Löschen, Erstellen)
  Timer_Check_Pos.l               ; Timer für das Überprüfen der Position
EndStructure
Global Entity_Main.Entity_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Imports #############################################

; ########################################## Macros ##############################################

; ########################################## Initkram ############################################

; ########################################## Proceduren ##########################################

Procedure Entity_Select_ID(ID, Log=1)
  If ListIndex(Entity()) <> -1 And Entity()\ID = ID
    ProcedureReturn #True
  Else
    ForEach Entity()
      If Entity()\ID = ID
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Entity", Lang_Get("", "Can't find Entity()\ID = [Field_0]", Str(ID)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure Entity_Select_Name(Name.s, Log=1)
  If ListIndex(Entity()) <> -1 And LCase(Entity()\Name) = LCase(Name)
    ProcedureReturn #True
  Else
    ForEach Entity()
      If LCase(Entity()\Name) = LCase(Name)
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Entity", Lang_Get("", "Can't find Entity()\Name = [Field_0]", Name), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure Entity_Get_Pointer(ID)
  List_Store(*Pointer, Entity())
  If ListIndex(Entity()) <> -1 And Entity()\ID = ID
    ProcedureReturn Entity()
  Else
    ForEach Entity()
      If Entity()\ID = ID
        *Result = Entity()
        List_Restore(*Pointer, Entity())
        ProcedureReturn *Result
      EndIf
    Next
  EndIf
  
  Log_Add("Entity", Lang_Get("", "Can't find Entity()\ID = [Field_0]", Str(ID)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  List_Restore(*Pointer, Entity())
  ProcedureReturn 0
EndProcedure

Procedure Entity_Get_Free_ID()
  List_Store(*Pointer, Entity())
  ID = 0
  Repeat
    Found = 0
    ForEach Entity()
      If ID = Entity()\ID
        Found = 1
        Break
      EndIf
    Next
    If Found = 0
      List_Restore(*Pointer, Entity())
      ProcedureReturn ID
    Else
      ID + 1
    EndIf
  ForEver
  
  Log_Add("Entity", Lang_Get("", "No free Entity()\ID"), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  List_Restore(*Pointer, Entity())
  ProcedureReturn -1
EndProcedure

Procedure Entity_Get_Free_ID_Client(Map_ID)
  List_Store(*Pointer, Entity())
  For ID = 0 To 127
    Found = 0
    ForEach Entity()
      If ID = Entity()\ID_Client And Map_ID = Entity()\Map_ID
        Found = 1
        Break
      EndIf
    Next
    If Found = 0
      List_Restore(*Pointer, Entity())
      ProcedureReturn ID
    EndIf
  Next
  
  Log_Add("Entity", Lang_Get("", "No free Entity()\ID_Client"), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  
  List_Restore(*Pointer, Entity())
  ProcedureReturn -1
EndProcedure

;-

Procedure Entity_Add(Name.s, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f)
  ID = Entity_Get_Free_ID()
  ID_Client = Entity_Get_Free_ID_Client(Map_ID)
  
  If ID <> -1 And ID_Client <> -1
    
    AddElement(Entity())
    Entity()\Prefix = ""
    Entity()\Name = Name
    Entity()\Suffix = ""
    Entity()\ID = ID
    Entity()\ID_Client = ID_Client
    Entity()\Map_ID = Map_ID
    Entity()\X = X
    Entity()\Y = Y
    Entity()\Z = Z
    Entity()\Rotation = Rotation
    Entity()\Look = Look
    Entity()\Build_Mode = "Normal"
    
    Plugin_Event_Entity_Add(Entity())
    
    ProcedureReturn ID
  EndIf
  
  ProcedureReturn -1
EndProcedure

Procedure Entity_Delete(ID)
  If Entity_Select_ID(ID)
    
    Plugin_Event_Entity_Add(Entity())
    
    ; ############# Pointer zu dem Element löschen
    ForEach Network_Client()
      If Network_Client()\Player\Entity = Entity()
        Network_Client()\Player\Entity = 0
      EndIf
    Next
    
    ; ############# Element löschen
    DeleteElement(Entity())
  EndIf
EndProcedure

Procedure Entity_Resend(ID)
  If Entity_Select_ID(ID)
    Entity()\Resend = 1
  EndIf
EndProcedure

Procedure Entity_Message_2_Clients(ID, Message.s) ; Sendet eine Nachricht zu den Mutterklienten
  List_Store(*Pointer, Network_Client())
  ForEach Network_Client()
    If Network_Client()\Player\Entity
      If Network_Client()\Player\Entity\ID = ID
        System_Message_Network_Send(Network_Client()\ID, Message)
      EndIf
    EndIf
  Next
  List_Restore(*Pointer, Network_Client())
EndProcedure

Threaded Entity_Displayname_Get_Return_String.s = ""
Procedure.s Entity_Displayname_Get(ID)
  
  List_Store(*Pointer, Entity())
  If Entity_Select_ID(ID)
    Entity_Displayname_Get_Return_String = Entity()\Prefix + Entity()\Name + Entity()\Suffix
    List_Restore(*Pointer, Entity())
    ProcedureReturn Entity_Displayname_Get_Return_String
  EndIf
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Entity_Displayname_Set(ID, Prefix.s, Name.s, Suffix.s)
  List_Store(*Pointer, Entity())
  If Entity_Select_ID(ID)
    Entity()\Prefix = Prefix
    Entity()\Name = Name
    Entity()\Suffix = Suffix
    Entity_Resend(ID)
  EndIf
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Entity_Kill(ID)
  List_Store(*Pointer, Entity())
  If Entity_Select_ID(ID)
    Map_ID = Entity()\Map_ID
    If Map_Select_ID(Map_ID)
      
      If Plugin_Event_Entity_Die(Entity())
        
        If Entity()\Time_Message_Death < Milliseconds()
          Entity()\Time_Message_Death = Milliseconds() + 2000
          System_Message_Network_Send_2_All(Map_ID, Lang_Get("", "Ingame: [Field_0] Died", Entity()\Name))
        EndIf
        
        X.f = Map_Data()\Spawn_X
        Y.f = Map_Data()\Spawn_Y
        Z.f = Map_Data()\Spawn_Z
        Rotation.f = Map_Data()\Spawn_Rot
        Look.f = Map_Data()\Spawn_Look
        Entity_Position_Set(ID, Map_ID, X, Y, Z, Rotation, Look, 5, 1)
        
      EndIf
      
    EndIf
  EndIf
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Entity_Position_Check(ID) ; Prüft, ob dieses Entity den Block betreten darf/ ob er tötlich ist ... und Teleporter
  List_Store(*Pointer, Entity())
  If Entity_Select_ID(ID)
    Map_ID = Entity()\Map_ID
    X = Round(Entity()\X, #PB_Round_Down)
    Y = Round(Entity()\Y, #PB_Round_Down)
    Z = Round(Entity()\Z, #PB_Round_Down)
    
    If Map_Select_ID(Map_ID)
      ForEach Map_Data()\Teleporter()
        If X >= Map_Data()\Teleporter()\X_0 And X <= Map_Data()\Teleporter()\X_1 And Y >= Map_Data()\Teleporter()\Y_0 And Y <= Map_Data()\Teleporter()\Y_1 And Z >= Map_Data()\Teleporter()\Z_0 And Z <= Map_Data()\Teleporter()\Z_1
          Dest_Map_Unique_ID.s = Map_Data()\Teleporter()\Dest_Map_Unique_ID
          Dest_Map_ID = Map_Data()\Teleporter()\Dest_Map_ID
          Dest_X.f = Map_Data()\Teleporter()\Dest_X
          Dest_Y.f = Map_Data()\Teleporter()\Dest_Y
          Dest_Z.f = Map_Data()\Teleporter()\Dest_Z
          Dest_Rot.f = Map_Data()\Teleporter()\Dest_Rot
          Dest_Look.f = Map_Data()\Teleporter()\Dest_Look
          
          If Dest_Map_Unique_ID And Map_Select_Unique_ID(Dest_Map_Unique_ID, 0)
            If Dest_X = -1 And Dest_Y = -1 And Dest_Z = -1
              Dest_X = Map_Data()\Spawn_X
              Dest_Y = Map_Data()\Spawn_Y
              Dest_Z = Map_Data()\Spawn_Z
              Dest_Rot = Map_Data()\Spawn_Rot
              Dest_Look = Map_Data()\Spawn_Look
            EndIf
            Entity_Position_Set(ID, Map_Data()\ID, Dest_X, Dest_Y, Dest_Z, Dest_Rot, Dest_Look, 10, 1)
          ElseIf Dest_Map_ID <> -1 And Map_Select_ID(Dest_Map_ID, 0)
            If Dest_X = -1 And Dest_Y = -1 And Dest_Z = -1
              Dest_X = Map_Data()\Spawn_X
              Dest_Y = Map_Data()\Spawn_Y
              Dest_Z = Map_Data()\Spawn_Z
              Dest_Rot = Map_Data()\Spawn_Rot
              Dest_Look = Map_Data()\Spawn_Look
            EndIf
            Entity_Position_Set(ID, Map_Data()\ID, Dest_X, Dest_Y, Dest_Z, Dest_Rot, Dest_Look, 10, 1)
          EndIf
          Break
        EndIf
      Next
    Else ; ###### Wenn aktuelle Karte nicht vorhanden
      If FirstElement(Map_Data())
        Entity_Position_Set(ID, Map_Data()\ID, Map_Data()\Spawn_X, Map_Data()\Spawn_Y, Map_Data()\Spawn_Z, Map_Data()\Spawn_Rot, Map_Data()\Spawn_Look, 255, 1)
      EndIf
    EndIf
    
    If Map_Select_ID(Map_ID)
      For i = 0 To 1
        Type = Map_Block_Get_Type(Map_Data(), X, Y, Z+i)
        If Type >= 0 And Type <= 255
          If Block(Type)\Killer
            Entity_Kill(ID)
          EndIf
        EndIf
      Next
    EndIf
  EndIf
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Entity_Position_Set(ID, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
  If Entity_Select_ID(ID)
    If Entity()\Send_Pos <= Priority
      
      If Plugin_Event_Entity_Position_Set(Entity(), Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
        
        If Entity()\Map_ID <> Map_ID ; ############## Wenn Kartenwechsel, dann: Neue ID_Client, Texte senden, Rang prüfen
          If Map_Select_ID(Map_ID)
            If Entity()\Player_List = 0 Or Entity()\Player_List\Rank >= Map_Data()\Rank_Join
              System_Message_Network_Send_2_All(Entity()\Map_ID, Lang_Get("", "Ingame: Entity '[Field_0]' changes to map '[Field_1]'", Entity_Displayname_Get(ID), Map_Data()\Name))
              System_Message_Network_Send_2_All(Map_ID, Lang_Get("", "Ingame: Entity '[Field_0]' joins map '[Field_1]'", Entity_Displayname_Get(ID), Map_Data()\Name))
              Entity()\Map_ID = Map_ID
              Entity()\X = X
              Entity()\Y = Y
              Entity()\Z = Z
              Entity()\Rotation = Rotation
              Entity()\Look = Look
              Entity()\ID_Client = Entity_Get_Free_ID_Client(Map_ID)
              ProcedureReturn #True
            Else
              Entity_Message_2_Clients(ID, Lang_Get("", "Ingame: You are not allowed to join map '[Field_0]'", Map_Data()\Name))
              ProcedureReturn #False
            EndIf
          Else
            Entity_Message_2_Clients(ID, Lang_Get("", "Ingame: Can't find Map"))
            ProcedureReturn #False
          EndIf
        Else
          If Map_Select_ID(Entity()\Map_ID) ; ###### Wenn aktuelle Karte vorhanden
            If Send_Own_Client Or Not Entity()\Send_Pos_Own
              Entity()\X = X
              Entity()\Y = Y
              Entity()\Z = Z
              Entity()\Rotation = Rotation
              Entity()\Look = Look
              Entity()\Send_Pos = Priority
              If Send_Own_Client
                Entity()\Send_Pos_Own = #True
              EndIf
              ProcedureReturn #True
            Else
              ProcedureReturn #False
            EndIf
          EndIf
          
        EndIf
        
      Else ; Wenn Bewegen blockiert, alte Position zum Client senden
        Entity()\Send_Pos_Own = #True
        ProcedureReturn #False
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

;-

Procedure Entity_Send() ; Verwaltet das Bewegen, Erstellen und Löschen von Entities der Klienten
  
  ForEach Network_Client()
    If Network_Client()\Logged_In
      ; ############### Entities löschen
      ForEach Network_Client()\Player\Entities()
        ID = Network_Client()\Player\Entities()\ID
        ID_Client = Network_Client()\Player\Entities()\ID_Client
        If Entity_Select_ID(ID, 0)
          Delete = 0
          ; ######## Wenn das Entity nicht auf der selben Karte ist
          If Entity()\Map_ID <> Network_Client()\Player\Map_ID
            Delete = 1
          EndIf
          ; ######## Das Entitie von sich selbst löschen
          If Network_Client()\Player\Entity
            If Network_Client()\Player\Entity\ID = Entity()\ID
              Delete = 1
            EndIf
          EndIf
          ; ######## Wenn das Entity neu gesendet werden soll
          If Entity()\Resend
            Entity()\Resend = 0
            Delete = 1
          EndIf
          If Delete
            Network_Out_Entity_Delete(Network_Client()\ID, ID_Client)
            DeleteElement(Network_Client()\Player\Entities())
          EndIf
        Else ; ##### Wenn Entity nicht mehr existiert
          Network_Out_Entity_Delete(Network_Client()\ID, ID_Client)
          DeleteElement(Network_Client()\Player\Entities())
        EndIf
      Next
      
      ; ############### Entities erstellen
      ForEach Entity()
        If Entity()\Map_ID = Network_Client()\Player\Map_ID
          ; ####### Wenn entity noch nicht vorhanden
          Create = 1
          ForEach Network_Client()\Player\Entities()
            If Network_Client()\Player\Entities()\ID = Entity()\ID
              Create = 0
              Break
            EndIf
          Next
          ; ####### Und wenn es nicht das Eigene ist!
          If Network_Client()\Player\Entity
            If Network_Client()\Player\Entity\ID = Entity()\ID
              Create = 0
            EndIf
          EndIf
          If Create
            AddElement(Network_Client()\Player\Entities())
            Network_Client()\Player\Entities()\ID = Entity()\ID
            Network_Client()\Player\Entities()\ID_Client = Entity()\ID_Client
            Network_Out_Entity_Add(Network_Client()\ID, Entity()\ID_Client, Entity_Displayname_Get(Entity()\ID), Entity()\X, Entity()\Y, Entity()\Z, Entity()\Rotation, Entity()\Look)
          EndIf
        EndIf
      Next
    EndIf
  Next
  
  ; ################ Entities bewegen
  
  ForEach Entity()
    If Entity()\Send_Pos
      Entity()\Send_Pos = 0
      ForEach Network_Client()
        If Network_Client()\Logged_In
          ForEach Network_Client()\Player\Entities()
            If Network_Client()\Player\Entities()\ID = Entity()\ID
              Network_Out_Entity_Position(Network_Client()\ID, Entity()\ID_Client, Entity()\X, Entity()\Y, Entity()\Z, Entity()\Rotation, Entity()\Look)
              Break
            EndIf
          Next
        EndIf
      Next
    EndIf
    If Entity()\Send_Pos_Own
      Entity()\Send_Pos_Own = 0
      ForEach Network_Client()
        If Network_Client()\Logged_In And Network_Client()\Player\Entity = Entity()
          Network_Out_Entity_Position(Network_Client()\ID, 255, Entity()\X, Entity()\Y, Entity()\Z, Entity()\Rotation, Entity()\Look)
        EndIf
      Next
    EndIf
  Next
  
EndProcedure

Procedure Entity_Main()
  If Entity_Main\Timer_Check_Pos < Milliseconds()
    Entity_Main\Timer_Check_Pos = Milliseconds() + 100
    ForEach Entity()
      Entity_Position_Check(Entity()\ID)
    Next
  EndIf
  
  If Entity_Main\Timer_Send < Milliseconds()
    Entity_Main\Timer_Send = Milliseconds() + 100
    Entity_Send()
  EndIf
EndProcedure
; IDE Options = PureBasic 5.22 LTS (Windows - x64)
; CursorPosition = 372
; Folding = ---
; EnableXP
; DisableDebugger