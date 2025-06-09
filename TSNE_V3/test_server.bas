'##############################################################################################################
'TEST-SERVER für TSNE Version 3
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Dim Shared G_Server		as UInteger					'Eine Variable für den Server-Handel erstellen



'##############################################################################################################
Type Client_Type									'Ein UDT welches die einzelnen Verbindungen und deren Parameter hält
	V_InUse				as UByte					'Wird verwendet um zu überprüfen ob der Eintrag belegt ist
	V_TSNEID			as UInteger					'Speicher die TSNEID der Verbindung
	
	V_IPA				as String					'Die IP der Verbindung
	V_ConTime			as Double					'Hier speichern wir die Uhrzeit des verbindungsaufbaus ab
	V_Data				as String					'Speicher die eingehenden Daten zwischen, (Blocktransfer)
End Type
Dim Shared ClientD()	as Client_Type				'Das UDT-Array für die Clienten
Dim Shared ClientC		as UShort					'Hier reicht ein Short aus, da mehr als 65535 Verbindugnen sowieso nicht möglich sind (Portbegrenzung).
Dim Shared ClientMutex	as Any Ptr					'Wir erstellen ein MUTEX welches verhindert das mehrere verbindugen gleichzeitg auf das UDT zugreifen



'##############################################################################################################
'	Deklarationen für die Empfänger Sub Routinen erstellen
Declare Sub	TSNE_Disconnected			(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected				(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData				(ByVal V_TSNEID as UInteger, ByRef V_Data as String)
Declare Sub TSNE_NewConnection			(ByVal V_TSNEID as UInteger, ByVal V_RequestID as Socket, ByVal V_IPA as String)
Declare Sub TSNE_NewConnectionCanceled	(ByVal V_TSNEID as UInteger, ByVal V_IPA as String)



'##############################################################################################################
Print "[INIT] Setup..."								'Signalisieren das wir das Programm starten
ClientMutex = MutexCreate()							'Ein neues MUTEX erstellen
Dim RV as Long										'Eine Statusrückgabe Variable
Print "[SERVER] Init..."							'Signalisieren das wir den Server jetzt inizialisieren
RV = TSNE_Create_Server(G_Server, 1234, 10, @TSNE_NewConnection, @TSNE_NewConnectionCanceled)	'Server erstellen
If RV <> TSNE_Const_NoError Then					'Prüfen ob dabei Fehler entstanden sind
	Print "[SERVER] [FEHLER] " & TSNE_GetGURUCode(RV)	'Irgend ein Fehler trat beim erstellen des Server auf
	MutexDestroy(ClientMutex)						'MUTEX zerstören. Wird jetzt nimmer gebraucht
	Print "[END]"									'Wir sind fertig
	End	0											'Und beenden das Programm mit dem Returncode: 0
End if
Print "[SERVER] OK!"								'Wenn nicht, dann ausgaben das alle OK war
RV = TSNE_BW_SetEnable(G_Server, TSNE_BW_Mode_Black)	'Wir aktivieren eine IPA-Blockliste des Types: BlackList (Alle IPAs in der Liste werden blockiert)
If RV <> TSNE_Const_NoError Then					'Prüfen ob dabei Fehler entstanden sind
	Print "[SERVER] [FEHLER] BWL: " & TSNE_GetGURUCode(RV)	'Irgend ein Fehler trat beim erstellen des BWL auf
	MutexDestroy(ClientMutex)						'MUTEX zerstören. Wird jetzt nimmer gebraucht
	Print "[END]"									'Wir sind fertig
	End	0											'Und beenden das Programm mit dem Returncode: 0
End If
Print "[SERVER] wait for ESC push..."				'Ausgeben das wir auf ein ESC Tastendruck warten
Do													'Wir poolen den Tastenabfrage
	Sleep 1, 1										'Kurz warten um die CPU auslastung massiv zu verringern
Loop until InKey() = Chr(27)						'Prüfen ob ein ESC gedrückt wurde. Wenn ja, dann shcleife verlassen
Print "[SERVER] ESC pushed!"						'Und ausgeben was wir das ESC erkannt haben
Print "[SERVER] Disconnecting..."					'Mitteilen das wir den Server beenden
RV = TSNE_Disconnect(G_Server)						'Server-Socket beenden
If RV <> TSNE_Const_NoError Then Print "[SERVER] [FEHLER] " & TSNE_GetGURUCode(RV)	'Wenn ein Fehler entstand, dann geben wir diesen aus
Print "[SERVER] Wait disconnected..."				'Ausgeben das wir trotzdem auf den Disconnect warten
TSNE_WaitClose(G_Server)							'Wir warten auf das ende der serververbindung
Print "[SERVER] Disconnected!"						'Server wurde beendet
MutexLock(ClientMutex)								'MUTEX sperren um zugriff darauf zu verhinden
Dim TID as UInteger									'Eine Variable erstellen welche die TSNEID zwischenspeichert
For X as UInteger = 1 to ClientC					'Alle clienten im UDT durchgehen
	If ClientD(X).V_InUse = 1 Then					'Wird das Element verwendet?
		TID = ClientD(X).V_TSNEID					'Wir hohlen die TSNEID der Verbindung udn speichern sie zwischen
		MutexUnLock(ClientMutex)					'Da wir jetzt die CLientverbindung trennen wird auch das Disconnect event aufgerufen. Darum Müssen wir das MUTEX entsperren
		TSNE_Disconnect(TID)						'Verbindung trennen
		MutexLock(ClientMutex)						'MUTEX wieder sperren um nächstes element zu prüfen
	End IF
Next
MutexUnLock(ClientMutex)							'Mutex wieder entsperren
MutexDestroy(ClientMutex)							'MUTEX zerstören. Wird jetzt nimmer gebraucht
Print "[END]"										'Wir sind fertig
End	0												'Und beenden das Programm mit dem Returncode: 0



'##############################################################################################################
Sub TSNE_Disconnected(ByVal V_TSNEID as UInteger)	'Empfänger für das Disconnect Signal (Verbindung beendet)
MutexLock(ClientMutex)								'Mutex Sperren um auf das Array zugreifen zu können
For X as UInteger = 1 to ClientC					'Wir gehen alle Array-Elemente durch
	If ClientD(X).V_InUse = 1 Then					'Wird das Element verwendet?
		If ClientD(X).V_TSNEID = V_TSNEID Then		'Ist das Element das gesuchte?
			ClientD(X).V_InUse = 0					'Da dieses Element nun nicht mehr gebraucht wird können wir dieses als 'Nicht in nutzung' markieren
			ClientD(X).V_Data = ""					'Daten-variable leeren. Verbraucht nur speicher
			Print "[CLIENT] Disconnected >" & X & "<"	'und ausgeben das wir die verbindung beendet haben
			MutexUnLock(ClientMutex)				'Mutex Sperre kann jetz taufgehoben werden, da es sonst zu einem MUTEX Leak kommt wenn wir die Sub direkt verlassen
			Exit Sub								'Sub direkt verlassen
		End If
	End If
Next
MutexUnLock(ClientMutex)							'Mutex Sperren aufheben
Print "[CLIENT] [ERROR] TSNEID Not found in Client-Array"	'Wir haben kein passendes Element gefunden udn geben das aus.
End Sub



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)		'Empfänger für das Connect Signal (Verbindung besteht)
MutexLock(ClientMutex)								'Mutex Sperren um auf das Array zugreifen zu können
For X as UInteger = 1 to ClientC					'Wir gehen alle Array-Elemente durch
	If ClientD(X).V_InUse = 1 Then					'Wird das Element verwendet?
		If ClientD(X).V_TSNEID = V_TSNEID Then		'Ist das Element das gesuchte?
			ClientD(X).V_ConTime = Timer()			'Wir speichern die aktuelle Uhrzeit ab
			Print "[CLIENT] Connected >" & X & "<"	'und ausgeben das die client-verbindung vollständig hergestellt wurde
			MutexUnLock(ClientMutex)				'Mutex Sperre kann jetz taufgehoben werden, da es sonst zu einem MUTEX Leak kommt wenn wir die Sub direkt verlassen
			Exit Sub								'Sub direkt verlassen
		End If
	End If
Next
MutexUnLock(ClientMutex)							'Mutex Sperren aufheben
Print "[CLIENT] [ERROR] TSNEID Not found in Client-Array"	'Wir haben kein passendes Element gefunden und geben das aus.
End Sub



'##############################################################################################################
Sub TSNE_NewConnection(ByVal V_TSNEID as UInteger, ByVal V_RequestID as Socket, ByVal V_IPA as String)		'Empfänger für das NewConnection Signal (Neue Verbindung)
Dim TNewTSNEID as UInteger							'Eine Variable welche die Neue TSNEID beinhaltet
Dim TReturnIPA as String							'Eine Variable welche die IP-Adresse des clienten beinhaltet
Dim CIndex as UInteger								'Eine Variable erstellen welche einen freien Array index speichert
Dim RV as Long										'Die Statusrückgabe variable
MutexLock(ClientMutex)								'Mutex Sperren um auf das Array zugreifen zu können
For X as UInteger = 1 to ClientC					'Wir gehen alle Array-Elemente durch
	If ClientD(X).V_InUse = 0 Then					'Haben wir ein Freies Element gefunden?
		CIndex = X									'Dann diesen Index abspeichern
		Exit For									'Und schleife verlassen
	End If
Next
If CIndex = 0 Then									'Haben wir kein freies Feld gefunden?
	If ClientC >= 100 Then							'Haben wir noch platz für einen Client oder wurde schon unser definiertes Maximum erreich?
		Print "[CLIENT] FULL!!!   IPA:" & V_IPA		'Wir zeigen an, das usner Server voll ist. und geben die IPA aus.
		RV = TSNE_Create_Accept(V_RequestID, TNewTSNEID, TReturnIPA, 0, 0, 0)	'Da wir kein Platz mehr haben akzeptieren wir pauschal die verbindung ohne Callback-sub's anzugeben (werden sowieso nicht benötigt).
		If RV <> TSNE_Const_NoError Then			'Gab es einen Fehler beim 'Accept'?
			Print "[CLIENT] [FEHLER] " & TSNE_GetGURUCode(RV)		'Dann geben wir diesen aus
			MutexUnLock(ClientMutex)				'Entsperren das Mutex
			Exit Sub								'und verlassen auf direktem wege die sub
		End If
		RV = TSNE_Data_Send(TNewTSNEID, "Der Server hat keinen Platz mehr für dich Frei!")	'Selbstverständlich informieren wir den Clienten über diesen Zustand (Bei unterschiedlichen Protokollen muss dies angepast werden)
		If RV <> TSNE_Const_NoError Then			'Gab es einen Fehler beim 'Send'?
			Print "[CLIENT] [FEHLER] " & TSNE_GetGURUCode(RV)	'Dann geben wir diesen aus jedoch ohne die Sub zu verlassen, da die Verbindung noch bestehen könnte
		End If
		TSNE_Disconnect(TNewTSNEID)					'Zum schluss beenden wir die Verbindung, da sie sowieso nicht von uns weiter verwaltet wird.
		MutexUnLock(ClientMutex)					'Noch das MUTEX entsperren
		Exit Sub									'und die Sub auf direktem wege verlassen
	End If
	ClientC += 1									'Ist noch Platz frei erstellen wir ein neues Element
	Redim Preserve ClientD(ClientC) as Client_Type	'Und redimensionieren (mit 'Preserve' für das erhalten der anderen Element-daten) das Array
	CIndex = ClientC								'Als Freien Index geben wir das neue Element an
End If
RV = TSNE_Create_Accept(V_RequestID, TNewTSNEID, TReturnIPA, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData)	'Da wir noch platz haben akzeptieren wir die verbindung mit den Callbacks
If RV <> TSNE_Const_NoError Then					'Gab es einen Fehler beim 'Accept'?
	Print "[CLIENT] [FEHLER] " & TSNE_GetGURUCode(RV)	'Dann geben wir diesen aus
	MutexUnLock(ClientMutex)						'Entsperren das Mutex
	Exit Sub										'und verlassen auf direktem wege die sub
End If
With ClientD(CIndex)								'Kein fehler entsanden? dann das freie Element selektieren
	.V_InUse	= 1									'und markieren es als 'In Nutzung'
	.V_TSNEID	= TNewTSNEID						'TSNEID der neuen Verbindung speichern
	.V_IPA		= V_IPA								'Die IPA (IP-Adresse) der neuen Verbindung speichern
	.V_ConTime	= 0									'Wir sind noch nicht ganz verbunden (Connect-event fehltnoch) darum Zeit auf 0 setzen
	.V_Data		= ""								'Daten Variable leeren. Könnte durch eine vorherige verbindung noch gefüllt sein
End With
Print "[CLIENT] New Connect >" & CIndex & "<   IPA:" & V_IPA	'Anzeigen das Verbindung akzeptiert wurde.
MutexUnLock(ClientMutex)							'Mutex Sperren aufheben
End Sub



'##############################################################################################################
Sub TSNE_NewConnectionCanceled(ByVal V_TSNEID as UInteger, ByVal V_IPA as String)
Print "[CLIENT] Request Blocked   IPA:" & V_IPA		'Anzeigen das Verbindungsanfrage Blockiert wurde
End Sub



'##############################################################################################################
Sub TSNE_NewData(ByVal V_TSNEID as UInteger, ByRef V_Data as String)	'Empfänger für neue Daten
Dim CIndex as UInteger								'Eine Variable erstellen welche ein Array-Index speichert
Dim RV as Long										'Die Statusrückgabe variable
MutexLock(ClientMutex)								'Mutex Sperren um auf das Array zugreifen zu können
For X as UInteger = 1 to ClientC					'Wir gehen alle Array-Elemente durch
	If ClientD(X).V_InUse = 1 Then					'Wird das Element verwendet?
		If ClientD(X).V_TSNEID = V_TSNEID Then		'Ist das Element das gesuchte?
			CIndex = X								'Wir speichern das Gefundene Index ab
			Exit For								'und vrlassen die For-Schleife
		End If
	End If
Next
If CIndex = 0 Then									'wurde das Element nicht gefunden?
	MutexUnLock(ClientMutex)						'Dann Mutex entsperren
	Print "[CLIENT] [ERROR] TSNEID Not found in Client-Array"	'Wir haben kein passendes Element gefunden und geben das aus.
	Exit Sub										'anschliessend SUB verlassen
End If
Dim TData as String = ClientD(CIndex).V_Data & V_Data	'Die eingehenden Daten hängen wir an die bestehenden an udn speichern dies in eine Temporäre Variable
ClientD(CIndex).V_Data = ""							'Die Bereits vorhandenen Daten werden gelöscht. Sollten noch welche übrig bleiben, beim Parsen können wir diese wieder hinzufügen.
Print "[CLIENT] DATA >" & CIndex & "<"				'Wir haben Daten erhalten udn geben diesen Zustand aus.
MutexUnLock(ClientMutex)							'Mutex Sperren aufheben


'Hier können wir jetzt unsere Daten verarbeiten welche in TData stehen


'Als beispiel habe ich einen HTTP-Server gewählt. Darum werden wir jetzt nach eienm HTTP-Header suchen
Dim XPos as UInteger = InStr(1, TData, Chr(13, 10, 13, 10))		'Wir suchen nach dem Ende des Headers (2x zeilenumbruch)
If XPos = 0 Then									'Haben wir keinen Header gefunden?
	MutexLock(ClientMutex)							'Dann Mutex Sperren
	ClientD(CIndex).V_Data = TData & ClientD(CIndex).V_Data		'Und die restlichen Daten an den ANfang des Temporären SPeichers legen
	MutexUnLock(ClientMutex)						'Mutex Sperren aufheben
	Exit Sub										'Sub direkt verlassen
End If
Dim XHeader as String = Mid(TData, 1, XPos - 1)		'Wir haben ihn gefunden und schneiden Ihn von den Daten ab.
TData = Mid(TData, XPos + 4)						'Die Daten selbst (falls vorhanden) brauchen keinen Header. Darum schneiden wir diesen header ab.


XPos = InStr(1, XHeader, Chr(13, 10))				'Wir suchen nach dem ersten CR LF im Header.
If XPos = 0 Then									'Wenn wir keienn Finden, hat der Client ein Problem und senden die Daten falsch.
	TSNE_Data_Send(V_TSNEID, "HTTP/1.1 400 Bad-Request" & Chr(13, 10, 13, 10))		'Darum teilen wir das dem Clienten mit
	TSNE_Disconnect(V_TSNEID)						'und beenden die verbindung, da sie einen Fehler erzeugt hat.
	Exit Sub										'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End If
Dim XRequest as String = Mid(XHeader, 1, XPos - 1)	'Andernfalls schneiden wir die Anfrage vom Header ab


XPos = InStr(1, XRequest, " ")						'Wir suchen nach dem ersten Leerzeichen in der Anfrage Sie trennt die Anfrage von einigen Parametern
If XPos = 0 Then									'Finden wir das Leerzeichen nicht, dann gab es wieder einen Fehler
	TSNE_Data_Send(V_TSNEID, "HTTP/1.1 400 Bad-Request" & Chr(13, 10, 13, 10))		'Darum teilen wir das dem Clienten mit
	TSNE_Disconnect(V_TSNEID)						'und beenden die verbindung, da sie einen Fehler erzeugt hat.
	Exit Sub										'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End If
Dim XType as String = Mid(XRequest, 1, XPos - 1)	'Wir schneiden den Anfragetyp ab (GET / HEAD / PUT / POST / ...)
XRequest = Mid(XRequest, XPos + 1)					'Da noch weitere Parameter nötig sind schneiden wir die Typ vom rest ab.
Select Case UCase(XType)							'Wir untersuchen den Anfragetyp
	Case "GET"										'GET unterstützen wir.
	Case Else										'Alle anderen nicht.
		TSNE_Data_Send(V_TSNEID, "HTTP/1.1 500 Not supportet" & Chr(13, 10, 13, 10))	'Darum teilen wir das dem Clienten mit
		TSNE_Disconnect(V_TSNEID)					'und beenden die verbindung, da wir mit der anfrage nichts anfangen können
		Exit Sub									'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End Select


XPos = InStr(1, XRequest, " ")						'Und suchen nach dem nächsten leerzeichen
If XPos = 0 Then									'Finden wir das Leerzeichen nicht, dann gab es wieder einen Fehler
	TSNE_Data_Send(V_TSNEID, "HTTP/1.1 400 Bad-Request" & Chr(13, 10, 13, 10))		'Darum teilen wir das dem Clienten mit
	TSNE_Disconnect(V_TSNEID)						'und beenden die verbindung, da sie einen Fehler erzeugt hat.
	Exit Sub										'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End If
Dim XGet as String = Mid(XRequest, 1, XPos - 1)		'Wir schneiden den Get-String ab. Er enthält die eigentliche Dateianfrage des Clienten
If XGet = "" Then									'Wenn der angefragt PFad leer ist, dann macht der CLient etwas falsch
	TSNE_Data_Send(V_TSNEID, "HTTP/1.1 400 Bad-Request" & Chr(13, 10, 13, 10))		'Darum teilen wir das dem Clienten mit
	TSNE_Disconnect(V_TSNEID)						'und beenden die verbindung, da sie einen Fehler erzeugt hat.
	Exit Sub										'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End If


If Left(XGet, 1) <> "/" Then						'Ist das erste zeichen kein "/" dann ist die Anfrage (in unserem fall) fehelrhaft
	TSNE_Data_Send(V_TSNEID, "HTTP/1.1 400 Bad-Request" & Chr(13, 10, 13, 10))		'Darum teilen wir das dem Clienten mit
	TSNE_Disconnect(V_TSNEID)						'und beenden die verbindung, da sie einen Fehler erzeugt hat.
	Exit Sub										'auch hier verlassen wir die SUB direkt, weil es nichts weiter zu tun gibt.
End If


XPos = InStr(1, XGet, "?")							'Suche nach einem '?'. Es markiert das ende einer Anfrage und den Anfang von Parameter
Dim XGetData as String								'Variable welche die Parameter enthalten wird (sofern vorhanden)
If XPos > 0 Then									''?' gefunden?
	XGetData = Mid(XGet, XPos + 1)					'Dann Parameter in Variable Kopieren
	XGet = Left(XGet, XPos - 1)						'Und parameter von der Anfrage abschneiden
End If


TData = ""											'Wir leeren die zuvor verwendete Variable, da die daten nicht weiter benötigt werden. AUserdem brauchen wir sie gleich
Dim T as String										'Eine neue Variable wird erstellt welche die zu senden Informationen enthalten wird.
Print "[CLIENT] Request: " & CIndex & "  >" & XGet & "<"
Select Case LCase(XGet)								'Wir selectieren die Anfrage
	Case "/"										'es wird das hauptverzeichniss angefragt
		T += "<html>"								'Es wir deien HTML-Seite erzeugt
		T += " <head>"
		T += "  <title>Test-Server</title>"			'Mit eine Titel
		T += " </head>"
		T += " <body>"
		T += "  <p>Ich bin ein HTTP-Testserver der mit TSNE_V3 arbeitet</p>"	'Und eienm sichtbarem Text
		T += "  <p><a href=""status"">Status</a></p>"	'Und eienm sichtbarem Text
		T += " </body>"
		T += "</html>"								'Es wir deien HTML-Seite erzeugt
		
		TData += "HTTP/1.1 200 OK" & Chr(13, 10)	'Wir erzeugen eine "OK" seite. Sie gibt an, das alle OK war und der Clietn nun Daten zugesand bekommt.
		TData += "content-type: text/html" & Chr(13, 10)	'Es wir dangegeben das zusätlzich Daten nach dem Header gesand werden und diese vom Type HTML sind
		TData += "content-lenght: " & Len(T) & Chr(13, 10)	'Auch die Länge der Daten sind nötig
		TData += "connection: close" & Chr(13, 10)	'Wir informieren den Clienten darüber das nach dem Senden aller daten die verbindugn automatishc getrennt wird.
		TData += Chr(13, 10)						'Und schliessen das ganze mit einerm Doppelten Zeilenumbruch ab (Header ende)
		RV = TSNE_Data_Send(V_TSNEID, TData)		'Wir senden den Header an den Clienten
		If RV <> TSNE_Const_NoError Then			'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
			Exit Select								'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! und Select verlassen. Vieleicht hat der CLient die Verbindung beendet.
		End If
		For X as UInteger = 1 to Len(T) Step 6000	'Wir senden die angehängten Daten in 6 KiloByte Blöcke zum Clienten
			RV = TSNE_Data_Send(V_TSNEID, Mid(T, X, 6000))	'Wir schneiden die jeweils nächsten 6KiloByte ab und senden sie zum Clienten
			If RV <> TSNE_Const_NoError Then		'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
				Exit For							'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! udn die Schleife verlassen. Vieleicht hat der CLient die verbindugn beendet.
			End If
		Next
		
	Case "/status"									'Der CLient will einen Status haben
		T += "<html>"								'Es wir deien HTML-Seite erzeugt
		T += " <head>"
		T += "  <title>Test-Server</title>"			'Mit eine Titel
		T += " </head>"
		T += " <body>"
		T += "  <p>= Mein Status =</p>"				'Und einem sichtbarem Text
		MutexLock(ClientMutex)						'Wir müssen das MUTEX sperren, weil wir auf daten im Array zugreifen
		T += "  <p>Ich habe / hatte maximal " & ClientC & " Verbindungen gleichzeitig</p>"
		T += "  <p>Deine IP-Adresse: " & ClientD(CIndex).V_IPA & "</p>"
		T += "  <p><a href=""block"">Blockiere meine IP-Adresse</a></p>"
		MutexUnLock(ClientMutex)					'Danach können wir die Sperre wieder aufheben
		T += " </body>"
		T += "</html>"								'Es wir deien HTML-Seite erzeugt
		
		TData += "HTTP/1.1 200 OK" & Chr(13, 10)	'Wir erzeugen eine "OK" seite. Sie gibt an, das alle OK war und der Clietn nun Daten zugesand bekommt.
		TData += "content-type: text/html" & Chr(13, 10)	'Es wir dangegeben das zusätlzich Daten nach dem Header gesand werden und diese vom Type HTML sind
		TData += "content-lenght: " & Len(T) & Chr(13, 10)	'Auch die Länge der Daten sind nötig
		TData += "connection: close" & Chr(13, 10)	'Wir informieren den Clienten darüber das nach dem Senden aller daten die verbindugn automatishc getrennt wird.
		TData += Chr(13, 10)						'Und schliessen das ganze mit einerm Doppelten Zeilenumbruch ab (Header ende)
		RV = TSNE_Data_Send(V_TSNEID, TData)		'Wir senden den Header an den Clienten
		If RV <> TSNE_Const_NoError Then			'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
			Exit Select								'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! und Select verlassen. Vieleicht hat der CLient die Verbindung beendet.
		End If
		For X as UInteger = 1 to Len(T) Step 6000	'Wir senden die angehängten Daten in 6 KiloByte Blöcke zum Clienten
			RV = TSNE_Data_Send(V_TSNEID, Mid(T, X, 6000))	'Wir schneiden die jeweils nächsten 6KiloByte ab und senden sie zum Clienten
			If RV <> TSNE_Const_NoError Then		'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
				Exit For							'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! udn die Schleife verlassen. Vieleicht hat der CLient die verbindugn beendet.
			End If
		Next
		
	Case "/block"
		MutexLock(ClientMutex)						'Wir müssen das MUTEX sperren, weil wir auf daten im Array zugreifen
		RV = TSNE_BW_Add(G_Server, ClientD(CIndex).V_IPA)	'Wir aktivieren eine IPA-Blockliste des Types: BlackList (Alle IPAs in der Liste werden blockiert)
		If RV <> TSNE_Const_NoError Then			'Prüfen ob dabei Fehler entstanden sind
			Print "[SERVER] [FEHLER] " & TSNE_GetGURUCode(RV)	'Irgend ein Fehler trat beim erstellen des Server auf
		End If
		MutexUnLock(ClientMutex)					'Danach können wir die Sperre wieder aufheben
		
		T += "<html>"								'Es wir deien HTML-Seite erzeugt
		T += " <head>"
		T += "  <title>Test-Server</title>"			'Mit eine Titel
		T += " </head>"
		T += " <body>"
		T += "  <p>Deine IP-Adresse steht jetzt auf der BlackList!</p>"
		T += "  <p>Weitere Anfragen sind ab jetzt nicht mehr möglich!</p>"
		T += " </body>"
		T += "</html>"								'Es wir deien HTML-Seite erzeugt
		
		TData += "HTTP/1.1 200 OK" & Chr(13, 10)	'Wir erzeugen eine "OK" seite. Sie gibt an, das alle OK war und der Clietn nun Daten zugesand bekommt.
		TData += "content-type: text/html" & Chr(13, 10)	'Es wir dangegeben das zusätlzich Daten nach dem Header gesand werden und diese vom Type HTML sind
		TData += "content-lenght: " & Len(T) & Chr(13, 10)	'Auch die Länge der Daten sind nötig
		TData += "connection: close" & Chr(13, 10)	'Wir informieren den Clienten darüber das nach dem Senden aller daten die verbindugn automatishc getrennt wird.
		TData += Chr(13, 10)						'Und schliessen das ganze mit einerm Doppelten Zeilenumbruch ab (Header ende)
		RV = TSNE_Data_Send(V_TSNEID, TData)		'Wir senden den Header an den Clienten
		If RV <> TSNE_Const_NoError Then			'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
			Exit Select								'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! und Select verlassen. Vieleicht hat der CLient die Verbindung beendet.
		End If
		For X as UInteger = 1 to Len(T) Step 6000	'Wir senden die angehängten Daten in 6 KiloByte Blöcke zum Clienten
			RV = TSNE_Data_Send(V_TSNEID, Mid(T, X, 6000))	'Wir schneiden die jeweils nächsten 6KiloByte ab und senden sie zum Clienten
			If RV <> TSNE_Const_NoError Then		'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
				Exit For							'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! udn die Schleife verlassen. Vieleicht hat der CLient die verbindugn beendet.
			End If
		Next
		
	Case else										'andere Dinge unterstützt unser HTTP-Server-Beispiel nicht
		TData += "HTTP/1.1 404 File / Path not found"	'Wir erzeugen eine Fehlerseite
		TData += Chr(13, 10, 13, 10)				'Und schliessen das ganze mit einerm Doppelten Zeilenumbruch ab (Header ende)
		RV = TSNE_Data_Send(V_TSNEID, TData)		'Wir senden den Header an den Clienten
		If RV <> TSNE_Const_NoError Then			'Ist die Rückgabe kleiner 0 dann entstand ein Fehler
			Exit Select								'Dieser Fehler ist so schwerwiegend das wir das senden abbrechen müssen! und Select verlassen. Vieleicht hat der CLient die Verbindung beendet.
		End If
End Select
TSNE_Disconnect(V_TSNEID)							'Am ende beenden wir die Verbindung, da alles nötig übertragen wurde. Und keine weitere aktion nötig ist.
End Sub

