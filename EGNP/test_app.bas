'##############################################################################################################
'EGNP - Demo Application (Pixel drawer)
'##############################################################################################################
#Include Once "EGNP.bi"
'== BEGIN workaround to fix an unknown fbc-gfx bug
#Include Once "fbgfx.bi"
'== END


'##############################################################################################################
Open Cons for Output as #1



'##############################################################################################################
Type MyUserType
	V_X		as Integer
	V_Y		as Integer
End Type



'##############################################################################################################
Dim Shared G_Img as Any Ptr
Dim Shared G_Mux as Any Ptr
Dim Shared G_Log(1 to 25) as String



'##############################################################################################################
Sub LogAdd(V_Text as String)
MutexLock(G_Mux)
For X as Integer = LBound(G_Log) to UBound(G_Log) - 1
	G_Log(X) = G_Log(X + 1)
Next
G_Log(UBound(G_Log)) = V_Text
MutexUnLock(G_Mux)
End Sub



'##############################################################################################################
Sub EGNP_StateConnection(V_ClientID as UInteger, V_State as EGNP_INT_ClientState_Enum)
LogAdd("EGNP_StateConnection:   CID:" & Str(V_ClientID) & "   State:" & EGNP_GetConnectionStateDescription(V_State))
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_StateUser(V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr)
LogAdd("EGNP_StateUser:   CID:" & Str(V_UserID) & "   State:" & EGNP_GetUserStateDescription(V_State))
Select Case V_State
	Case EGNP_USE_Join
		RV_MyPtr = CAllocate(SizeOf(MyUserType))
		
	Case EGNP_USE_Leave, EGNP_USE_Kicked
		DeAllocate(RV_MyPtr)
		
End Select
End Sub



'##############################################################################################################
Sub EGNP_Message(V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Message as String, V_MessageType as EGNP_MessageType_Enum, ByRef RV_ToMyPtr as Any Ptr, ByRef RV_FromMyPtr as Any Ptr)
LogAdd("EGNP_Message:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   Type:" & Str(V_MessageType) & "   MSG:>" & V_Message & "<")
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_MoveInt(V_FromUserID as UInteger, V_ToUserID as UInteger, V_X as Integer, V_Y as Integer, V_Z as Integer, V_Int as Integer, ByRef RV_ToMyPtr as Any Ptr, ByRef RV_FromMyPtr as Any Ptr)
If RV_FromMyPtr <> 0 Then
	With *Cast(MyUserType Ptr, RV_FromMyPtr)
		.V_X	= V_X
		.V_Y	= V_Y
	End With
End If

MutexLock(G_Mux)
'== BEGIN workaround to fix an unknown fbc-gfx bug
If (V_X >= 0) and (V_X < 640) and (V_Y >= 0) and (V_Y < 480) Then
	Select Case V_Z
		Case 1: (Cast(UInteger Ptr, Cast(Any Ptr, G_Img) + SizeOf(FB.Image)))[V_Y * 640 + V_X] = &HFF000000 or (V_Int and &H00FFFFFF)
		Case 2: (Cast(UInteger Ptr, Cast(Any Ptr, G_Img) + SizeOf(FB.Image)))[V_Y * 640 + V_X] = &HFF000000
	End Select
End If
'== END
'the following source will freez the app because of an unknown fbc-gfx bug
'Select Case V_Z
'	Case 1: Circle G_Img, (V_X, V_Y), 2, &HFF000000 or (V_Int and &H00FFFFFF), , , , F
'	Case 2: Circle G_Img, (V_X, V_Y), 15, &HFF000000, , , , F
'End Select
MutexUnLock(G_Mux)
End Sub



'##############################################################################################################
Do Until InKey() = ""
Loop
Print "Please choose 'manual select' in the serverlist and click on 'connect'!"
Screenres 640, 480, 32
G_Img = ImageCreate(640, 480, &HFF000000, 32)
'== BEGIN workaround to fix an unknown fbc-gfx bug
Cast(Fb.Image Ptr, G_Img)->pitch = 640 * 4
'== END

Dim TClientID as UInteger
Dim TCallbacks as EGNP_Callback_Type
With TCallbacks
	.V_StateConnection		= @EGNP_StateConnection
	.V_StateUser			= @EGNP_StateUser
	.V_Message				= @EGNP_Message
	.V_MoveInt				= @EGNP_MoveInt
End With
Dim RV as EGNP_GURU_Enum


RV = EGNP_Client_Create(TClientID, TCallbacks)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0


Dim THost as String = "deltalabs.de"
Dim TPort as UShort = 6008
Dim TPassServer as String = ""
Dim TNick as String = "testuser-" & Str(fix(timer()))
Dim TUser as String = "standard"
Dim TPass as String = "standardpass"
Dim TFlags as EGNP_ServerFlags_Enum
RV = EGNP_Public_ShowListAndGetServer(400, 200, "egnp_demo", 1, THost, TPort, TPassServer, TNick, TUser, TPass, TFlags)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0

CLS()
Print "connecting..."

RV = EGNP_Client_Connect(TClientID, THost, TPort, TNick, TPassServer, TUser, TPass)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0

RV = EGNP_Client_WaitConnected(TClientID)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0

Dim TMR as Integer
Dim TMX as Integer
dim TMY as Integer
Dim TMZ as Integer
Dim TMB as Integer
Dim TMXL as Integer
dim TMYL as Integer
Dim TMZL as Integer
Dim TMBL as Integer
Dim TCol as UInteger = Int(Rnd * &HFFFFFF)
Dim TUserPtr as EGNP_User_Type Ptr
Do
	'left-mouse-btn = draw (pset with TCol)
	'right-mouse-btn = delete (circle with black)
	MutexLock(G_Mux)
	If InKey() = Chr(27) Then MutexUnLock(G_Mux): Exit Do
	TMR = GetMouse(TMX, TMY, TMZ, TMB)
	ScreenLock()
	CLS()
	Put (0, 0), G_Img, PSet
	For X as Integer = UBound(G_Log) to LBound(G_Log) Step -1
		Print G_Log(X)
	Next
	EGNP_Client_Lock()
	TUserPtr = EGNP_Client_GetUserTypeFirst(TClientID)
	Do Until TUserPtr = 0
		If TUserPtr->V_MyPtr <> 0 Then
			With *Cast(MyUserType Ptr, TUserPtr->V_MyPtr)
				Circle (.V_X, .V_Y), 5, &HFFFFFFFF
				Draw String (.V_X + 15, .V_Y), TUserPtr->V_Nickname, &HFF888888
			End With
		ENd If
		TUserPtr = TUserPtr->V_Next
	Loop
	EGNP_Client_UnLock()
	ScreenUnLock()
	MutexUnLock(G_Mux)
	If (TMXL <> TMX) or (TMYL <> TMY) or (TMZL <> TMZ) or (TMBL <> TMB) Then
		RV = EGNP_Client_SendMove(TClientID, 0, TMX, TMY, TMB, TCol)
		TMXL = TMX
		TMYL = TMY
		TMZL = TMZ
		TMBL = TMB
	End If
	If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): Exit Do
	'USleep 10000
	Sleep 10, 1
Loop

End 0

