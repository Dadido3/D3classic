; ########################################## Dokumentation ##########################################
; 
; 
; 
; 
; 
; 
; 
; ################################################### Includes ##############################################

XIncludeFile "../Include/Include.pbi"

; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Name = "Heapview"
#Plugin_Author = "David Vogel"

; ################################################### Variables #############################################

Structure Main
  Quit.a
EndStructure
Global Main.Main

Structure Window_Main
  ID.i
  Width.u
  Height.u
  Bytes_Per_Pixel.d
  Image.i
  Image_ID.i
EndStructure
Global Window_Main.Window_Main

Structure Heap_Entry
  Type.a
  *Pointer
  Size.l
  Overhead.l
  Region_Index.a
EndStructure
Global NewList Heap_Entry.Heap_Entry()

Structure PROCESS_HEAP_ENTRY_BLOCK
  *hMem
  dwReserved.l  [3]
EndStructure
Structure PROCESS_HEAP_ENTRY_REGION
  dwCommittedSize.l
  dwUnCommittedSize.l
  *lpFirstBlock
  *lpLastBlock
EndStructure
Structure PROCESS_HEAP_ENTRY
  *lpData
  cbData.l
  cbOverhead.a
  iRegionIndex.a
  wFlags.w
  StructureUnion
    Block.PROCESS_HEAP_ENTRY_BLOCK
    Region.PROCESS_HEAP_ENTRY_REGION
  EndStructureUnion
EndStructure

Structure History
  Heaps.l
  Commited.l
EndStructure
Global NewList History.History()

Global NewList Temp()

; ########################################## Declares ############################################

; ########################################## Ladekram ############################################

; ########################################## Macros ##############################################

Macro Get_X(Position, Width)
  ((Position) % Width)
EndMacro

Macro Get_Y(Position, Width)
  ((Position) / Width)
EndMacro

; ########################################## Proceduren ##########################################

Procedure Heap_Walk()
  Protected Entry.PROCESS_HEAP_ENTRY
  
  Protected Heaps = GetProcessHeaps_(0, 0)
  If Heaps = 0
    ProcedureReturn GetLastError_()
  EndIf
  
  ClearList(Heap_Entry())
  
  Protected *Heaps_Array = AllocateMemory(Heaps*4)
  
  Protected Heaps_Temp = Heaps
  
  Heaps = GetProcessHeaps_(Heaps_Temp, *Heaps_Array)
  If Heaps = 0
    ProcedureReturn GetLastError_()
  ElseIf Heaps > Heaps_Temp
    ProcedureReturn -1
  EndIf
  
  For i = 0 To Heaps-1
    Protected Heap = PeekL(*Heaps_Array+i*4)
    
    If HeapLock_(Heap) = #False
      ProcedureReturn GetLastError_()
    EndIf
    
    Entry\lpData = #Null
    While HeapWalk_(Heap, @Entry)
      AddElement(Heap_Entry())
      
      If Entry\wFlags & #PROCESS_HEAP_ENTRY_BUSY
        Heap_Entry()\Type = 0
        ;PrintN("Allocated block")
        If Entry\wFlags & #PROCESS_HEAP_ENTRY_MOVEABLE
          ;PrintN("movable with HANDLE "+Str(Entry\Block\hMem))
        EndIf
        If Entry\wFlags & #PROCESS_HEAP_ENTRY_DDESHARE
          ;PrintN("DDESHARE")
        EndIf
      ElseIf Entry\wFlags & #PROCESS_HEAP_REGION
        Heap_Entry()\Type = 1
        ;PrintN("Region")
        ;PrintN("  "+Str(Entry\Region\dwCommittedSize)+" bytes committed")
        ;PrintN("  "+Str(Entry\Region\dwUnCommittedSize)+" bytes uncommitted")
        ;PrintN("  First block address: "+Str(Entry\Region\lpFirstBlock))
        ;PrintN("  Last block address: "+Str(Entry\Region\lpLastBlock))
      ElseIf Entry\wFlags & #PROCESS_HEAP_UNCOMMITTED_RANGE
        Heap_Entry()\Type = 2
        ;PrintN("Uncommitted range")
      Else
        Heap_Entry()\Type = 3
        ;PrintN("Block")
      EndIf
      
      Heap_Entry()\Pointer = Entry\lpData
      Heap_Entry()\Size = Entry\cbData
      Heap_Entry()\Overhead = Entry\cbOverhead
      Heap_Entry()\Region_Index = Entry\iRegionIndex
      
      ;PrintN("  Data portion begins at: "+Str(Entry\lpData))
      ;PrintN("  Size: "+Str(Entry\cbData)+" bytes")
      ;PrintN("  Overhead: "+Str(Entry\cbOverhead)+" bytes")
      ;PrintN("  Region index: "+Str(Entry\iRegionIndex))
      ;PrintN("")
    Wend
    
    ;Protected LastError = GetLastError_()
    ;If LastError <> #ERROR_NO_MORE_ITEMS
    ;  ProcedureReturn LastError
    ;EndIf
    
    If HeapUnlock_(Heap) = #False
      ProcedureReturn GetLastError_()
    EndIf
    
  Next
  
  FreeMemory(*Heaps_Array)
  
  ProcedureReturn 0
