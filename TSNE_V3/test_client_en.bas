'##############################################################################################################
'TEST-CLIENT für TSNE_V3
'##############################################################################################################



'##############################################################################################################
#include once "TSNE_V3.bi"							'Include TCP Network modul



'##############################################################################################################
Dim G_Client as UInteger							'Create var for the Client-Handel



'##############################################################################################################
'	declarations of each callback routine
Declare Sub	TSNE_Disconnected	(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_Connected		(ByVal V_TSNEID as UInteger)
Declare Sub	TSNE_NewData		(ByVal V_TSNEID as UInteger, ByRef V_Data as String)



'##############################################################################################################
Print "[INIT] Client..."							'begin App
Dim BV as Integer									'Var for state return of function calls


'This Function creates a connection to "www.google.de" on port 80.
'xxx_Create_Client automaticle translate the hostname into a valid IP-Adress. U can use a IP-Adress too.
'U can set a Timeout at the end of the Function to define a timeout for the establishing. But 60seconds
'are by default for internet connections. If u work on the local network, u can reduce the value to 10 secons or lower.
'Just experiment whis these value in the local network. But, how i say, for the internet its recommend u use 60 seconds.
'this is intenaly the default value too for this function. So u can ignor this parameter, if u want.
'G_Client is the returning connection-ID what need each TSNE_xxx funtion.
'the @ Parameter are Callacks what TSNE will automaticle call if a state change raised.
'How the name say's, its TSNE_Disconnected a callback for the close-state of the connection
'TSNE_Connected is for a successfully creating this connection
'TSNE_NewData is a Routine if new data avaible.

Print "[Connecting]"
BV = TSNE_Create_Client(G_Client, "www.google.de", 80, @TSNE_Disconnected, @TSNE_Connected, @TSNE_NewData, 60)

'Checking the return value
If BV <> TSNE_Const_NoError Then					'If a error
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Print the Human-Readable error message
	End -1											'Terminate app
End If
Print "[OK]"										'Else, it was ok

'In this case we can wait till the connection was close. We will manage all traffic in the callback-routines.
'We send a "connection: close" to the google client so that google close the connection after data-transmission.

Print "[WAIT] ..."
TSNE_WaitClose(G_Client)							'here we wait for the close of the connection
Print "[WAIT] OK"

Print "[END]"
End													'Terminate app.



'##############################################################################################################
Sub TSNE_Disconnected(ByVal V_TSNEID as UInteger)	'Receiver for Disconnect
'If a connection was closed, this routin will fired.
'We print shortly this state
Print "[DIS]"
'In other cases here we can remove previous created things like allocated memmory for this connection or others
End Sub



'##############################################################################################################
Sub TSNE_Connected(ByVal V_TSNEID as UInteger)		'Receiver for a stable created connection
'Print this success
Print "[CON]"

'Prepare data to send (for HTTP-Protocol see WIKIPEDIA)
Dim CRLF as String = Chr(13, 10)
Dim D as String
D += "GET / HTTP/1.0" & CRLF
D += "Host: www.google.de" & CRLF
D += "connection: close" & CRLF
D += CRLF

'Send the Data to the connection
Print "[SEND] ..."
Print ">" & D & "<"
'here we use the V_TSNEID so send the data.
'This callback comes from TSNE and TSNE give us the Client-ID of this connection by V_TSNEID.
'So we can use this instead of the G_Client var.
Dim BV as Integer = TSNE_Data_Send(V_TSNEID, D)
If BV <> TSNE_Const_NoError Then
	Print "[FEHLER] " & TSNE_GetGURUCode(BV)		'Print error
Else: Print "[SEND] OK"
End If
End Sub



'##############################################################################################################
Sub TSNE_NewData (ByVal V_TSNEID as UInteger, ByRef V_Data as String)	'Receiver for new incomming data
'If new Data is avaible, TSNE will fire this callback and give us the new data in V_Data
'The Client who has sent will identifyd by V_TSNEID.
'If goolge has sent all data to us then google will close the connection itself.
Print "[NDA]: >" & V_Data & "<"
End Sub


