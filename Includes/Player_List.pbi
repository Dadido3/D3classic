; ########################################## Variablen ##########################################

Structure Player_List_Main
  Database_ID.i               ; Datenbank-ID
  Number_Counter.w            ; Zähler für die eindeutigen Nummern
  Save_File.b                 ; Zeigt an, ob gespeichert werden soll
  Timer_File_Save.l           ; Timer für das Speichern der Datei
EndStructure
Global Player_List_Main.Player_List_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Player_List_Database_Close() ; Schließt die Datenbank.
  If Player_List_Main\Database_ID
    CloseDatabase(Player_List_Main\Database_ID)
    Player_List_Main\Database_ID = 0
    Log_Add("Player_List", Lang_Get("", "Database closed", Filename.s), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Player_List_Database_Create(Filename.s) ; Erstellt eine Datenbank und richtet die Grundtabellen ein
  Temp_File_ID = CreateFile(#PB_Any, Filename.s)
  If IsFile(Temp_File_ID)
    CloseFile(Temp_File_ID)
    
    Temp_Database_ID = OpenDatabase(#PB_Any, Filename.s, "", "", #PB_Database_SQLite)
    If Temp_Database_ID
      DatabaseUpdate(Temp_Database_ID, "CREATE TABLE Player_List (Number INTEGER PRIMARY KEY, Name TEXT UNIQUE, Rank INTEGER, Counter_Login INTEGER, Counter_Kick INTEGER, Ontime_Counter FLOAT, IP TEXT, Stopped BOOL, Banned BOOL, Time_Muted INTEGER, Message_Ban TEXT, Message_Kick TEXT, Message_Mute TEXT, Message_Rank TEXT, Message_Stop TEXT, Inventory BLOB);")
      
      Log_Add("Player_List", Lang_Get("", "Database created", Filename.s), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
  EndIf
EndProcedure

Procedure Player_List_Database_Open(Filename.s) ; Öffnet eine Datenbank, es kann nun geschrieben und gelesen werden.
  Player_List_Database_Close()
  
  If FileSize(Filename.s) = -1
    Player_List_Database_Create(Filename.s)
  EndIf
  
  If Player_List_Main\Database_ID = 0
    Player_List_Main\Database_ID = OpenDatabase(#PB_Any, Filename.s, "", "", #PB_Database_SQLite)
    If Player_List_Main\Database_ID
      Log_Add("Player_List", Lang_Get("", "Database opened", Filename.s), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      ProcedureReturn 1
    Else
      Log_Add("Player_List", Lang_Get("", "Database not opened. Can't open", Filename.s, DatabaseError()), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      ProcedureReturn 0
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure Player_List_Select(Name.s, Log=1) ; Wählt das Linked-List-Objekt
  If ListIndex(Player_List()) <> -1 And LCase(Player_List()\Name) = LCase(Name)
    ProcedureReturn #True
  Else
    ForEach Player_List()
      If LCase(Player_List()\Name) = LCase(Name)
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Player", Lang_Get("", "Can't find Player_List()\Name = [Field_0]", Name), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure Player_List_Select_Number(Number, Log=1) ; Wählt das Linked-List-Objekt
  If ListIndex(Player_List()) <> -1 And Player_List()\Number = Number
    ProcedureReturn #True
  Else
    ForEach Player_List()
      If Player_List()\Number = Number
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Player", Lang_Get("", "Can't find Player_List()\Number = [Field_0]", Str(Number)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure Player_List_Get_Pointer(Number, Log=1) ; Wählt das Linked-List-Objekt
  If ListIndex(Player_List()) <> -1 And Player_List()\Number = Number
    ProcedureReturn Player_List()
  Else
    ForEach Player_List()
      If Player_List()\Number = Number
        ProcedureReturn Player_List()
      EndIf
    Next
  EndIf
  
  If Log
    Log_Add("Player", Lang_Get("", "Can't find Player_List()\Number = [Field_0]", Str(Number)), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure Player_List_Get_Number() ; Eindeutige Spielernummer
  
  If ListIndex(Player_List()) <> -1
    *Player_List_Old = Player_List()
  Else
    *Player_List_Old = 0
  EndIf
  
  Number = Player_List_Main\Number_Counter
  While Number = -1 Or Player_List_Select_Number(Number)
    Number = Player_List_Main\Number_Counter
    Player_List_Main\Number_Counter + 1
  Wend
  
  If *Player_List_Old
    ChangeCurrentElement(Player_List(), *Player_List_Old)
  EndIf
  
  ProcedureReturn Number
EndProcedure

Procedure Player_List_Load(Filename.s) ; Lädt die Liste mit Spielern aus Datenbank
  If Player_List_Database_Open(Filename.s)
    
    If DatabaseQuery(Player_List_Main\Database_ID, "SELECT * FROM Player_List") ; Ermittelt alle Einträge
      
      ClearList(Player_List())
      
      While NextDatabaseRow(Player_List_Main\Database_ID)  ; alle Einträge durchlaufen
        If AddElement(Player_List())
          Player_List()\Number = GetDatabaseLong(Player_List_Main\Database_ID, 0)
          Player_List()\Name = GetDatabaseString(Player_List_Main\Database_ID, 1)
          Player_List()\Rank = GetDatabaseLong(Player_List_Main\Database_ID, 2)
          Player_List()\Counter_Login = GetDatabaseLong(Player_List_Main\Database_ID, 3)
          Player_List()\Counter_Kick = GetDatabaseLong(Player_List_Main\Database_ID, 4)
          Player_List()\Ontime_Counter = GetDatabaseDouble(Player_List_Main\Database_ID, 5)
          Player_List()\IP = GetDatabaseString(Player_List_Main\Database_ID, 6)
          Player_List()\Stopped = GetDatabaseLong(Player_List_Main\Database_ID, 7)
          Player_List()\Banned = GetDatabaseLong(Player_List_Main\Database_ID, 8)
          Player_List()\Time_Muted = GetDatabaseLong(Player_List_Main\Database_ID, 9)
          Player_List()\Message_Ban = GetDatabaseString(Player_List_Main\Database_ID, 10)
          Player_List()\Message_Kick = GetDatabaseString(Player_List_Main\Database_ID, 11)
          Player_List()\Message_Mute = GetDatabaseString(Player_List_Main\Database_ID, 12)
          Player_List()\Message_Rank = GetDatabaseString(Player_List_Main\Database_ID, 13)
          Player_List()\Message_Stop = GetDatabaseString(Player_List_Main\Database_ID, 14)
          GetDatabaseBlob(Player_List_Main\Database_ID, 15, @Player_List()\Inventory, 2*256)
        EndIf
      Wend
      
      Log_Add("Player_List", Lang_Get("", "Database loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      FinishDatabaseQuery(Player_List_Main\Database_ID)
    Else
      Log_Add("Player_List", Lang_Get("", "Database error: [Field_0]", DatabaseError()), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    EndIf
    
    ForEach Player_List()
      If Player_List_Main\Number_Counter & 65535 <= Player_List()\Number & 65535
        Player_List_Main\Number_Counter = Player_List()\Number + 1
      EndIf
    Next
    
    Player_List_Database_Close()
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure Player_List_Save(Filename.s) ; Speichert/Überschreibt die Liste mit (Geänderten)Spielern in Datenbank
  If Player_List_Database_Open(Filename.s)
    
    ForEach Player_List()
      If Player_List()\Save
        Player_List()\Save = 0
        
        SetDatabaseBlob(Player_List_Main\Database_ID, 0, @Player_List()\Inventory, 2*256)
        If DatabaseUpdate(Player_List_Main\Database_ID, "REPLACE INTO Player_List (Number, Name, Rank, Counter_Login, Counter_Kick, Ontime_Counter, IP, Stopped, Banned, Time_Muted, Message_Ban, Message_Kick, Message_Mute, Message_Rank, Message_Stop, Inventory) VALUES ('"+Str(Player_List()\Number)+"', '"+Player_List()\Name+"', '"+Str(Player_List()\Rank)+"', '"+Str(Player_List()\Counter_Login)+"', '"+Str(Player_List()\Counter_Kick)+"', '"+StrF(Player_List()\Ontime_Counter)+"', '"+Player_List()\IP+"', '"+Str(Player_List()\Stopped)+"', '"+Str(Player_List()\Banned)+"', '"+Str(Player_List()\Time_Muted)+"', "+Chr(34)+ReplaceString(Player_List()\Message_Ban, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(Player_List()\Message_Kick, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(Player_List()\Message_Mute, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(Player_List()\Message_Rank, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(Player_List()\Message_Stop, Chr(34), "'")+Chr(34)+", ?)") = 0
          Log_Add("Player_List", Lang_Get("", "Database error: [Field_0]", DatabaseError()), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
        EndIf
      EndIf
    Next
    
    Log_Add("Player_List", Lang_Get("", "Database loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    Player_List_Database_Close()
    ProcedureReturn 1
  EndIf
  
  ProcedureReturn 0
EndProcedure

Procedure Player_List_Save_Old(Filename.s) ; Speichert die Liste mit Spielern
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Player_List()
      WriteStringN(File_ID, "["+Player_List()\Name+"]")
      WriteStringN(File_ID, "Number = "+Str(Player_List()\Number))
      WriteStringN(File_ID, "Banned = "+Str(Player_List()\Banned))
      WriteStringN(File_ID, "Stopped = "+Str(Player_List()\Stopped))
      WriteStringN(File_ID, "Time_Muted = "+Str(Player_List()\Time_Muted))
      WriteStringN(File_ID, "Counter_Login = "+Str(Player_List()\Counter_Login))
      WriteStringN(File_ID, "Counter_Kick = "+Str(Player_List()\Counter_Kick))
      WriteStringN(File_ID, "Rank = "+Str(Player_List()\Rank))
      WriteStringN(File_ID, "Message_Ban = "+Player_List()\Message_Ban)
      WriteStringN(File_ID, "Message_Kick = "+Player_List()\Message_Kick)
      WriteStringN(File_ID, "Message_Mute = "+Player_List()\Message_Mute)
      WriteStringN(File_ID, "Message_Rank = "+Player_List()\Message_Rank)
      WriteStringN(File_ID, "Message_Stop = "+Player_List()\Message_Stop)
      WriteStringN(File_ID, "Ontime_Counter = "+StrD(Player_List()\Ontime_Counter))
      WriteStringN(File_ID, "IP = "+Player_List()\IP)
      For i = 0 To #Player_Attributes-1
        If Player_List()\Attribute [i] And Player_List()\Attribute_Long [i]
          WriteStringN(File_ID, "Attribute_Long_"+Player_List()\Attribute [i]+" = "+Str(Player_List()\Attribute_Long [i]))
        EndIf
        If Player_List()\Attribute [i] And Player_List()\Attribute_String [i]
          WriteStringN(File_ID, "Attribute_String_"+Player_List()\Attribute [i]+" = "+Player_List()\Attribute_String [i])
        EndIf
      Next
      Inventory_String.s = "Inventory = "
      For i = 0 To 255
        Inventory_String.s + Str(Player_List()\Inventory[i]) + "|"
      Next
      WriteStringN(File_ID, Inventory_String)
      
      If ListIndex(Player_List()) <> -1
        *Player_List_Old = Player_List()
      Else
        *Player_List_Old = 0
      EndIf
      
      UnlockMutex(Main\Mutex)
      ;##################### Sicherer Wartebereich
      LockMutex(Main\Mutex)
      
      If *Player_List_Old
        ChangeCurrentElement(Player_List(), *Player_List_Old)
      EndIf
      
    Next
    
    Log_Add("Player_List", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Player_List_Load_Old(Filename.s) ; Lädt die Liste mit Spielern (Alt)
  If OpenPreferences(Filename)
    
    Log_Add("Player_List", "!!!!!!!!!!! Found old Playerlist-File. Server is converting it, please wait.", 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        If PreferenceGroupName() <> ""
          AddElement(Player_List())
          Player_List()\Name = PreferenceGroupName()
          Player_List()\Number = ReadPreferenceLong("Number", -1)
          If Player_List()\Number = -1
            Player_List()\Number = Player_List_Get_Number()
          EndIf
          Player_List()\Banned = ReadPreferenceLong("Banned", 0)
          Player_List()\Stopped = ReadPreferenceLong("Stopped", 0)
          Player_List()\Time_Muted = ReadPreferenceLong("Time_Muted", 0)
          Player_List()\Counter_Login = ReadPreferenceLong("Counter_Login", 0)
          Player_List()\Counter_Kick = ReadPreferenceLong("Counter_Kick", 0)
          Player_List()\Rank = ReadPreferenceLong("Rank", 0)
          Player_List()\Message_Ban = ReadPreferenceString("Message_Ban", "")
          Player_List()\Message_Kick = ReadPreferenceString("Message_Kick", "")
          Player_List()\Message_Mute = ReadPreferenceString("Message_Mute", "")
          Player_List()\Message_Rank = ReadPreferenceString("Message_Rank", "")
          Player_List()\Message_Stop = ReadPreferenceString("Message_Stop", "")
          Player_List()\Ontime_Counter = ReadPreferenceDouble("Ontime_Counter", 0)
          Player_List()\IP = ReadPreferenceString("IP", Lang_Get("", "Keine Information."))
          
          Attribute_Number = 0
          ExaminePreferenceKeys()
          While NextPreferenceKey()
            If Attribute_Number < #Player_Attributes - 1
              If Left(PreferenceKeyName(), 15) = "Attribute_Long_"
                Player_List()\Attribute [Attribute_Number] = Mid(PreferenceKeyName(), 16)
                Player_List()\Attribute_Long [Attribute_Number] = Val(PreferenceKeyValue())
                Attribute_Number + 1
              EndIf
              If Left(PreferenceKeyName(), 17) = "Attribute_String_"
                Player_List()\Attribute [Attribute_Number] = Mid(PreferenceKeyName(), 18)
                Player_List()\Attribute_String [Attribute_Number] = PreferenceKeyValue()
                Attribute_Number + 1
              EndIf
            Else
              Break
            EndIf
          Wend
          
          Inventory_String.s = ReadPreferenceString("Inventory", "||")
          For i = 1 To 256
            Player_List()\Inventory[i-1] = Val(StringField(Inventory_String, i, "|"))
          Next
          
          Player_List()\Save = 1
          Player_List_Main\Save_File = 1
                    
        EndIf
      Wend
    EndIf
    
    ForEach Player_List()
      If Player_List_Main\Number_Counter & 65535 <= Player_List()\Number & 65535
        Player_List_Main\Number_Counter = Player_List()\Number + 1
      EndIf
    Next
    
    Log_Add("Player_List", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
    
    RenameFile(Filename.s, Filename.s+".old")
    
  EndIf
EndProcedure

Procedure Player_List_Add(Name.s) ; Fügt ein Player zur Liste hinzu, wenn noch nicht vorhanden
  
  If Player_List_Select(Name, 0) = 0 And Name <> ""
    AddElement(Player_List())
    Player_List()\Number = Player_List_Get_Number()
    Player_List()\Name = Name
    Player_List()\Rank = 0
    Player_List()\Save = 1
    Player_List_Main\Save_File = 1
  EndIf
EndProcedure

Procedure Player_List_Main()
  If Player_List_Main\Timer_File_Save < Milliseconds() And Player_List_Main\Save_File
    Player_List_Main\Timer_File_Save = Milliseconds() + 30000
    Player_List_Main\Save_File = 0
    
    Player_List_Save(Files_File_Get("Playerlist"))
  EndIf
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 342
; FirstLine = 301
; Folding = ---
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0