'##############################################################################################################
'TEST-SMTP-Sender f�r TSNE_V3
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Dim Shared G_Client as UInteger						'Eine Variable f�r den Client-Handel erstellen
Dim Shared G_Data as String							'Variable zum speichern der Eingehenden Daten
Dim Shared G_State as UInteger						'Variable die den aktuellen Status der �bermittlung speichert

'Variablen f�r die E-Mail Daten
Dim Shared XServer as String
Dim Shared XFrom as String
Dim Shared XTo as String
Dim Shared XBetreff as String
Dim Shared XNachricht as String




'##############################################################################################################
'	Deklarationen f�r die Empf�nger Sub Routinen erstellen
'	Nur dann n�tig, wenn die Sub's unterhalb des aufrufs stehen.
Declare Sub	TSNE_Disconnected	(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected		(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData		(ByVal V_TSNEID as UInteger, ByRef V_Data as String)



'##############################################################################################################
Print "[INIT] Client..."							'Programm beginnen
Dim BV as Integer									'Variable f�r Statusr�ckgabe erstellen


Dim D as String
For X as UByte = 1 to 5
	Do
		Print ""
		Select Case X
			Case 1
				Print "Ein E-Mail-Server ist ein Empf�nger f�r die E-Mails, bzw ein Relay, welcher E-Mails weiterleitet"
				Print "Wird kein Server angegeben, wird versucht die E-Mail direkt zu zustellen!"
				Print "Durch Schutzmechanissmen kann dies jedoch bei einigen Empf�ngern vehlschlagen!"
				Print "Wer bei der Telekom seinen DSL / Internet Zugang besitzt kann hier 'smtprelay.t-online.de' eintragen!"
				Print "Dies ist der von der Telekom f�r Telekomkunden bereitgestellte SMTP-Mail Relay-Server"
				Line Input "E-Mail-Server:", D
			Case 2
				Print "Hier muss eine Absender-Adresse eingegeben werden. Sinvollist hier eine REALE E-Mail adresse,"
				Print "damit der Empf�nger auf diese E-Mail Antworten kann."
				Line Input "E-Mail Adresse des Absender:", D
				If InStr(1, D, "@") <= 0 Then Print "E-Mail Adresse ung�ltig!": D = ""
			Case 3
				Line Input "E-Mail Adresse des Empf�nger:", D
				If InStr(1, D, "@") <= 0 Then Print "E-Mail Adresse ung�ltig!": D = ""
			Case 4
				Line Input "Betreff:", D
			Case 5
				Line Input "Nachricht:", D
		End Select
	Loop Until (D <> "") or ((X = 1) and (D = ""))
	Select Case X
		Case 1: XServer = D
		Case 2: XFrom = D
		Case 3: XTo = D
		Case 4: XBetreff = D
		Case 5: XNachricht = D
	End Select
Next

If XServer = "" Then
	Print "Kein Server angegeben! Versuche E-Mail direkt zu senden!"
	Dim XPos as UInteger = InStr(1, XTo, "@")
	If XPos > 0 Then XServer = Mid(XTo, XPos + 1)
End If


Print "[Verbindungsaufbau zum Server]"				'Verbindungsaufbau
BV = TSNE_Create_Client(G_Client, XServer, 25, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData, 60)

'	Statusr�ckgabe auswerten
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If

Print "[Verbindung hergestellt]"
TSNE_WaitClose(G_Client)							'Wir warten solange bis die Verbindung beendet wurde
Print "[Fertig]"
End													'Anschliessend beenden wir unser Programm



'##############################################################################################################
Sub TSNE_Disconnected(ByVal V_TSNEID as UInteger)
Print "[Verbindung Beendet]"
End Sub



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)
Print "[Verbindung besteht]"						'Verbindung wurde erfolgreich hergestellt.
End Sub



'##############################################################################################################
Sub TSNE_NewData (ByVal V_TSNEID as UInteger, ByRef V_Data as String)
G_Data += V_Data
Dim XPos as UInteger
Dim T as String
Do
	XPos = InStr(1, G_Data, Chr(13, 10))
	If XPos = 0 Then Exit Do
	T = Mid(G_Data, 1, XPos - 1)
	G_Data = Mid(G_Data, XPos + 2)
	Select Case ValUInt(Left(T, 3))
		Case 220
			TSNE_Data_Send(V_TSNEID, "HELO Direkt_Mailer" & Chr(13, 10))
			
		Case 221
			TSNE_Disconnect(V_TSNEID)
			Print "E-Mail Erfolgreich versand!"
			
		Case 250
			Select Case G_State
				Case 0: TSNE_Data_Send(V_TSNEID, "MAIL FROM:<" & XFrom & ">" & Chr(13, 10))
				Case 1: TSNE_Data_Send(V_TSNEID, "RCPT TO:<" & XTo & ">" & Chr(13, 10))
				Case 2: TSNE_Data_Send(V_TSNEID, "DATA" & Chr(13, 10))
				Case 3: TSNE_Data_Send(V_TSNEID, "QUIT" & Chr(13, 10))
			End Select
			G_State += 1
			
		Case 354
			TSNE_Data_Send(V_TSNEID, "From: <" & XFrom & ">" & Chr(13, 10) & "To: <" & XTo & ">" & Chr(13, 10) & "Subjekt: " & XBetreff & Chr(13, 10) & Chr(13, 10) & XNachricht & Chr(13, 10) & "." & Chr(13, 10))
			
		Case Else
			TSNE_Disconnect(V_TSNEID)
			Print "Fehler beim Senden der E-Mail!"
	End Select
Loop
End Sub


