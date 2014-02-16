; ########################################## Dokumentation ##########################################
; 
; Test für das Darstellen der Karten.
; 
; Probleme !!!!!!
;  - Startdrawing auch in Map_Preview
;  - Windowmanagement Fehlt
; 
; ########################################## Variablen ##########################################

#View_3D_Width = 500
#View_3D_Height = 250

Structure View_3D_Main
  
EndStructure
Global View_3D_Main.View_3D_Main

Structure View_3D_Window
  ID.i
  Width.w
  Height.w
  Image.i
  Image_ID.i
EndStructure
Global View_3D_Window.View_3D_Window

Structure View_3D_Camera
  Map_ID.l
  X.f
  Y.f
  Z.f
  Rot.f
  Look.f
EndStructure
Global View_3D_Camera.View_3D_Camera

; ########################################## Declares ############################################

Declare View_3D_Window(Open, Width, Height)

; ########################################## Ladekram ############################################

;View_3D_Window(1, #View_3D_Width, #View_3D_Height)

View_3D_Camera\Map_ID = 0
View_3D_Camera\X = 50
View_3D_Camera\Y = 20
View_3D_Camera\Z = 80
View_3D_Camera\Rot = 180
View_3D_Camera\Look = 0

; ########################################## Macros ##########################################

Macro View_3D_Color_Change(Color, Factor)
  RGB(Red(Color)*Factor, Green(Color)*Factor, Blue(Color)*Factor)
EndMacro

; ########################################## Proceduren ##########################################


Procedure View_3D_Window(Open, Width, Height)
  If Open = 1 And View_3D_Window\ID = 0
    
    View_3D_Window\Width = Width
    View_3D_Window\Height = Height
    
    View_3D_Window\ID = OpenWindow(#PB_Any, 0, 0, View_3D_Window\Width, View_3D_Window\Height, "D3-Server: View_3D",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)
    If View_3D_Window\ID
      View_3D_Window\Image_ID = CreateImage(#PB_Any, View_3D_Window\Width, View_3D_Window\Height)
      View_3D_Window\Image = ImageGadget(#PB_Any, 0, 0, View_3D_Window\Width, View_3D_Window\Height, ImageID(View_3D_Window\Image_ID))
    EndIf
  ElseIf Open = 0 And View_3D_Window\ID <> 0
    CloseWindow(View_3D_Window\ID)
    FreeImage(View_3D_Window\Image_ID)
    View_3D_Window\ID = 0
  EndIf
EndProcedure

Procedure View_3D_Ray_Get_Color(X.f, Y.f, Z.f, Rot.f, Look.f, Angle_X.f, Angle_Y.f, Max_Depth)
  
  *Pointer.Map_Block
  
  M_X.f = Sin(Rot/#Math_Rad_2_Ark)*Cos(-Look/#Math_Rad_2_Ark)
  M_Y.f = -Cos(Rot/#Math_Rad_2_Ark)*Cos(-Look/#Math_Rad_2_Ark)
  M_Z.f = Sin(-Look/#Math_Rad_2_Ark)
  
  M_X.f + Sin((Rot+90)/#Math_Rad_2_Ark)*Angle_X/#Math_Rad_2_Ark + Sin(Rot/#Math_Rad_2_Ark)*Sin(-Look/#Math_Rad_2_Ark)*Angle_Y/#Math_Rad_2_Ark
  M_Y.f + -Cos((Rot+90)/#Math_Rad_2_Ark)*Angle_X/#Math_Rad_2_Ark + -Cos(Rot/#Math_Rad_2_Ark)*Sin(-Look/#Math_Rad_2_Ark)*Angle_Y/#Math_Rad_2_Ark
  M_Z.f - Cos(-Look/#Math_Rad_2_Ark)*Angle_Y/#Math_Rad_2_Ark
  
  X_C.f = X
  Y_C.f = Y
  Z_C.f = Z
  
  For i = 1 To Max_Depth
    Depth.f = i
    
    X_C + M_X
    Y_C + M_Y
    Z_C + M_Z
    
    X_P = Round(X_C, 0)
    Y_P = Round(Y_C, 0)
    Z_P = Round(Z_C, 0)
    
    If X_P >= 0 And X_P < Map_Data()\Size_X And Y_P >= 0 And Y_P < Map_Data()\Size_Y And Z_P >= 0 And Z_P < Map_Data()\Size_Z
      *Pointer = Map_Data()\Data + Map_Get_Offset(X_P, Y_P, Z_P, Map_Data()\Size_X, Map_Data()\Size_Y, #Map_Block_Element_Size)
      If *Pointer\Type <> 0
        Factor.f = (((Z+M_Z*Depth)-Z_P)*0.2+0.8) * (1-(M_Z+1)*0.45)
        ProcedureReturn View_3D_Color_Change(Block(*Pointer\Type)\Color_Overview, Factor)
      EndIf
    Else
      Break
    EndIf
  Next
  
  ProcedureReturn RGB(0,255,255)
EndProcedure

Procedure View_3D_Draw()
  If View_3D_Window\ID
    If StartDrawing(ImageOutput(View_3D_Window\Image_ID))
      
      Zoom = 4
      Plane_Z.f = (View_3D_Window\Width+View_3D_Window\Height) / 2
      
      If Map_Select_ID(View_3D_Camera\Map_ID)
        
        For ix = 0 To (View_3D_Window\Width/Zoom)-1
          For iy = 0 To (View_3D_Window\Height/Zoom)-1
            Screen_X = ix*Zoom-View_3D_Window\Width/2
            Screen_Y = iy*Zoom-View_3D_Window\Height/2
            Angle_X.f = ATan(Screen_X / Plane_Z)*#Math_Rad_2_Ark
            Angle_Y.f = ATan(Screen_Y / Plane_Z)*#Math_Rad_2_Ark
            Box(ix*Zoom, iy*Zoom, Zoom, Zoom, View_3D_Ray_Get_Color(View_3D_Camera\X, View_3D_Camera\Y, View_3D_Camera\Z, View_3D_Camera\Rot, View_3D_Camera\Look, Angle_X, Angle_Y, 128))
          Next
        Next
        
      EndIf
      
      StopDrawing()
      SetGadgetState(View_3D_Window\Image, ImageID(View_3D_Window\Image_ID))
    EndIf
  EndIf
EndProcedure

Procedure View_3D_Main()
  
  View_3D_Draw()
  
  If View_3D_Window\ID
    WindowEvent()
    
    If FirstElement(Entity())
      View_3D_Camera\Map_ID = Entity()\Map_ID
      View_3D_Camera\X = Entity()\X
      View_3D_Camera\Y = Entity()\Y
      View_3D_Camera\Z = Entity()\Z + 1.6
      View_3D_Camera\Rot = Entity()\Rotation
      View_3D_Camera\Look = Entity()\Look
    Else
      View_3D_Camera\Rot + 5
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 43
; FirstLine = 28
; Folding = -
; EnableXP
; DisableDebugger