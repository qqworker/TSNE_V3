'##############################################################################################################
'EGNP - Simple Demo-Client
'##############################################################################################################
#Include Once "EGNP.bi"



'##############################################################################################################
Sub EGNP_StateConnection(V_ClientID as UInteger, V_State as EGNP_INT_ClientState_Enum)
Print "EGNP_StateConnection:   CID:" & Str(V_ClientID) & "   State:" & EGNP_GetConnectionStateDescription(V_State)
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_StateUser(V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr)
Print "EGNP_StateUser:   CID:" & Str(V_UserID) & "   State:" & EGNP_GetUserStateDescription(V_State)
End Sub



'##############################################################################################################
Sub EGNP_Message(V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Message as String, V_MessageType as EGNP_MessageType_Enum, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)
Print "EGNP_Message:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   Type:" & Str(V_MessageType) & "   MSG:>" & V_Message & "<"
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_Data(V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Data as String, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)
Print "EGNP_Data:      FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   Data:>" & V_Data & "<"
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_MoveDbl(V_FromUserID as UInteger, V_ToUserID as UInteger, V_X as Double, V_Y as Double, V_Z as Double, V_Int as Integer, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)
Print "EGNP_MoveDbl:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   X:" & V_X & "   Y:" & V_Y & "   Z:" & V_Z & "   Int:" & V_Int
End Sub

'----------------------------------------------------------------------------------------------------------------------------------------------------
Sub EGNP_MoveInt(V_FromUserID as UInteger, V_ToUserID as UInteger, V_X as Integer, V_Y as Integer, V_Z as Integer, V_Int as Integer, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)
Print "EGNP_MoveInt:   FromUID:" & Str(V_FromUserID) & "   ToUID:" & Str(V_ToUserID) & "   X:" & V_X & "   Y:" & V_Y & "   Z:" & V_Z & "   Int:" & V_Int
End Sub



'##############################################################################################################
Dim TClientID as UInteger
Dim TCallbacks as EGNP_Callback_Type
With TCallbacks
	.V_StateConnection		= @EGNP_StateConnection
	.V_StateUser			= @EGNP_StateUser
	.V_Message				= @EGNP_Message
	.V_Data					= @EGNP_Data
	.V_MoveInt				= @EGNP_MoveInt
	.V_MoveDbl				= @EGNP_MoveDbl
End With
Dim RV as EGNP_GURU_Enum


RV = EGNP_Client_Create(TClientID, TCallbacks)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


Print "Please choose 'manual select' in the serverlist and click on 'connect'!"
ScreenRes 400, 200, 32
Dim THost as String = "deltalabs.de"
Dim TPort as UShort = 6008
Dim TPassServer as String = ""
Dim TNick as String = "testuser-" & Str(fix(timer()))
Dim TUser as String = "standard"
Dim TPass as String = "standardpass"
Dim TFlags as EGNP_ServerFlags_Enum
RV = EGNP_Public_ShowListAndGetServer(400, 200, "egnp_demo", 1, THost, TPort, TPassServer, TNick, TUser, TPass, TFlags)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0
Screen 0, , -1
RV = EGNP_Client_Connect(TClientID, THost, TPort, TNick, TPassServer, TUser, TPass)
If RV <> EGNP_GURU_NoError Then Print #1, EGNP_GetGURUDescription(RV): End 0



RV = EGNP_Client_WaitConnected(TClientID)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


Print "EGNP_Client_GetMyID:" & EGNP_Client_GetMyID(TClientID)


RV = EGNP_Client_SendMessage(TClientID, EGNP_Client_GetMyID(TClientID), "Test message to me: " & Str(Timer()))
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


RV = EGNP_Client_SendMessage(TClientID, 0, "Test message to all: " & Str(Timer()))
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


RV = EGNP_Client_SendData(TClientID, 0, "DATA-Test")
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


RV = EGNP_Client_SendMove(TClientID, 0, 1, 2, 3, 4)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0


RV = EGNP_Client_SendMove(TClientID, 0, 1.1, 2.2, 3.3, 4)
If RV <> EGNP_GURU_NoError Then Print EGNP_GetGURUDescription(RV): End 0

Print Chr(13, 10) & " -------------------------" & Chr(13, 10) & " !!! PRESS ESC TO EXIT !!!" & Chr(13, 10) & " -------------------------" & Chr(13, 10)
Do Until InKey() = Chr(27)
	Sleep 10, 1
Loop

End 0

