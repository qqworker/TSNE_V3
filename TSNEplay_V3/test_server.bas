screen 18
print "SERVER - beenden mit ESC"
' ***** Netzwerkverbindung *****

#include once "tsneplay_v3.bi"
dim shared netzwerk as TSNEPlay_GURUCode

sub TSNEPlay_ConnectionState(byval von as uinteger, byval state as TSNEPlay_State_Enum)
  ' Rückmeldung für einen Spieler über seinen Status
end sub

sub TSNEPlay_Player_Connected(byval id as uinteger, IPA as string, nick as string)
  ' Spieler wurde verbunden; z. B. könnte man da die Anzahl der verbundenen Spieler zählen
end sub

sub TSNEPlay_Player_Disconnected(byval id as uinteger)
  ' Spieler wurde getrennt - Programmunterbrechung?
end sub

sub TSNEPlay_Message(byval von as uinteger, byval zu as uinteger, byval nachricht as string, _
                     byval typ as TSNEPlay_MessageType_Enum)
  ' Ein Spieler hat uns / allen eine Nachricht geschickt
  print "Nachricht von " & von & ": " & nachricht
end sub

sub TSNEPlay_Move(byval von as uinteger, byval zu as uinteger, byval typ as double, _
                  byval x as double, byval y as double, byval r as uinteger)
  ' Spielzug
end sub

sub TSNEPlay_Data(von as uinteger, zu as uinteger, daten as string)
 ' Meldung vom Programmierer
end sub

' Aufbau der Verbindung
netzwerk = TSNEPlay_CreateServer(10, 1234, "Server", "geheimesPasswort", @TSNEPlay_ConnectionState, _
           @TSNEPlay_Player_Connected, @TSNEPlay_Player_Disconnected, @TSNEPlay_Message, @TSNEPlay_Move, _
           @TSNEPlay_Data)
if netzwerk <> TSNEPlay_NoError then print "[ERROR] "; TSNEPlay_Desc_GetGuruCode(netzwerk): end -1
dim as TSNEPlay_State_Enum TState, TStateL
dim tot as double = timer() + 10
do until inkey = chr(27)
  'Den Aktuellen Verbindungsstatus abfragen
  TState = TSNEPlay_Connection_GetState
  if TStateL <> TState then
    TStateL = TState
    select case TState
      case TSNEPlay_State_Disconnected, TSNEPlay_State_Ready: exit do
    end select
  end if
  sleep 1
  if tot < timer() then exit do
loop
'Und nochmal prüfen (falls es ein timeout gab)
TState = TSNEPlay_Connection_GetState
if TState <> TSNEPlay_State_Ready then
  print "Verbindung zum Server fehlgeschlagen!"
  end -1
end if



' Das "Programm"
do
  sleep 1
loop until inkey = chr(27)