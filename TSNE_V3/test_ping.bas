'##############################################################################################################
'TEST-PING für TSNE_V3
'##############################################################################################################



'##############################################################################################################
'#Define TSNE_PINGICMP				'USE ONLY IF U SURE CAN SAY ICMP.DLL EXIST ON THE TARGET OS!!!
									'Dieses Flag signalisiert die Verwendung der ICMP.dll unter WINDOWS in TSNE.
									'Es kann vorkommen, das die ICMP.dll nicht auf jedem System verfügbar ist.
									'Daher bitte nur nutzen, wenn sichergestellt ist, das diese DLL auch WIRKLICH
									'auf dem Zielsystem verfügbar sein wird!
#include once "TSNE_V3.bi"			'Die TCP Netzwerkbibliotek integrieren



'TSNE nutzt 3 arten von PING funktionen

'1. RAW-Ping	hierbei wird ein Socket erzeugt das selbst einen PING sendet und auswertet.
'				Hierfür sind ROOT-Rechte nötig! Sowohl unter Windows als auch unter Linux!
'2. APP-Ping	Das Programm "PING.exe" bzw "ping" unter Linux wird hierbei aufgerufen und
'				sendet den eigentlichen Ping. Hierfür sind KEIEN Root-Rechte nötig!
'				Sollte auf jedem System Funktionieren.
'3. ICMP.dll	TSNE nutzt bei gesetztem "TSNE_PINGICMP" die icmp.dll zum versand und empfang
'				eines Ping's. Hier muss jedoch die DLL auch im system Vorhanden sein, was
'				NICHT IMMER der Fall ist! Daher bitte mit vorsicht nutzen!

'Ein RAW-Ping Kann durch das Setzen des 'V_ForceRAWPing' Parameters in der Funktion 'TSNE_Ping' erzwungen werden.

'[WINDOWS]
'Zuerst wird versucht (Vorrausgesetzt TSNE_PINGICMP ist definiert) einen Ping über die ICMP.dll zu senden.
'Bei erfolglosem Versuch wird versucht das Programm "Ping" auszuführen.
'Scheitert dies, versucht TSNE einen Ping über das RAW-Socket.
'
'[LINUX]
'Ist dieser Parameter auf 0 gesetzt wird zuerst versucht das Programm "Ping" auszuführen.
'Scheitert dies, versucht TSNE einen Ping über das RAW-Socket.



'##############################################################################################################
Dim TRunTime as Double
Dim RV as Integer

'Ping Ausführen

'TSNE_Ping(ByVal V_IPA as String, ByRef R_Runtime as Double, ByVal V_TimeoutSecs as UByte = 10, ByVal V_ForceRAWPing as UByte = 0, ByVal V_FileIOMutex as Any Ptr = 0) as Integer
'V_IPA			= Target IP-Address
'R_Runtime		= Runtime of the Ping will store in this Variable
'V_TimeoutSecs	= Define a Timeout (in seconds) for the Ping. Default are 10 seconds.
'V_ForceRAWPing	= If 1 then TSNE use a RAW-Socket so send a Ping. Only posible if the APP running as ROOT or ADMINISTRATOR!
'V_FileIOMutex	= If u not using RAW_Ping then TSNE try running the application "PING" on linux and windows.
'				  To do this, a Filedescriptor (Freefile) must create in TSNE! If u use Threads and File IO Operations
'				  Then u must give TSNE the Mutex to Lock the File-IO-Operation for preventing a wrong access to the System
'				  while your app accessing a file.
'				  TSNE Locks this Mutex a short time to create a FreeFile and Open the Application Pipe.


RV = TSNE_Ping("192.168.0.1", TRunTime)

'Statusrückgabe auswerten
If RV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(RV)		'Fehler ausgeben
	End -1											'Programmbeenden
End If

Print "Runtime: "; Str(TRunTime); " seconds"
End 0


