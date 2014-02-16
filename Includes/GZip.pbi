; ########################################## Variablen ##########################################

Structure Z_Stream ; SizeOf(Z_Stream) = 56
  *Next_In
  Avail_In.i
  Total_In.l
  
  *Next_Out
  Avail_Out.i
  Total_Out.l
  
  MSG.i
  Placeholder.l
  Zalloc.l
  ZFree.l
  Opaque.l
  
  Data_Type.l
  Adler.l
  Reserved.l
EndStructure


Structure GZip_Main
  Lib_ID.i                  ; Library_ID
  Initialised.b             ; GZip (ZLib) wurde geladen
  Mutex_ID.i                ; Mutex für die Lib
EndStructure
Global GZip_Main.GZip_Main

; ########################################## Konstanten ##########################################

#ZLIB_VERSION = "1.2.5"

; Allowed flush values; see deflate() and inflate() below for details.
#Z_NO_FLUSH =             0
#Z_PARTIAL_FLUSH =        1 ; will be removed, use Z_SYNC_FLUSH instead
#Z_SYNC_FLUSH =           2
#Z_FULL_FLUSH =           3
#Z_FINISH =               4
#Z_BLOCK =                5

; Return codes For the compression/decompression functions.
; Negative values are errors, positive values are used For special but normal events. 
#Z_OK =                   0
#Z_STREAM_END =           1
#Z_NEED_DICT =            2
#Z_ERRNO =               -1
#Z_STREAM_ERROR =        -2
#Z_DATA_ERROR =          -3
#Z_MEM_ERROR =           -4
#Z_BUF_ERROR =           -5
#Z_VERSION_ERROR =       -6

; Compression levels. 
#Z_NO_COMPRESSION =       0
#Z_BEST_SPEED =           1
#Z_BEST_COMPRESSION =     9
#Z_DEFAULT_COMPRESSION = -1

; Compression strategy | see deflateInit2() below for details. 
#Z_FILTERED =             1
#Z_HUFFMAN_ONLY =         2
#Z_RLE =                  3
#Z_FIXED =                4
#Z_DEFAULT_STRATEGY =     0

; Possible values of the data_type field (though see inflate()). 
#Z_BINARY =               0
#Z_TEXT =                 1
#Z_UNKNOWN =              2

; The deflate compression method (the only one supported in this version). 
#Z_DEFLATED =             8

; For initializing zalloc, zfree, opaque. 
#Z_NULL =                 0

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

; ########################################## Proceduren ##########################################

