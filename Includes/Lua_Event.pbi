; ########################################## Variablen ##########################################

Structure Lua_Event_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Lua_Event_Main.Lua_Event_Main

Structure Lua_Event
  Type.a                ; Typ: 0=Timer 10=Client_Add 11=Client_Del 20=Player_login 21=Player_Logout 22=Player_Map_Join 23=Player_Map_Left 24=Player_Move 25=Player_Die 30=Map_Chat 40=Blockchange
  Map_ID.l              ; ID der Map
  Lua_Function.s        ; Lua-Funktion welche ausgeführt wird
  Time.q                ; Zeitintervall des Events beim Timer modus
  Time_Next.q           ; Zeitpunkt des nächsten Events beim Timer modus
EndStructure
Global NewList Lua_Event.Lua_Event()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Imports ##########################################

; ########################################## Macros #############################################

; #################################### Initkram ###############################################

; ################################## Proceduren ##########################################

Procedure Lua_Event_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ClearList(Lua_Event())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Lua_Event())
        Lua_Event()\Type = ReadPreferenceLong("Type", -1)
        Lua_Event()\Lua_Function = ReadPreferenceString("Lua_Function", "")
        Lua_Event()\Map_ID = ReadPreferenceLong("Map_ID", -1)
        Lua_Event()\Time = ReadPreferenceLong("Time", 1000)
      Wend
    EndIf
    
    Lua_Event_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Lua_Event", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  Else
    Log_Add("Lua_Event", Lang_Get("", "File not loaded", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Lua_Event_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; Types: 0=Timer 10=Client_Add 11=Client_Del 20=Client_login 21=Client_Logout")
    WriteStringN(File_ID, "; Types: 22=Client_Map_Join 23=Client_Map_Left 24=Client_Move 25=Client_Die 30=Client_Chat_Map 40=Client_Blockchange")
    WriteStringN(File_ID, "; Types: 100=Map_Add 101=Map_Action_Delete 102=Map_Action_Resize 103=Map_Action_Fill")
    WriteStringN(File_ID, "; Types: 104=Map_Action_Save 105=Map_Action_Load")
    WriteStringN(File_ID, "")
    
    ForEach Lua_Event()
      WriteStringN(File_ID, "["+Str(ListIndex(Lua_Event()))+"]")
      WriteStringN(File_ID, "Type = "+Str(Lua_Event()\Type))
      WriteStringN(File_ID, "Lua_Function = "+Lua_Event()\Lua_Function)
      WriteStringN(File_ID, "Map_ID = "+Str(Lua_Event()\Map_ID))
      WriteStringN(File_ID, "Time = "+Str(Lua_Event()\Time))
    Next
    
    Lua_Event_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Lua_Event", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Lua_Event_Do(Type, Client_ID=0, Map_ID=-1, Player_Number=-1, Mode=-1, Material=-1, X=-1, Y=-1, Z=-1, Message.s="", Action_ID=-1, Placed_By_Client.a=0)
  
  Result = 1
  
  ForEach Lua_Event()
    If Lua_Event()\Type = Type
      If Lua_Event()\Map_ID = Map_ID Or Lua_Event()\Map_ID = -1 Or Map_ID = -1
        
        ;Lua_SetVariable_Integer("Event_Type", Type)
        
        Select Type
          Case 0 ; Timer
            If Lua_Event()\Time_Next < Milliseconds()
              Lua_Event()\Time_Next = Milliseconds() + Lua_Event()\Time
              ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Map_ID)+")")
              Lua_Do_Function_Event_Timer(Lua_Event()\Lua_Function, Map_ID)
            EndIf
            
          Case 10 ; Client_Add
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Add(Lua_Event()\Lua_Function, Client_ID)
            
          Case 11 ; Client_Del
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Delete(Lua_Event()\Lua_Function, Client_ID)
            
          Case 20 ; Client_Login
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Login(Lua_Event()\Lua_Function, Client_ID)
            
          Case 21 ; Client_Logout
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Logout(Lua_Event()\Lua_Function, Client_ID)
            
          Case 22 ; Client_Map_Join
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Map_Join(Lua_Event()\Lua_Function, Map_ID, Client_ID)
            
          Case 23 ; Client_Map_Left
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Map_Left(Lua_Event()\Lua_Function, Map_ID, Client_ID)
            
          Case 24 ; Client_Move
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+")")
            Lua_Do_Function_Event_Client_Move(Lua_Event()\Lua_Function, Map_ID, Client_ID)
            
          Case 25 ; Client_Die
            ;Lua_Do_Function(Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+","+Str(Player_Number)+")")
            Lua_Do_Function_Event_Client_Die(Lua_Event()\Lua_Function, Map_ID, Client_ID, Player_Number)
            
          Case 30 ; Client_Chat_Map
            ;Lua_Do_Function("Return_Value = "+Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+",'"+Message+"')")
            If Lua_Do_Function_Event_Client_Chat_Map(Lua_Event()\Lua_Function, Map_ID, Client_ID, Message) = 0
              Result = 0
            EndIf
            
          Case 31 ; Client_Chat_Global
            If Lua_Do_Function_Event_Client_Chat_Global(Lua_Event()\Lua_Function, Client_ID, Message) = 0
              Result = 0
            EndIf
            
          Case 40 ; Client_Blockchange
            ;Lua_Do_Function("Return_Value = "+Lua_Event()\Lua_Function+"("+Str(Map_ID)+","+Str(Client_ID)+","+Str(Mode)+","+Str(Material)+","+Str(X)+","+Str(Y)+","+Str(Z)+")")
            If Lua_Do_Function_Event_Client_Blockchange(Lua_Event()\Lua_Function, Map_ID, Client_ID, Mode, Material, X, Y, Z, Placed_By_Client.a) = 0
              Result = 0
            EndIf
            
          Case 100 ; Map_Add
            Lua_Do_Function_Event_Map(Lua_Event()\Lua_Function, Map_ID)
            
          Case 101 ; Map_Action_Delete
            Lua_Do_Function_Event_Map_Action(Lua_Event()\Lua_Function, Action_ID, Map_ID)
            
          Case 102 ; Map_Action_Resize
            Lua_Do_Function_Event_Map_Action(Lua_Event()\Lua_Function, Action_ID, Map_ID)
            
          Case 103 ; Map_Action_Fill
            Lua_Do_Function_Event_Map_Action(Lua_Event()\Lua_Function, Action_ID, Map_ID)
            
          Case 104 ; Map_Action_Save
            Lua_Do_Function_Event_Map_Action(Lua_Event()\Lua_Function, Action_ID, Map_ID)
            
          Case 105 ; Map_Action_Load
            Lua_Do_Function_Event_Map_Action(Lua_Event()\Lua_Function, Action_ID, Map_ID)
            
        EndSelect
        
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Event_Main()
  
  If Lua_Event_Main\Save_File
    Lua_Event_Main\Save_File = 0
    Lua_Event_Save(Files_File_Get("Lua_Event"))
  EndIf
  
  If Lua_Event_Main\Timer_File_Check < Milliseconds()
    Lua_Event_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Lua_Event"), #PB_Date_Modified)
    If Lua_Event_Main\File_Date_Last <> File_Date
      Lua_Event_Load(Files_File_Get("Lua_Event"))
    EndIf
  EndIf
  
  Lua_Event_Do(0, 0, -1, -1, -1, -1, -1, -1, -1, "")
  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 181
; FirstLine = 143
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0