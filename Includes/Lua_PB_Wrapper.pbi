
; ########################################## Konstanten ########################################

; ########################################## Variablen ##########################################

Structure Lua_PB_Wrapper_Main
  
EndStructure
Global Lua_PB_Wrapper_Main.Lua_PB_Wrapper_Main

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; #################################### Initkram ###############################################

Lua_PB_Wrapper_Register_All()

;-################################## Proceduren in Lua ##########################################


; #################################################################
; #                                                               #
; #           Example, replace these with the functions           #
; #                                                               #
; #################################################################

ProcedureC Lua_CMD_YOURFUNCTIONHERE(Lua_State)
  Client_ID = Lua_lua_tointeger(Lua_State, 1)
  Map_ID = Lua_lua_tointeger(Lua_State, 2)
  X.f = Lua_lua_tonumber(Lua_State, 3)
  Y.f = Lua_lua_tonumber(Lua_State, 4)
  Z.f = Lua_lua_tonumber(Lua_State, 5)
  Rotation.f = Lua_lua_tonumber(Lua_State, 6)
  Look.f = Lua_lua_tonumber(Lua_State, 7)
  Send_Own = Lua_lua_tointeger(Lua_State, 8)
  Priority = Lua_lua_tointeger(Lua_State, 9)
  
  ;do something here
  
  Lua_lua_pushinteger(Lua_State, 123)
  
  ProcedureReturn 1 ; Number of results
EndProcedure

;-########################################## Proceduren ##########################################

Procedure Lua_PB_Wrapper_Register_All()
  If Lua_Main\State
    ;Lua_lua_register(Lua_Main\State, "YOURFUNCTIONHERE", @Lua_CMD_YOURFUNCTIONHERE())
  EndIf
EndProcedure

Procedure Lua_PB_Wrapper_Main()
  If Lua_Main\State
    
  EndIf
EndProcedure
; IDE Options = PureBasic 4.50 Beta 2 (Windows - x86)
; CursorPosition = 16
; Folding = -
; EnableXP