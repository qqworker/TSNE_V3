'##############################################################################################################
'TEST-CLIENT mit cookie's für TSNE_V3
'##############################################################################################################


'Das beispiel ist grundlegend identisch mit dem "test_client.bas" beispiel. Daher erspare ich gröstenteils
'die beschreibugnen und konzentriere mich hier nur auf die cookie implementierung.


'Als server nutzen wir google, da dieser cookies versendet, empfängt udn verarbeiten kann.

'Cookies werden hier beschrieben: http://de.wikipedia.org/wiki/HTTP-Cookie
'sowie in den RFC's: http://tools.ietf.org/html/rfc2109
'##############################################################################################################
#include once "TSNE_V3.bi"



'##############################################################################################################
'Ein Typ definieren, das einem Cookie entspricht.
Type Cookie_Type
	V_Next			as Cookie_Type Ptr		'Nötig um eine Linked List zu erzeugen
	V_Prev			as Cookie_Type Ptr		'Nötig um eine Linked List zu erzeugen
	
	'es folgend die Cookie-Parameter (Optionl = Muss nicht zwingend gegeben sein)
	V_Name			as String				'der Name dieses Cookie's
	V_Version		as UInteger				'Cookie-Version
	V_Expires		as String				'(optional) Ablaufzeitpunkt als Datum dieses Cookies (wird bei erreichen gelöscht)
	V_MaxAge		as UInteger				'(optional) Ablaufzeitpunkt in Sekunden (-||-)
	V_Domain		as String				'(optional) Die Domain (z.B. Google.de)
	V_Path			as String				'(optional) Der Request-Path (z.B. /index.html)
	V_Port			as UShort				'(optional) Der Server-Port (z.B. 80)
	V_Comment		as String				'(optional) Ein Kommentar zu diesem Cookie
	V_CommentURL	as String				'(optional) Eine URL als Kommentar zu diesem Cookie
	V_Secure		as UByte				'(optional) 1 = dies ist ein sicheres Cookie. Wird meist nur bei HTTPS-Verbindungen gesendet
	V_Discard		as UByte				'(optional) 1 = Soblad das Programm beendet wird, MUSS dieses Cookie gelöscht werden!
End Type
'--------------------------------------------------------------------------------------------------------------
Dim Shared G_CookieF	as Cookie_Type Ptr
Dim Shared G_CookieL	as Cookie_Type Ptr



'##############################################################################################################
'Sucht nach einen Bereits vorhandenem Cookie, und gibt diesen als Klartext zurück
Function Cookie_Get(ByVal V_Domain as String, ByVal V_Path as String, ByVal V_Port as UShort = 80) as String
'Prüfen ob alle daten vorhanden sind.
If V_Domain = "" Then Return ""
If V_Path = "" Then Return ""
If V_Port = 0 Then Return ""

'Passendes Cookie suchen
Dim TPtr as Cookie_Type Ptr = G_CookieF
Do Until TPtr = 0
	'Domain prüfen
	If TPtr->V_Domain = Right(V_Domain, Len(TPtr->V_Domain)) Then
		'Port prüfen
		If TPtr->V_Port = V_Port Then
			'Path prüfen
			If (TPtr->V_Path = "") or (TPtr->V_Path = Left(V_Path, Len(TPtr->V_Path))) Then
				Return TPtr->V_Name
			End If
		End If
	End If
	TPtr = TPtr->V_Next
Loop
'Ansonsten nichts zurückgeben
Return ""
End Function

'Cookie: NID=24=Iv5X8T1V1tIeYyiUo9WTI4vRqG23-3l77pTWffp8FIvDOCNBGSo3Yt2YO-7PdclrWMgVvNZhFn7Pnxn9OY-qKcFQwjQLwYoCU2LWJPuhFgxXpca-9i8MGbM7LYeovrX4; SID=DQAAAFsAAAAIH_Dz9zSH3qWpMubXYtDZsBv8ki0O_q8fHwwz94bYWUe0fjT2RbqRZNPAWlsuJEWK_ZE6lfWVpidJwq


