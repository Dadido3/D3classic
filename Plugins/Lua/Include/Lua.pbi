
; ########################################## Konstanten ########################################

;option for multiple returns in `lua_pcall' and `lua_call' 
#LUA_MULTRET 					  =	-1

;  pseudo-indices 
#LUA_REGISTRYINDEX 			=	(-10000)
#LUA_ENVIRONINDEX 			=	(-10001)
#LUA_GLOBALSINDEX 			=	(-10002)

;  thread status; 0 is OK  
#LUA_YIELD 						  =	1
#LUA_ERRRUN 					  =	2
#LUA_ERRSYNTAX 				  =	3
#LUA_ERRMEM 					  =	4
#LUA_ERRERR 					  =	5

;  basic types 
#LUA_TNONE						  =	-1
#LUA_TNIL						    =	0
#LUA_TBOOLEAN					  =	1
#LUA_TLIGHTUSERDATA 	  =	2
#LUA_TNUMBER					  =	3
#LUA_TSTRING					  =	4
#LUA_TTABLE						  =	5
#LUA_TFUNCTION					=	6
#LUA_TUSERDATA					=	7
#LUA_TTHREAD					  =	8

;  minimum Lua stack available to a C function 
#LUA_MINSTACK 					=	20

;  garbage-collection function and options 
#LUA_GCSTOP						  =	0
#LUA_GCRESTART					=	1
#LUA_GCCOLLECT					=	2
#LUA_GCCOUNT					  =	3
#LUA_GCCOUNTB					  =	4
#LUA_GCSTEP						  =	5
#LUA_GCSETPAUSE				  =	6
#LUA_GCSETSTEPMUL 			=	7
																	
;  Event codes 																	
#LUA_HOOKCALL 					=	0
#LUA_HOOKRET 					  =	1
#LUA_HOOKLINE 					=	2
#LUA_HOOKCOUNT 				  =	3
#LUA_HOOKTAILRET 				=	4

;  Event masks 
#LUA_MASKCALL 					=	1 << #LUA_HOOKCALL
#LUA_MASKRET 					  =	1 << #LUA_HOOKRET
#LUA_MASKLINE 					=	1 << #LUA_HOOKLINE
#LUA_MASKCOUNT 				  =	1 << #LUA_HOOKCOUNT

Enumeration 0
  #Lua_Event_Timer
  
  #Lua_Event_Client_Add
  #Lua_Event_Client_Delete
  #Lua_Event_Client_Login
  #Lua_Event_Client_Logout
  #Lua_Event_Entity_Add
  #Lua_Event_Entity_Delete
  #Lua_Event_Entity_Position_Set
  #Lua_Event_Entity_Die
  #Lua_Event_Map_Add
  #Lua_Event_Map_Action_Delete
  #Lua_Event_Map_Action_Resize
  #Lua_Event_Map_Action_Fill
  #Lua_Event_Map_Action_Save
  #Lua_Event_Map_Action_Load
  #Lua_Event_Map_Block_Change
  #Lua_Event_Map_Block_Change_Client
  #Lua_Event_Map_Block_Change_Player
  #Lua_Event_Chat_Map
  #Lua_Event_Chat_All
  #Lua_Event_Chat_Private
EndEnumeration

; ########################################## Variablen ##########################################

Structure Lua_Main
  State.i                     ; Lua-State von luaL_NewState()
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
EndStructure
Global Lua_Main.Lua_Main

Structure Lua_File
  Filename.s
  File_Date_Last.l            ; Datum letzter Änderung
EndStructure
Global NewList Lua_File.Lua_File()

Structure Lua_Event
  ID.s                ; Event-ID as String
  Function.s          ; Function-Name
  Type.a              ; Event Types
  ; ------------------;
  Map_ID.l            ; Map_ID
  Time.l              ; Time (for Timer-Event)
  ; ------------------;
  Timer.l             ; Timer for the Timer-Event
EndStructure
Global NewList Lua_Event.Lua_Event()

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

Declare Lua_Register_All()

Declare Lua_Do_Function(Function.s, Arguments, Results)

Declare Lua_Event_Add(ID.s, Function.s, Type.s, Set_Or_Check.a, Time.l, Map_ID.l)
Declare Lua_Event_Delete(ID.s)

; ########################################## Imports ##########################################

;SetCurrentDirectory("")
;Debug GetCurrentDirectory()

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86  
    #Lua_Import_Prefix = "_"
    ImportC "../../../Librarys/lib/lua5.1.x86.lib" ; Windows x86
  CompilerElse
    #Lua_Import_Prefix = ""
    ImportC "../../../Librarys/lib/lua5.1.x64.lib" ; Windows x64
  CompilerEndIf
CompilerElse
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86  
    #Lua_Import_Prefix = ""
    Import "/usr/lib/libm.so"
    EndImport
    Import "/usr/lib/libdl.so"
    EndImport
    ImportC "../../../Librarys/lib/lua5.1.x86.a" ;     Linux x86
  CompilerElse
    #Lua_Import_Prefix = ""
    ImportC "../../../Librarys/lib/lua5.1.x64.a" ;     Linux x64
  CompilerEndIf
