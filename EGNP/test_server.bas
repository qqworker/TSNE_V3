'##############################################################################################################
#Include Once "EGNP.bi"



'##############################################################################################################
Open Cons for Output as #1



'##############################################################################################################
Sub EGNP_Server_ConnectionRequest(V_ServerID as UInteger, V_IPA as String, ByRef R_Cancel as Integer)
'never use any EGNP funktion inside this callback!!!
Print "EGNP_Server_ConnectionRequest:   IPA:" & V_IPA
End Sub



'##############################################################################################################
Sub EGNP_Server_StateUser(V_ServerID as UInteger, V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr, ByRef R_Cancel as Integer)
Print "EGNP_Server_StateUser:   CID:" & Str(V_UserID) & "   State:" & EGNP_GetUserStateDescription(V_State)
End Sub



'##############################################################################################################
Sub EGNP_Server_AccountAction(V_ServerID as UInteger, V_UserID as UInteger, V_Action as EGNP_INT_AccountAction_Enum, ByRef V_Username as String, ByRef RV_UserFlags as EGNP_AccountPermissions_Enum, ByRef RV_MyPtr as Any Ptr, ByRef R_Cancel as Integer)
Dim T as String
If (RV_UserFlags and EGNP_APE_Banned)			<> 0 Then T += "B" Else T += " "
If (RV_UserFlags and EGNP_APE_Administrator)	<> 0 Then T += "A" Else T += " "
If (RV_UserFlags and EGNP_APE_Moderator)		<> 0 Then T += "M" Else T += " "
If (RV_UserFlags and EGNP_APE_Owner)			<> 0 Then T += "O" Else T += " "
If (RV_UserFlags and EGNP_APE_SuperModerator)	<> 0 Then T += "S" Else T += " "
If (RV_UserFlags and EGNP_APE_Registered)		<> 0 Then T += "R" Else T += " "
Print "EGNP_Server_AccountAction:   CID:" & Str(V_UserID) & "   Action:" & EGNP_GetAccountActionDescription(V_Action) & "   Username:>" & V_Username & "<   Flags:" & T
End Sub



'##############################################################################################################
Sub EGNP_Server_Message(V_ServerID as UInteger, V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Message as String, V_MessageType as EGNP_MessageType_Enum, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
Print "EGNP_Server_Message:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   Type:" & Str(V_MessageType) & "   MSG:>" & V_Message & "<"
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_Server_Data(V_ServerID as UInteger, V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Data as String, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
Print "EGNP_Server_Data:      FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   Data:>" & V_Data & "<"
'if we set R_CANCLE <> 0 (0 is the default value), then the data will not delivered to the client(s)
R_Cancel = 1
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_Server_MoveInt(V_ServerID as UInteger, V_FromUserID as UInteger, V_ToUserID as UInteger, V_X as Integer, V_Y as Integer, V_Z as Integer, V_Int as Integer, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
'Print "EGNP_Server_MoveInt:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   X:" & V_X & "   Y:" & V_Y & "   Z:" & V_Z & "   Int:" & V_Int
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_Server_MoveDbl(V_ServerID as UInteger, V_FromUserID as UInteger, V_ToUserID as UInteger, V_X as Double, V_Y as Double, V_Z as Double, V_Int as Integer, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
Print "EGNP_Server_MoveDbl:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   X:" & V_X & "   Y:" & V_Y & "   Z:" & V_Z & "   Int:" & V_Int
End Sub



'##############################################################################################################
'Create a Return-Variable what holds Return-GURU-Values
Dim RV as EGNP_GURU_Enum

'Create a new Gameserver on Port 1234 with "servpass" as Serverpassword
Print "Create server..."
Dim TServerID as UInteger
RV = EGNP_Server_Create(TServerID, 6006, "Testserver", "Server Description", "")

'at next, we must check if the server successful created or
If RV <> EGNP_GURU_NoError Then
	'a error raised. Then, print the error
	Print EGNP_GetGURUDescription(RV)
	
	'and exit the app
	End 0
End If


'Server-Callbacks can be used (must not) to check what clients send to other, or to control the transmission
Dim TCallbacks as EGNP_Callback_Type
With TCallbacks
	.V_Server_ConnectionRequest		= @EGNP_Server_ConnectionRequest
	.V_Server_StateUser				= @EGNP_Server_StateUser
	.V_Server_AccountAction			= @EGNP_Server_AccountAction
	.V_Server_Message				= @EGNP_Server_Message
	.V_Server_Data					= @EGNP_Server_Data
	.V_Server_MoveInt				= @EGNP_Server_MoveInt
	.V_Server_MoveDbl				= @EGNP_Server_MoveDbl
End With
EGNP_Server_SetCallbacks(TServerID, TCallbacks)


'here we activate the internal user-account managment. The Account-data will stored into "account.dat"
'the userpassword is one-way-crypted on the clientside and send to the server.
'the server checks the password by compair the crypted passwords from the client with the one on the account-file.
'u can backup the "account.dat" file. It holds all user / account stuff in one.
'NOTE: NEVER TRY TO MODIFY THE ACCOUNT FILE BY HAND! THIS WILL DESTROY THE FILE!!! For modifications use the EGNP_Client_Account commands!
'NOTE: If a client connect to a account-managed server, the server will strech the login time to min. 1 sec to prevent bruteforce attacks.
RV = EGNP_Server_AccountEnable(TServerID, "account.dat")
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'we must create a new account if the account.dat file doesn't exist, or the server are new.
'To do this, we easly call "EGNP_Server_AccountAdd". This will add a account we have specified to the account.dat file.
'BUT ONLY if we have enabled the account-managment via "EGNP_Server_AccountEnable"!
'NOTE: U cannot restore the passwort of an account! U can only RESET it to a new one via EGNP_Server_AccountPass!
'Account-Permissions (like, MOD or ADMIN state) u can set via V_Flags parameter on the "EGNP_Server_AccountAdd" command or
'on the fly or via the "EGNP_Client_Account_..." commands (full demo on test_account.bas)
'NOTE: to change flags or manage the account-list, u need the EGNP_APE_SuperModerator or EGNP_APE_Administrator Flag!
'RV = EGNP_Server_AccountAdd(TServerID, "administrator", "administratorpass", "administratornick", EGNP_APE_Administrator)
'If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'the next command will register the server on a public server-list.
'the serverlist is currently hostet on "deltalabs.de" and is avaible for all other servers and clients.
'If the server registered on the public-server, then all clients can search in this list for avaible servers.
'The GAMENAME and GAMEVERSION parameter needs to spezified the server-collection on the public-server.
'As example, if u have 3 servers running, then the client can search for it by call "EGNP_Public_ShowListAndGetServer"
'with the GAMENAME and GAMEVERSION parameter. This makes posible to add different servers or games to the same
'public-server-list, without separation. The separation was handled by the public-server for u ;)
'The NAME and DESCRIPTION value on EGNP_Server_Create will seen public in this list.
'the list will cycly updatet by EGNP so that clients can see how many players are connected, maxplayer and
'whats flags the server have set e.g. NeedAccount, crypted connection, udppipe, and so one.
RV = EGNP_Server_PublicRegister(TServerID, "egnp_demo", 1)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'this enable the server. If it not is enabled (default after create a server) then no client can connect.
'It will return "disconnected, server unavaible" on the client-side.
RV = EGNP_Server_Enable(TServerID)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'from now, the server running and let accept client connections to it.
Print "running!"
Do Until InKey() = Chr(27)
	
	Sleep 100, 1
Loop
Print "stopping server..."


EGNP_Server_Destroy(TServerID)

Print "exiting..."
end 0