EndProcedure

Procedure Window_Main(Open, Width, Height)
  If Open = 1 And Window_Main\ID = 0
    Window_Main(0, Width, Height)
  EndIf
  
  If Open = 1 And Window_Main\ID = 0
    
    Window_Main\Width  = Width
    Window_Main\Height = Height
    Window_Main\Bytes_Per_Pixel = (4294967296)/(Window_Main\Width*Window_Main\Height)
    
    Window_Main\ID = OpenWindow(#PB_Any, 0, 0, Window_Main\Width, Window_Main\Height, "Server - Heapview",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
    If Window_Main\ID
      Window_Main\Image_ID = CreateImage(#PB_Any, Window_Main\Width, Window_Main\Height)
      Window_Main\Image = ImageGadget(#PB_Any, 0, 0, Window_Main\Width, Window_Main\Height, ImageID(Window_Main\Image_ID))
    EndIf
  ElseIf Open = 0 And Window_Main\ID <> 0
    CloseWindow(Window_Main\ID)
    FreeImage(Window_Main\Image_ID)
    Window_Main\ID = 0
  EndIf
EndProcedure

Procedure Window_Main_Draw(Heapwalk_Time)
  Start_Time = ElapsedMilliseconds()
  If Window_Main\ID
    If StartDrawing(ImageOutput(Window_Main\Image_ID))
      
      Box(0, 0, Window_Main\Width, Window_Main\Height, 0)
      
      Allocated = 0
      
      *Pointer = -1
      
      ForEach Heap_Entry()
        ;If Heap_Entry()\Type = 0
          If *Pointer <> Heap_Entry()\Pointer
            *Pointer = Heap_Entry()\Pointer
            *Pointer_Start = *Pointer
            Allocated + Heap_Entry()\Size
            Size = Round(Heap_Entry()\Size/Window_Main\Bytes_Per_Pixel, 1)
            Real_Size = Heap_Entry()\Size
            Select Heap_Entry()\Type
              Case 0
                Color = RGB(50, 155+*Pointer_Start%100, 155+Real_Size%100)
              Case 1
                Color = RGB(255,255,0)
              Case 2
                Color = RGB(50,0,0)
              Case 3
                Color = RGB(0,255,255)
            EndSelect
            While *Pointer-*Pointer_Start < Real_Size
              Position = *Pointer / Window_Main\Bytes_Per_Pixel
              ;Byte.a = PeekA(*Pointer)
              ;Color = RGB(50, *Pointer_Start%255, Real_Size%256);RGB(50,Byte,Byte)
              X = Get_X(Position, Window_Main\Width)
              Y = Get_Y(Position, Window_Main\Width)
              Plot(X, Y, Color)
              *Pointer + Window_Main\Bytes_Per_Pixel
            Wend
          EndIf
        ;EndIf
      Next
      
      DrawingMode(#PB_2DDrawing_Transparent)
      X = 0
      Y = Window_Main\Height/2
      DrawText(X, Y, "Allocated: "+StrD(Allocated/1000000,3)+"MB", RGB(255,255,255)) : Y + 15
      DrawText(X, Y, StrD(Allocated*100/4294967296,1)+"%", RGB(255,255,255)) : Y + 15
      DrawText(X, Y, "Allocations: "+Str(ListSize(Heap_Entry())), RGB(255,255,255)) : Y + 15
      
      LastElement(History())
      AddElement(History())
      History()\Commited = Allocated
      History()\Heaps = ListSize(Heap_Entry())
      
      While ListSize(History()) > 800
        If FirstElement(History())
          DeleteElement(History())
        EndIf
      Wend
      Heaps_Max = 0
      Commited_Max = 0
      ForEach History()
        If Heaps_Max < History()\Heaps : Heaps_Max = History()\Heaps : EndIf
        If Commited_Max < History()\Commited : Commited_Max = History()\Commited : EndIf
      Next
      Heaps_Min = Heaps_Max
      Commited_Min = Commited_Max
      ForEach History()
        If Heaps_Min > History()\Heaps : Heaps_Min = History()\Heaps : EndIf
        If Commited_Min > History()\Commited : Commited_Min = History()\Commited : EndIf
      Next
      Heap_Scale.d = 50/(Heaps_Max-Heaps_Min)
      Heap_Offset = -Heaps_Min
      Commited_Scale.d = 150/(Commited_Max-Commited_Min)
      Commited_Offset = -Commited_Min
      If Heap_Scale > 2 : Heap_Scale = 2 : EndIf
      If Commited_Scale > 2 : Commited_Scale = 2 : EndIf
      X = 0
      ForEach History()
        Heaps_Scaled.d = (History()\Heaps+Heap_Offset)*Heap_Scale
        Commited_Scaled.d = (History()\Commited+Commited_Offset)*Commited_Scale
        LineXY(X, Y+200, X, Y+200-Heaps_Scaled, RGB(255,255,0))
        LineXY(X, Y+150, X, Y+150-Commited_Scaled, RGB(255,0,0))
        X + 1
      Next
      Y + 205
      
      X = 0
      DrawText(X, Y, "Heap walked in "+Str(Heapwalk_Time)+"ms", RGB(255,255,255)) : Y + 15
      X = 0
      DrawText(X, Y, "Image generated in "+Str(ElapsedMilliseconds()-Start_Time)+"ms", RGB(255,255,255)) : Y + 15
      
      
      StopDrawing()
      SetGadgetState(Window_Main\Image, ImageID(Window_Main\Image_ID))
    EndIf
  EndIf
EndProcedure

; ####################################################### Initkram #########################################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Window_Main(1, 800, 600)
  
  Define_Prototypes(*Plugin_Function)
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  Window_Main(0, 800, 600)
EndProcedure

ProcedureCDLL Main()
  Static Timer
  
  Repeat
    Window_Event = WindowEvent()
    Event_Window = EventWindow()
    Event_Gadget = EventGadget()
    Event_Type = EventType()
    
    If Window_Event
      Select Event_Window
        Case Window_Main\ID
          Select Window_Event
            Case #PB_Event_Gadget
              Select EventGadget()
                
              EndSelect
              
            Case #PB_Event_SizeWindow
              Window_Main\Width  = WindowWidth(Event_Window)
              Window_Main\Height = WindowHeight(Event_Window)
              If Window_Main\Width And Window_Main\Height
                ResizeImage(Window_Main\Image_ID, Window_Main\Width, Window_Main\Height)
                Window_Main\Bytes_Per_Pixel = (4294967296)/(Window_Main\Width*Window_Main\Height)
              EndIf
              
            Case #PB_Event_CloseWindow
              Window_Main(0, 800, 600)
              
          EndSelect
      EndSelect
    Else
      Break
    EndIf
  ForEver
  
  If Window_Main\ID
    If Timer < ElapsedMilliseconds()
      Timer = ElapsedMilliseconds() + 2000
      Heap_Start_Time = ElapsedMilliseconds()
      Heap_Walk()
      Window_Main_Draw(ElapsedMilliseconds()-Heap_Start_Time)
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 350
; FirstLine = 309
; Folding = --
; EnableThread
; EnableXP
; EnableOnError
; Executable = Heapview.x86.dll
; DisableDebugger