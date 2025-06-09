'##############################################################################################################
'TEST-CLIENT für TSNE_V3
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Dim G_Client as UInteger							'Eine Variable für den Client-Handel erstellen



'##############################################################################################################
'	Deklarationen für die Empfänger Sub Routinen erstellen
'	Nur dann nötig, wenn die Sub's unterhalb des aufrufs stehen.
Declare Sub	TSNE_Disconnected	(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected		(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData		(ByVal V_TSNEID as UInteger, ByRef V_Data as String)



'##############################################################################################################
Print "[INIT] Client..."							'Programm beginnen
Dim BV as Integer									'Variable für Statusrückgabe erstellen

'Client Verbindung etablieren, Pointer der Empfänger Sub Routinen mit übergeben.
'Hier bauen wir eine verbindugn zu "www.google.de" auf dem Port 80 auf.
'Die Create_Client Function wandelt selbstständig den Hostname (www.google.de) zu einer
'IP-Adresse um. Alternativ könnten wir auch die IP-Adresse von Google anstelle des Host's
'eintragen. Dies würde den Verbindungsaufbau nur minimal beschleunigen.
'Alternativ (optional) können wir am ende noch ein TimeOut angeben (Sekunden), nachdem
'der Funktionsaufruf zurückgegeben werden soll, falls die Verbindugn nicht zustande kommen sollte.
'Zu Beachten sei hier, das ein Wert von 60sek. noch im Normalem Bereich ist!!! und
'dieser nicht unterschritten werden sollte. Natürlich können auch kleinere Zeiten
'gewählt werden, jedoch sollte man diese mit bedacht ansetzen. Z.B. im Lan, wo typsiche
'Reaktionszeiten von 60sek. nicht der fall sind .)
Print "[Connecting]"
BV = TSNE_Create_Client(G_Client, "www.google.de", 80, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData, 60)

'	Statusrückgabe auswerten
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If

Print "[OK]"										'Verbindung wurde erfolgreich hergestellt.

'In unserem Fall senden wir im Connect Event automatisch einee HTTP-Anfrage welche eine
'Option enthält, die den Google-Server veranlast, nach dem senden der Antwort die Verbindugn
'mit uns automatisch zu beenden. Daher brauchen wir hier nicht manuell die Verbindung trennen
'und können so bequem auf das ende warten, bevor wir unser Programm beenden.
Print "[WAIT] ..."									'Warte auf das ende der Verbindung (Disconnect)
TSNE_WaitClose(G_Client)
Print "[WAIT] OK"

Print "[END]"
End													'Anschliessend beenden wir unser Programm



'##############################################################################################################
Sub TSNE_Disconnected(ByVal V_TSNEID as UInteger)	'Empfänger für das Disconnect Signal (Verbindung beendet)
'Wir geben nur kurz aus, das die Verbindung beendet wurde.
'Weitere aktionen sind nicht nötig. Wir haben ja nicht wirklich irgend was vorbereitet
'das wir jetzt wieder rückgängig machen müssten.
Print "[DIS]";
End Sub



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)		'Empfänger für das Connect Signal (Verbindung besteht)
Print "[CON]";										'Nachdem die Verbindung vollständig aufgebaut wurde, geben wir dies aus, und bereiten das senden der Anfrage vor.

'Daten zum senden vorbereiten (HTTP Protokoll Anfrage)
Dim CRLF as String = Chr(13, 10)
Dim D as String
D += "GET / HTTP/1.1" & CRLF
D += "Host: www.google.de" & CRLF
D += "connection: close" & CRLF
D += CRLF

'Daten an die Verbindung senden
Print "[SEND] ..."
Print ">" & D & "<"
Dim BV as Integer = TSNE_Data_Send(V_TSNEID, D)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
Else: Print "[SEND] OK"
End If
End Sub



'##############################################################################################################
Sub TSNE_NewData (ByVal V_TSNEID as UInteger, ByRef V_Data as String)	'Empfänger für neue Daten
'Nach dem senden sollte wir kurze zeit später die Antwort erhalten.
'Sie befindet sich in V_Data, wodurch wir sie bequem ausgeben können.
'Wenn alle Daten eingetroffen sind. beendet Google die Verbindugn mit uns. so wie wir es in der
'Anfrage verlangt haben. Anschliessend erhalten wir unser Disconnect Signal, gefolgt vom
'automatischen Verlassen der TSNE_WaitCLose Routine.
Print "[NDA]: >" & V_Data & "<"
End Sub