CompilerEndIf
  ; lua.h
  ; /*
  ; ** state manipulation
  ; */
  lua_newstate(*lua_Alloc, *ud)                                      ;As #Lua_Import_Prefix+"lua_newstate"
  lua_close(lua_State.i)                                             ;As #Lua_Import_Prefix+"lua_close"
  lua_newthread(lua_State.i)                                         ;As #Lua_Import_Prefix+"lua_newthread"
  lua_atpanic(lua_State.i, *lua_CFunction)                           ;As #Lua_Import_Prefix+"lua_atpanic"
  
  ; /*
  ; ** basic stack manipulation
  ; */
  lua_gettop(lua_State.i)                                            ;As #Lua_Import_Prefix+"lua_gettop"
  lua_settop(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_settop"
  lua_pushvalue(lua_State.i, idx.l)                                  ;As #Lua_Import_Prefix+"lua_pushvalue"
  lua_remove(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_remove"
  lua_insert(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_insert"
  lua_replace(lua_State.i, idx.l)                                    ;As #Lua_Import_Prefix+"lua_replace"
  lua_checkstack(lua_State.i, sz.l)                                  ;As #Lua_Import_Prefix+"lua_checkstack"
  
  lua_xmove(*lua_State_from, *lua_State_to, n.l)                     ;As #Lua_Import_Prefix+"lua_xmove"
  
  ; /*
  ; ** access functions (stack -> C)
  ; */
  lua_isnumber(lua_State.i, idx.l)                                   ;As #Lua_Import_Prefix+"lua_isnumber"
  lua_isstring(lua_State.i, idx.l)                                   ;As #Lua_Import_Prefix+"lua_isstring"
  lua_iscfunction(lua_State.i, idx.l)                                ;As #Lua_Import_Prefix+"lua_iscfunction"
  lua_isuserdata(lua_State.i, idx.l)                                 ;As #Lua_Import_Prefix+"lua_isuserdata"
  lua_type(lua_State.i, idx.l)                                       ;As #Lua_Import_Prefix+"lua_type"
  lua_typename(lua_State.i, tp.l)                                    ;As #Lua_Import_Prefix+"lua_typename"
  
  lua_equal(lua_State.i, idx1.l, idx2.l)                             ;As #Lua_Import_Prefix+"lua_equal"
  lua_rawequal(lua_State.i, idx1.l, idx2.l)                          ;As #Lua_Import_Prefix+"lua_rawequal"
  lua_lessthan(lua_State.i, idx1.l, idx2.l)                          ;As #Lua_Import_Prefix+"lua_lessthan"
  
  lua_tonumber.d(lua_State.i, idx.l)                                 ;As #Lua_Import_Prefix+"lua_tonumber"
  lua_tointeger(lua_State.i, idx.l)                                  ;As #Lua_Import_Prefix+"lua_tointeger"
  lua_toboolean(lua_State.i, idx.l)                                  ;As #Lua_Import_Prefix+"lua_toboolean"
  lua_tolstring(lua_State.i, idx.l, len.l)                           ;As #Lua_Import_Prefix+"lua_tolstring"
  lua_objlen(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_objlen"
  lua_tocfunction(lua_State.i, idx.l)                                ;As #Lua_Import_Prefix+"lua_tocfunction"
  lua_touserdata(lua_State.i, idx.l)                                 ;As #Lua_Import_Prefix+"lua_touserdata"
  lua_tothread(lua_State.i, idx.l)                                   ;As #Lua_Import_Prefix+"lua_tothread"
  lua_topointer(lua_State.i, idx.l)                                  ;As #Lua_Import_Prefix+"lua_topointer"
  
  ; /*
  ; ** push functions (C -> stack)
  ; */
  lua_pushnil(lua_State.i)                                           ;As #Lua_Import_Prefix+"lua_pushnil"
  lua_pushnumber(lua_State.i, LUA_NUMBER.d)                          ;As #Lua_Import_Prefix+"lua_pushnumber"
  lua_pushinteger(lua_State.i, LUA_INTEGER.l)                        ;As #Lua_Import_Prefix+"lua_pushinteger"
  lua_pushlstring(lua_State.i, string.s, size.l)                     ;As #Lua_Import_Prefix+"lua_pushlstring"
  lua_pushstring(lua_State.i, string.s)                              ;As #Lua_Import_Prefix+"lua_pushstring"
  ;lua_pushvfstring(lua_State.i, const char *fmt, va_list argp)
  ;lua_pushfstring(lua_State.i, const char *fmt, ...)
  lua_pushcclosure(lua_State.i, *fn, n.l)                            ;As #Lua_Import_Prefix+"lua_pushcclosure"
  lua_pushboolean(lua_State.i, b.l)                                  ;As #Lua_Import_Prefix+"lua_pushboolean"
  lua_pushlightuserdata(lua_State.i, *p)                             ;As #Lua_Import_Prefix+"lua_pushlightuserdata"
  lua_pushthread(lua_State.i)                                        ;As #Lua_Import_Prefix+"lua_pushthread"
  
  ; /*
  ; ** get functions (Lua -> stack)
  ; */
  lua_gettable(lua_State.i, idx.l)                                   ;As #Lua_Import_Prefix+"lua_gettable"
  lua_getfield(lua_State.i, idx.l, k.s)                              ;As #Lua_Import_Prefix+"lua_getfield"
  lua_rawget(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_rawget"
  lua_rawgeti(lua_State.i, idx.l, n.l)                               ;As #Lua_Import_Prefix+"lua_rawgeti"
  lua_createtable(lua_State.i, narr.l, nrec.l)                       ;As #Lua_Import_Prefix+"lua_createtable"
  lua_newuserdata(lua_State.i, sz.l)                                 ;As #Lua_Import_Prefix+"lua_newuserdata"
  lua_getmetatable(lua_State.i, objindex.l)                          ;As #Lua_Import_Prefix+"lua_getmetatable"
  lua_getfenv(lua_State.i, idx.l)                                    ;As #Lua_Import_Prefix+"lua_getfenv"
  
  ; /*
  ; ** set functions (stack -> Lua)
  ; */
  lua_settable(lua_State.i, idx.l)                                   ;As #Lua_Import_Prefix+"lua_settable"
  lua_setfield(lua_State.i, idx.l, k.s)                              ;As #Lua_Import_Prefix+"lua_setfield"
  lua_rawset(lua_State.i, idx.l)                                     ;As #Lua_Import_Prefix+"lua_rawset"
  lua_rawseti(lua_State.i, idx.l, n.l)                               ;As #Lua_Import_Prefix+"lua_rawseti"
  lua_setmetatable(lua_State.i, objindex.l)                          ;As #Lua_Import_Prefix+"lua_setmetatable"
  lua_setfenv(lua_State.i, idx.l)                                    ;As #Lua_Import_Prefix+"lua_setfenv"
  
  ; /*
  ; ** `load' and `call' functions (load and run Lua code)
  ; */
  lua_call(lua_State.i, nargs.l, nresults.l)                         ;As #Lua_Import_Prefix+"lua_call"
  ;lua_callk(lua_State.i, nargs.l, nresults.l, ctx.l, lua_CFunction)  As #Lua_Import_Prefix+"lua_callk"
  lua_pcall(lua_State.i, nargs.l, nresults.l, *lua_errCFunction)     ;As #Lua_Import_Prefix+"lua_pcall"
  ;lua_pcallk(lua_State.i, nargs.l, nresults.l, ctx.l, *lua_errCFunction, lua_CFunction) As #Lua_Import_Prefix+"lua_pcallk"
  ;lua_cpcall(lua_State.i, *lua_CFunction, *ud.l)                     As #Lua_Import_Prefix+"lua_cpcall"
  lua_load(lua_State.i, lua_Reader.l, *dt, chunkname)                ;As #Lua_Import_Prefix+"lua_load"
  
  lua_dump(lua_State.i, lua_Writer.l, *vdata)                        ;As #Lua_Import_Prefix+"lua_dump"
  
  ; /*
  ; ** coroutine functions
  ; */
  lua_yield(lua_State.i, nresults.l)                                 ;As #Lua_Import_Prefix+"lua_yield"
  lua_resume(lua_State.i, narg.l)                                    ;As #Lua_Import_Prefix+"lua_resume"
  lua_status(lua_State.i)                                            ;As #Lua_Import_Prefix+"lua_status"
  
  ; /*
  ; ** garbage-collection function And options
  ; */
  lua_gc(lua_State.i, what.l, idata.l)                               ;As #Lua_Import_Prefix+"lua_gc"
  
  ; /*
  ; ** miscellaneous functions
  ; */
  lua_error(lua_State.i)                                             ;As #Lua_Import_Prefix+"lua_error"
  
  lua_next(lua_State.i, idx.l)                                       ;As #Lua_Import_Prefix+"lua_next"
  
  lua_concat(lua_State.i, n.l)                                       ;As #Lua_Import_Prefix+"lua_concat"
  
  lua_getallocf(lua_State.i, *p_ud)                                  ;As #Lua_Import_Prefix+"lua_getallocf"
  lua_setallocf(lua_State.i, lua_Alloc.l, *ud)                       ;As #Lua_Import_Prefix+"lua_setallocf"
  
  ; lualib.h
  luaopen_base(lua_State.i)                                          ;As #Lua_Import_Prefix+"luaopen_base"
  luaopen_table(lua_State.i)                                         ;As #Lua_Import_Prefix+"luaopen_table"
  luaopen_io(lua_State.i)                                            ;As #Lua_Import_Prefix+"luaopen_io"
  luaopen_os(lua_State.i)                                            ;As #Lua_Import_Prefix+"luaopen_os"
  luaopen_string(lua_State.i)                                        ;As #Lua_Import_Prefix+"luaopen_string"
  luaopen_math(lua_State.i)                                          ;As #Lua_Import_Prefix+"luaopen_math"
  luaopen_debug(lua_State.i)                                         ;As #Lua_Import_Prefix+"luaopen_debug"
  luaopen_package(lua_State.i)                                       ;As #Lua_Import_Prefix+"luaopen_package"
  
  ; /* open all previous libraries */
  luaL_openlibs(lua_State.i)                                         ;As #Lua_Import_Prefix+"luaL_openlibs"
  
  ;lauxlib_h
  luaI_openlib(lua_State.i, libname.s, *luaL_Reg, nup.l)             ;As #Lua_Import_Prefix+"luaI_openlib"
  luaL_register(lua_State.i, libname.s, *luaL_Reg)                   ;As #Lua_Import_Prefix+"luaL_register"
  luaL_getmetafield(lua_State.i, obj.l, e.s)                         ;As #Lua_Import_Prefix+"luaL_getmetafield"
  luaL_callmeta(lua_State.i, obj.l, e.s)                             ;As #Lua_Import_Prefix+"luaL_callmeta"
  luaL_typerror(lua_State.i, narg.l, tname.s)                        ;As #Lua_Import_Prefix+"luaL_typerror"
  luaL_argerror(lua_State.i, numarg.l, extramsg.s)                   ;As #Lua_Import_Prefix+"luaL_argerror"
  luaL_checklstring(lua_State.i, numarg.l, size.l)                   ;As #Lua_Import_Prefix+"luaL_checklstring"
  luaL_optlstring(lua_State.i, numarg.l, def.s, size.l)              ;As #Lua_Import_Prefix+"luaL_optlstring"
  luaL_checknumber(lua_State.i, numarg.l)                            ;As #Lua_Import_Prefix+"luaL_checknumber"
  luaL_optnumber(lua_State.i, narg, LUA_NUMBER.d)                    ;As #Lua_Import_Prefix+"luaL_optnumber"
  
  luaL_checkinteger(lua_State.i, numarg.l)                           ;As #Lua_Import_Prefix+"luaL_checkinteger"
  luaL_optinteger(lua_State.i, narg.l, LUA_INTEGER.l)                ;As #Lua_Import_Prefix+"luaL_optinteger"
  
  luaL_checkstack(lua_State.i, sz.l, msg.s)                          ;As #Lua_Import_Prefix+"luaL_checkstack"
  luaL_checktype(lua_State.i, narg.l, t.l)                           ;As #Lua_Import_Prefix+"luaL_checktype"
  luaL_checkany(lua_State.i, narg.l)                                 ;As #Lua_Import_Prefix+"luaL_checkany"
  
  luaL_newmetatable(lua_State.i, tname.s)                            ;As #Lua_Import_Prefix+"luaL_newmetatable"
  luaL_checkudata(lua_State.i, ud.l, tname.s)                        ;As #Lua_Import_Prefix+"luaL_checkudata"
  
  luaL_where(lua_State.i, lvl.l)                                     ;As #Lua_Import_Prefix+"luaL_where"
  ;luaL_error(lua_State.i, const char *fmt, ...)
  
  luaL_checkoption(lua_State.i, narg.l, def.s, *string_array)        ;As #Lua_Import_Prefix+"luaL_checkoption"
  
  luaL_ref(lua_State.i, t.l)                                         ;As #Lua_Import_Prefix+"luaL_ref"
  luaL_unref(lua_State.i, t.l, ref.l)                                ;As #Lua_Import_Prefix+"luaL_unref"
  
  luaL_loadfile(lua_State.i, filename.s)                             ;As #Lua_Import_Prefix+"luaL_loadfile"
  luaL_loadbuffer(lua_State.i, buff.l, size.l, name.s)               ;As #Lua_Import_Prefix+"luaL_loadbuffer"
  luaL_loadstring(lua_State.i, string.s)                             ;As #Lua_Import_Prefix+"luaL_loadstring"
  
  luaL_newstate()                                                    ;As #Lua_Import_Prefix+"luaL_newstate"
  
  
  luaL_gsub(lua_State.i, s.s, p.s, r.s)                              ;As #Lua_Import_Prefix+"luaL_gsub"
  
  luaL_findtable(lua_State.i, idx.l, fname.s)                        ;As #Lua_Import_Prefix+"luaL_findtable"
  
  luaL_buffinit(lua_State.i, *luaL_Buffer)                           ;As #Lua_Import_Prefix+"luaL_buffinit"
  luaL_prepbuffer(*luaL_Buffer)                                      ;As #Lua_Import_Prefix+"luaL_prepbuffer"
  luaL_addlstring(*luaL_Buffer, s.s, size.l)                         ;As #Lua_Import_Prefix+"luaL_addlstring"
  luaL_addstring(*luaL_Buffer, s.s)                                  ;As #Lua_Import_Prefix+"luaL_addstring"
  luaL_addvalue(*luaL_Buffer)                                        ;As #Lua_Import_Prefix+"luaL_addvalue"
  luaL_pushresult(*luaL_Buffer)                                      ;As #Lua_Import_Prefix+"luaL_pushresult"
EndImport

; ########################################## Macros #############################################

Macro lua_register(Lua_State, Name, Adress)
	lua_pushstring(Lua_State, Name)
  lua_pushcclosure(Lua_State, Adress, 0)
  lua_settable(Lua_State, #LUA_GLOBALSINDEX)
EndMacro

Macro luaL_dofile(Lua_State, Filename)
	luaL_loadfile(Lua_State, Filename)
	lua_pcall(Lua_State, 0, #LUA_MULTRET, 0)
EndMacro

Macro luaL_dostring(Lua_State, String)
	luaL_loadstring(Lua_State, String)
	lua_pcall(Lua_State, 0, #LUA_MULTRET, 0)
EndMacro

Macro lua_setglobal(Lua_State, String) 
	lua_setfield(Lua_State, #LUA_GLOBALSINDEX, String)
EndMacro

Macro lua_getglobal(Lua_State, String) 
	lua_getfield(Lua_State, #LUA_GLOBALSINDEX, String)
EndMacro

Macro lua_pop(Lua_State, n)
  lua_settop(Lua_State, -(n)-1)
EndMacro

Macro lua_newtable(Lua_State)
  lua_createtable(Lua_State, 0, 0)
EndMacro

Macro lua_tostring(Result_String, Lua_State, idx)
  *Temp_String = lua_tolstring(Lua_State, idx, #Null)
  If *Temp_String : Result_String = PeekS(*Temp_String) : Else : Result_String = "" : EndIf
EndMacro

;Macro lua_call(Lua_State, nargs, nresults)
;  lua_callk(Lua_State, nargs, nresults, 0, #Null)
;EndMacro

;Macro lua_pcall(Lua_State, nargs, nresults, lua_errCFunction)
;  lua_pcallk(Lua_State, nargs, nresults, lua_errCFunction, 0, #Null)
;EndMacro

; #################################### Initkram #################################################

;-################################## Proceduren in Lua ##########################################

ProcedureC Lua_CMD_Client_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Client_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Client_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Client_Get_Map_ID(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Network_Client = Client_Get_Pointer(Client_ID)
  If *Pointer
    Result = *Pointer\Player\Map_ID
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Client_Get_IP(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Network_Client = Client_Get_Pointer(Client_ID)
  If *Pointer
    Result.s = *Pointer\IP
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Client_Get_Login_Name(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Network_Client = Client_Get_Pointer(Client_ID)
  If *Pointer
    Result.s = *Pointer\Player\Login_Name
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Client_Get_Logged_In(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Network_Client = Client_Get_Pointer(Client_ID)
  If *Pointer
    Result = *Pointer\Logged_In
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Client_Get_Entity(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Network_Client = Client_Get_Pointer(Client_ID)
  If *Pointer
    If *Pointer\Player\Entity
      Result = *Pointer\Player\Entity\ID
    EndIf
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Build_Mode_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Value.s, Lua_State, 2)
  
  Build_Mode_Set(Client_ID, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  Result = PeekS(Build_Mode_Get(Client_ID))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_State_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Value = lua_tointeger(Lua_State, 2)
  
  Build_Mode_State_Set(Client_ID, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_State_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  Result = Build_Mode_State_Get(Client_ID)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Coordinate_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  
  Build_Mode_Coordinate_Set(Client_ID, Index, X, Y, Z)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Coordinate_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  
  Result_X = -1
  Result_Y = -1
  Result_Z = -1
  
  Result_X = Build_Mode_Coordinate_Get_X(Client_ID, Index)
  Result_Y = Build_Mode_Coordinate_Get_Y(Client_ID, Index)
  Result_Z = Build_Mode_Coordinate_Get_Z(Client_ID, Index)
  
  lua_pushinteger(Lua_State, Result_X)
  lua_pushinteger(Lua_State, Result_Y)
  lua_pushinteger(Lua_State, Result_Z)
  
  ProcedureReturn 3 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Long_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  Value = lua_tointeger(Lua_State, 3)
  
  Build_Mode_Long_Set(Client_ID, Index, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Long_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  
  Result = -1
  
  Result = Build_Mode_Long_Get(Client_ID, Index)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Float_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  Value.d = lua_tonumber(Lua_State, 3)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Value, XMM0
    DisableASM
  CompilerEndIf
  
  Build_Mode_Float_Set(Client_ID, Index, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_Float_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  
  Result.f = -1
  
  Result = Build_Mode_Float_Get(Client_ID, Index)
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_String_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  lua_tostring(Value.s, Lua_State, 3) ;Value.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  
  Build_Mode_String_Set(Client_ID, Index, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Mode_String_Get(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Index = lua_tointeger(Lua_State, 2)
  
  Result.s = ""
  
  Result = PeekS(Build_Mode_String_Get(Client_ID, Index))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Build_Line_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X_0 = lua_tointeger(Lua_State, 3)
  Y_0 = lua_tointeger(Lua_State, 4)
  Z_0 = lua_tointeger(Lua_State, 5)
  X_1 = lua_tointeger(Lua_State, 6)
  Y_1 = lua_tointeger(Lua_State, 7)
  Z_1 = lua_tointeger(Lua_State, 8)
  Material = lua_tointeger(Lua_State, 9)
  Priority = lua_tointeger(Lua_State, 10)
  Undo = lua_tointeger(Lua_State, 11)
  Physic = lua_tointeger(Lua_State, 12)
  
  Build_Line_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Priority, Undo, Physic)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Box_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X_0 = lua_tointeger(Lua_State, 3)
  Y_0 = lua_tointeger(Lua_State, 4)
  Z_0 = lua_tointeger(Lua_State, 5)
  X_1 = lua_tointeger(Lua_State, 6)
  Y_1 = lua_tointeger(Lua_State, 7)
  Z_1 = lua_tointeger(Lua_State, 8)
  Material = lua_tointeger(Lua_State, 9)
  Replace_Material = lua_tointeger(Lua_State, 10)
  Hollow = lua_tointeger(Lua_State, 11)
  Priority = lua_tointeger(Lua_State, 12)
  Undo = lua_tointeger(Lua_State, 13)
  Physic = lua_tointeger(Lua_State, 14)
  
  Build_Box_Player(Player_Number, Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Material, Replace_Material, Hollow, Priority, Undo, Physic)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Sphere_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  R.d = lua_tonumber(Lua_State, 6)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ R, XMM0
    DisableASM
  CompilerEndIf
  Material = lua_tointeger(Lua_State, 7)
  Replace_Material = lua_tointeger(Lua_State, 8)
  Hollow = lua_tointeger(Lua_State, 9)
  Priority = lua_tointeger(Lua_State, 10)
  Undo = lua_tointeger(Lua_State, 11)
  Physic = lua_tointeger(Lua_State, 12)
  
  Build_Sphere_Player(Player_Number, Map_ID, X, Y, Z, R, Material, Replace_Material, Hollow, Priority, Undo, Physic)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Build_Rank_Box(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X_0 = lua_tointeger(Lua_State, 2)
  Y_0 = lua_tointeger(Lua_State, 3)
  Z_0 = lua_tointeger(Lua_State, 4)
  X_1 = lua_tointeger(Lua_State, 5)
  Y_1 = lua_tointeger(Lua_State, 6)
  Z_1 = lua_tointeger(Lua_State, 7)
  Rank = lua_tointeger(Lua_State, 8)
  Max_Rank = lua_tointeger(Lua_State, 9)
  
  Build_Rank_Box(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Rank, Max_Rank)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Font_Draw_Text(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Font_ID.s, Lua_State, 2)
  Map_ID = lua_tointeger(Lua_State, 3)
  X = lua_tointeger(Lua_State, 4)
  Y = lua_tointeger(Lua_State, 5)
  Z = lua_tointeger(Lua_State, 6)
  V_X.d = lua_tonumber(Lua_State, 7)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ V_X, XMM0
    DisableASM
  CompilerEndIf
  V_Y.d = lua_tonumber(Lua_State, 8)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ V_Y, XMM0
    DisableASM
  CompilerEndIf
  lua_tostring(String.s, Lua_State, 9)
  Material_F = lua_tointeger(Lua_State, 10)
  Material_B = lua_tointeger(Lua_State, 11)
  
  Font_Draw_Text(Player_Number, Font_ID, Map_ID, X, Y, Z, V_X, V_Y, String, Material_F, Material_B)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Font_Draw_Text_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Font_ID.s, Lua_State, 2)
  Map_ID = lua_tointeger(Lua_State, 3)
  X = lua_tointeger(Lua_State, 4)
  Y = lua_tointeger(Lua_State, 5)
  Z = lua_tointeger(Lua_State, 6)
  V_X.d = lua_tonumber(Lua_State, 7)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ V_X, XMM0
    DisableASM
  CompilerEndIf
  V_Y.d = lua_tonumber(Lua_State, 8)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ V_Y, XMM0
    DisableASM
  CompilerEndIf
  lua_tostring(String.s, Lua_State, 9)
  Material_F = lua_tointeger(Lua_State, 10)
  Material_B = lua_tointeger(Lua_State, 11)
  
  *Player.Player_List = Player_Get_Pointer(Player_Number)
  If *Player
    Font_Draw_Text_Player(*Player, Font_ID, Map_ID, X, Y, Z, V_X, V_Y, String, Material_F, Material_B)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Entity_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Entity_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Entity_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Add(Lua_State)
  lua_tostring(Name.s, Lua_State, 1) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  Map_ID  = lua_tointeger(Lua_State, 2)
  X.d = lua_tonumber(Lua_State, 3)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ X, XMM0
    DisableASM
  CompilerEndIf
  Y.d = lua_tonumber(Lua_State, 4)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Y, XMM0
    DisableASM
  CompilerEndIf
  Z.d = lua_tonumber(Lua_State, 5)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Z, XMM0
    DisableASM
  CompilerEndIf
  Rotation.d = lua_tonumber(Lua_State, 6)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Rotation, XMM0
    DisableASM
  CompilerEndIf
  Look.d = lua_tonumber(Lua_State, 7)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Look, XMM0
    DisableASM
  CompilerEndIf
  
  Result = Entity_Add(Name.s, Map_ID, X, Y, Z, Rotation, Look)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Delete(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Entity_Delete(Entity_ID)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Player(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    If *Pointer\Player_List
      Result = *Pointer\Player_List\Number
    EndIf
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Map_ID(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\Map_ID
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_X(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result.f = 0
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\X
  EndIf
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Y(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result.f = 0
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\Y
  EndIf
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Z(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result.f = 0
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\Z
  EndIf
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Rotation(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result.f = 0
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\Rotation
  EndIf
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Get_Look(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result.f = 0
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result = *Pointer\Look
  EndIf
  
  lua_pushnumber(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Resend(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Entity_Resend(Entity_ID)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Message_2_Clients(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Message.s, Lua_State, 2) ;Message.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Entity_Message_2_Clients(Entity_ID, Message)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Displayname_Get(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Result_Prefix.s = ""
  Result_Name.s = ""
  Result_Suffix.s = ""
  
  *Pointer.Entity = Entity_Get_Pointer(Entity_ID)
  If *Pointer
    Result_Prefix = *Pointer\Prefix
    Result_Name = *Pointer\Name
    Result_Suffix = *Pointer\Suffix
  EndIf
  
  lua_pushstring(Lua_State, Result_Prefix)
  lua_pushstring(Lua_State, Result_Name)
  lua_pushstring(Lua_State, Result_Suffix)
  
  ProcedureReturn 3 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Displayname_Set(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Prefix.s, Lua_State, 2) ;Prefix.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(Name.s, Lua_State, 3) ;Name.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  lua_tostring(Suffix.s, Lua_State, 4) ;Suffix.s = PeekS(lua_tolstring(Lua_State, 4, #Null))
  
  Entity_Displayname_Set(Entity_ID, Prefix, Name, Suffix)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Position_Set(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X.d = lua_tonumber(Lua_State, 3)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ X, XMM0
    DisableASM
  CompilerEndIf
  Y.d = lua_tonumber(Lua_State, 4)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Y, XMM0
    DisableASM
  CompilerEndIf
  Z.d = lua_tonumber(Lua_State, 5)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Z, XMM0
    DisableASM
  CompilerEndIf
  Rotation.d = lua_tonumber(Lua_State, 6)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Rotation, XMM0
    DisableASM
  CompilerEndIf
  Look.d = lua_tonumber(Lua_State, 7)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Look, XMM0
    DisableASM
  CompilerEndIf
  Priority = lua_tointeger(Lua_State, 8)
  Send_Own_Client = lua_tointeger(Lua_State, 9)
  
  Entity_Position_Set(Entity_ID, Map_ID, X, Y, Z, Rotation, Look, Priority, Send_Own_Client)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Entity_Kill(Lua_State)
  Entity_ID = lua_tointeger(Lua_State, 1)
  
  Entity_Kill(Entity_ID)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Player_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Player_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Player_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Attribute_Long_Set(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Attribute.s, Lua_State, 2) ;Attribute.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  Value = lua_tointeger(Lua_State, 3)
  
  Player_Attribute_Long_Set(Player_Number, Attribute, Value)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Attribute_Long_Get(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Attribute.s, Lua_State, 2) ;Attribute.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Result = Player_Attribute_Long_Get(Player_Number, Attribute)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Attribute_String_Set(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Attribute.s, Lua_State, 2) ;Attribute.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(String.s, Lua_State, 3)    ;String.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  
  Player_Attribute_String_Set(Player_Number, Attribute, String)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Attribute_String_Get(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Attribute.s, Lua_State, 2) ;Attribute.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Result.s = PeekS(Player_Attribute_String_Get(Player_Number, Attribute))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Inventory_Set(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Material = lua_tointeger(Lua_State, 2)
  Number = lua_tointeger(Lua_State, 3)
  
  Player_Inventory_Set(Player_Number, Material, Number)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Inventory_Get(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Material = lua_tointeger(Lua_State, 2)
  
  Result = Player_Inventory_Get(Player_Number, Material)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Prefix(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result.s = PeekS(Player_Get_Prefix(Player_Number))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Name(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result.s = PeekS(Player_Get_Name(Player_Number))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Suffix(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result.s = PeekS(Player_Get_Suffix(Player_Number))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_IP(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Player_List = Player_Get_Pointer(Player_Number)
  If *Pointer
    Result = *Pointer\IP
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Rank(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Player_List = Player_Get_Pointer(Player_Number)
  If *Pointer
    Result = *Pointer\Rank
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Online(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Player_List = Player_Get_Pointer(Player_Number)
  If *Pointer
    Result = *Pointer\Online
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Ontime(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Player_List = Player_Get_Pointer(Player_Number)
  If *Pointer
    Result = *Pointer\Ontime_Counter
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Get_Mute_Time(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Player_List = Player_Get_Pointer(Player_Number)
  If *Pointer
    Result = *Pointer\Time_Muted
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Set_Rank(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Rank = lua_tointeger(Lua_State, 2)
  lua_tostring(Reason.s, Lua_State, 3)
  
  Player_Rank_Set(Player_Number, Rank, Reason)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Kick(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Reason.s, Lua_State, 2) ;Reason.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  Count = lua_tointeger(Lua_State, 3)
  Log = lua_tointeger(Lua_State, 4)
  Show = lua_tointeger(Lua_State, 5)
  
  Player_Kick(Player_Number, Reason, Count, Log, Show)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Ban(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Reason.s, Lua_State, 2) ;Reason.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Player_Ban(Player_Number, Reason)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Unban(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Player_Unban(Player_Number)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Stop(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Reason.s, Lua_State, 2)
  
  Player_Stop(Player_Number, Reason)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Unstop(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Player_Unstop(Player_Number)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Mute(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Minutes = lua_tointeger(Lua_State, 2)
  lua_tostring(Reason.s, Lua_State, 3) ;Reason.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  
  Player_Mute(Player_Number, Minutes, Reason)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Player_Unmute(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  
  Player_Unmute(Player_Number)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Map_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Map_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Map_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Change(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  Type.a = lua_tointeger(Lua_State, 6)
  Undo.a = lua_tointeger(Lua_State, 7)
  Physic.a = lua_tointeger(Lua_State, 8)
  Send.a = lua_tointeger(Lua_State, 9)
  Priority.a = lua_tointeger(Lua_State, 10)
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
    Map_Block_Change(Player_Number, *Map_Data, X, Y, Z, Type, Undo, Physic, Send, Priority)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Change_Client(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  Mode.a = lua_tointeger(Lua_State, 6)
  Type.a = lua_tointeger(Lua_State, 7)
  
  *Client.Network_Client = Client_Get_Pointer(Client_ID)
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Client And *Map_Data
    Map_Block_Change_Client(*Client, *Map_Data, X, Y, Z, Mode, Type)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Change_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  Type.a = lua_tointeger(Lua_State, 6)
  Undo.a = lua_tointeger(Lua_State, 7)
  Physic.a = lua_tointeger(Lua_State, 8)
  Send.a = lua_tointeger(Lua_State, 9)
  Send_Priority.a = lua_tointeger(Lua_State, 10)
  
  *Player.Player_List = Player_Get_Pointer(Player_Number)
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Player And *Map_Data
    Map_Block_Change_Player(*Player, *Map_Data, X, Y, Z, Type, Undo, Physic, Send, Send_Priority)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Move(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X_0 = lua_tointeger(Lua_State, 2)
  Y_0 = lua_tointeger(Lua_State, 3)
  Z_0 = lua_tointeger(Lua_State, 4)
  X_1 = lua_tointeger(Lua_State, 5)
  Y_1 = lua_tointeger(Lua_State, 6)
  Z_1 = lua_tointeger(Lua_State, 7)
  Undo.a = lua_tointeger(Lua_State, 8)
  Physic.a = lua_tointeger(Lua_State, 9)
  Send_Priority.a = lua_tointeger(Lua_State, 10)
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
    Map_Block_Move(*Map_Data, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Undo, Physic, Send_Priority)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Send(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  Map_ID = lua_tointeger(Lua_State, 2)
  X = lua_tointeger(Lua_State, 3)
  Y = lua_tointeger(Lua_State, 4)
  Z = lua_tointeger(Lua_State, 5)
  Type.a = lua_tointeger(Lua_State, 6)
  
  ;Network_Out_Block_Set(Client_ID, X, Y, Z, Type)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Get_Type(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  
  Result = -1
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = Map_Block_Get_Type(*Pointer, X, Y, Z)
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Get_Rank(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  
  Result = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = Map_Block_Get_Rank(*Pointer, X, Y, Z)
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Block_Get_Player_Last(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  
  Result = -1
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = Map_Block_Get_Player_Number(*Pointer, X, Y, Z)
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Name(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Name
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Unique_ID(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Unique_ID
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Directory(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Directory
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Rank_Build(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Rank_Build
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Rank_Join(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Rank_Join
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Rank_Show(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Rank_Show
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Dimensions(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result_X = 0
  Result_Y = 0
  Result_Z = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result_X = *Pointer\Size_X
    Result_Y = *Pointer\Size_Y
    Result_Z = *Pointer\Size_Z
  EndIf
  
  lua_pushinteger(Lua_State, Result_X)
  lua_pushinteger(Lua_State, Result_Y)
  lua_pushinteger(Lua_State, Result_Z)
  
  ProcedureReturn 3 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Spawn(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result_X.f = 0
  Result_Y.f = 0
  Result_Z.f = 0
  Result_Rot.f = 0
  Result_Look.f = 0
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result_X = *Pointer\Spawn_X
    Result_Y = *Pointer\Spawn_Y
    Result_Z = *Pointer\Spawn_Z
    Result_Rot = *Pointer\Spawn_Rot
    Result_Look = *Pointer\Spawn_Look
  EndIf
  
  lua_pushnumber(Lua_State, Result_X)
  lua_pushnumber(Lua_State, Result_Y)
  lua_pushnumber(Lua_State, Result_Z)
  lua_pushnumber(Lua_State, Result_Rot)
  lua_pushnumber(Lua_State, Result_Look)
  
  ProcedureReturn 5 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Get_Save_Intervall(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    Result = *Pointer\Save_Intervall
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Name(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Input.s, Lua_State, 2) ;Input.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Name = Input
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Directory(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Input.s, Lua_State, 2) ;Input.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    If LCase(Right(Input, 1)) <> "/"
      Input + "/"
    EndIf
    *Pointer\Directory = Input
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Rank_Build(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  Input = lua_tointeger(Lua_State, 2)
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Rank_Build = Input
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Rank_Join(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  Input = lua_tointeger(Lua_State, 2)
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Rank_Join = Input
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Rank_Show(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  Input = lua_tointeger(Lua_State, 2)
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Rank_Show = Input
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Spawn(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  Input_X.d = lua_tonumber(Lua_State, 2)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Input_X, XMM0
    DisableASM
  CompilerEndIf
  Input_Y.d = lua_tonumber(Lua_State, 3)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Input_Y, XMM0
    DisableASM
  CompilerEndIf
  Input_Z.d = lua_tonumber(Lua_State, 4)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Input_Z, XMM0
    DisableASM
  CompilerEndIf
  Input_Rot.d = lua_tonumber(Lua_State, 5)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Input_Rot, XMM0
    DisableASM
  CompilerEndIf
  Input_Look.d = lua_tonumber(Lua_State, 6)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Input_Look, XMM0
    DisableASM
  CompilerEndIf
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Spawn_X = Input_X
    *Pointer\Spawn_Y = Input_Y
    *Pointer\Spawn_Z = Input_Z
    *Pointer\Spawn_Rot = Input_Rot
    *Pointer\Spawn_Look = Input_Look
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Set_Save_Intervall(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  Intervall = lua_tointeger(Lua_State, 2)
  
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    *Pointer\Save_Intervall = Intervall
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Add(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  lua_tostring(Name.s, Lua_State, 5) ;Name.s = PeekS(lua_tolstring(Lua_State, 5, #Null))
  
  Result = Map_Add(Map_ID, X, Y, Z, Name.s)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Action_Add_Resize(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  
  Result = Map_Action_Add_Resize(0, Map_ID, X, Y, Z)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Action_Add_Fill(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Function.s, Lua_State, 2) ;Function.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(Argument_String.s, Lua_State, 3) ;Argument_String.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  
  Result = Map_Action_Add_Fill(0, Map_ID, Function, Argument_String)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Action_Add_Save(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Directory.s, Lua_State, 2) ;Directory.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Result = Map_Action_Add_Save(0, Map_ID, Directory)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Action_Add_Load(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Directory.s, Lua_State, 2) ;Directory.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  Result = Map_Action_Add_Load(0, Map_ID, Directory)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Action_Add_Delete(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Result = Map_Action_Add_Delete(0, Map_ID) ; Action Delete
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Resend(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  
  Map_Resend(Map_ID)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Export(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  X_0 = lua_tointeger(Lua_State, 2)
  Y_0 = lua_tointeger(Lua_State, 3)
  Z_0 = lua_tointeger(Lua_State, 4)
  X_1 = lua_tointeger(Lua_State, 5)
  Y_1 = lua_tointeger(Lua_State, 6)
  Z_1 = lua_tointeger(Lua_State, 7)
  lua_tostring(Filename.s, Lua_State, 8) ;Filename.s = PeekS(lua_tolstring(Lua_State, 8, #Null))
  
  Map_Export(Map_ID, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Filename)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Map_Import_Player(Lua_State)
  Player_Number = lua_tointeger(Lua_State, 1)
  lua_tostring(Filename.s, Lua_State, 2) ;Filename.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  Map_ID = lua_tointeger(Lua_State, 3)
  X = lua_tointeger(Lua_State, 4)
  Y = lua_tointeger(Lua_State, 5)
  Z = lua_tointeger(Lua_State, 6)
  SX = lua_tointeger(Lua_State, 7)
  SY = lua_tointeger(Lua_State, 8)
  SZ = lua_tointeger(Lua_State, 9)
  
  Map_Import_Player(Player_Number, Filename, Map_ID, X, Y, Z, SX, SY, SZ)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Block_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Block_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Block_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Block_Get_Name(Lua_State)
  Block_ID = lua_tointeger(Lua_State, 1)
  
  Result.s = ""
  
  *Pointer.Block = Block_Get_Pointer(Block_ID)
  If *Pointer
    Result = *Pointer\Name
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Block_Get_Rank_Place(Lua_State)
  Block_ID = lua_tointeger(Lua_State, 1)
  
  Result = -32769
  
  *Pointer.Block = Block_Get_Pointer(Block_ID)
  If *Pointer
    Result = *Pointer\Rank_Place
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Block_Get_Rank_Delete(Lua_State)
  Block_ID = lua_tointeger(Lua_State, 1)
  
  Result = -32769
  
  *Pointer.Block = Block_Get_Pointer(Block_ID)
  If *Pointer
    Result = *Pointer\Rank_Delete
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Block_Get_Client_Type(Lua_State)
  Block_ID = lua_tointeger(Lua_State, 1)
  
  Result = -1
  
  *Pointer.Block = Block_Get_Pointer(Block_ID)
  If *Pointer
    Result = *Pointer\On_Client
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Rank_Get_Table(Lua_State)
  lua_newtable(Lua_State)
  
  Elements = Rank_Count_Elements()
  If Elements > 0
    Dim Temp.Plugin_Result_Element(Elements)
    Rank_Get_Array(@Temp())
    
    For i = 0 To Elements-1
      lua_pushinteger(Lua_State, i+1)           ;Push the table index
      lua_pushinteger(Lua_State, Temp(i)\ID)    ;Push the cell value
      lua_rawset(Lua_State, -3)                 ;Stores the pair in the table (The table is on the top of the stack again)
    Next
  EndIf
  
  lua_pushinteger(Lua_State, Elements)
  
  ProcedureReturn 2 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Add(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  lua_tostring(Name.s, Lua_State, 2)   ;Name.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(Prefix.s, Lua_State, 3) ;Color.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  lua_tostring(Suffix.s, Lua_State, 4) ;
    
  Rank_Add(Rank, Name, Prefix, Suffix)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Delete(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  Exact = lua_tointeger(Lua_State, 2)
  
  Rank_Delete(Rank, Exact)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Get_Name(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  Exact = lua_tointeger(Lua_State, 2)
  
  Result.s = ""
  
  *Pointer.Rank = Rank_Get_Pointer(Rank, Exact)
  If *Pointer
    Result = *Pointer\Name
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Get_Prefix(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  Exact = lua_tointeger(Lua_State, 2)
  
  Result.s = ""
  
  *Pointer.Rank = Rank_Get_Pointer(Rank, Exact)
  If *Pointer
    Result = *Pointer\Prefix
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Get_Suffix(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  Exact = lua_tointeger(Lua_State, 2)
  
  Result.s = ""
  
  *Pointer.Rank = Rank_Get_Pointer(Rank, Exact)
  If *Pointer
    Result = *Pointer\Suffix
  EndIf
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Rank_Get_Root(Lua_State)
  Rank = lua_tointeger(Lua_State, 1)
  
  Result = -32769
  
  *Pointer.Rank = Rank_Get_Pointer(Rank)
  If *Pointer
    Result = *Pointer\Rank
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Teleporter_Get_Table(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  *Pointer.Map_Data = Map_Get_Pointer(Map_ID)
  If *Pointer
    lua_newtable(Lua_State)
    
    Elements = Teleporter_Count_Elements(*Pointer)
    If Elements > 0
      Dim Temp.Plugin_Result_Element(Elements)
      Teleporter_Get_Array(*Pointer, @Temp())
      
      For i = 0 To Elements-1
        *Teleporter.Map_Teleporter_Element = Temp(i)\Pointer
        lua_pushinteger(Lua_State, i+1)             ;Push the table index
        lua_pushstring(Lua_State, *Teleporter\ID)   ;Push the cell value
        lua_rawset(Lua_State, -3)                   ;Stores the pair in the table (The table is on the top of the stack again)
      Next
    EndIf
    
    lua_pushinteger(Lua_State, Elements)
    
    ProcedureReturn 2 ; Anzahl der Rückgabeargumente
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Teleporter_Get_Box(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(ID.s, Lua_State, 2) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  Result_X_0 = -1
  Result_Y_0 = -1
  Result_Z_0 = -1
  Result_X_1 = -1
  Result_Y_1 = -1
  Result_Z_1 = -1
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
    
    *Pointer.Map_Teleporter_Element = Teleporter_Get_Pointer(*Map_Data, ID)
    If *Pointer
      Result_X_0 = *Pointer\X_0
      Result_Y_0 = *Pointer\Y_0
      Result_Z_0 = *Pointer\Z_0
      Result_X_1 = *Pointer\X_1
      Result_Y_1 = *Pointer\Y_1
      Result_Z_1 = *Pointer\Z_1
    EndIf
    
  EndIf
  
  lua_pushinteger(Lua_State, Result_X_0)
  lua_pushinteger(Lua_State, Result_Y_0)
  lua_pushinteger(Lua_State, Result_Z_0)
  lua_pushinteger(Lua_State, Result_X_1)
  lua_pushinteger(Lua_State, Result_Y_1)
  lua_pushinteger(Lua_State, Result_Z_1)
  
  ProcedureReturn 6 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Teleporter_Get_Destination(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(ID.s, Lua_State, 2) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  Result_Map_Unique_ID.s = ""
  Result_Map_ID = -1
  Result_X.f = 0
  Result_Y.f = 0
  Result_Z.f = 0
  Result_Rot.f = 0
  Result_Look.f = 0
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
  
    *Pointer.Map_Teleporter_Element = Teleporter_Get_Pointer(*Map_Data, ID)
    If *Pointer
      Result_Map_Unique_ID.s = *Pointer\Dest_Map_Unique_ID
      Result_Map_ID = *Pointer\Dest_Map_ID
      Result_X = *Pointer\Dest_X
      Result_Y = *Pointer\Dest_Y
      Result_Z = *Pointer\Dest_Z
      Result_Rot = *Pointer\Dest_Rot
      Result_Look = *Pointer\Dest_Look
    EndIf
    
  EndIf
  
  lua_pushstring(Lua_State, Result_Map_Unique_ID)
  lua_pushinteger(Lua_State, Result_Map_ID)
  lua_pushnumber(Lua_State, Result_X)
  lua_pushnumber(Lua_State, Result_Y)
  lua_pushnumber(Lua_State, Result_Z)
  lua_pushnumber(Lua_State, Result_Rot)
  lua_pushnumber(Lua_State, Result_Look)
  
  ProcedureReturn 6 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Teleporter_Add(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(ID.s, Lua_State, 2) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  X_0 = lua_tointeger(Lua_State, 3)
  Y_0 = lua_tointeger(Lua_State, 4)
  Z_0 = lua_tointeger(Lua_State, 5)
  X_1 = lua_tointeger(Lua_State, 6)
  Y_1 = lua_tointeger(Lua_State, 7)
  Z_1 = lua_tointeger(Lua_State, 8)
  lua_tostring(Dest_Map_Unique_ID.s, Lua_State, 9)
  Dest_Map_ID = lua_tointeger(Lua_State, 10)
  X.d = lua_tonumber(Lua_State, 11)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ X, XMM0
    DisableASM
  CompilerEndIf
  Y.d = lua_tonumber(Lua_State, 12)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Y, XMM0
    DisableASM
  CompilerEndIf
  Z.d = lua_tonumber(Lua_State, 13)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Z, XMM0
    DisableASM
  CompilerEndIf
  Rot.d = lua_tonumber(Lua_State, 14)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Rot, XMM0
    DisableASM
  CompilerEndIf
  Look.d = lua_tonumber(Lua_State, 15)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Look, XMM0
    DisableASM
  CompilerEndIf
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
    Teleporter_Add(*Map_Data, ID.s, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Dest_Map_Unique_ID, Dest_Map_ID, X, Y, Z, Rot, Look)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Teleporter_Delete(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(ID.s, Lua_State, 2) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  *Map_Data.Map_Data = Map_Get_Pointer(Map_ID)
  If *Map_Data
    Teleporter_Delete(*Map_Data, ID.s)
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_System_Message_Network_Send_2_All(Lua_State)
  Map_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Message.s, Lua_State, 2) ;Message.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  System_Message_Network_Send_2_All(Map_ID, Message.s)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_System_Message_Network_Send(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  lua_tostring(Message.s, Lua_State, 2) ;Message.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  
  System_Message_Network_Send(Client_ID, Message.s)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Network_Out_Block_Set(Lua_State)
  Client_ID = lua_tointeger(Lua_State, 1)
  X = lua_tointeger(Lua_State, 2)
  Y = lua_tointeger(Lua_State, 3)
  Z = lua_tointeger(Lua_State, 4)
  Type = lua_tointeger(Lua_State, 5)
  
  Network_Out_Block_Set(Client_ID, X, Y, Z, Type)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Language_Get(Lua_State)
  lua_tostring(Language.s, Lua_State, 1) ;Language.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  lua_tostring(Input.s, Lua_State, 2) ;Input.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(Field_0.s, Lua_State, 3) ;
  lua_tostring(Field_1.s, Lua_State, 4) ;
  lua_tostring(Field_2.s, Lua_State, 5) ;
  lua_tostring(Field_3.s, Lua_State, 6) ;
  ;*String_0 = lua_tolstring(Lua_State, 3, #Null)
  ;If *String_0 : Field_0.s = PeekS(*String_0) : EndIf
  ;*String_1 = lua_tolstring(Lua_State, 4, #Null)
  ;If *String_0 : Field_1.s = PeekS(*String_1) : EndIf
  ;*String_2 = lua_tolstring(Lua_State, 5, #Null)
  ;If *String_2 : Field_2.s = PeekS(*String_2) : EndIf
  ;*String_3 = lua_tolstring(Lua_State, 6, #Null)
  ;If *String_3 : Field_3.s = PeekS(*String_3) : EndIf
  
  Result.s = PeekS(Lang_Get(Language, Input, Field_0, Field_1, Field_2, Field_3))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Files_File_Get(Lua_State)
  lua_tostring(File.s, Lua_State, 1) ;File.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  Result.s = PeekS(Files_File_Get(File.s))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Files_Folder_Get(Lua_State)
  lua_tostring(Name.s, Lua_State, 1) ;Name.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  Result.s = PeekS(Files_Folder_Get(Name.s))
  
  lua_pushstring(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

;-############################################################

ProcedureC Lua_CMD_Event_Add(Lua_State)
  lua_tostring(ID.s, Lua_State, 1) ;ID.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  lua_tostring(Function.s, Lua_State, 2) ;Function.s = PeekS(lua_tolstring(Lua_State, 2, #Null))
  lua_tostring(Type.s, Lua_State, 3) ;Type.s = PeekS(lua_tolstring(Lua_State, 3, #Null))
  Set_Or_Check.a = lua_tointeger(Lua_State, 4)
  Time.l = lua_tointeger(Lua_State, 5)
  Map_ID.l = lua_tointeger(Lua_State, 6)
  
  Result = Lua_Event_Add(ID.s, Function.s, Type.s, Set_Or_Check.a, Time.l, Map_ID.l)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_CMD_Event_Delete(Lua_State)
  lua_tostring(ID.s, Lua_State, 1) ;ID.s = PeekS(lua_tolstring(Lua_State, 1, #Null))
  
  Lua_Event_Delete(ID.s)
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

;-########################################## Event-Proceduren ####################################

Procedure Lua_Event_Select(ID.s, Log.a=0)
  If ListIndex(Lua_Event()) <> -1 And Lua_Event()\ID = ID
    ProcedureReturn #True
  Else
    ForEach Lua_Event()
      If Lua_Event()\ID = ID
        ProcedureReturn #True
      EndIf
    Next
  EndIf
  
  If Log
    Temp.s = PeekS(Lang_Get("", "Can't find Lua_Event()\ID = '[Field_0]'", ID))
    Log_Add("Lua_Event", Temp.s, 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure Lua_Event_Add(ID.s, Function.s, Type.s, Set_Or_Check.a, Time.l, Map_ID.l)
  If ID <> ""
    
    Select LCase(Type)
      Case "timer"                    : Type_Enumeration = #Lua_Event_Timer
      Case "client_add"               : Type_Enumeration = #Lua_Event_Client_Add
      Case "client_delete"            : Type_Enumeration = #Lua_Event_Client_Delete
      Case "client_login"             : Type_Enumeration = #Lua_Event_Client_Login
      Case "client_logout"            : Type_Enumeration = #Lua_Event_Client_Logout
      Case "entity_add"               : Type_Enumeration = #Lua_Event_Entity_Add
      Case "entity_delete"            : Type_Enumeration = #Lua_Event_Entity_Delete
      Case "entity_position_set"      : Type_Enumeration = #Lua_Event_Entity_Position_Set
      Case "entity_die"               : Type_Enumeration = #Lua_Event_Entity_Die
      Case "map_add"                  : Type_Enumeration = #Lua_Event_Map_Add
      Case "map_action_delete"        : Type_Enumeration = #Lua_Event_Map_Action_Delete
      Case "map_action_resize"        : Type_Enumeration = #Lua_Event_Map_Action_Resize
      Case "map_action_fill"          : Type_Enumeration = #Lua_Event_Map_Action_Fill
      Case "map_action_save"          : Type_Enumeration = #Lua_Event_Map_Action_Save
      Case "map_action_load"          : Type_Enumeration = #Lua_Event_Map_Action_Load
      Case "map_block_change"         : Type_Enumeration = #Lua_Event_Map_Block_Change
      Case "map_block_change_client"  : Type_Enumeration = #Lua_Event_Map_Block_Change_Client
      Case "map_block_change_player"  : Type_Enumeration = #Lua_Event_Map_Block_Change_Player
      Case "chat_map"                 : Type_Enumeration = #Lua_Event_Chat_Map
      Case "chat_all"                 : Type_Enumeration = #Lua_Event_Chat_All
      Case "chat_private"             : Type_Enumeration = #Lua_Event_Chat_Private
      Default                         : ProcedureReturn #False
    EndSelect
    
    If Lua_Event_Select(ID.s)
      Lua_Event()\Function = Function
      Lua_Event()\Type = Type_Enumeration
      
      Lua_Event()\Time = Time
      Lua_Event()\Map_ID = Map_ID
      ProcedureReturn #True
    Else
      If Set_Or_Check = 0
        FirstElement(Lua_Event())
        If InsertElement(Lua_Event())
          Lua_Event()\ID = ID
          Lua_Event()\Function = Function
          Lua_Event()\Type = Type_Enumeration
          
          Lua_Event()\Time = Time
          Lua_Event()\Map_ID = Map_ID
          ProcedureReturn #True
        EndIf
      Else
        LastElement(Lua_Event())
        If AddElement(Lua_Event())
          Lua_Event()\ID = ID
          Lua_Event()\Function = Function
          Lua_Event()\Type = Type_Enumeration
          
          Lua_Event()\Time = Time
          Lua_Event()\Map_ID = Map_ID
          ProcedureReturn #True
        EndIf
      EndIf
      
    EndIf
    
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure Lua_Event_Delete(ID.s)
  If Lua_Event_Select(ID.s)
    DeleteElement(Lua_Event())
  EndIf
EndProcedure

; ################

Procedure Lua_Do_Function_Event_Timer(Function_Name.s, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 1, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Event_Client_Add(Result, Function_Name.s, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Client_Delete(Result, Function_Name.s, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Client_Login(Result, Function_Name.s, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Client_Logout(Result, Function_Name.s, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Entity_Add(Result, Function_Name.s, Entity_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Entity_Delete(Result, Function_Name.s, Entity_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Entity_Position_Set(Result, Function_Name.s, Entity_ID, Map_ID, X.f, Y.f, Z.f, Rotation.f, Look.f, Priority.a, Send_Own_Client.a)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushnumber(Lua_Main\State, X)
    lua_pushnumber(Lua_Main\State, Y)
    lua_pushnumber(Lua_Main\State, Z)
    lua_pushnumber(Lua_Main\State, Rotation)
    lua_pushnumber(Lua_Main\State, Look)
    lua_pushinteger(Lua_Main\State, Priority)
    lua_pushinteger(Lua_Main\State, Send_Own_Client)
    Lua_Do_Function(Function_Name, 10, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Entity_Die(Result, Function_Name.s, Entity_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Add(Result, Function_Name.s, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 2, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Action_Delete(Result, Function_Name.s, Action_ID, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Action_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Action_Resize(Result, Function_Name.s, Action_ID, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Action_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Action_Fill(Result, Function_Name.s, Action_ID, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Action_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Action_Save(Result, Function_Name.s, Action_ID, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Action_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Action_Load(Result, Function_Name.s, Action_ID, Map_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Action_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Block_Change(Result, Function_Name.s, Player_Number, Map_ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Player_Number)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Type)
    lua_pushinteger(Lua_Main\State, Undo)
    lua_pushinteger(Lua_Main\State, Physic)
    lua_pushinteger(Lua_Main\State, Send)
    lua_pushinteger(Lua_Main\State, Send_Priority)
    Lua_Do_Function(Function_Name, 11, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Block_Change_Client(Result, Function_Name.s, Client_ID, Map_ID, X, Y, Z, Mode.a, Type.a)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Client_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Mode)
    lua_pushinteger(Lua_Main\State, Type)
    Lua_Do_Function(Function_Name, 8, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Map_Block_Change_Player(Result, Function_Name.s, Player_Number, Map_ID, X, Y, Z, Type.a, Undo.a, Physic.a, Send.a, Send_Priority.a)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Player_Number)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Type)
    lua_pushinteger(Lua_Main\State, Undo)
    lua_pushinteger(Lua_Main\State, Physic)
    lua_pushinteger(Lua_Main\State, Send)
    lua_pushinteger(Lua_Main\State, Send_Priority)
    Lua_Do_Function(Function_Name, 11, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Chat_Map(Result, Function_Name.s, Entity_ID, Message.s)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    lua_pushstring(Lua_Main\State, Message)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Chat_All(Result, Function_Name.s, Entity_ID, Message.s)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    lua_pushstring(Lua_Main\State, Message)
    Lua_Do_Function(Function_Name, 3, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Event_Chat_Private(Result, Function_Name.s, Entity_ID, Player_Name.s, Message.s)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Result)
    lua_pushinteger(Lua_Main\State, Entity_ID)
    lua_pushstring(Lua_Main\State, Player_Name)
    lua_pushstring(Lua_Main\State, Message)
    Lua_Do_Function(Function_Name, 4, 1)
    Result = lua_tointeger(Lua_Main\State, -1)
    lua_pop(Lua_Main\State, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function_Command(Function_Name.s, Client_ID, Command.s, Text_0.s, Text_1.s, Arg_0.s, Arg_1.s, Arg_2.s, Arg_3.s, Arg_4.s)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Client_ID)
    lua_pushstring(Lua_Main\State, Command)
    lua_pushstring(Lua_Main\State, Text_0)
    lua_pushstring(Lua_Main\State, Text_1)
    lua_pushstring(Lua_Main\State, Arg_0)
    lua_pushstring(Lua_Main\State, Arg_1)
    lua_pushstring(Lua_Main\State, Arg_2)
    lua_pushstring(Lua_Main\State, Arg_3)
    lua_pushstring(Lua_Main\State, Arg_4)
    Lua_Do_Function(Function_Name, 9, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Map_Block_Physics(Function_Name.s, Map_ID, X, Y, Z)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    Lua_Do_Function(Function_Name, 4, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Map_Block_Create(Function_Name.s, Map_ID, X, Y, Z, Old_Block.a, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Old_Block)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 6, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Map_Block_Delete(Function_Name.s, Map_ID, X, Y, Z, Old_Block.a, Client_ID)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Old_Block)
    lua_pushinteger(Lua_Main\State, Client_ID)
    Lua_Do_Function(Function_Name, 6, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Map_Fill(Function_Name.s, Map_ID, Size_X, Size_Y, Size_Z, Argument_String.s)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, Size_X)
    lua_pushinteger(Lua_Main\State, Size_Y)
    lua_pushinteger(Lua_Main\State, Size_Z)
    lua_pushstring(Lua_Main\State, Argument_String)
    Lua_Do_Function(Function_Name, 5, 0)
  EndIf
EndProcedure

Procedure Lua_Do_Function_Build_Mode(Function_Name.s, Client_ID, Map_ID, X, Y, Z, Mode, Block_Type)
  If Lua_Main\State
    lua_getfield(Lua_Main\State, #LUA_GLOBALSINDEX, Function_Name)
    lua_pushinteger(Lua_Main\State, Client_ID)
    lua_pushinteger(Lua_Main\State, Map_ID)
    lua_pushinteger(Lua_Main\State, X)
    lua_pushinteger(Lua_Main\State, Y)
    lua_pushinteger(Lua_Main\State, Z)
    lua_pushinteger(Lua_Main\State, Mode)
    lua_pushinteger(Lua_Main\State, Block_Type)
    Lua_Do_Function(Function_Name, 7, 0)
  EndIf
EndProcedure

;-########################################## Proceduren ##########################################

Procedure Lua_Init()
  Lua_Main\State = luaL_newstate()
  
  If Lua_Main\State
    luaopen_base(Lua_Main\State)
    luaopen_table(Lua_Main\State)
    
  	;luaopen_io(Lua_Main\State)
  	lua_pushcclosure(Lua_Main\State, @luaopen_io(), 0)
    lua_call(Lua_Main\State, 0, 0)
    
  	luaopen_os(Lua_Main\State)
  	luaopen_string(Lua_Main\State)
  	luaopen_math(Lua_Main\State)
  	;luaopen_debug(Lua_Main\State)
  	;luaopen_package(Lua_Main\State)
  	lua_pushcclosure(Lua_Main\State, @luaopen_package(), 0)
    lua_call(Lua_Main\State, 0, 0)
    
    
    Lua_Register_All()
    
    Log_Add("Lua-Plugin", "Lua loaded", 0, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  Else
    Log_Add("Lua-Plugin", "Lua-State = 0", 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
  EndIf
  
EndProcedure

Procedure Lua_Register_All()
  If Lua_Main\State
    lua_register(Lua_Main\State, "Client_Get_Table", @Lua_CMD_Client_Get_Table())
    lua_register(Lua_Main\State, "Client_Get_Map_ID", @Lua_CMD_Client_Get_Map_ID())
    lua_register(Lua_Main\State, "Client_Get_IP", @Lua_CMD_Client_Get_IP())
    lua_register(Lua_Main\State, "Client_Get_Login_Name", @Lua_CMD_Client_Get_Login_Name())
    lua_register(Lua_Main\State, "Client_Get_Logged_In", @Lua_CMD_Client_Get_Logged_In())
    lua_register(Lua_Main\State, "Client_Get_Entity", @Lua_CMD_Client_Get_Entity())
    
    lua_register(Lua_Main\State, "Build_Mode_Set", @Lua_CMD_Build_Mode_Set())
    lua_register(Lua_Main\State, "Build_Mode_Get", @Lua_CMD_Build_Mode_Get())
    lua_register(Lua_Main\State, "Build_Mode_State_Set", @Lua_CMD_Build_Mode_State_Set())
    lua_register(Lua_Main\State, "Build_Mode_State_Get", @Lua_CMD_Build_Mode_State_Get())
    lua_register(Lua_Main\State, "Build_Mode_Coordinate_Set", @Lua_CMD_Build_Mode_Coordinate_Set())
    lua_register(Lua_Main\State, "Build_Mode_Coordinate_Get", @Lua_CMD_Build_Mode_Coordinate_Get())
    lua_register(Lua_Main\State, "Build_Mode_Long_Set", @Lua_CMD_Build_Mode_Long_Set())
    lua_register(Lua_Main\State, "Build_Mode_Long_Get", @Lua_CMD_Build_Mode_Long_Get())
    lua_register(Lua_Main\State, "Build_Mode_Float_Set", @Lua_CMD_Build_Mode_Float_Set())
    lua_register(Lua_Main\State, "Build_Mode_Float_Get", @Lua_CMD_Build_Mode_Float_Get())
    lua_register(Lua_Main\State, "Build_Mode_String_Set", @Lua_CMD_Build_Mode_String_Set())
    lua_register(Lua_Main\State, "Build_Mode_String_Get", @Lua_CMD_Build_Mode_String_Get())
    
    lua_register(Lua_Main\State, "Build_Line_Player", @Lua_CMD_Build_Line_Player())
    lua_register(Lua_Main\State, "Build_Box_Player", @Lua_CMD_Build_Box_Player())
    lua_register(Lua_Main\State, "Build_Sphere_Player", @Lua_CMD_Build_Sphere_Player())
    lua_register(Lua_Main\State, "Build_Rank_Box", @Lua_CMD_Build_Rank_Box())
    
    lua_register(Lua_Main\State, "Font_Draw_Text", @Lua_CMD_Font_Draw_Text())
    lua_register(Lua_Main\State, "Font_Draw_Text_Player", @Lua_CMD_Font_Draw_Text_Player())
    
    lua_register(Lua_Main\State, "Entity_Get_Table", @Lua_CMD_Entity_Get_Table())
    lua_register(Lua_Main\State, "Entity_Add", @Lua_CMD_Entity_Add())
    lua_register(Lua_Main\State, "Entity_Delete", @Lua_CMD_Entity_Delete())
    lua_register(Lua_Main\State, "Entity_Get_Player", @Lua_CMD_Entity_Get_Player())
    lua_register(Lua_Main\State, "Entity_Get_Map_ID", @Lua_CMD_Entity_Get_Map_ID())
    lua_register(Lua_Main\State, "Entity_Get_X", @Lua_CMD_Entity_Get_X())
    lua_register(Lua_Main\State, "Entity_Get_Y", @Lua_CMD_Entity_Get_Y())
    lua_register(Lua_Main\State, "Entity_Get_Z", @Lua_CMD_Entity_Get_Z())
    lua_register(Lua_Main\State, "Entity_Get_Rotation", @Lua_CMD_Entity_Get_Rotation())
    lua_register(Lua_Main\State, "Entity_Get_Look", @Lua_CMD_Entity_Get_Look())
    lua_register(Lua_Main\State, "Entity_Resend", @Lua_CMD_Entity_Resend())
    lua_register(Lua_Main\State, "Entity_Message_2_Clients", @Lua_CMD_Entity_Message_2_Clients())
    lua_register(Lua_Main\State, "Entity_Displayname_Get", @Lua_CMD_Entity_Displayname_Get())
    lua_register(Lua_Main\State, "Entity_Displayname_Set", @Lua_CMD_Entity_Displayname_Set())
    lua_register(Lua_Main\State, "Entity_Position_Set", @Lua_CMD_Entity_Position_Set())
    lua_register(Lua_Main\State, "Entity_Kill", @Lua_CMD_Entity_Kill())
    
    lua_register(Lua_Main\State, "Player_Get_Table", @Lua_CMD_Player_Get_Table())
    lua_register(Lua_Main\State, "Player_Attribute_Long_Set", @Lua_CMD_Player_Attribute_Long_Set())
    lua_register(Lua_Main\State, "Player_Attribute_Long_Get", @Lua_CMD_Player_Attribute_Long_Get())
    lua_register(Lua_Main\State, "Player_Attribute_String_Set", @Lua_CMD_Player_Attribute_String_Set())
    lua_register(Lua_Main\State, "Player_Attribute_String_Get", @Lua_CMD_Player_Attribute_String_Get())
    lua_register(Lua_Main\State, "Player_Inventory_Set", @Lua_CMD_Player_Inventory_Set())
    lua_register(Lua_Main\State, "Player_Inventory_Get", @Lua_CMD_Player_Inventory_Get())
    lua_register(Lua_Main\State, "Player_Get_Prefix", @Lua_CMD_player_Get_Prefix())
    lua_register(Lua_Main\State, "Player_Get_Name", @Lua_CMD_player_Get_Name())
    lua_register(Lua_Main\State, "Player_Get_Suffix", @Lua_CMD_player_Get_Suffix())
    lua_register(Lua_Main\State, "Player_Get_IP", @Lua_CMD_Player_Get_IP())
    lua_register(Lua_Main\State, "Player_Get_Rank", @Lua_CMD_Player_Get_Rank())
    lua_register(Lua_Main\State, "Player_Get_Online", @Lua_CMD_Player_Get_Online())
    lua_register(Lua_Main\State, "Player_Get_Ontime", @Lua_CMD_Player_Get_Ontime())
    lua_register(Lua_Main\State, "Player_Get_Mute_Time", @Lua_CMD_Player_Get_Mute_Time())
    lua_register(Lua_Main\State, "Player_Set_Rank", @Lua_CMD_Player_Set_Rank())
    lua_register(Lua_Main\State, "Player_Kick", @Lua_CMD_Player_Kick())
    lua_register(Lua_Main\State, "Player_Ban", @Lua_CMD_Player_Ban())
    lua_register(Lua_Main\State, "Player_Unban", @Lua_CMD_Player_Unban())
    lua_register(Lua_Main\State, "Player_Stop", @Lua_CMD_Player_Stop())
    lua_register(Lua_Main\State, "Player_Unstop", @Lua_CMD_Player_Unstop())
    lua_register(Lua_Main\State, "Player_Mute", @Lua_CMD_Player_Mute())
    lua_register(Lua_Main\State, "Player_Unmute", @Lua_CMD_Player_Unmute())

    
    lua_register(Lua_Main\State, "Map_Get_Table", @Lua_CMD_Map_Get_Table())
    lua_register(Lua_Main\State, "Map_Block_Change", @Lua_CMD_Map_Block_Change())
    lua_register(Lua_Main\State, "Map_Block_Change_Client", @Lua_CMD_Map_Block_Change_Client())
    lua_register(Lua_Main\State, "Map_Block_Change_Player", @Lua_CMD_Map_Block_Change_Player())
    lua_register(Lua_Main\State, "Map_Block_Move", @Lua_CMD_Map_Block_Move())
    ;lua_register(Lua_Main\State, "Map_Block_Send", @Lua_CMD_Map_Block_Send())
    lua_register(Lua_Main\State, "Map_Block_Get_Type", @Lua_CMD_Map_Block_Get_Type())
    lua_register(Lua_Main\State, "Map_Block_Get_Rank", @Lua_CMD_Map_Block_Get_Rank())
    lua_register(Lua_Main\State, "Map_Block_Get_Player_Last", @Lua_CMD_Map_Block_Get_Player_Last())
    lua_register(Lua_Main\State, "Map_Get_Name", @Lua_CMD_Map_Get_Name())
    lua_register(Lua_Main\State, "Map_Get_Unique_ID", @Lua_CMD_Map_Get_Unique_ID())
    lua_register(Lua_Main\State, "Map_Get_Directory", @Lua_CMD_Map_Get_Directory())
    lua_register(Lua_Main\State, "Map_Get_Rank_Build", @Lua_CMD_Map_Get_Rank_Build())
    lua_register(Lua_Main\State, "Map_Get_Rank_Join", @Lua_CMD_Map_Get_Rank_Join())
    lua_register(Lua_Main\State, "Map_Get_Rank_Show", @Lua_CMD_Map_Get_Rank_Show())
    lua_register(Lua_Main\State, "Map_Get_Dimensions", @Lua_CMD_Map_Get_Dimensions())
    lua_register(Lua_Main\State, "Map_Get_Spawn", @Lua_CMD_Map_Get_Spawn())
    lua_register(Lua_Main\State, "Map_Get_Save_Intervall", @Lua_CMD_Map_Get_Save_Intervall())
    lua_register(Lua_Main\State, "Map_Set_Name", @Lua_CMD_Map_Set_Name())
    lua_register(Lua_Main\State, "Map_Set_Directory", @Lua_CMD_Map_Set_Directory())
    lua_register(Lua_Main\State, "Map_Set_Rank_Build", @Lua_CMD_Map_Set_Rank_Build())
    lua_register(Lua_Main\State, "Map_Set_Rank_Join", @Lua_CMD_Map_Set_Rank_Join())
    lua_register(Lua_Main\State, "Map_Set_Rank_Show", @Lua_CMD_Map_Set_Rank_Show())
    lua_register(Lua_Main\State, "Map_Set_Spawn", @Lua_CMD_Map_Set_Spawn())
    lua_register(Lua_Main\State, "Map_Set_Save_Intervall", @Lua_CMD_Map_Set_Save_Intervall())
    lua_register(Lua_Main\State, "Map_Add", @Lua_CMD_Map_Add())
    lua_register(Lua_Main\State, "Map_Action_Add_Resize", @Lua_CMD_Map_Action_Add_Resize())
    lua_register(Lua_Main\State, "Map_Action_Add_Fill", @Lua_CMD_Map_Action_Add_Fill())
    lua_register(Lua_Main\State, "Map_Action_Add_Save", @Lua_CMD_Map_Action_Add_Save())
    lua_register(Lua_Main\State, "Map_Action_Add_Load", @Lua_CMD_Map_Action_Add_Load())
    lua_register(Lua_Main\State, "Map_Action_Add_Delete", @Lua_CMD_Map_Action_Add_Delete())
    lua_register(Lua_Main\State, "Map_Resend", @Lua_CMD_Map_Resend())
    lua_register(Lua_Main\State, "Map_Export", @Lua_CMD_Map_Export())
    lua_register(Lua_Main\State, "Map_Import_Player", @Lua_CMD_Map_Import_Player())
    
    lua_register(Lua_Main\State, "Block_Get_Table", @Lua_CMD_Block_Get_Table())
    lua_register(Lua_Main\State, "Block_Get_Name", @Lua_CMD_Block_Get_Name())
    lua_register(Lua_Main\State, "Block_Get_Rank_Place", @Lua_CMD_Block_Get_Rank_Place())
    lua_register(Lua_Main\State, "Block_Get_Rank_Delete", @Lua_CMD_Block_Get_Rank_Delete())
    lua_register(Lua_Main\State, "Block_Get_Client_Type", @Lua_CMD_Block_Get_Client_Type())
    
    lua_register(Lua_Main\State, "Rank_Get_Table", @Lua_CMD_Rank_Get_Table())
    lua_register(Lua_Main\State, "Rank_Add", @Lua_CMD_Rank_Add())
    lua_register(Lua_Main\State, "Rank_Delete", @Lua_CMD_Rank_Delete())
    lua_register(Lua_Main\State, "Rank_Get_Name", @Lua_CMD_Rank_Get_Name())
    lua_register(Lua_Main\State, "Rank_Get_Prefix", @Lua_CMD_Rank_Get_Prefix())
    lua_register(Lua_Main\State, "Rank_Get_Suffix", @Lua_CMD_Rank_Get_Suffix())
    lua_register(Lua_Main\State, "Rank_Get_Root", @Lua_CMD_Rank_Get_Root())
    
    
    lua_register(Lua_Main\State, "Teleporter_Get_Table", @Lua_CMD_Teleporter_Get_Table())
    lua_register(Lua_Main\State, "Teleporter_Add", @Lua_CMD_Teleporter_Add())
    lua_register(Lua_Main\State, "Teleporter_Delete", @Lua_CMD_Teleporter_Delete())
    lua_register(Lua_Main\State, "Teleporter_Get_Box", @Lua_CMD_Teleporter_Get_Box())
    lua_register(Lua_Main\State, "Teleporter_Get_Destination", @Lua_CMD_Teleporter_Get_Destination())
    
    lua_register(Lua_Main\State, "System_Message_Network_Send_2_All", @Lua_CMD_System_Message_Network_Send_2_All())
    lua_register(Lua_Main\State, "System_Message_Network_Send", @Lua_CMD_System_Message_Network_Send())
    
    lua_register(Lua_Main\State, "Network_Out_Block_Set", @Lua_CMD_Network_Out_Block_Set())
    
    lua_register(Lua_Main\State, "Lang_Get", @Lua_CMD_Language_Get())
    
    lua_register(Lua_Main\State, "Files_File_Get", @Lua_CMD_Files_File_Get())
    lua_register(Lua_Main\State, "Files_Folder_Get", @Lua_CMD_Files_Folder_Get())
    
    lua_register(Lua_Main\State, "Event_Add", @Lua_CMD_Event_Add())
    lua_register(Lua_Main\State, "Event_Delete", @Lua_CMD_Event_Delete())
  EndIf
EndProcedure

Procedure Lua_SetVariable_String(Name.s, String.s)
  If Lua_Main\State
  	lua_pushstring(Lua_Main\State, String)
  	lua_setglobal(Lua_Main\State, Name)
	EndIf
EndProcedure 

Procedure Lua_SetVariable_Integer(Name.s, Value)
  If Lua_Main\State
  	lua_pushinteger(Lua_Main\State, Value)
  	lua_setglobal(Lua_Main\State, Name)
	EndIf
EndProcedure

Procedure.s Lua_GetVariable_String(Name.s)
  If Lua_Main\State
  	lua_getglobal(Lua_Main\State, Name)
  	If lua_tolstring(Lua_Main\State, -1, #Null)
  	  String.s = PeekS(lua_tolstring(Lua_Main\State, -1, #Null))
  	  lua_pop(Lua_Main\State, 1)
  	  ProcedureReturn String
  	EndIf
	EndIf
EndProcedure

Procedure Lua_GetVariable_Integer(Name.s)
  If Lua_Main\State
  	lua_getglobal(Lua_Main\State, Name)
  	Value = lua_tointeger(Lua_Main\State, -1)
  	lua_pop(Lua_Main\State, 1)
  	ProcedureReturn Value
	EndIf
EndProcedure

Procedure Lua_Do_Function(Function.s, Arguments, Results)
  If Lua_Main\State
    
    Result = lua_pcall(Lua_Main\State, Arguments, Results, 0)
    
    Select Result
      Case #LUA_ERRRUN
        Error.s = PeekS(lua_tolstring(Lua_Main\State, -1, #Null))
        Temp.s = PeekS(Lang_Get("", "Runtimeerror in [Field_0]", Function, Error))
        Log_Add("Lua-Plugin", Temp.s, 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Case #LUA_ERRMEM
        Temp.s = PeekS(Lang_Get("", "Memoryallocationerror in [Field_0]", Function))
        Log_Add("Lua-Plugin", Temp.s, 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      Case #LUA_ERRERR
        Temp.s = PeekS(Lang_Get("", "Error in [Field_0]", Function))
        Log_Add("Lua-Plugin", Temp.s, 5, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
      
    EndSelect
    
  EndIf
EndProcedure

Procedure Lua_Do_String(String.s)
  If Lua_Main\State
    
    luaL_dostring(Lua_Main\State, String)
    
  EndIf
EndProcedure

Procedure Lua_Do_File(Filename.s)
  If Lua_Main\State
    
    luaL_dofile(Lua_Main\State, Filename)
    
  EndIf
EndProcedure

Procedure Lua_Check_New_Files(Directory.s)
  
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  Directory_ID = ExamineDirectory(#PB_Any, Directory, "*.*")
  If Directory_ID
    While NextDirectoryEntry(Directory_ID)
      Entry_Name.s = DirectoryEntryName(Directory_ID)
      Filename.s = Directory + "/" + Entry_Name
      
      If Entry_Name <> "." And Entry_Name <> ".."
        
        If DirectoryEntryType(Directory_ID) = #PB_DirectoryEntry_File
          If LCase(Right(Entry_Name, 4)) = ".lua"
            Found = 0
            ForEach Lua_File()
              If Lua_File()\Filename = Filename
                Found = 1
                Break
              EndIf
            Next
            If Found = 0
              AddElement(Lua_File())
              Lua_File()\Filename = Filename
            EndIf
          EndIf
        Else
          Lua_Check_New_Files(Filename)
        EndIf
        
      EndIf
      
    Wend
    FinishDirectory(Directory_ID)
  EndIf
  
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 141
; FirstLine = 102
; Folding = -----------------------------
; EnableXP
; DisableDebugger