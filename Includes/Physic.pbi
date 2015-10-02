; ########################################## Variablen ##########################################

#Physics_Fill_X = 1024
#Physics_Fill_Y = 1024

Structure Physic_Main
  Water_Max_Searchdeep.l          ; Maximale größe beim Suchen nach einer freien Stelle auf einer Fläche
EndStructure
Global Physic_Main.Physic_Main

Structure Physic_Block_Fill       ; Structure zur Hilfe der Berechnungen Flüssigkeiten
  X.w
  Y.w
  Z.w
EndStructure
Global NewList Physic_Block_Fill.Physic_Block_Fill()

Global Dim Physic_Block_Fill_Array.b(#Physics_Fill_X, #Physics_Fill_Y) ; 2D Array zur Hilfe der Berechnungen Flüssigkeiten
Global Dim Physic_Block_Fill_Array_Empty.b(#Physics_Fill_X, #Physics_Fill_Y) ; Leeres 2D Array

; ########################################## Ladekram ############################################

Physic_Main\Water_Max_Searchdeep = 50000

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure Physic_Block_Fill_Array_Clear() ; Löscht den Inhalt des Arrays
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ZeroMemory_(Physic_Block_Fill_Array(), #Physics_Fill_X*#Physics_Fill_Y)
  CompilerElse
    CopyMemory(@Physic_Block_Fill_Array_Empty(), @Physic_Block_Fill_Array(), #Physics_Fill_X*#Physics_Fill_Y)
  CompilerEndIf
EndProcedure

Procedure Physic_Block_Compute_10(*Map_Data.Map_Data, X.l, Y.l, Z.l) ; Berechnet einen Block Mit Physic=10
  Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  If Map_Block_Get_Type(*Map_Data, X, Y, Z-1) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X, Y, Z-1, 2, 1, 1)
  EndIf
EndProcedure

Procedure Physic_Block_Compute_11(*Map_Data.Map_Data, X.l, Y.l, Z.l) ; Berechnet einen Block Mit Physic=11
  Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  If Map_Block_Get_Type(*Map_Data, X, Y, Z-1) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X, Y, Z-1, 2, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X+1, Y, Z-1) = 0 And Map_Block_Get_Type(*Map_Data, X+1, Y, Z) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X+1, Y, Z-1, 2, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X-1, Y, Z-1) = 0 And Map_Block_Get_Type(*Map_Data, X-1, Y, Z) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X-1, Y, Z-1, 2, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X, Y+1, Z-1) = 0 And Map_Block_Get_Type(*Map_Data, X, Y+1, Z) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X, Y+1, Z-1, 2, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X, Y-1, Z-1) = 0 And Map_Block_Get_Type(*Map_Data, X, Y-1, Z) = 0 : Map_Block_Move(*Map_Data, X, Y, Z, X, Y-1, Z-1, 2, 1, 1)
  EndIf
EndProcedure

Procedure Physic_Block_Compute_20(*Map_Data.Map_Data, X.l, Y.l, Z.l) ; Berechnet einen Block Mit Physic=20
  Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  Player_Number = Map_Block_Get_Player_Number(*Map_Data, X, Y, Z)
  If Map_Block_Get_Type(*Map_Data, X, Y, Z-1) = 0 : Map_Block_Change(Player_Number, *Map_Data, X, Y, Z-1, Block_Type, 2, 1, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X+1, Y, Z) = 0 : Map_Block_Change(Player_Number, *Map_Data, X+1, Y, Z, Block_Type, 2, 1, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X-1, Y, Z) = 0 : Map_Block_Change(Player_Number, *Map_Data, X-1, Y, Z, Block_Type, 2, 1, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X, Y+1, Z) = 0 : Map_Block_Change(Player_Number, *Map_Data, X, Y+1, Z, Block_Type, 2, 1, 1, 1)
  ElseIf Map_Block_Get_Type(*Map_Data, X, Y-1, Z) = 0 : Map_Block_Change(Player_Number, *Map_Data, X, Y-1, Z, Block_Type, 2, 1, 1, 1)
  EndIf
EndProcedure

Procedure Physic_Block_Compute_21(*Map_Data.Map_Data, X.l, Y.l, Z.l) ; Berechnet einen Block Mit Physic=21
  Block_Type = Map_Block_Get_Type(*Map_Data, X, Y, Z)
  If Map_Block_Get_Type(*Map_Data, X, Y, Z-1) = 0 
    Map_Block_Move(*Map_Data, X, Y, Z, X, Y, Z-1, 2, 1, 1)
  Else
    Physic_Block_Fill_Array_Clear()
    ClearList(Physic_Block_Fill())
    AddElement(Physic_Block_Fill())
    Physic_Block_Fill()\X = X
    Physic_Block_Fill()\Y = Y
    Physic_Block_Fill()\Z = Z
    Found = 0
    While FirstElement(Physic_Block_Fill())
      F_X = Physic_Block_Fill()\X
      F_Y = Physic_Block_Fill()\Y
      F_Z = Physic_Block_Fill()\Z
      DeleteElement(Physic_Block_Fill())
      If Map_Block_Get_Type(*Map_Data, F_X, F_Y, F_Z-1) = 0
        Map_Block_Move(*Map_Data, X, Y, Z, F_X, F_Y, F_Z-1, 2, 1, 1)
        Found = 1
      Else
        LastElement(Physic_Block_Fill())
        If Map_Block_Get_Type(*Map_Data, F_X+1, F_Y, F_Z) = 0 And Physic_Block_Fill_Array(F_X+1, F_Y) = 0 : Physic_Block_Fill_Array(F_X+1, F_Y) = 1 : AddElement(Physic_Block_Fill()) : Physic_Block_Fill()\X = F_X+1 : Physic_Block_Fill()\Y = F_Y : Physic_Block_Fill()\Z = F_Z : EndIf
        If Map_Block_Get_Type(*Map_Data, F_X-1, F_Y, F_Z) = 0 And Physic_Block_Fill_Array(F_X-1, F_Y) = 0 : Physic_Block_Fill_Array(F_X*1, F_Y) = 1 : AddElement(Physic_Block_Fill()) : Physic_Block_Fill()\X = F_X-1 : Physic_Block_Fill()\Y = F_Y : Physic_Block_Fill()\Z = F_Z : EndIf
        If Map_Block_Get_Type(*Map_Data, F_X, F_Y+1, F_Z) = 0 And Physic_Block_Fill_Array(F_X, F_Y+1) = 0 : Physic_Block_Fill_Array(F_X, F_Y+1) = 1 : AddElement(Physic_Block_Fill()) : Physic_Block_Fill()\X = F_X : Physic_Block_Fill()\Y = F_Y+1 : Physic_Block_Fill()\Z = F_Z : EndIf
        If Map_Block_Get_Type(*Map_Data, F_X, F_Y-1, F_Z) = 0 And Physic_Block_Fill_Array(F_X, F_Y-1) = 0 : Physic_Block_Fill_Array(F_X, F_Y-1) = 1 : AddElement(Physic_Block_Fill()) : Physic_Block_Fill()\X = F_X : Physic_Block_Fill()\Y = F_Y-1 : Physic_Block_Fill()\Z = F_Z : EndIf
      EndIf
      If ListSize(Physic_Block_Fill()) > Physic_Main\Water_Max_Searchdeep Or Found
        ClearList(Physic_Block_Fill())
      EndIf
    Wend
  EndIf
EndProcedure

Procedure Physic_Main()
  
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 54
; FirstLine = 28
; Folding = --
; EnableXP
; DisableDebugger