; ########################################## Variablen ##########################################

Structure Chat_Main
  
EndStructure
Global Chat_Main.Chat_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Chat_Message_Network_Send_2_Map(Entity_ID, Message.s) ; Sendet eine Nachricht eines Entities zu allen Clienten auf einer Karte
  List_Store(*Pointer, Entity())
  
  If Entity_Select_ID(Entity_ID)
    
    If Entity()\Player_List
      If Entity()\Player_List\Time_Muted < Date()
        
        Map_ID = Entity()\Map_ID
        Text.s = Message
        
        ;For i = 0 To 9
        ;  Text.s = ReplaceString(Text, "%"+Str(i), "&"+Str(i))
        ;Next
        ;For i = 97 To 102
        ;  Text.s = ReplaceString(Text, "%"+Chr(i), "&"+Chr(i))
        ;Next
        Text = ReplaceString(Text, "<br>", Chr(10))
        Text = ReplaceString(Text, Chr(10), Chr(10)+Entity_Displayname_Get(Entity_ID)+"&f: ")
        
        If Plugin_Event_Chat_Map(Entity(), Message.s)
          
          Log_Add("Chat", Entity()\Name+": "+Message, 1, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          
          Text.s = Entity_Displayname_Get(Entity_ID)+"&f: "+Text
          System_Message_Network_Send_2_All(Map_ID, Text)
          
        EndIf
        
      Else
        Entity_Message_2_Clients(Entity_ID, Lang_Get("", "Ingame: You are muted"))
      EndIf
      
    EndIf
  EndIf
  
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Chat_Message_Network_Send_2_All(Entity_ID, Message.s) ; Sendet eine Nachricht eines Entities zu allen Clienten (Globalchat)
  List_Store(*Pointer, Entity())
  
  If Entity_Select_ID(Entity_ID)
    
    If Entity()\Player_List
      If Entity()\Player_List\Time_Muted < Date()
        
        Map_ID = Entity()\Map_ID
        Text.s = Message
        
        ;For i = 0 To 9
        ;  Text.s = ReplaceString(Text, "%"+Str(i), "&"+Str(i))
        ;Next
        ;For i = 97 To 102
        ;  Text.s = ReplaceString(Text, "%"+Chr(i), "&"+Chr(i))
        ;Next
        Text = ReplaceString(Text, "<br>", Chr(10))
        Text = ReplaceString(Text, Chr(10), Chr(10)+Lang_Get("", "Ingame: Global_Message")+" "+Entity_Displayname_Get(Entity_ID)+"&f: ")
        
        If Plugin_Event_Chat_All(Entity(), Message.s)
          
          Log_Add("Chat", "# "+Entity()\Name+": "+Message, 1, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
          
          Text.s = Lang_Get("", "Ingame: Global_Message")+" "+Entity_Displayname_Get(Entity_ID)+"&f: "+Text
          System_Message_Network_Send_2_All(-1, Text)
          
        EndIf
        
      Else
        Entity_Message_2_Clients(Entity_ID, Lang_Get("", "Ingame: You are muted"))
      EndIf
      
    EndIf
  EndIf
  
  List_Restore(*Pointer, Entity())
EndProcedure

Procedure Chat_Message_Network_Send(Entity_ID, Player_Name.s, Message.s) ; Sendet eine Nachricht eines Entities zu einem anderen Entity's Client
  List_Store(*Pointer, Entity())
  List_Store(*Pointer_2, Network_Client())
  
  If Entity_Select_ID(Entity_ID)
    
    If Player_Name = ""
      Player_Name = Entity()\Last_Private_Message
    EndIf
    
    If Entity()\Player_List
      If Entity()\Player_List\Time_Muted < Date()
        
        Text.s = Message
        ;For i = 0 To 9
        ;  Text.s = ReplaceString(Text, "%"+Str(i), "&"+Str(i))
        ;Next
        ;For i = 97 To 102
        ;  Text.s = ReplaceString(Text, "%"+Chr(i), "&"+Chr(i))
        ;Next
        Text.s = ReplaceString(Text, "<br>", Chr(10))
        Text.s = Text
        Text_1.s = Lang_Get("", "Private_Message: From")+" "+Entity_Displayname_Get(Entity_ID)+"&f: "+Text
        Text_1.s = ReplaceString(Text_1, Chr(10), Chr(10)+Lang_Get("", "Private_Message: From")+" "+Entity_Displayname_Get(Entity_ID)+"&f: "+Text_1)
        
        Found = 0
        ForEach Network_Client()
          If Network_Client()\Player\Entity
            If LCase(Network_Client()\Player\Entity\Name) = LCase(Player_Name)
              
              Entity()\Last_Private_Message = Player_Name
              
              Log_Add("Chat", Entity()\Name+" > "+Network_Client()\Player\Entity\Name+": "+Message, 1, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
              
              System_Message_Network_Send(Network_Client()\ID, Text_1)
              
              Text_0.s = Lang_Get("", "Private_Message: At")+" "+Entity_Displayname_Get(Network_Client()\Player\Entity\ID)+"&f: "+Text
              Text_0.s = ReplaceString(Text_0, Chr(10), Chr(10)+Lang_Get("", "Private_Message: At")+" "+Entity_Displayname_Get(Network_Client()\Player\Entity\ID)+"&f: "+Text_0)
              
              Entity_Message_2_Clients(Entity_ID, Text_0)
              
              Found = 1
            EndIf
          EndIf
        Next
        
        If Found = 0
          Entity_Message_2_Clients(Entity_ID, Lang_Get("", "Ingame: Can't find Network_Client()\Player\Entity\Name = [Field_0]", Player_Name))
        EndIf
        
      Else
        Entity_Message_2_Clients(Entity_ID, Lang_Get("", "Ingame: You are muted"))
      EndIf
    EndIf
    
  EndIf
  
  List_Restore(*Pointer, Entity())
  List_Restore(*Pointer_2, Network_Client())
EndProcedure
; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 24
; Folding = -
; EnableXP
; DisableDebugger