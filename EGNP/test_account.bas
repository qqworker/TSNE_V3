'##############################################################################################################
'EGNP - Account Managment Demo
'##############################################################################################################
#Include Once "EGNP.bi"



'##############################################################################################################
'This function we use only to laster print the userlist
Sub PrintAccountList(V_Client as UInteger)
Print "EGNP_Client_Account_List"
Dim TUserD() as EGNP_Account_Type
Dim TUserC as UInteger
Dim RV as EGNP_GURU_Enum = EGNP_Client_Account_List(V_Client, "", TUserD(), TUserC)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Dim T as String
'Now we print the retrived list of the user(s).
For X as Integer = 1 to TUserC
	With TUserD(X)
		T = ""
		If (.V_UserFlags and EGNP_APE_Registered)		<> 0 Then T += "R" Else T += " "
		If (.V_UserFlags and EGNP_APE_Banned)			<> 0 Then T += "B" Else T += " "
		If (.V_UserFlags and EGNP_APE_Moderator)		<> 0 Then T += "M" Else T += " "
		If (.V_UserFlags and EGNP_APE_SuperModerator)	<> 0 Then T += "S" Else T += " "
		If (.V_UserFlags and EGNP_APE_Administrator)	<> 0 Then T += "A" Else T += " "
		If (.V_UserFlags and EGNP_APE_Owner)			<> 0 Then T += "O" Else T += " "
		Print "  USER: >" & T & "<___>" & .V_Username & "<___>" & .V_Nickname & "<"
	End With
Next
Print ""
End Sub



'u find more details about the folowing two callbacks and how to connect in test_app.bas and test_client.bas
'##############################################################################################################
Sub EGNP_StateConnection(V_ClientID as UInteger, V_State as EGNP_INT_ClientState_Enum)
Print "EGNP_StateConnection:   CID:" & Str(V_ClientID) & "   State:" & EGNP_GetConnectionStateDescription(V_State)
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_StateUser(V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr)
Print "EGNP_StateUser:   CID:" & Str(V_UserID) & "   State:" & EGNP_GetUserStateDescription(V_State)
End Sub



'##############################################################################################################
Dim TClientID as UInteger
Dim TCallbacks as EGNP_Callback_Type
With TCallbacks
	.V_StateConnection		= @EGNP_StateConnection
	.V_StateUser			= @EGNP_StateUser
End With
Dim RV as EGNP_GURU_Enum


RV = EGNP_Client_Create(TClientID, TCallbacks)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'We connect to the DeltaLab's EGNP-Developer-Server. All Users where Connect to this Server have the ADMINISTRATOR Flag set!
'With the ADMIN-Flag we can use all EGNP-Account and Managment Commands.
'NOTE: The DeltaLab's Developer-Server allows only 100 Accounts registered and will cycled (every 5min) reset the AccountList to
'5 defined Accounts. 1x "standard" registered acc, 1x "banned", 1x "moderator", 1x "supermod", 1x "admin"
'The accounts are build up like this semantic:
'Username: "standard"
'Password: "standardpass"
'Nickname: "standardnick"
'e.g. for mod: moderator, moderatorpass, moderatornick
'"egnp_demo" is the game-key and 1 the game-version, if u want to use EGNP_Public_ShowListAndGetServer.
'NOTE: Only the Deltalabs-EGNP-DEV server supports full account managment functions. The other is vor demonstration purpose only.
Dim TMyKey as String = Str(fix(timer()))
RV = EGNP_Client_Connect(TClientID, "deltalabs.de", 6008, "testuser-" & TMyKey, "", "standard", "standardpass")
'RV = EGNP_Client_Connect(TClientID, "DeltaLabs.de", 6008, "testuser-" & Str(fix(timer())), "servpass", "", "standard", "standardpass")
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'we wait to fully connect to the server
RV = EGNP_Client_WaitConnected(TClientID)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


'list current accounts. The Second Parameter is a optional "select" value,
'to select a specified Username. e.g. to get Flags of a selected user.
'NOTE: Only SuperModerator and Administrator accounts can edit the User-Flags!
Print "EGNP_Client_Account_List"
Dim TUserD() as EGNP_Account_Type
Dim TUserC as UInteger
RV = EGNP_Client_Account_List(TClientID, "", TUserD(), TUserC)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Dim T as String
'Now we print the retrived list of the user(s).
For X as Integer = 1 to TUserC
	With TUserD(X)
		T = ""
		If (.V_UserFlags and EGNP_APE_Registered)		<> 0 Then T += "R" Else T += " "
		If (.V_UserFlags and EGNP_APE_Banned)			<> 0 Then T += "B" Else T += " "
		If (.V_UserFlags and EGNP_APE_Moderator)		<> 0 Then T += "M" Else T += " "
		If (.V_UserFlags and EGNP_APE_SuperModerator)	<> 0 Then T += "S" Else T += " "
		If (.V_UserFlags and EGNP_APE_Administrator)	<> 0 Then T += "A" Else T += " "
		If (.V_UserFlags and EGNP_APE_Owner)			<> 0 Then T += "O" Else T += " "
		Print "  USER: >" & T & "<___>" & .V_Username & "<___>" & .V_Nickname & "<"
	End With