'##############################################################################################################
'Diese Funktion fügt ein Cookie (sofern es noch nicht vorhanden ist, zur LinkedList hinzu und gibt den Pointer zurück
Function Cookie_Add(V_DataD() as String, V_ParamD() as String, V_DataC as UInteger) as Cookie_Type Ptr
Dim TCookie as Cookie_Type
'Parameter untersuchen
With TCookie
	For X as UInteger = 1 to V_DataC
		Select Case LCase(V_DataD(X))
			Case "version":		.V_Version		= ValUInt(V_ParamD(X))
			Case "expires":		.V_Expires		= V_ParamD(X)
			Case "max-age":		.V_MaxAge		= ValUInt(V_ParamD(X))
			Case "domain":		.V_Domain		= V_ParamD(X)
			Case "path":		.V_Path			= V_ParamD(X)
			Case "port":		.V_Port			= CUShort(ValUInt(V_ParamD(X)))
			Case "comment":		.V_Comment		= V_ParamD(X)
			Case "commenturl":	.V_CommentURL	= V_ParamD(X)
			Case "secure":		.V_Secure		= CUByte(ValUInt(V_ParamD(X)))
			Case "discard":		.V_Discard		= CUByte(ValUInt(V_ParamD(X)))
			Case else
				'Alle anderen Cezeichnugnen entsprechen dem NAME. da die Bezeichnugn des Namen unbekannt ist, wird er auch hinzugefügt
				.V_Name = V_DataD(X) & "=" & V_ParamD(X)
		End Select
	Next
	If .V_Port = 0 Then .V_Port = 80
	'Regulär müsste auch die Version vorhanden sein. Da google jedoch diesen parameter nicht sendet, prüfen wir, ob ein Wert vorhanden ist. Wenn nicht, dann setzen wir ihn
	If .V_Version = 0 Then .V_Version = 1
	
	'Prüfen, ob alle nötigen angaben vorhanden sind
	If .V_Name = "" Then Return 0
	If .V_Version = 0 Then Return 0
	'Prüfen ob Cookie bereits vorhanden ist. Wenn ja, dann Pointer zurück geben.
	Dim TName as String = LCase(.V_Name)
	Dim TPtr as Cookie_Type Ptr = G_CookieF
	Do Until TPtr = 0
		If TPtr->V_Name = TName Then Return TPtr
		TPtr = TPtr->V_Next
	Loop
	'Ansonsten neuen eintrag erzeugen
	If G_CookieL <> 0 Then
		G_CookieL->V_Next = CAllocate(SizeOf(Cookie_Type))
		G_CookieL->V_Next->V_Prev = G_CookieL
		G_CookieL = G_CookieL->V_Next
	Else
		G_CookieL = CAllocate(SizeOf(Cookie_Type))
		G_CookieF = G_CookieL
	End If
	*G_CookieL = TCookie
End With
Return G_CookieL
End Function



'##############################################################################################################
Dim G_Client as UInteger
Dim Shared G_Data as String
Dim Shared G_Head as String



'##############################################################################################################
Declare Sub	TSNE_Disconnected	(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected		(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData		(ByVal V_TSNEID as UInteger, ByRef V_Data as String)



'##############################################################################################################
Print "[INIT] Client..."
Dim BV as Integer

'Wir senden die folgende Anfrage 2x hintereinander. Einmal um ein cookie zu empfangen, udn ein zweites mal um das cookie mit zu senden.
G_Client = 0
G_Data = ""
G_Head = ""
Print "[Connecting]"
BV = TSNE_Create_Client(G_Client, "www.google.de", 80, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData, 60)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)
	End -1
Else: Print "[OK]"
End If
Print "[WAIT] ..."
TSNE_WaitClose(G_Client)
Print "[WAIT] OK"


'Beim erneutem senden kann man in der Konsole sehen, das in der antwort von Google KEIN neues cookie gesetzt wird.
'Das zeigt an, das unser cookie akzeptiert wurde.
G_Client = 0
G_Data = ""
G_Head = ""
Print "[Connecting]"
BV = TSNE_Create_Client(G_Client, "www.google.de", 80, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData, 60)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)
	End -1
Else: Print "[OK]"
End If
Print "[WAIT] ..."
TSNE_WaitClose(G_Client)
Print "[WAIT] OK"


Print "[END]"
End



'##############################################################################################################
Sub TSNE_Disconnected(ByVal V_TSNEID as UInteger)
Print "[DIS]"
End Sub



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)
Print "[CON]"
Dim CRLF as String = Chr(13, 10)
Dim D as String
'Nach einem vorhandenem Cookie suchen
Dim TCookie as String = Cookie_Get("www.google.de", "/")
D += "GET / HTTP/1.0" & CRLF
D += "Host: www.google.de" & CRLF
'Wenn ein Cookie gefunden wurde, dann wird es in die Anfrage eingebaut
If TCookie <> "" Then D += "Cookie: " & TCookie & CRLF
D += "connection: close" & CRLF
D += CRLF