Procedure GZip_Init()
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      Filename.s = "Zlib(x86)\zlib.dll"       ; Windows x86
    CompilerElse
      Filename.s = "Zlib(x64)\zlib.dll"       ; Windows x64
    CompilerEndIf
  CompilerElse
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      Filename.s = "libz.so"                  ; Linux x86
    CompilerElse
      Filename.s = "libz.so"                  ; Linux x64
    CompilerEndIf
  CompilerEndIf
  GZip_Main\Lib_ID = OpenLibrary(#PB_Any, Filename)
  
  If GZip_Main\Mutex_ID = 0
    GZip_Main\Mutex_ID = CreateMutex()
  EndIf
  
  If IsLibrary(GZip_Main\Lib_ID)
    GZip_Main\Initialised = 1
  Else
    Log_Add("GZip", Lang_Get("", "Can't load lib", Filename), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    GZip_Main\Initialised = 0
  EndIf
EndProcedure

Procedure GZip_CompressBound(Input_Len)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  Result = CallCFunction(GZip_Main\Lib_ID, "compressBound", Input_Len)
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  ProcedureReturn Result
EndProcedure

Procedure GZip_Compress(*Output, Output_Len, *Input, Input_Len)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  Protected Stream.Z_Stream
  
  Stream\Next_In   = *Input
  Stream\Avail_In  = Input_Len
  Stream\Next_Out  = *Output
  Stream\Avail_Out = Output_Len
  
  If Stream\Avail_Out <> Output_Len : UnlockMutex(GZip_Main\Mutex_ID) : ProcedureReturn -1 : EndIf
  
  Stream\Zalloc = 0
  Stream\Zfree  = 0
  Stream\Opaque = 0
  
  Version.s = #ZLIB_VERSION
  
  Err = CallCFunction(GZip_Main\Lib_ID, "deflateInit2_", @Stream, #Z_BEST_COMPRESSION, #Z_DEFLATED, 15+16, 9, #Z_FILTERED, @Version, SizeOf(Z_Stream))
  If Err <> #Z_OK : UnlockMutex(GZip_Main\Mutex_ID) : ProcedureReturn -1 : EndIf
  
  Err = CallCFunction(GZip_Main\Lib_ID, "deflate", @Stream, #Z_FINISH)
  If err <> #Z_STREAM_END
    CallCFunction(GZip_Main\Lib_ID, "deflateEnd", @Stream)
    UnlockMutex(GZip_Main\Mutex_ID)
    ProcedureReturn -1
  EndIf
  
  Output_Len = Stream\Total_Out

  Err = CallCFunction(GZip_Main\Lib_ID, "deflateEnd", @Stream)
  If Err <> #Z_OK : UnlockMutex(GZip_Main\Mutex_ID) : ProcedureReturn -1 : EndIf
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  ;PrintN(Str(Output_Len))
  
  ProcedureReturn Output_Len
EndProcedure

Procedure GZip_Compress_Raw(*Output, Output_Len, *Input, Input_Len)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  If CallCFunction(GZip_Main\Lib_ID, "compress", *Output, @Output_Len, *Input, Input_Len) = #Z_OK
    Result = Output_Len
  Else
    Result = -1
  EndIf
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  ProcedureReturn Result
EndProcedure

Procedure GZip_Compress_2_File_2_Buffers(*Input_0, Input_Len_0, *Input_1, Input_Len_1, Filename.s)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  Mode.s = "wb"
  
  Result = #True
  
  GZ_File_ID = CallCFunction(GZip_Main\Lib_ID, "gzopen", @Filename.s, @Mode.s)
  If GZ_File_ID
    If CallCFunction(GZip_Main\Lib_ID, "gzwrite", GZ_File_ID, *Input_0, Input_Len_0) <> Input_Len_0 : Result = #False : EndIf
    If CallCFunction(GZip_Main\Lib_ID, "gzwrite", GZ_File_ID, *Input_1, Input_Len_1) <> Input_Len_1 : Result = #False : EndIf
    If CallCFunction(GZip_Main\Lib_ID, "gzclose", GZ_File_ID) <> 0 : Result = #False : EndIf
  Else
    Result = #False
  EndIf
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  ProcedureReturn Result
EndProcedure

Procedure GZip_Compress_2_File(*Input, Input_Len, Filename.s)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  Mode.s = "wb"
  
  Result = #True
  
  GZ_File_ID = CallCFunction(GZip_Main\Lib_ID, "gzopen", @Filename.s, @Mode.s)
  If GZ_File_ID
    If CallCFunction(GZip_Main\Lib_ID, "gzwrite", GZ_File_ID, *Input, Input_Len) <> Input_Len : Result = #False : EndIf
    If CallCFunction(GZip_Main\Lib_ID, "gzclose", GZ_File_ID) <> 0 : Result = #False : EndIf
  Else
    Result = #False
  EndIf
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  ProcedureReturn Result
EndProcedure

Procedure GZip_Decompress_From_File(Filename.s, *Output, Output_Len)
  
  LockMutex(GZip_Main\Mutex_ID)
  
  Mode.s = "rb"
  
  Result = #True
  
  GZ_File_ID = CallCFunction(GZip_Main\Lib_ID, "gzopen", @Filename.s, @Mode.s)
  If GZ_File_ID
    Size = CallCFunction(GZip_Main\Lib_ID, "gzread", GZ_File_ID, *Output, Output_Len)
    If Size = -1 : Result = #False : EndIf
    CallCFunction(GZip_Main\Lib_ID, "gzclose", GZ_File_ID)
  Else
    Result = #False
  EndIf
  
  UnlockMutex(GZip_Main\Mutex_ID)
  
  If Result = #True
    ProcedureReturn Size
  Else
    ProcedureReturn Result
  EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 142
; FirstLine = 116
; Folding = --
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0