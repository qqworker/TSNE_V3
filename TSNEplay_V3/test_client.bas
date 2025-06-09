screen 18
print "CLIENT - Meldung eingeben; anschliessend beenden mit ESC"
' ***** Netzwerkverbindung *****

#include once "tsneplay_v3.bi"
dim shared netzwerk as TSNEPlay_GURUCode

sub TSNEPlay_ConnectionState(byval von as uinteger, byval state as TSNEPlay_State_Enum)
  ' Rückmeldung für einen Spieler über seinen Status
end sub

sub TSNEPlay_Player_Connected(byval id as uinteger, IPA as string, nick as string)
  ' Spieler wurde verbunden
  print id & " hat die Verbindung hergestellt"
end sub

sub TSNEPlay_Player_Disconnected(byval id as uinteger)
  ' Spieler wurde getrennt
  print id & " hat die Verbindung abgebrochen"
end sub

sub TSNEPlay_Message(byval von as uinteger, byval zu as uinteger, byval nachricht as string, _
                     byval typ as TSNEPlay_MessageType_Enum)
  'Ein Spieler hat uns / allen eine Nachricht geschickt
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
randomize timer
dim as integer zufallsnummer = rnd*99999
netzwerk = TSNEPlay_ConnectToServer("localhost", 1234, "Client" & zufallsnummer, "geheimesPasswort", _
           @TSNEPlay_ConnectionState, @TSNEPlay_Player_Connected, @TSNEPlay_Player_Disconnected, _
           @TSNEPlay_Message, @TSNEPlay_Move, @TSNEPlay_Data)

' Daten an den Server schicken
dim as string eingabe
do
  sleep 1
  eingabe = inkey
  if eingabe <> "" then TSNEPlay_SendMSG(0, "Tastendruck " & eingabe)
loop until eingabe = chr(27)