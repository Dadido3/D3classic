; ########################################## Variablen ##########################################

#Build_Queue_Max_Timeout = 50

Structure Build_Main
  
EndStructure
Global Build_Main.Build_Main

Structure Build_Player_Queue
  Player_Number.w
  Map_ID.l
  X.u
  Y.u
  Z.u
  Material.a
  Priority.a
  Undo.a
  Physic.a
EndStructure
Global NewList Build_Player_Queue.Build_Player_Queue()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Build_Line_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Priority, Undo, Physic)
  D_X = X_1 - X_0
  D_Y = Y_1 - Y_0
  D_Z = Z_1 - Z_0
  
  Blocks = 1
  
  If Blocks < Abs(D_X) : Blocks = Abs(D_X) : EndIf
  If Blocks < Abs(D_Y) : Blocks = Abs(D_Y) : EndIf
  If Blocks < Abs(D_Z) : Blocks = Abs(D_Z) : EndIf
  
  M_X.f = D_X / Blocks
  M_Y.f = D_Y / Blocks
  M_Z.f = D_Z / Blocks
  
  *Player.Player_List = Player_List_Get_Pointer(Player_Number)
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  For i = 0 To Blocks
    Map_Block_Change_Player(*Player, *Map_Data, X_0+M_X*i, Y_0+M_Y*i, Z_0+M_Z*i, Material, Undo, Physic, 1, Priority)
  Next
EndProcedure

Procedure Build_Box_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Replace_Material, Hollow, Priority, Undo, Physic)
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
  
  If Map_Select_ID(Map_ID)
    For ix = X_0 To X_1
      For iy = Y_0 To Y_1
        For iz = Z_0 To Z_1
          If Replace_Material = -1 Or Replace_Material = Map_Block_Get_Type(Map_Data(), ix, iy, iz)
            If ix = X_0 Or ix = X_1 Or iy = Y_0 Or iy = Y_1 Or iz = Z_0 Or iz = Z_1
              FirstElement(Build_Player_Queue())
              If InsertElement(Build_Player_Queue())
                Build_Player_Queue()\Player_Number = Player_Number
                Build_Player_Queue()\Map_ID = Map_ID
                Build_Player_Queue()\X = X+ix
                Build_Player_Queue()\Y = Y+iy
                Build_Player_Queue()\Z = Z+iz
                Build_Player_Queue()\Material = Material
                Build_Player_Queue()\Priority = Priority
                Build_Player_Queue()\Undo = Undo
                Build_Player_Queue()\Physic = Physic
              EndIf
            ElseIf Hollow = 0
              LastElement(Build_Player_Queue())
              If AddElement(Build_Player_Queue())
                Build_Player_Queue()\Player_Number = Player_Number
                Build_Player_Queue()\Map_ID = Map_ID
                Build_Player_Queue()\X = X+ix
                Build_Player_Queue()\Y = Y+iy
                Build_Player_Queue()\Z = Z+iz
                Build_Player_Queue()\Material = Material
                Build_Player_Queue()\Priority = Priority
                Build_Player_Queue()\Undo = Undo
                Build_Player_Queue()\Physic = Physic
              EndIf
            EndIf
          EndIf
        Next
      Next
    Next
  EndIf
EndProcedure

Procedure Build_Sphere_Player(Player_Number, Map_ID, X, Y, Z, R.f, Material, Replace_Material, Hollow, Priority, Undo, Physic)
  
  R_Rounded = Round(R, 1)
  R_Pow.f = Pow(R,2)
  
  *Player.Player_List = Player_List_Get_Pointer(Player_Number)
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  
  For ix = -R_Rounded To R_Rounded
    For iy = -R_Rounded To R_Rounded
      For iz = -R_Rounded To R_Rounded
        Square_Dist = Pow(ix,2)+Pow(iy,2)+Pow(iz,2)
        If Square_Dist <= R_Pow
          If Hollow
            Allowed = 0
            If     Pow(ix+1,2)+Pow(iy  ,2)+Pow(iz  ,2) > R_Pow : Allowed = 1
            ElseIf Pow(ix-1,2)+Pow(iy  ,2)+Pow(iz  ,2) > R_Pow : Allowed = 1
            ElseIf Pow(ix  ,2)+Pow(iy+1,2)+Pow(iz  ,2) > R_Pow : Allowed = 1
            ElseIf Pow(ix  ,2)+Pow(iy-1,2)+Pow(iz  ,2) > R_Pow : Allowed = 1
            ElseIf Pow(ix  ,2)+Pow(iy  ,2)+Pow(iz+1,2) > R_Pow : Allowed = 1
            ElseIf Pow(ix  ,2)+Pow(iy  ,2)+Pow(iz-1,2) > R_Pow : Allowed = 1
            EndIf
          Else
            Allowed = 1
          EndIf
          If Allowed
            If Replace_Material = -1 Or Replace_Material = Map_Block_Get_Type(*Map_Data, X+ix, Y+iy, Z+iz)
              Map_Block_Change_Player(*Player, *Map_Data, X+ix, Y+iy, Z+iz, Material, Undo, Physic, 1, Priority)
            EndIf
          EndIf
        EndIf
      Next
    Next
  Next
EndProcedure

Procedure Build_Rank_Box(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank, Max_Rank) ; Beschreibt eine Rank-Box
  
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
    
    If Map_Data()\Rank_Build <= Max_Rank And Rank <= Max_Rank
      Map_Block_Set_Rank_Box(Map_Data(), X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank)
    EndIf
  EndIf
EndProcedure

Procedure Build_Queue_Do()
  Temp_Time = Milliseconds()
  While FirstElement(Build_Player_Queue())
    If Player_List_Select_Number(Build_Player_Queue()\Player_Number)
      If Map_Select_ID(Build_Player_Queue()\Map_ID)
        Map_Block_Change_Player(Player_List(), Map_Data(), Build_Player_Queue()\X, Build_Player_Queue()\Y, Build_Player_Queue()\Z, Build_Player_Queue()\Material, Build_Player_Queue()\Undo, Build_Player_Queue()\Physic, 1, Build_Player_Queue()\Priority)
      EndIf
    EndIf
    DeleteElement(Build_Player_Queue())
    If Milliseconds() - Temp_Time > #Build_Queue_Max_Timeout
      Break
    EndIf
  Wend
EndProcedure

Procedure Build_Main()
  Build_Queue_Do()
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 176
; FirstLine = 137
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0