Print "[SEND] ..."
Print ">" & D & "<"
Dim BV as Integer = TSNE_Data_Send(V_TSNEID, D)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)
Else: Print "[SEND] OK"
End If
End Sub



'##############################################################################################################
Sub TSNE_NewData (ByVal V_TSNEID as UInteger, ByRef V_Data as String)
'Print "[NDA]: >" & V_Data & "<"
'Prüfen, ob Header noch nicht gefunden wurde
If G_Head = "" Then
	'Dann neue daten anhängen
	G_Data += V_Data
	'udn nach dem ende des headers suchen
	Dim XPos as UInteger = InStr(1, G_Data, Chr(13, 10, 13, 10))
	'gefunden?
	If XPos > 0 then
		'Dann header abschneiden udn speichern
		G_Head = Left(G_Data, XPos - 1)
		Dim T as String
		'Header nach Cookie durchsuchen
		Do
			'Zeilenende suchen
			XPos = InStr(1, G_Head, Chr(13, 10))
			'Kein zeilenende gefnuden? dann suche verlassen (fertig)
			If XPos = 0 Then Exit Do
			'ansonsten, zeile zwischenkopieren
			T = Left(G_Head, XPos - 1)
			'und vom rest abschneiden
			G_Head = Mid(G_Head, XPos + 2)
			'In Zeile nach ":" suchen. (Parameterende)
			XPos = InStr(1, T, ":")
			'Gefunden?
			If XPos > 0 Then
				'Ist die zeile ein zu setzendes cookie?
				If LCase(Left(T, XPos - 1)) = "set-cookie" Then
					Print "COOKIE >"; Trim(Mid(T, XPos + 1)); "<"
					'Cookieparameter abschneiden udn leerzeichen abtrennen
					T = Trim(Mid(T, XPos + 1))
					'Variablen zum zerschneiden der Cookieparameter
					Dim BC as UByte
					Dim DD() as String
					Dim DV() as String
					Dim DC as UInteger
					Dim X as UInteger
					Dim Y as UInteger = 1
					'Cookieparameter zeichen für zeichen abarbeiten um ";" zu suchen
					For X = 1 to Len(T)
						Select Case T[X - 1]
							Case 34 '"
								'Wenn Zeichen ein " ist, dann dürfen folgt ein text. Hier darf kein gefudnenes ";" zum trennen verwendet werden
								'Wurde erneut ein " gefunden, dann ist der string zu ende
								If BC = 0 Then BC = 1 else BC = 0
								
							Case 59 ';
								'es wurde ein ; gefunden
								'Ist das Zeichen nicht in einem Text eingeschlossen?
								If BC = 0 Then
									'Dann parameter abtrennen und speichern
									DC += 1
									Redim Preserve DD(DC) as String
									Redim Preserve DV(DC) as String
									DD(DC) = Trim(Mid(T, Y, X - Y))
									'Nach einen Parameter trenner suchen
									XPos = InStr(1, DD(DC), "=")
									'Gefunden?
									If XPos > 0 then
										'Dann parameter abschneiden und seperat speichern
										DV(DC) = Mid(DD(DC), XPos + 1)
										DD(DC) = Left(DD(DC), XPos - 1)
									Else 'Eigentlich ist es ein fehler, wenn kein parameter vorhanden ist. Wir sidn jedoch kulant und akzeptieren es auch so
									End If
									Y = X + 1
								End If
						End Select
					Next
					'Ist noch ein Parameter übrig, das noch nicht hinzugefügt wurde?
					If X <> Y Then
						'Dann hinzufügen
						DC += 1
						Redim Preserve DD(DC) as String
						Redim Preserve DV(DC) as String
						DD(DC) = Trim(Mid(T, Y))
						XPos = InStr(1, DD(DC), "=")
						If XPos > 0 then
							DV(DC) = Mid(DD(DC), XPos + 1)
							DD(DC) = Left(DD(DC), XPos - 1)
						End If
					End If
					'Cookieparameter ausgeben
					Print
					For X = 1 to DC
						Print X; " >"; DD(X); "<___>"; DV(X); "<"
					Next
					Print
					
					'Cookie hinzufügen
					Cookie_Add(DD(), DV(), DC)
					
					'und schleife verlassen
					Exit Do
				End If
			End If
		Loop
	End If
End If
End Sub


