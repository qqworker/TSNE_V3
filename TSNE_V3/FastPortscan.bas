'##############################################################################################################
'FastPortscan für TSNE_V3
'##############################################################################################################





'##############################################################################################################
'           = = =   A C H T U N G   = = =
'##############################################################################################################

' Scnnersoftware wie diese darf NUR!!! zur untersuchung des EIGENEN!!! LOKALEN!!! Netzwerks genutzt werden!!!!
' Jegliche anderweitige handhabung IST STRAFBAR!!!!!!!!!
' Dieser Quellcode wurde so entwickelt, das der Gebrauch NUR für Lokale Scanns geeignet ist!
' Jegliche Manipulation oder abänderungen zur Untersuchung fremder Netzwerke IST STRAFBAR!!!
' Ich übernehme KEINE Haftung für Schäden oder Rechtliche belange bei zweckfremder nutzung dieses Codes!!!!!!!

'##############################################################################################################
'           = = =   A C H T U N G   = = =
'##############################################################################################################





'##############################################################################################################
#include once "TSNE_V3.bi"							'Die TCP Netzwerkbibliotek integrieren



'##############################################################################################################
Const G_ToPort				as UInteger	= 1024		'Nur die Offiziellen Ports scannen
Const G_TreadCount			as UShort	= 100		'Wir definieren 100 Threads zum parallen Scannen
Const G_ConnectionTimeout	as UInteger	= 2			'Wir definieren ein Verbindungstimeout von 2 sek.
													'Reicht locker für einen Lokalen Scan aus



'##############################################################################################################
Dim Shared G_Host			as String				'IP-Adresse / Hostname
Dim Shared G_PortD(65535)	as UByte				'Ein Array welches Den Status eines Ports erfasst
Dim Shared G_PortC			as UInteger				'Zähler, für die aktuelle Portnummer
Dim Shared G_Mutex			as Any Ptr				'Ein Mutex zum Schutz des Arrays
Dim Shared G_ThreadD()		as Any Ptr				'Array welches die Threads-IDs hält



'##############################################################################################################
Sub TSNE_NewData(V_TSNEID as UInteger, ByRef V_Data as String)	'Ist von TSNE_V3 Pflicht
'Wird nicht benötigt, udn ist daher leer.
End Sub



'##############################################################################################################
Sub Scan_Thread()
Dim XPort	as UInteger									'Variable die den aktuellen Port speichert
Dim TClient	as UInteger									'TSNE_ID variable
Dim BV		as Integer									'Statusrückgabevariable
MutexLock(G_Mutex)										'Array Sperren
Dim THost	as String	= G_Host						'Host
Dim TTOut	as UInteger	= G_ConnectionTimeout			'Timeout
MutexUnLock(G_Mutex)									'Array Sperren
Do
	Sleep 1, 1
	MutexLock(G_Mutex)									'Array Sperren
	If G_PortC + 1 > G_ToPort Then MutexUnLock(G_Mutex): Exit Do	'Wenn wir das maximum überschreiten würden, dann verlassen wir den Thread
	G_PortC += 1										'Aktuelle Portnummer heraufzählen
	XPort = G_PortC										'Andernfalls speicher wir uns den Port zwischen, damit dieser
														'von einem anderen Thread nicht verändert wird.
	Print XPort; "  ";									'Portnummer ausgeben (Wird IM MutexLock gemacht, damit die
														'Ausgaben der Threads nicht vermischt werden.
	G_PortD(XPort) = 1									'Im Array eine 1 hinterlegen (wird gescannt)
	MutexUnLock(G_Mutex)								'Entsperren
	'Verbindungsaufbau
	TClient = 0
	BV = TSNE_Create_Client(TClient, THost, XPort, 0, 0, @TSNE_NewData, TTOut)
	If TClient > 0 Then									'Wenn uns eine ID zugeteilt wurde, dann...
		TSNE_Disconnect(TClient)						'Aktive Verbindung wieder schliessen
	End If
	MutexLock(G_Mutex)									'Array Sperren
	If BV = TSNE_Const_NoError Then						'Verbindung hergestellt?
		G_PortD(XPort) = 2								'Wenn ja, dann Wert 2 im Array hinterlegen
	Else: G_PortD(XPort) = 3							'Wenn nicht, dann Wert 3 hinterlegen
	End If
	MutexUnLock(G_Mutex)								'Array wieder entsperren.
Loop
End Sub


'##############################################################################################################
G_Mutex = MutexCreate()
G_Host = Command()										'IP-Adresse / Hostname von der Kommandozeile einhohlen
MutexLock(G_Mutex)										'Array Sperren

Print "[INIT] Creating scanning threads..."				'Programm beginnen
Redim G_ThreadD(G_TreadCount) as Any Ptr
Redim G_ThreadS(G_TreadCount) as UByte
For X as UInteger = 1 to G_TreadCount
	G_ThreadD(X) = ThreadCreate(Cast(Any Ptr, @Scan_Thread), , 150000)
Next

Print "[INIT] Scanning..."								'Programmbeginnt mit Scan, nachdem das Unlock aufgerufen wurde
MutexUnLock(G_Mutex)									'Array Entsperren
For X as UInteger = 1 to G_TreadCount
	ThreadWait(G_ThreadD(X))
Next
MutexLock(G_Mutex)									'Array Entsperren
Print "[INIT] Success!"									'Scann Fertig!
MutexUnLock(G_Mutex)									'Array Entsperren

For X as UInteger = 1 to G_ToPort						'Alle Ports durchgehen
	If G_PortD(X) = 2 Then								'Ist eine 2 gespeichert, dann wurde der Port als "Offen" markiert.
		Print "OFFEN: "; X; " ";						'Wir geben die Offene Portnummer aus
		Select Case X									'Die gängigsten Portnummern bekommen noch eine Bezeichnung (Unzuverlässig!!)
														'http://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
			Case 7:		Print "[Echo]"
			Case 13:	Print "[DayTime]"
			Case 20:	Print "[FTP-Data]"
			Case 21:	Print "[FTP-CMD]"
			Case 22:	Print "[SSH]"
			Case 23:	Print "[Telnet]"
			Case 25:	Print "[SMTP / ESMTP]"
			Case 37:	Print "[Time]"
			Case 42:	Print "[WinS]"
			Case 43:	Print "[WhoIs]"
			Case 53:	Print "[DNS]"
			Case 79:	Print "[Finger]"
			Case 80:	Print "[HTTP]"
			Case 109:	Print "[POP2]"
			Case 110:	Print "[POP3]"
			Case 113:	Print "[Auth]"
			Case 118:	Print "[SQL]"
			Case 119:	Print "[NNTP]"
			Case 123:	Print "[NTP]"
			Case 137:	Print "[NetBIOS-Service]"
			Case 138:	Print "[NetBIOS-Datagram]"
			Case 139:	Print "[NetBIOS-Session]"
			Case 143:	Print "[IMAP]"
			Case 156:	Print "[SQL]"
			Case 161:	Print "[SNMP]"
			Case 220:	Print "[IMAP]"
			Case 443:	Print "[HTTPS]"
			Case 546:	Print "[DHCPv6 Client]"
			Case 547:	Print "[DHCPv6 Server]"
			Case 3306:	Print "[MySQL]"
			Case 3389:	Print "[RDP]"
			Case 6667:	Print "[IRC]"
			'......
			Case Else: Print
		End Select
	End If
Next

MutexDestroy(G_Mutex)
Print "[END]"											'Programm beenden
End														'Anschliessend beenden wir unser Programm
