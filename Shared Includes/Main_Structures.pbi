#Client_Player_Buildmode_Variables = 5

#Player_Attributes = 5

; ###############################################################################################################

Structure Player_List
  Number.w                    ; Eindeutige Identifikation des Spielers im Server (-1 ist ungültig)
  Name.s                      ; Name des Spielers
  Save.b                      ; Element soll gespeichert werden.
  Online.l                    ; Ob der Spieler online ist
  Ontime_Counter.d            ; Anzahl der Sekunden, welche der Spieler online ist.
  IP.s                        ; Aktuelle oder letzte IP
  Banned.b                    ; Spieler ist gebannt
  Message_Ban.s               ; Nachricht beim letzten Ban (Inklusive Spielername)
  Counter_Login.l             ; Zähler für das Einloggen eines Spielers
  Counter_Kick.l              ; Zähler für das Kicken eines Spielers
  Message_Kick.s              ; Nachricht beim letzten Kick (Inklusive Spielername)
  Rank.w                      ; Rang des Spielers
  Message_Rank.s              ; Nachricht der letzten Rangänderung (Inklusive Spielername)
  Stopped.b                   ; Spieler wurde "Angehalten", er kann nichts mehr bauen und abreissen
  Message_Stop.s              ; Nachricht beim letzten Stop (Inklusive Spielername)
  Time_Muted.l                ; Date() ab dem der Spieler etwas sagen kann.
  Message_Mute.s              ; Nachricht beim letzten Stummstellen (Inklusive Spielername)
  Attribute.s [#Player_Attributes]        ; Attributname
  Attribute_Long.l [#Player_Attributes]   ; Wert des Attributs
  Attribute_String.s [#Player_Attributes] ; Wert des Attributs
  Inventory.u [256]           ; Anzahl verfügbarer Blöcke des Spielers
EndStructure

; ################################################################################################################

Structure Map_Block_Do      ; Physik-Queue
  Time.l                    ; Zeitpunkt, an dem der Block berechnet wird
  X.u
  Y.u
  Z.u
EndStructure

Structure Map_Block_Changed ; Liste mit geänderten Blöcken (zum Versenden übers Netwerk)
  X.u
  Y.u
  Z.u
  Priority.a
  Old_Material.w            ; Material vor der Änderung
EndStructure

Structure Undo_Step
  Player_Number.w
  Map_ID.l
  X.w
  Y.w
  Z.w
  Time.l
  Type_Before.b           ; Material vor Änderung
  Player_Number_Before.w  ; Spielernummer vor Änderung
EndStructure

Structure Map_Rank_Element
  X_0.u                     ; Punkt 0
  Y_0.u                     ; Punkt 0
  Z_0.u                     ; Punkt 0
  X_1.u                     ; Punkt 1
  Y_1.u                     ; Punkt 1
  Z_1.u                     ; Punkt 1
  Rank.w                    ; Rang des Bereichs
EndStructure

Structure Map_Teleporter_Element
  ID.s                      ; ID des Teleporters
  X_0.w
  Y_0.w
  Z_0.w
  X_1.w
  Y_1.w
  Z_1.w
  Dest_Map_Unique_ID.s
  Dest_Map_ID.l
  Dest_X.f
  Dest_Y.f
  Dest_Z.f
  Dest_Rot.f
  Dest_Look.f
EndStructure

Structure Map_Data
  ID.l                      ; ID der Karte (Identifikation Intern) (-1 Gibt es nicht)
  Unique_ID.s               ; Einmalige ID der Karte
  Name.s                    ; Name der Karte
  Save_Intervall.l          ; Speicherintervall in Minuten
  Save_Time.l               ; Zeitpunkt bei dem zuletzt gespeichert wurde (Millisekunden)
  Directory.s               ; Verzeichnis der Karte
  Overview_Type.l           ; Übersichtstyp: 0=Keiner, 1=2D, 2=Iso-Schnell
  Size_X.u                  ; Größe der Karte in X
  Size_Y.u                  ; Größe der Karte in Y
  Size_Z.u                  ; Größe der Karte in Z
  Block_Counter.l [256]     ; Blockzähler auf der Karte
  Spawn_X.f                 ; Spawnpoint
  Spawn_Y.f                 ; Spawnpoint
  Spawn_Z.f                 ; Spawnpoint
  Spawn_Rot.f               ; Spawnpoint
  Spawn_Look.f              ; Spawnpoint
  *Data                     ; Speicher mit Kartendaten
  *Physic_Data              ; Ob ein Block bereits in der Physicsqueue ist (Boolsche Variable 1Byte --> 8Blöcke)
  *Blockchange_Data         ; Ob ein Block bereits in der Blockchangequeue ist (Boolsche Variable 1Byte --> 8Blöcke)
  List Map_Block_Do.Map_Block_Do(); Physik-Queue
  List Map_Block_Changed.Map_Block_Changed(); Blockchange-Queue
  List Undo_Step.Undo_Step(); Undo-Steps
  List Rank.Map_Rank_Element(); Liste aller Rang-Box-Elemente (neusten und vordersten Elemente am Anfang der Liste)
  List Teleporter.Map_Teleporter_Element(); List aller Teleporter
  Physic_Stopped.a          ; Wenn 1, dann wurde die Physik auf der Karte deaktiviert
  Blockchange_Stopped.a     ; Wenn 1, dann wurde das Senden von Blockchanges deaktiviert (Für das Senden der Karte)
  Rank_Build.w              ; Benötigter Rang um zu bauen
  Rank_Join.w               ; Benötigter Rang um Karte zu betreten
  Rank_Show.w               ; Benötigter Rang um die Karte zu sehen (Betreten ist möglich)
  MOTD_Override.s           ; Wenn ungleich "", dann wird beim Betreten der Karte diese MOTD angezeigt
EndStructure

; ################################################################################################################

Structure Build_Variable
  X.w
  Y.w
  Z.w
  Long.l
  Float.f
  String.s
EndStructure

Structure Entity
  ID.l                        ; ID des Entities
  Prefix.s                    ; Vor dem Namen (z.B. Farbcode)
  Name.s                      ; Angezeigter Name
  Suffix.s                    ; Nach dem Namen
  ID_Client.a                 ; ID für den Client (0 - 254)
  *Player_List.Player_List    ; Spielerelement aus der "Player_List"
  Resend.a                    ; Sendet das Entity neu
  ; ---------------------------
  Map_ID.l                    ; Aktuelle Karte des Entities (-1 Existiert nicht)
  X.f                         ; Aktuelle X-Position des Entities in Blöcken
  Y.f                         ; Aktuelle Y-Position des Entities in Blöcken
  Z.f                         ; Aktuelle Z-Position des Entities in Blöcken
  Rotation.f                  ; Rotation in Grad
  Look.f                      ; Vertikale Rotation in Grad
  Send_Pos.a                  ; Position senden (Priorität | 0=Aus)
  Send_Pos_Own.a              ; Position an die "Mutterclienten" senden.
  ; ---------------------------
  Time_Message_Death.l        ; Zeit, ab welcher eine Nachricht ausgegeben wird (Verhindern von Chatspam)
  Time_Message_Other.l        ; Zeit, ab welcher eine Nachricht ausgegeben wird (Verhindern von Chatspam)
  Last_Private_Message.s      ; Zu wem die letzte private Nachricht gesendet wurde
  ; ---------------------------
  Last_Material.a             ; Letzter gebauter Blocktyp
  Build_Material.w            ; Blocktyp, mit welchem gebaut wird. -1 = Normal bauen
  Build_Mode.s                ; Modus, bei dem die Aktion durch Bauen beschrieben wird. (0: Normal >0: Box, Sphere...)
  Build_State.a               ; Status beim Bauen... (Welcher Punkt...)
  Build_Variable.Build_Variable [#Client_Player_Buildmode_Variables] ; Variablen für den Buildmode (Rang einer RBox...)
EndStructure

; ################################################################################################################

Structure Entity_Short
  ID.l
  ID_Client.a
EndStructure

Structure Player
  Login_Name.s                ; Name des Spielers beim Login
  MPPass.s                    ; "Pass" für den Multiplayer (Für accountkontrolle)
  Client_Version.a            ; Version des Clients
  Map_ID.l                    ; ID der Karte, auf welcher der Spieler ist (-1: Der Klient hat keine Karte)
  ; ---------------------------
  List Entities.Entity_Short(); Entities, welche auf dem Client sichtbar sind (Es Zählt Entity\ID, nicht Entity\ID_Client)
  *Entity.Entity              ; Zeiger auf das zu steuernde Entity
  ; ---------------------------
  
  
  
  
  Last_Private_Message.s  ; Zu wem die letzte private Nachricht geschickt wurde
  Time_Deathmessage.l     ; Wann zuletzt die Todes-Nachricht ausgegeben wurde. (Soll Chatspam verhindern)
  Time_Buildmessage.l     ; Wann zuletzt eine Bau-Nachricht ausgegeben wurde.  (Soll Chatspam verhindern)
  Logout_Hide.b           ; Zeigt logout nicht an (Bei Kick, Ban...)
  
EndStructure

Structure Network_Client
  ID.i                          ; ID des Clients
  IP.s                          ; IP des Clients
  *Buffer_Input                 ; Eingansbuffer (Ringbuffer) des Clients
  *Buffer_Input_Offset          ; Offset im Eingangsbuffer
  *Buffer_Input_Available       ; Verfügbare Daten Eingangsbuffer in Byte
  *Buffer_Output                ; Sendebuffer (Ringbuffer) des Clients
  *Buffer_Output_Offset         ; Offset im Sendebuffer
  *Buffer_Output_Available      ; Verfügbare Daten Sendebuffer in Byte
  Disconnect_Time.l             ; Dieser Client wird zu diesem Zeitpunkt disconnected (0 = Deaktiviert)
  Last_Time_Event.l             ; Zeit an welcher das letzte Event dieses Clients ausgelöst wurde
  Player.Player                 ; Spieler-Struktur des Clients
  Upload_Rate.l                 ; Uploadrate in bytes/s
  Download_Rate.l               ; Downloadrate in bytes/s
  Upload_Rate_Counter.l         ; Upload in bytes (Zähler wird jede Sekunde 0 gesetzt und übernommen)
  Download_Rate_Counter.l       ; Download in bytes (Zähler wird jede Sekunde 0 gesetzt und übernommen)
  Ping.l                        ; Ping in ms
  Ping_Sent_Time.l              ; Zeitpunkt vom letzten Senden
  Ping_Time.l                   ; Zeitpunkt zum nächsten Pingen
  Logged_In.a                   ; Client ist Eingeloggt
EndStructure

; #################################################################################################################



; #################################################################################################################

Structure Block
  Name.s                  ; Name des Blocks
  On_Client.a             ; Block-Nr auf Client
  Physic.a                ; Physikalisches verhalten
  Physic_Plugin.s         ; Welches Plugin beim Physik-Ereignis aufgerufen wird
  Do_Time.l               ; Zeit, nach welcher der Block beim aktivieren berechnet wird
  Do_Time_Random.l        ; Sorgt für Zufall
  Do_Repeat.b             ; Do wird ständig widerholt
  Do_By_Load.b            ; Beim Laden der Karte in Physic-Warteschlange eintragen
  Create_Plugin.s         ; Plugin beim erstellen
  Delete_Plugin.s         ; Plugin beim löschen
  Replace_By_Load.w       ; Block gets replaced with this, on maploading
  Rank_Place.w            ; Erforderlicher Rang um den Block zu erstellen
  Rank_Delete.w           ; Erforderlicher Rang um den Block zu löschen
  After_Delete.a          ; Typ des Blocks nach dem Löschen
  Killer.a                ; Dieser Block tötet
  Special.a               ; Dieser Block ist besonders (Kann nicht normal gebaut werden, wird mit /materials angezeigt)
  Color_Overview.l        ; Farbe für Übersichtskarte
EndStructure

; #################################################################################################################

Structure Rank
  Rank.w              ; Nummer des Rangs
  Name.s              ; Name des Rangs
  Prefix.s            ; Prefix
  Suffix.s            ; Suffix
  On_Client.b         ; Byte, welches zum Clienten gesendet wird
EndStructure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 107
; FirstLine = 66
; EnableXP
; DisableDebugger