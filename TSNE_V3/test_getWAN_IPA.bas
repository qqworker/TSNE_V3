'##############################################################################################################
'Get WAN IPA Client f�r TSNE_V3
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Dim G_Client as UInteger							'Eine Variable f�r den Client-Handel erstellen
Dim Shared G_DataRX as String						'Variable welche die HTML-Daten aufnimmt



'##############################################################################################################
'	Deklarationen f�r die Empf�nger Sub Routinen erstellen
'	Nur dann n�tig, wenn die Sub's unterhalb des aufrufs stehen.
Declare Sub	TSNE_Disconnected	(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected		(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData		(ByVal V_TSNEID as UInteger, ByRef V_Data as String)



'##############################################################################################################
Dim BV as Integer									'Variable f�r Statusr�ckgabe erstellen

Print "IPA erfragen..."

'Client erstellen, und das DATA und Connected Callback angeben. Disconnect ist nicht n�tig,
'da der HTTP Request ein Connection: Close verlangt
BV = TSNE_Create_Client(G_Client, "checkip.dyndns.org", 80, 0, @TSNE_Connected, @TSNE_NewData, 60)
'	Statusr�ckgabe auswerten
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If

'Solange warten, bis die Verbindung beendet wurde
TSNE_WaitClose(G_Client)

'Empfangene Daten (IP-Adresse) auslesen
Dim XPos as UInteger = InStr(1, G_DataRX, "IP Address:")
If XPos = 0 Then
	Print "[FEHLER] Konnte IP-Adresse nicht ermitteln!"
	End -1
End If
G_DataRX = Trim(Mid(G_DataRX, XPos + 11))
XPos = InStr(1, G_DataRX, "<")
If XPos = 0 Then
	Print "[FEHLER] Konnte IP-Adresse nicht ermitteln!"
	End -1
End If
Dim XIPA as String = Trim(Left(G_DataRX, XPos - 1))
Print "Neue IP-Adresse: "; XIPA
End													'Anschliessend beenden wir unser Programm



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)		'Empf�nger f�r das Connect Signal (Verbindung besteht)
'Anfrage vorbereiten
Dim D as String
D = "GET / HTTP/1.0" & Chr(13, 10)
D += "Host: checkip.dyndns.org" & Chr(13, 10)
D += "User-Agent: TSNE_V3_DyndnsUpDateClient" & Chr(13, 10)
D += "connection: close" & Chr(13, 10)
D += Chr(13, 10)
'Anfrage and en Server senden
Dim BV as Integer = TSNE_Data_Send(V_TSNEID, D)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	TSNE_Disconnect(V_TSNEID)
End If
End Sub



'##############################################################################################################
Sub TSNE_NewData (ByVal V_TSNEID as UInteger, ByRef V_Data as String)	'Empf�nger f�r neue Daten
'Neue Daten an die bereits vorhandenen anh�ngen
G_DataRX += V_Data
End Sub


