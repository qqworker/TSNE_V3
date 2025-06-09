'##############################################################################################################
'TEST-CLIENT für TSNE_V3 [UDP]
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Dim G_ClientRX as UInteger							'Eine Variable für den Client-Handel erstellen
Dim G_ClientTX as UInteger							'Eine Variable für den Client-Handel erstellen



'##############################################################################################################
'	Deklarationen für die Empfänger Sub Routinen erstellen
'	Nur dann nötig, wenn die Sub's unterhalb des aufrufs stehen.
Declare Sub	TSNE_NewDataUDP		(ByVal V_TSNEID as UInteger, ByVal V_IPA as String, ByRef V_Data as String)



'##############################################################################################################
Print "[INIT] Client..."							'Programm beginnen
Dim BV as Integer									'Variable für Statusrückgabe erstellen


Print "[Create UDP]"
BV = TSNE_Create_UDP_TX(G_ClientTX)					'UDP-Socket zum senden erstellen
'	Statusrückgabe auswerten
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If


BV = TSNE_Create_UDP_RX(G_ClientRX, 1234, @TSNE_NewDataUDP)		'UDP-Socket für den Empfang erstellen
'	Statusrückgabe auswerten
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If


Print "[OK]"										'Verbindung wurde erfolgreich hergestellt.


Do until inkey() = Chr(27)
	Print "Send"
	
	'Um Daten zu senden muss [NUR im UDP Modus] eine IP Adresse und ein Port angegeben werden.
	'Wird als IP-Adresse "0" angegeben wird die nachricht als Broadcast an alle im Subnetz vorhandenen
	'Clienten gesendet.
	BV = TSNE_Data_Send(G_ClientTX, Str(Timer()), , "localhost", 1234)		'Senden an DIREKT an sich selbst
'	BV = TSNE_Data_Send(G_ClientTX, Str(Timer()), , "0", 1234)				'Sendet an ALLE im Subnetz
	If BV <> TSNE_Const_NoError Then
		Print "[FEHLER] " & TSNE_GetGURUCode(BV)	'Fehler ausgeben
		End -1										'Programmbeenden
	End If
	sleep 1000, 1									'Im Sekundenabstand senden
Loop



TSNE_Disconnect(G_ClientTX)							'UDP-Socket wieder schliessen
TSNE_Disconnect(G_ClientRX)							'UDP-Socket wieder schliessen
Print "[WAIT] ..."									'Warte auf das ende der Verbindung (Disconnect)
TSNE_WaitClose(G_ClientTX)
TSNE_WaitClose(G_ClientRX)
Print "[WAIT] OK"


Print "[END]"
End													'Anschliessend beenden wir unser Programm



'##############################################################################################################
Sub TSNE_NewDataUDP (ByVal V_TSNEID as UInteger, ByVal V_IPA as String, ByRef V_Data as String)	'Empfänger für neue Daten (UDP)
'Beim UDP-Modus wird nicht nur die empfangenen Daten, sondern auch die IP des senders übergeben.
Print "[NDA]: >" & V_IPA & "<___>" & V_Data & "<"
End Sub