Next
Print ""


'we create a new account
'at first we build a temporaly KEY, so that another clients cann create his owen user, and will not conflict with us.
'Username and nickname must be unique!
Dim TKey as String = Str(Fix(Timer()))
Print "EGNP_Client_Account_Create"
RV = EGNP_Client_Account_Create(TClientID, "testuser-" & TKey, "testpass", "testnick-" & TKey)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Print ""


'now we retrive only the parameter of the new user. So we can get the flags of the new user to mod it later.
Print "EGNP_Client_Account_List"
Dim TFlags as EGNP_AccountPermissions_Enum
RV = EGNP_Client_Account_List(TClientID, "testuser-" & TKey, TUserD(), TUserC)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
For X as Integer = 1 to TUserC
	With TUserD(X)
		T = ""
		If (.V_UserFlags and EGNP_APE_Registered)		<> 0 Then T += "R" Else T += " "
		If (.V_UserFlags and EGNP_APE_Banned)			<> 0 Then T += "B" Else T += " "
		If (.V_UserFlags and EGNP_APE_Moderator)		<> 0 Then T += "M" Else T += " "
		If (.V_UserFlags and EGNP_APE_SuperModerator)	<> 0 Then T += "S" Else T += " "
		If (.V_UserFlags and EGNP_APE_Administrator)	<> 0 Then T += "A" Else T += " "
		If (.V_UserFlags and EGNP_APE_Owner)			<> 0 Then T += "O" Else T += " "
		Print "  USER: >" & T & "<___>" & .V_Username & "<___>" & .V_Nickname & "<"
		If .V_Username = "testuser-" & TKey Then TFlags = .V_UserFlags
	End With
Next
Print ""


'The User user became a new Userflag. We set the Moderator-Flag.
'NOTE: Only SuperModerator and Administrator accounts can edit the User-Flags!
'NOTE: The New Flags will override the old! So check the current flags and mod it!
'NOTE: The Registration Flag will set by the server.
Print "EGNP_Client_Account_SetFlags"
TFlags or= EGNP_APE_Moderator
RV = EGNP_Client_Account_SetFlags(TClientID, "testuser-" & TKey, TFlags)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Print ""


'to reduce the source-size, here we use a sub to print the account-list.
PrintAccountList(TClientID)


'NOTE: Only SuperModerator and Administrator accounts and the owner of an account can edit the Nickname!
Print "EGNP_Client_Account_SetNickname"
RV = EGNP_Client_Account_SetNickname(TClientID, "testuser-" & TKey, "foobarlo" & TKey)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Print ""


PrintAccountList(TClientID)


'NOTE: Only SuperModerator and Administrator accounts and the owner of an account can change the Password!
'NOTE: U cannot get a current password! The Password is stored one side crypted and cannot be decrypted!
'NOTE: So, if a user forgot his password, u only can change it to a new one!
Print "EGNP_Client_Account_SetPassword"
RV = EGNP_Client_Account_SetPassword(TClientID, "testuser-" & TKey, "flobarpass")
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Print ""


'At least we destroy an account
'NOTE: Only SuperModerator and Administrator accounts can destroy accounts!
'NOTE: The Owner can remove too his owen account.
Print "EGNP_Client_Account_Destroy"
RV = EGNP_Client_Account_Destroy(TClientID, "testuser-" & TKey, "flobarpass")
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0
Print ""


PrintAccountList(TClientID)


'To demonstrate the KICK command, we kick our own connection ;)
'NOTE: Only Moderator, SuperModerator and Administrator accounts can use the KICK command!
'At first we get the owen USER-ID to kick. NOTE That this id on the client-side and the serverside are not the same!
Print "EGNP_Client_Kick"
RV = EGNP_Client_Kick(TClientID, EGNP_Client_GetUserIDByNick(TClientID, "testuser-" & TMyKey))
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


Print "Press ESC to exit!"
Do Until InKey() = Chr(27)
	Sleep 10 , 1
Loop
End 0

