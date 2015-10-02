; ########################################## Variablen ##########################################

#Build_Mode_Blocks_To_Resend_Size_Max = 1000

Structure Build_Mode_Main
  Save_File.b             ; Zeigt an, ob gespeichert werden soll
  File_Date_Last.l        ; Datum letzter Änderung, bei Änderung speichern
  Timer_File_Check.l      ; Timer für das überprüfen der Dateigröße
EndStructure
Global Build_Mode_Main.Build_Mode_Main

Structure Build_Mode
  ID.s
  Name.s
  Plugin.s                ; Plugin-Funktion
EndStructure
Global NewList Build_Mode.Build_Mode()

Structure Build_Mode_Blocks_To_Resend ; Blöcke welche nach dem Umschalten des Buildmodes zurückgesendet werden
  Client_ID.i
  Map_ID.l
  X.u
  Y.u
  Z.u
EndStructure
Global NewList Build_Mode_Blocks_To_Resend.Build_Mode_Blocks_To_Resend()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Build_Mode_Load(Filename.s)
  If OpenPreferences(Filename)
    
    ClearList(Build_Mode())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Build_Mode())
        Build_Mode()\ID = PreferenceGroupName()
        Build_Mode()\Name = ReadPreferenceString("Name", "-")
        Build_Mode()\Plugin = ReadPreferenceString("Plugin", "Lua:"+ReadPreferenceString("Lua_Function", ""))
      Wend
    EndIf
    
    Build_Mode_Main\Save_File = 1
    
    Build_Mode_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Build_Mode", Lang_Get("", "File loaded", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    ClosePreferences()
  Else
    Log_Add("Build_Mode", Lang_Get("", "File not loaded", Filename), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
EndProcedure

Procedure Build_Mode_Save(Filename.s)
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Build_Mode()
      WriteStringN(File_ID, "["+Build_Mode()\ID+"]")
      WriteStringN(File_ID, "Name = "+Build_Mode()\Name)
      WriteStringN(File_ID, "Plugin = "+Build_Mode()\Plugin)
      WriteStringN(File_ID, "")
    Next
    
    Build_Mode_Main\File_Date_Last = GetFileDate(Filename, #PB_Date_Modified)
    Log_Add("Build_Mode", Lang_Get("", "File saved", Filename), 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Build_Mode_Distribute(Client_ID, Map_ID, X, Y, Z, Mode, Block_Type.a)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      
      Build_Mode.s = Network_Client()\Player\Entity\Build_Mode
      
      If Map_ID = -1
        Map_ID = Network_Client()\Player\Entity\Map_ID
      EndIf
      
      ; ###### /Material...
      If Block_Type = 1 And Network_Client()\Player\Entity\Build_Material <> -1
        Block_Type = Network_Client()\Player\Entity\Build_Material
      EndIf
      
      Found = 0
      ForEach Build_Mode()
        If Build_Mode()\ID = Build_Mode
          Found = 1
          Break
        EndIf
      Next
      
      If Found = 1
        
        If Build_Mode()\Plugin = ""
          Map_Block_Change_Client(Network_Client(), Map_Get_Pointer(Map_ID), X, Y, Z, Mode, Block_Type)
        Else
          FirstElement(Build_Mode_Blocks_To_Resend())
          InsertElement(Build_Mode_Blocks_To_Resend())
          Build_Mode_Blocks_To_Resend()\Client_ID = Client_ID
          Build_Mode_Blocks_To_Resend()\Map_ID = Map_ID
          Build_Mode_Blocks_To_Resend()\X = X
          Build_Mode_Blocks_To_Resend()\Y = Y
          Build_Mode_Blocks_To_Resend()\Z = Z
          Plugin_Event_Build_Mode(Build_Mode()\Plugin, Network_Client(), Map_Get_Pointer(Map_ID), X, Y, Z, Mode, Block_Type)
        EndIf
        
      Else
        Network_Client()\Player\Entity\Build_Mode = "Normal"
        Log_Add("Build_Mode", Lang_Get("", "Can't find Build_Mode()\ID = [Field_0]", Build_Mode), 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      EndIf
      
    EndIf
  EndIf
EndProcedure

Procedure Build_Mode_Blocks_Resend(Client_ID)
  ForEach Build_Mode_Blocks_To_Resend()
    If Build_Mode_Blocks_To_Resend()\Client_ID = Client_ID
      Map_ID = Build_Mode_Blocks_To_Resend()\Map_ID
      X = Build_Mode_Blocks_To_Resend()\X
      Y = Build_Mode_Blocks_To_Resend()\Y
      Z = Build_Mode_Blocks_To_Resend()\Z
      
      DeleteElement(Build_Mode_Blocks_To_Resend())
      
      If Map_Select_ID(Map_ID)
        Block_Type.a = Map_Block_Get_Type(Map_Data(), X, Y, Z)
        Network_Out_Block_Set(Client_ID, X, Y, Z, Block_Type)
      EndIf
    EndIf
  Next
EndProcedure

;-

Procedure Build_Mode_Set(Client_ID, Build_Mode.s)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_Mode = Build_Mode
      
      Build_Mode_Blocks_Resend(Client_ID)
    EndIf
  EndIf
EndProcedure

Procedure.s Build_Mode_Get(Client_ID)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Mode
    EndIf
  EndIf
  ProcedureReturn ""
EndProcedure

Procedure Build_Mode_State_Set(Client_ID, Build_State)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_State = Build_State
    EndIf
  EndIf
EndProcedure

Procedure Build_Mode_State_Get(Client_ID)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_State
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Build_Mode_Coordinate_Set(Client_ID, Index, X, Y, Z)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_Variable[Index]\X = X
      Network_Client()\Player\Entity\Build_Variable[Index]\Y = Y
      Network_Client()\Player\Entity\Build_Variable[Index]\Z = Z
    EndIf
  EndIf
EndProcedure

Procedure Build_Mode_Coordinate_Get_X(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\X
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Build_Mode_Coordinate_Get_Y(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\Y
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Build_Mode_Coordinate_Get_Z(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\Z
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Build_Mode_Long_Set(Client_ID, Index, Value)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_Variable[Index]\Long = Value
    EndIf
  EndIf
EndProcedure

Procedure Build_Mode_Long_Get(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\Long
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Build_Mode_Float_Set(Client_ID, Index, Value.f)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_Variable[Index]\Float = Value
    EndIf
  EndIf
EndProcedure

Procedure.f Build_Mode_Float_Get(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\Float
    EndIf
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure Build_Mode_String_Set(Client_ID, Index, Value.s)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      Network_Client()\Player\Entity\Build_Variable[Index]\String = Value
    EndIf
  EndIf
EndProcedure

Procedure.s Build_Mode_String_Get(Client_ID, Index)
  If Network_Client_Select(Client_ID)
    If Network_Client()\Player\Entity
      ProcedureReturn Network_Client()\Player\Entity\Build_Variable[Index]\String
    EndIf
  EndIf
  ProcedureReturn ""
EndProcedure

;-

Procedure Build_Mode_Main()
  If Build_Mode_Main\Save_File
    Build_Mode_Main\Save_File = 0
    Build_Mode_Save(Files_File_Get("Build_Mode"))
  EndIf
  
  If Build_Mode_Main\Timer_File_Check < Milliseconds()
    Build_Mode_Main\Timer_File_Check = Milliseconds() + 1000
    File_Date = GetFileDate(Files_File_Get("Build_Mode"), #PB_Date_Modified)
    If Build_Mode_Main\File_Date_Last <> File_Date
      Build_Mode_Load(Files_File_Get("Build_Mode"))
    EndIf
  EndIf
  
  While ListSize(Build_Mode_Blocks_To_Resend()) > #Build_Mode_Blocks_To_Resend_Size_Max
    If LastElement(Build_Mode_Blocks_To_Resend())
      DeleteElement(Build_Mode_Blocks_To_Resend())
    EndIf
  Wend
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 276
; FirstLine = 241
; Folding = ----
; EnableXP
; DisableDebugger