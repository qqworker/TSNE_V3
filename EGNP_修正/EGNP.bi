'####################################################################################################################################################
'####################################################################################################################################################
' EGNP_V1 - Easy Game Net Play Version: (see line 19 till 21)
'####################################################################################################################################################
'####################################################################################################################################################
' (c) 2013-.... By.: /_\ DeltaLab's Germany - Experimental Computing
' Autor: Martin Wiemann
' IRC: IRC://DeltaLabs.de/#mln
' Idea: 2013.12.31
'####################################################################################################################################################
' Free for NON-comercial use. Using the DeltaLab's Server for comercial use is NOT allowed! Mail me if u need more licences: fb@deltalabs.de
'####################################################################################################################################################



'####################################################################################################################################################
#IFNDEF _EGNP_
    #DEFINE _EGNP_
    #Define EGNP_Version 1.1
    #Define EGNP_VersionDate 20160124
    #Define EGNP_VersionFull 1.1_20160124 (0.90.1 07-17-2013)
'>...

#Define TSNE_DEF_REUSER
#Define TSNE_SUBCALLBACK
#Define TSNE_FastEventThread
#Include Once "TSNE_V3.bi"
#IF TSNE_VersionDate < 20131223
    #ERROR Wrong TSNE-Version! Too old! U need 3.7_20131223 or higer!
#ENDIF



'####################################################################################################################################################
' === TODO ===
'highscores
'udp
'rooms



'####################################################################################################################################################
Enum EGNP_GURU_Enum
    EGNP_GURU_Unknown                           = 0
    EGNP_GURU_NoError                           = 1
    EGNP_GURU_NoErrorCreateAccount              = 2

    EGNP_GURU_ParameterError                    = -1000
    EGNP_GURU_IDnotFound                        = -1001
    EGNP_GURU_NothingSelected                   = -1002

    EGNP_GURU_InternalError                     = -1900
    EGNP_GURU_DATALenError                      = -1901
    EGNP_GURU_Timeout                           = -1902
    EGNP_GURU_UnknownCMD                        = -1903
    EGNP_GURU_CantConnect                       = -1904
    EGNP_GURU_ExternalError                     = -1905
    EGNP_GURU_CantOpenFile                      = -1906
    EGNP_GURU_TransmissionError                 = -1907
    EGNP_GURU_ParseLenError                     = -1908

    EGNP_GURU_LoginDenied                       = -1920
    EGNP_GURU_NickDenied                        = -1921
    EGNP_GURU_CommandDenied                     = -1922
    EGNP_GURU_UsernameDenied                    = -1923
End Enum



'####################################################################################################################################################
Enum EGNP_INT_CMD_Enum
    EGNP_CMD_Unknown                            = 0
    EGNP_CMD_NoError                            = 1

    EGNP_CMD_ServerUnavaible                    = 1100
    EGNP_CMD_ServerOffline                      = 1101
    EGNP_CMD_ServerFull                         = 1102
    EGNP_CMD_ServerConnectionDenied             = 1103

    EGNP_CMD_Ping                               = 1190
    EGNP_CMD_Pong                               = 1191

    EGNP_CMD_Crypt1                             = 1200
    EGNP_CMD_Crypt2                             = 1201
    EGNP_CMD_Crypt3                             = 1202
    EGNP_CMD_Ident                              = 1203
    EGNP_CMD_ServerAlternative                  = 1204
    EGNP_CMD_ServerList                         = 1205
    EGNP_CMD_ServerListAdd                      = 1206
    EGNP_CMD_ServerListReady                    = 1207
    EGNP_CMD_ServerListUpdate                   = 1208

    EGNP_CMD_AccCreate                          = 1210
    EGNP_CMD_AccDestroy                         = 1211
    EGNP_CMD_AccLogin                           = 1212
    EGNP_CMD_AccList                            = 1213
    EGNP_CMD_AccSetFlags                        = 1214
    EGNP_CMD_AccSetNick                         = 1215
    EGNP_CMD_AccSetPass                         = 1216

    EGNP_CMD_Ready                              = 1300

    EGNP_CMD_UserLeave                          = 1400
    EGNP_CMD_UserKick                           = 1401
    EGNP_CMD_UserJoin                           = 1402
    EGNP_CMD_UserMessage                        = 1403
    EGNP_CMD_UserData                           = 1404

    EGNP_CMD_ScoreList                          = 1420
    EGNP_CMD_ScoreAdd                           = 1421

End Enum



'####################################################################################################################################################
Dim Shared EGNP_INT_Mux                         as Any Ptr



'####################################################################################################################################################
Enum EGNP_INT_AccountAction_Enum
    EGNP_AAE_Unknown                            = 0
    EGNP_AAE_Login
    EGNP_AAE_Create
    EGNP_AAE_Destroy
    EGNP_AAE_SetFlags
End Enum



'####################################################################################################################################################
Enum EGNP_INT_UserState_Enum
    EGNP_USE_Unknown                            = 0
    EGNP_USE_Leave
    EGNP_USE_Kicked
    EGNP_USE_Join
End Enum



'####################################################################################################################################################
Enum EGNP_INT_ClientState_Enum
    EGNP_CSE_Unknown                            = 0
    EGNP_CSE_Disconnected                       = &B00001000
    EGNP_CSE_DisconnectedTimeout                = &B00001001
    EGNP_CSE_DisconnectedUnavaible              = &B00001011
    EGNP_CSE_DisconnectedFull                   = &B00001100
    EGNP_CSE_DisconnectedConnectionDenied       = &B00001101
    EGNP_CSE_Connecting                         = &B00010000
    EGNP_CSE_Connected                          = &B00010001
    EGNP_CSE_Ident                              = &B00100000
    EGNP_CSE_Login                              = &B01000000
    EGNP_CSE_Ready                              = &B10000000
End Enum



'####################################################################################################################################################
Enum EGNP_MessageType_Enum
    EGNP_MTE_Regular                            = 0
    EGNP_MTE_Private
    EGNP_MTE_Notice
    EGNP_MTE_Hightlighted
End Enum



'####################################################################################################################################################
Enum EGNP_AccountPermissions_Enum
    EGNP_APE_AnonymouseUser                     = &B00000000000000000000000000000000
    EGNP_APE_Registered                         = &B00000000000000000000000000000001
    EGNP_APE_Banned                             = &B00000000000000000000000000000010
    EGNP_APE_Owner                              = &B00000000000000000000000000010000
    EGNP_APE_Moderator                          = &B00000000000000000000000000100000
    EGNP_APE_SuperModerator                     = &B00000000000000000000000001000000
    EGNP_APE_Administrator                      = &B00000000000000000000000010000000
End Enum



'####################################################################################################################################################
Type EGNP_Callback_Type
    V_StateConnection                           as Sub  (V_ClientID as UInteger, V_State as EGNP_INT_ClientState_Enum)
    V_StateUser                                 as Sub  (V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr)
    V_Message                                   as Sub  (V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Message as String, V_MessageType as EGNP_MessageType_Enum, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)
    V_Data                                      as Sub  (V_FromUserID as UInteger, V_ToUserID as UInteger, ByRef V_Data as String, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr)

    V_Server_ConnectionRequest                  as Sub  (V_ServerID as UInteger, V_IPA as String, ByRef R_Cancel as Integer)
    V_Server_StateUser                          as Sub  (V_ServerID as UInteger, V_UserID as UInteger, V_State as EGNP_INT_UserState_Enum, ByRef RV_MyPtr as Any Ptr, ByRef R_Cancel as Integer)
    V_Server_AccountAction                      as Sub  (V_ServerID as UInteger, V_UserID as UInteger, V_Action as EGNP_INT_AccountAction_Enum, ByRef V_Username as String, ByRef RV_UserFlags as EGNP_AccountPermissions_Enum, ByRef RV_MyPtr as Any Ptr, ByRef R_Cancel as Integer)
    V_Server_Message                            as Sub  (V_ServerID as UInteger, V_FromUserID as UInteger, ByRef V_ToUserID as UInteger, ByRef V_Message as String, ByRef V_MessageType as EGNP_MessageType_Enum, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
    V_Server_Data                               as Sub  (V_ServerID as UInteger, V_FromUserID as UInteger, ByRef V_ToUserID as UInteger, ByRef V_Data as String, ByRef RV_FromMyPtr as Any Ptr, ByRef RV_ToMyPtr as Any Ptr, ByRef R_Cancel as Integer)
End Type



'####################################################################################################################################################
Enum EGNP_ServerFlags_Enum
    EGNP_SFE_Serverpass                         = &B00000000000000000000000000000001
    EGNP_SFE_Account                            = &B00000000000000000000000000000010
End Enum



'####################################################################################################################################################
Type EGNP_User_Type
    V_Next                                      as EGNP_User_Type Ptr
    V_Prev                                      as EGNP_User_Type Ptr

    V_ClientID                                  as UInteger
    V_Nickname                                  as String
    V_UserFlags                                 as EGNP_AccountPermissions_Enum
    V_MyPtr                                     as Any Ptr
End Type



'####################################################################################################################################################
Type EGNP_INT_ClientAnswer_Type
    V_Next                                      as EGNP_INT_ClientAnswer_Type Ptr
    V_Prev                                      as EGNP_INT_ClientAnswer_Type Ptr

    V_TimeOut                                   as Double
    V_Serial                                    as Double
    V_CMD                                       as EGNP_INT_CMD_Enum
    V_Answer                                    as String
End Type

Type EGNP_INT_Client_Type
    V_Next                                      as EGNP_INT_Client_Type Ptr
    V_Prev                                      as EGNP_INT_Client_Type Ptr

    V_TSNEIDTCP                                 as UInteger
    V_TSNEIDUDPRX                               as UInteger
    V_TSNEIDUDPTX                               as UInteger

    V_DataTCP                                   as String
    V_DataUDP                                   as String

    V_Callbacks                                 as EGNP_Callback_Type
    V_State                                     as EGNP_INT_ClientState_Enum
    V_LCMD                                      as EGNP_INT_CMD_Enum

    V_Host                                      as String
    V_PortTCP                                   as UShort
    V_PortUDP                                   as UShort
    V_Nickname                                  as String
    V_PasswordServer                            as String
    V_Username                                  as String
    V_Password                                  as String
    V_AutoReconnect                             as Integer

    V_ServerName                                as String
    V_ServerDescription                         as String
    V_ServerMaxPlayer                           as UShort
    V_ServerPublic                              as Integer
    V_ServerUseServerPass                       as Integer
    V_ServerUseAccount                          as Integer

    V_CryptKeyRX                                as String
    V_CryptKeyTX                                as String

    V_MyID                                      as UInteger

    V_UserF                                     as EGNP_User_Type Ptr
    V_UserL                                     as EGNP_User_Type Ptr

    V_AnswerF                                   as EGNP_INT_ClientAnswer_Type Ptr
    V_AnswerL                                   as EGNP_INT_ClientAnswer_Type Ptr

'   V_LSerialMsg                                as ULongInt
'   V_LSerialDat                                as ULongInt
'   V_LSerialDbl                                as ULongInt
'   V_LSerialInt                                as ULongInt
End Type

Dim Shared EGNP_INT_Client_F                    as EGNP_INT_Client_Type Ptr
Dim Shared EGNP_INT_Client_L                    as EGNP_INT_Client_Type Ptr



'####################################################################################################################################################
Type EGNP_INT_Server_Type_ as EGNP_INT_Server_Type

Type EGNP_INT_ServerClient_Type
    V_Next                                      as EGNP_INT_ServerClient_Type Ptr
    V_Prev                                      as EGNP_INT_ServerClient_Type Ptr

    V_Server                                    as EGNP_INT_Server_Type_ Ptr

    V_TSNEID                                    as UInteger
    V_TimeCon                                   as Double
    V_TimeOut                                   as Double
    V_TimePing                                  as Double
    V_IPA                                       as String

    V_PingC                                     as Integer
    V_DataTCP                                   as String
    V_DataUDP                                   as String

    V_State                                     as EGNP_INT_ClientState_Enum

    V_Nickname                                  as String
    V_NicknameL                                 as String
    V_Username                                  as String
    V_UserFlags                                 as EGNP_AccountPermissions_Enum
    V_MyPtr                                     as Any Ptr

    V_PPKLen                                    as Integer
    V_PPKPri                                    as String
    V_PPKPub                                    as String
    V_PPKSum                                    as String
    V_PPKMix                                    as String
    V_CryptKeyRX                                as String
    V_CryptKeyTX                                as String
End Type

Type EGNP_Account_Type
    V_ClientID                                  as UInteger
    V_Username                                  as String
    V_Nickname                                  as String
    V_UserFlags                                 as EGNP_AccountPermissions_Enum
End Type

Type EGNP_INT_Account_Type
    V_Next                                      as EGNP_INT_Account_Type Ptr
    V_Prev                                      as EGNP_INT_Account_Type Ptr

    V_Username                                  as String
    V_UsernameL                                 as String
    V_Password                                  as String
    V_Nickname                                  as String
    V_UserFlags                                 as EGNP_AccountPermissions_Enum
End Type

Type EGNP_INT_Server_Type
    V_Next                                      as EGNP_INT_Server_Type Ptr
    V_Prev                                      as EGNP_INT_Server_Type Ptr

    V_CreateTime                                as Double

    V_GameName                                  as String
    V_GameVersion                               as UInteger

    V_PortTCP                                   as UShort
    V_PortUDP                                   as UShort

    V_Callbacks                                 as EGNP_Callback_Type
    V_Password                                  as String
    V_MaxPlayer                                 as UShort
    V_Public                                    as Integer
    V_UseAccounts                               as Integer
    V_Name                                      as String
    V_Description                               as String

    V_AccountF                                  as EGNP_INT_Account_Type Ptr
    V_AccountL                                  as EGNP_INT_Account_Type Ptr
    V_AccountFile                               as String

    V_ClientF                                   as EGNP_INT_ServerClient_Type Ptr
    V_ClientL                                   as EGNP_INT_ServerClient_Type Ptr
    V_ClientC                                   as UInteger

    V_Enabled                                   as Integer

    V_PublicUpdate                              as Integer
    V_PublicKey                                 as String
    V_PublicTime                                as Double

    V_TSNEIDTCP                                 as UInteger
    V_TSNEIDUDPRX                               as UInteger
    V_TSNEIDUDPTX                               as UInteger

End Type

Dim Shared EGNP_INT_Server_F                    as EGNP_INT_Server_Type Ptr
Dim Shared EGNP_INT_Server_L                    as EGNP_INT_Server_Type Ptr


'####################################################################################################################################################
Dim Shared EGNP_INT_CMDSerial                   as Double



'####################################################################################################################################################
Function EGNP_INT_GETCMDDESC(V_CMDCode as Integer) as String
Select Case V_CMDCode
    Case EGNP_GURU_Unknown                          : Return "[    0] UNKNOWN"
    Case EGNP_GURU_NoError                          : Return "[    1] E-NO   "
    Case EGNP_GURU_ParameterError                   : Return "[-1000] E-PARAM"
    Case EGNP_GURU_IDnotFound                       : Return "[-1001] IDnotFo"
    Case EGNP_GURU_NothingSelected                  : Return "[-1002] NotiSel"
    Case EGNP_GURU_InternalError                    : Return "[-1900] E-INT  "
    Case EGNP_GURU_DATALenError                     : Return "[-1901] E-DATLE"
    Case EGNP_GURU_Timeout                          : Return "[-1902] TIMEOUT"
    Case EGNP_GURU_UnknownCMD                       : Return "[-1903] UnkoCMD"
    Case EGNP_GURU_CantConnect                      : Return "[-1904] CantCon"
    Case EGNP_GURU_ExternalError                    : Return "[-1905] E-EXT  "
    Case EGNP_GURU_CantOpenFile                     : Return "[-1906] CantOpe"
    Case EGNP_GURU_TransmissionError                : Return "[-1907] E-Trans"
    Case EGNP_GURU_ParseLenError                    : Return "[-1908] E-PaLen"
    Case EGNP_GURU_LoginDenied                      : Return "[-1910] Log-Den"
    Case EGNP_GURU_NickDenied                       : Return "[-1911] Nic-Den"
    Case EGNP_GURU_CommandDenied                    : Return "[-1912] CMD-Den"
    Case EGNP_CMD_ServerUnavaible                   : Return "[ 1100] Unavaib"
    Case EGNP_CMD_ServerOffline                     : Return "[ 1101] Offline"
    Case EGNP_CMD_ServerFull                        : Return "[ 1102] Full   "
    Case EGNP_CMD_ServerConnectionDenied            : Return "[ 1103] Con-Den"
    Case EGNP_CMD_Ping                              : Return "[ 1190] PING   "
    Case EGNP_CMD_Pong                              : Return "[ 1191] PONG   "
    Case EGNP_CMD_Crypt1                            : Return "[ 1200] Crypt-1"
    Case EGNP_CMD_Crypt2                            : Return "[ 1201] Crypt-2"
    Case EGNP_CMD_Crypt3                            : Return "[ 1202] Crypt-3"
    Case EGNP_CMD_Ident                             : Return "[ 1203] Ident  "
    Case EGNP_CMD_ServerAlternative                 : Return "[ 1204] SerAlt "
    Case EGNP_CMD_ServerList                        : Return "[ 1205] SerL   "
    Case EGNP_CMD_ServerListAdd                     : Return "[ 1206] SerLAdd"
    Case EGNP_CMD_ServerListReady                   : Return "[ 1207] SerLRed"
    Case EGNP_CMD_ServerListUpdate                  : Return "[ 1208] SerLUpd"
    Case EGNP_CMD_AccCreate                         : Return "[ 1210] AccCrea"
    Case EGNP_CMD_AccDestroy                        : Return "[ 1211] AccDest"
    Case EGNP_CMD_AccLogin                          : Return "[ 1212] AccLogi"
    Case EGNP_CMD_AccList                           : Return "[ 1213] AccList"
    Case EGNP_CMD_AccSetFlags                       : Return "[ 1213] AccSFla"
    Case EGNP_CMD_AccSetNick                        : Return "[ 1213] AccNick"
    Case EGNP_CMD_AccSetPass                        : Return "[ 1213] AccPass"
    Case EGNP_CMD_Ready                             : Return "[ 1300] Ready  "
    Case EGNP_CMD_UserLeave                         : Return "[ 1400] UsrLeav"
    Case EGNP_CMD_UserKick                          : Return "[ 1401] UsrKick"
    Case EGNP_CMD_UserJoin                          : Return "[ 1402] UsrJoin"
    Case EGNP_CMD_UserMessage                       : Return "[ 1403] UsrMsg "
    Case EGNP_CMD_UserData                          : Return "[ 1404] UsrData"
    Case EGNP_CMD_ScoreList                         : Return "[ 1420] ScorLis"
    Case EGNP_CMD_ScoreAdd                          : Return "[ 1421] ScorAdd"
    Case Else                                       : Return "[" & Space(5 - Len(Str(V_CMDCode))) & Str(V_CMDCode) & "        "
End Select
End Function



'####################################################################################################################################################
Function EGNP_GetGURUDescription(V_GURU as EGNP_GURU_Enum) as String
Select Case V_GURU
    Case EGNP_GURU_ParameterError               : Return "Parametererror"
    Case EGNP_GURU_IDnotFound                   : Return "ID not found"
    Case EGNP_GURU_NothingSelected              : Return "Nothing selected"

    Case EGNP_GURU_InternalError                : Return "Internal error"
    Case EGNP_GURU_DATALenError                 : Return "DATALEN error"
    Case EGNP_GURU_Timeout                      : Return "Timeout"
    Case EGNP_GURU_UnknownCMD                   : Return "Unknown CMD"
    Case EGNP_GURU_ParseLenError                : Return "PARAMETERDATALEN error"

    Case EGNP_CMD_ServerUnavaible               : Return "Server unavaible"
    Case EGNP_CMD_ServerOffline                 : Return "Server offline"
    Case EGNP_CMD_ServerFull                    : Return "Server full"
    Case EGNP_GURU_CantConnect                  : Return "Can't connect"

    Case EGNP_GURU_ExternalError                : Return "External error"
    Case EGNP_GURU_CantOpenFile                 : Return "Can't open file"
    Case EGNP_GURU_TransmissionError            : Return "Transmission error"

    Case EGNP_GURU_LoginDenied                  : Return "Login denied"
    Case EGNP_GURU_NickDenied                   : Return "Nickname in use or not allowed to use"
    Case EGNP_GURU_CommandDenied                : Return "Command denied"
    Case EGNP_GURU_UsernameDenied               : Return "Username in use or not allowed to use"

    Case EGNP_CMD_ServerUnavaible               : Return "Server unavaible"
    Case EGNP_CMD_ServerOffline                 : Return "Server offline"
    Case EGNP_CMD_ServerFull                    : Return "Server full"
    Case EGNP_CMD_ServerConnectionDenied        : Return "Connection denied"
    Case Else: Return TSNE_GetGURUCode(V_GURU)
End Select
End Function


Function EGNP_GetConnectionStateDescription(V_State as EGNP_INT_ClientState_Enum) as String
Select Case V_State
    Case EGNP_CSE_Unknown                       : Return "Unknown."
    Case EGNP_CSE_Disconnected                  : Return "Disconnected."
    Case EGNP_CSE_DisconnectedTimeout           : Return "Disconnected. Timeout."
    Case EGNP_CSE_DisconnectedUnavaible         : Return "Disconnected. Server unavaible."
    Case EGNP_CSE_DisconnectedFull              : Return "Disconnected. Server full."
    Case EGNP_CSE_DisconnectedConnectionDenied  : Return "Disconnected. Connection denied."
    Case EGNP_CSE_Connecting                    : Return "Connecting..."
    Case EGNP_CSE_Connected                     : Return "Connected!"
    Case EGNP_CSE_Ready                         : Return "Ready!"

    Case Else: Return "Unknown connection state!"
End Select
End Function


Function EGNP_GetUserStateDescription(V_State as EGNP_INT_UserState_Enum) as String
Select Case V_State
    Case EGNP_USE_Unknown                       : Return "Unknown."
    Case EGNP_USE_Leave                         : Return "Leave."
    Case EGNP_USE_Kicked                        : Return "Kicked."
    Case EGNP_USE_Join                          : Return "Join."

    Case Else: Return "Unknown user state!"
End Select
End Function


Function EGNP_GetAccountActionDescription(V_Action as EGNP_INT_AccountAction_Enum) as String
Select Case V_Action
    Case EGNP_AAE_Unknown                       : Return "Unknown."
    Case EGNP_AAE_Login                         : Return "Login."
    Case EGNP_AAE_Create                        : Return "Create."
    Case EGNP_AAE_Destroy                       : Return "Destroy."
    Case EGNP_AAE_SetFlags                      : Return "SetFlags."

    Case Else: Return "Unknown user state!"
End Select
End Function



'####################################################################################################################################################
Function OSC_Crypt(ByVal V_Username as String, ByVal V_Passwort as String, ByVal V_Rechte as String, ByVal V_CryptDeep as UByte) as String
Dim V as Integer
Dim X as Integer
Dim Y as Integer
Dim Z as Integer
Dim T as String
Dim ASCIICode as UByte
For V = 1 to V_CryptDeep
    ASCIICode XOR= CByte((V_CryptDeep - V + 1) Mod 255)
    For X = 1 to Len(V_Username)
        ASCIICode XOR= V_Username[X - 1]
        For Y = 1 to Len(V_Passwort)
            ASCIICode XOR= V_Passwort[Y - 1]
            If Len(V_Rechte) > 0 then
                For Z = 1 to Len(V_Rechte)
                    ASCIICode XOR= V_Rechte[Z - 1]
                Next
            End If
            T += Chr(ASCIICode)
            ASCIICode XOR= CByte(X Mod 255)
        Next
    Next
Next
Return T
End Function



'####################################################################################################################################################
Function EGNP_INT_BuildCMD(V_CMD as EGNP_INT_CMD_Enum, V_Data as String = "") as String
Dim TLen as UInteger = 4 + Len(V_Data)
Return Chr((TLen shr 24) and 255, (TLen shr 16) and 255, (TLen shr 8) and 255, TLen and 255, (V_CMD shr 24) and 255, (V_CMD shr 16) and 255, (V_CMD shr 8) and 255, V_CMD and 255) & V_Data
End Function


Function EGNP_INT_BuildString(V_Data as String) as String
Dim TLen as UInteger = 4 + Len(V_Data)
Return Chr((TLen shr 24) and 255, (TLen shr 16) and 255, (TLen shr 8) and 255, TLen and 255) & V_Data
End Function


Function EGNP_INT_BuildUShort(V_Data as UShort) as String
Return Chr((V_Data shr 8) and 255, V_Data and 255)
End Function


Function EGNP_INT_BuildUInteger(V_Data as UInteger) as String
Return Chr((V_Data shr 24) and 255, (V_Data shr 16) and 255, (V_Data shr 8) and 255, V_Data and 255)
End Function


Function EGNP_INT_BuildDouble(V_Data as Double) as String
Dim T as String = Space(8)
*Cast(Double Ptr, @T[0]) = V_Data
Return T
End Function



'####################################################################################################################################################
Function EGNP_INT_GetString(ByRef RV_Data as String, ByRef R_Data as String) as EGNP_GURU_Enum
If Len(RV_Data) < 4 Then Return EGNP_GURU_ParseLenError
Dim TLen as UInteger = (RV_Data[0] shl 24) or (RV_Data[1] shl 16) or (RV_Data[2] shl 8) or RV_Data[3]
If TLen > &HFFFFF Then Return EGNP_GURU_ParseLenError
If Len(RV_Data) < TLen Then Return EGNP_GURU_ParseLenError
R_Data = Mid(RV_Data, 5, TLen - 4)
RV_Data = Mid(RV_Data, TLen + 1)
Return EGNP_GURU_NoError
End Function


Function EGNP_INT_GetUShort(ByRef RV_Data as String, ByRef R_Data as UShort) as EGNP_GURU_Enum
If Len(RV_Data) < 2 Then Return EGNP_GURU_ParseLenError
R_Data = (RV_Data[0] shl 8) or RV_Data[1]
RV_Data = Mid(RV_Data, 3)
Return EGNP_GURU_NoError
End Function


Function EGNP_INT_GetUInteger(ByRef RV_Data as String, ByRef R_Data as UInteger) as EGNP_GURU_Enum
If Len(RV_Data) < 4 Then Return EGNP_GURU_ParseLenError
R_Data = (RV_Data[0] shl 24) or (RV_Data[1] shl 16) or (RV_Data[2] shl 8) or RV_Data[3]
RV_Data = Mid(RV_Data, 5)
Return EGNP_GURU_NoError
End Function


Function EGNP_INT_GetDouble(ByRef RV_Data as String, ByRef R_Data as Double) as EGNP_GURU_Enum
If Len(RV_Data) < 8 Then Return EGNP_GURU_ParseLenError
R_Data = *Cast(Double Ptr, @RV_Data[0])
RV_Data = Mid(RV_Data, 9)
Return EGNP_GURU_NoError
End Function



'####################################################################################################################################################
Function EGNP_INT_AsyncSendToOne(V_TSNEID as UInteger, V_Data as String, V_Async as Integer = 1) as Integer
'If Len(V_Data) >= 8 Then
'   Dim TCMD as EGNP_INT_CMD_Enum
'   TCMD = (V_Data[4] shl 24) or (V_Data[5] shl 16) or (V_Data[6] shl 8) or V_Data[7]
'   Print #1, "OUT >" & EGNP_INT_GETCMDDESC(TCMD) & "<___>" & Len(V_Data) & "<"
'Else: Print #1, "OUT >[?????]        <___>" & Len(V_Data) & "<"
'End If
Return TSNE_Data_Send(V_TSNEID, V_Data)
Return TSNE_Data_Send(V_TSNEID, V_Data, , , , V_Async)
End Function



Sub EGNP_INT_AsyncSendToAll(V_ServerPtr as EGNP_INT_Server_Type Ptr, V_Data as String)
If V_ServerPtr = 0 Then Exit Sub
Dim TCPtr as EGNP_INT_ServerClient_Type Ptr = V_ServerPtr->V_ClientF
Do Until TCPtr = 0
    If (TCPtr->V_State and EGNP_CSE_Ready) = 0 Then TCPtr = TCPtr->V_Next: Continue Do
    TSNE_Data_Send(TCPtr->V_TSNEID, V_Data, , , , 1)
    TCPtr = TCPtr->V_Next
Loop
End Sub


'####################################################################################################################################################
Function EGNP_INT_User_Add(V_ClientPtr as EGNP_INT_Client_Type Ptr, V_ClientID as UInteger, V_Nickname as String, V_UserFlags as EGNP_AccountPermissions_Enum) as EGNP_User_Type Ptr
If V_ClientPtr = 0 Then Return 0
With *V_ClientPtr
    If .V_UserL <> 0 Then
        .V_UserL->V_Next = CAllocate(SizeOf(EGNP_User_Type))
        .V_UserL->V_Next->V_Prev = .V_UserL
        .V_UserL = .V_UserL->V_Next
    Else
        .V_UserL = CAllocate(SizeOf(EGNP_User_Type))
        .V_UserF = .V_UserL
    End If
    With *.V_UserL
        .V_ClientID     = V_ClientID
        .V_Nickname     = V_Nickname
        .V_UserFlags    = V_UserFlags
    End With
    Return .V_UserL
End With
End Function


Function EGNP_INT_User_Get(V_ClientPtr as EGNP_INT_Client_Type Ptr, V_ClientID as UInteger) as EGNP_User_Type Ptr
If V_ClientPtr = 0 Then Return 0
Dim TCPtr as EGNP_User_Type Ptr = V_ClientPtr->V_UserF
Do Until TCPtr = 0
    If TCPtr->V_ClientID = V_ClientID Then Return TCPtr
    TCPtr = TCPtr->V_Next
Loop
Return 0
End Function


Sub EGNP_INT_User_Del(V_ClientPtr as EGNP_INT_Client_Type Ptr, V_ClientID as UInteger)
Dim TCPtr as EGNP_User_Type Ptr = EGNP_INT_User_Get(V_ClientPtr, V_ClientID)
If TCPtr = 0 Then Exit Sub
If TCPtr->V_Next <> 0 Then TCPtr->V_Next->V_Prev = TCPtr->V_Prev
If TCPtr->V_Prev <> 0 Then TCPtr->V_Prev->V_Next = TCPtr->V_Next
If V_ClientPtr->V_UserF = TCPtr Then V_ClientPtr->V_UserF = TCPtr->V_Next
If V_ClientPtr->V_UserL = TCPtr Then V_ClientPtr->V_UserL = TCPtr->V_Prev
DeAllocate(TCPtr)
End Sub



'####################################################################################################################################################
Function EGNP_INT_Client_GetByID(V_ServerPtr as EGNP_INT_Server_Type Ptr, V_ClientID as UInteger) as EGNP_INT_ServerClient_Type Ptr
If V_ServerPtr = 0 Then Return 0
Dim TSPtr as EGNP_INT_ServerClient_Type Ptr = Cast(EGNP_INT_ServerClient_Type Ptr, V_ClientID)
Dim TCPtr as EGNP_INT_ServerClient_Type Ptr = V_ServerPtr->V_ClientF
Do Until TCPtr = 0
    If TCPtr = TSPtr Then Return TCPtr
    TCPtr = TCPtr->V_Next
Loop
Return 0
End Function



'####################################################################################################################################################
Function EGNP_INT_Server_AccountAdd(V_ServerPtr as EGNP_INT_Server_Type Ptr, V_Username as String, V_Password as String, V_Nickname as String, V_Flags as EGNP_AccountPermissions_Enum = EGNP_APE_Registered) as EGNP_GURU_Enum
If V_ServerPtr = 0 Then Return EGNP_GURU_ParameterError
If V_Username = "" Then Return EGNP_GURU_ParameterError
If V_Password = "" Then Return EGNP_GURU_ParameterError
If V_Nickname = "" Then Return EGNP_GURU_ParameterError
Dim S as String = LCase(V_Username)
If V_ServerPtr->V_UseAccounts <> 1 Then Return EGNP_GURU_ParameterError
If V_ServerPtr->V_AccountFile = "" Then Return EGNP_GURU_ParameterError
Dim TAPtr as EGNP_INT_Account_Type Ptr = V_ServerPtr->V_AccountF
Do Until TAPtr = 0
    If TAPtr->V_UsernameL = S Then Return EGNP_GURU_UsernameDenied
    TAPtr = TAPtr->V_Next
Loop
Dim T as String
T += EGNP_INT_BuildUInteger(0)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildString(V_Password)
T += EGNP_INT_BuildString(V_Nickname)
Dim TLen as UInteger = Len(T)
Dim TFN as Integer = FreeFile()
If Open(V_ServerPtr->V_AccountFile for Append as #TFN) <> 0 Then Return EGNP_GURU_CantOpenFile
Print #TFN, Chr((TLen Shr 24) and 255, (TLen Shr 16) and 255, (TLen Shr 8) and 255, TLen and 255) & T;
Close #TFN
With *V_ServerPtr
    If .V_AccountL <> 0 Then
        .V_AccountL->V_Next = CAllocate(SizeOf(EGNP_INT_Account_Type))
        .V_AccountL->V_Next->V_Prev = .V_AccountL
        .V_AccountL = .V_AccountL->V_Next
    Else
        .V_AccountL = CAllocate(SizeOf(EGNP_INT_Account_Type))
        .V_AccountF = .V_AccountL
    End If
    With *.V_AccountL
        .V_Username     = V_Username
        .V_UsernameL    = LCase(.V_Username)
        .V_Password     = V_Password
        .V_Nickname     = V_Nickname
        .V_UserFlags    = EGNP_APE_Registered or V_Flags
    End With
End With
Return EGNP_GURU_NoError
End Function


Function EGNP_INT_Server_AccountRestore(V_ServerPtr as EGNP_INT_Server_Type Ptr) as EGNP_GURU_Enum
If V_ServerPtr = 0 Then Return EGNP_GURU_ParameterError
Dim T as String
Dim D as String
Dim TLen as UInteger
If V_ServerPtr->V_AccountFile = "" Then Return EGNP_GURU_ParameterError
If Kill(V_ServerPtr->V_AccountFile) <> 0 Then Return EGNP_GURU_CantOpenFile
Dim TFN as Integer = FreeFile()
If Open(V_ServerPtr->V_AccountFile for Binary as #TFN) <> 0 Then Return EGNP_GURU_CantOpenFile
Dim TAPtr as EGNP_INT_Account_Type Ptr = V_ServerPtr->V_AccountF
Do Until TAPtr = 0
    With *TAPtr
        T = ""
        T += EGNP_INT_BuildUInteger(.V_UserFlags)
        T += EGNP_INT_BuildString(.V_Username)
        T += EGNP_INT_BuildString(.V_Password)
        T += EGNP_INT_BuildString(.V_Nickname)
        TLen = Len(T)
        D += Chr((TLen Shr 24) and 255, (TLen Shr 16) and 255, (TLen Shr 8) and 255, TLen and 255) & T
    End With
    TAPtr = TAPtr->V_Next
Loop
Print #TFN, D;
Close #TFN
Return EGNP_GURU_NoError
End Function



'####################################################################################################################################################
Sub EGNP_INT_Server_Disconnected(ByVal V_TSNEID as UInteger, ByVal V_ClientPtr as EGNP_INT_ServerClient_Type Ptr)
'Print "SDIS:" & Str(V_ClientPtr)
If V_ClientPtr = 0 Then Exit Sub
MutexLock(EGNP_INT_Mux)
Dim TDoCall as Integer = IIf((V_ClientPtr->V_State and EGNP_CSE_Ready) <> 0, 1, 0)
V_ClientPtr->V_State = EGNP_CSE_Disconnected
Dim TSPtr as EGNP_INT_Server_Type Ptr = V_ClientPtr->V_Server
If V_ClientPtr->V_Next <> 0 Then V_ClientPtr->V_Next->V_Prev = V_ClientPtr->V_Prev
If V_ClientPtr->V_Prev <> 0 Then V_ClientPtr->V_Prev->V_Next = V_ClientPtr->V_Next
If TSPtr->V_ClientF = V_ClientPtr Then TSPtr->V_ClientF = V_ClientPtr->V_Next
If TSPtr->V_ClientL = V_ClientPtr Then TSPtr->V_ClientL = V_ClientPtr->V_Prev
If TSPtr->V_ClientC > 0 Then TSPtr->V_ClientC -= 1
EGNP_INT_AsyncSendToAll(V_ClientPtr->V_Server, EGNP_INT_BuildCMD(EGNP_CMD_UserLeave, EGNP_INT_BuildUInteger(Cast(UInteger, V_ClientPtr))))
Dim TCallbacks as EGNP_Callback_Type = V_ClientPtr->V_Server->V_Callbacks
V_ClientPtr->V_Server->V_PublicUpdate = 1
Dim TServID as UInteger = Cast(UInteger, V_ClientPtr->V_Server)
MutexUnLock(EGNP_INT_Mux)
Dim TMyPtrFrom as Any Ptr = V_ClientPtr->V_MyPtr
Dim TCRV as Integer
If TDoCall = 1 Then If TCallbacks.V_Server_StateUser <> 0 Then TCallbacks.V_Server_StateUser(TServID, Cast(UInteger, V_ClientPtr), EGNP_USE_Leave, TMyPtrFrom, TCRV)
DeAllocate(V_ClientPtr)
End Sub


Sub EGNP_INT_Server_Connected(ByVal V_TSNEID as UInteger, ByVal V_ClientPtr as EGNP_INT_ServerClient_Type Ptr)
'Print "SCON"
If V_ClientPtr = 0 Then TSNE_Disconnect(V_TSNEID): Exit Sub
MutexLock(EGNP_INT_Mux)
V_ClientPtr->V_State = EGNP_CSE_Connected
Dim T as String
With *V_ClientPtr
    T += EGNP_INT_BuildString(.V_Server->V_Name)
    T += EGNP_INT_BuildString(.V_Server->V_Description)
    T += EGNP_INT_BuildUShort(.V_Server->V_MaxPlayer)
    T += Chr(IIf(.V_Server->V_Public = 1, 1, 0))
    T += Chr(IIf(.V_Server->V_UseAccounts = 1, 1, 0))
    T += Chr(IIf(.V_Server->V_Password <> "", 1, 0))
End With
MutexUnLock(EGNP_INT_Mux)
If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_Ident, T)) <> TSNE_Const_NoError Then TSNE_Disconnect(V_TSNEID)
End Sub


Sub EGNP_INT_Server_ConnectionDenied(ByVal V_TSNEID as UInteger, ByVal V_ClientPtr as EGNP_INT_ServerClient_Type Ptr)
'Print "SDEN"
EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(Cast(UInteger, V_ClientPtr)))
TSNE_Disconnect(V_TSNEID)
End Sub


Sub EGNP_INT_Server_NewData(ByVal V_TSNEID as UInteger, ByRef V_Data as String, ByVal V_ClientPtr as EGNP_INT_ServerClient_Type Ptr)
'Print "SDAT:" & Len(V_Data)
If V_ClientPtr = 0 Then TSNE_Disconnect(V_TSNEID): Exit Sub
Dim TLen as UInteger
Dim TCMD as EGNP_INT_CMD_Enum
Dim TData as String
Dim TData1 as String
Dim TS(1 to 4) as String
Dim TUI(1 to 6) as UInteger
Dim TD(1 to 3) as Double
Dim RV as EGNP_GURU_Enum
Dim T as String
Dim T1 as String
Dim TCPtr as EGNP_INT_ServerClient_Type Ptr
Dim TCPtrS as EGNP_INT_ServerClient_Type Ptr
Dim TCRV as Integer
Dim TCUID as UInteger
Dim TCallbacks as EGNP_Callback_Type
Dim TMyPtrFrom as Any Ptr
Dim TMyPtrTo as Any Ptr
Dim TAPtr as EGNP_INT_Account_Type Ptr
Dim TUFlags as EGNP_AccountPermissions_Enum
Dim TSerial as Double
Dim TOK as Integer
MutexLock(EGNP_INT_Mux)
With *V_ClientPtr
    TCUID = Cast(UInteger, V_ClientPtr)
    TCallbacks = .V_Server->V_Callbacks
    Dim TServID as UInteger = Cast(UInteger, .V_Server)
    .V_DataTCP += V_Data
    .V_TimeOut = Timer() + 60
    Do
        TCRV = 0
        If Len(.V_DataTCP) < 8 Then MutexUnLock(EGNP_INT_Mux): Exit Sub
        If Len(.V_DataTCP) > &HFFFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_DATALenError)): Exit Sub
        TLen = (.V_DataTCP[0] shl 24) or (.V_DataTCP[1] shl 16) or (.V_DataTCP[2] shl 8) or .V_DataTCP[3]
        If TLen > &HFFFFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_DATALenError)): Exit Sub
        If Len(.V_DataTCP) < TLen Then MutexUnLock(EGNP_INT_Mux): Exit Sub
        TCMD = (.V_DataTCP[4] shl 24) or (.V_DataTCP[5] shl 16) or (.V_DataTCP[6] shl 8) or .V_DataTCP[7]
        TData = Mid(.V_DataTCP, 9, TLen - 4)
        .V_DataTCP = Mid(.V_DataTCP, TLen + 5)
        'Print "IN  >" & EGNP_INT_GETCMDDESC(TCMD) & "<___>" & TLen & "<___>" & Len(TData) & "<___>" & Len(.V_DataTCP) & "<"
        Select Case TCMD
            Case EGNP_CMD_ServerOffline, EGNP_CMD_ServerFull: MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
            Case EGNP_CMD_Crypt1
                .V_PPKLen = 255
                .V_PPKPri = Space(.V_PPKLen)
                .V_PPKPub = Space(.V_PPKLen)
                .V_PPKSum = Space(.V_PPKLen)
                .V_PPKMix = Space(.V_PPKLen)
                For X as Integer = 0 to .V_PPKLen - 1
                    .V_PPKPri[X] = Int(Rnd * 255)
                    .V_PPKPub[X] = Int(Rnd * 255)
                Next
                T = ""
                T += EGNP_INT_BuildString(.V_PPKPub)

            Case EGNP_CMD_Crypt2
                For X as Integer = 0 to .V_PPKLen - 1
                    .V_PPKSum[X] = .V_PPKPub[X] xor .V_PPKPri[X]
                Next
                T = ""
                T += EGNP_INT_BuildString(.V_PPKSum)

            Case EGNP_CMD_Crypt3
                For X as Integer = 0 to .V_PPKLen - 1
                    .V_PPKSum[X] = .V_PPKSum[X] xor .V_PPKPri[X]
                Next

            Case EGNP_CMD_Ident
                If ((.V_State and EGNP_CSE_Ident) <> 0) or ((.V_State and EGNP_CSE_Ready) <> 0) Then
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                RV = EGNP_INT_GetString(TData, TS(1)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(2)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If .V_Server->V_Password <> TS(2) Then
                    MutexUnLock(EGNP_INT_Mux)
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                    TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                If Len(TS(1)) > &HFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                T1 = LCase(TS(1))
                TCPtr = V_ClientPtr->V_Server->V_ClientF
                Do Until TCPtr = 0
                    If TCPtr->V_NicknameL <> T1 Then TCPtr = TCPtr->V_Next: Continue Do
                    MutexUnLock(EGNP_INT_Mux)
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_NickDenied), 0)
                    TSNE_Disconnect(V_TSNEID): Exit Do
                Loop
                .V_Nickname = TS(1)
                .V_NicknameL = T1
                If .V_Server->V_UseAccounts = 0 Then
                    TMyPtrFrom = .V_MyPtr
                    MutexUnLock(EGNP_INT_Mux)
                    If TCallbacks.V_Server_StateUser <> 0 Then TCallbacks.V_Server_StateUser(TServID, TCUID, EGNP_USE_Join, TMyPtrFrom, TCRV)
                    If TCRV <> 0 Then
                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                        TSNE_Disconnect(V_TSNEID): Exit Do
                    End If
                    MutexLock(EGNP_INT_Mux)
                    .V_MyPtr = TMyPtrFrom
                    .V_State = EGNP_CSE_Connected or EGNP_CSE_Ident or EGNP_CSE_Ready
                    If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_Ready, EGNP_INT_BuildUInteger(TCUID)), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                    .V_Server->V_PublicUpdate = 1
                    T = ""
                    T += EGNP_INT_BuildUInteger(TCUID)
                    T += EGNP_INT_BuildString(.V_Nickname)
                    T += EGNP_INT_BuildUInteger(.V_UserFlags)
                    EGNP_INT_AsyncSendToAll(.V_Server, EGNP_INT_BuildCMD(EGNP_CMD_UserJoin, T))
                    T1 = ""
                    TCPtr = V_ClientPtr->V_Server->V_ClientF
                    Do Until TCPtr = 0
                        If TCPtr = V_ClientPtr Then TCPtr = TCPtr->V_Next: Continue Do
                        If (TCPtr->V_State and EGNP_CSE_Ready) = 0 Then TCPtr = TCPtr->V_Next: Continue Do
                        T = ""
                        T += EGNP_INT_BuildUInteger(Cast(UInteger, TCPtr))
                        T += EGNP_INT_BuildString(TCPtr->V_Nickname)
                        T += EGNP_INT_BuildUInteger(TCPtr->V_UserFlags)
                        T1 += EGNP_INT_BuildCMD(EGNP_CMD_UserJoin, T)
                        TCPtr = TCPtr->V_Next
                    Loop
                    If T1 <> "" Then If EGNP_INT_AsyncSendToOne(V_TSNEID, T1, 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                Else
                    .V_State = EGNP_CSE_Connected or EGNP_CSE_Ident
                    MutexUnLock(EGNP_INT_Mux)
                    For X as Integer = 1 to 100
                        'USleep 10000
                        Sleep 10, 1
                    Next
                    MutexLock(EGNP_INT_Mux)
                    If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_AccLogin), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                End If

            Case EGNP_CMD_AccLogin
                If ((.V_State and EGNP_CSE_Ident) = 0) or ((.V_State and EGNP_CSE_Ready) <> 0) Then
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                RV = EGNP_INT_GetString(TData, TS(1)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(2)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(1)) < 8        Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(2)) < 16       Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(1)) > &HFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(2)) > &HFFFF   Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                TMyPtrFrom = .V_MyPtr
                MutexUnLock(EGNP_INT_Mux)
                TUFlags = 0
                If TCallbacks.V_Server_AccountAction <> 0 Then TCallbacks.V_Server_AccountAction(TServID, TCUID, EGNP_AAE_Login, TS(1), TUFlags, TMyPtrFrom, TCRV)
                If TCRV <> 0 Then
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                    TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                MutexLock(EGNP_INT_Mux)
                .V_MyPtr = TMyPtrFrom
                TS(1) = LCase(TS(1))
                TAPtr = .V_Server->V_AccountF
                Do Until TAPtr = 0
                    If TAPtr->V_UsernameL = TS(1) Then
                        If TAPtr->V_Password <> TS(2) Then
                            EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                            MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Sub
                        End If
                        .V_Username = TAPtr->V_Username
                        .V_UserFlags = EGNP_APE_Registered or TAPtr->V_UserFlags or TUFlags
                        TMyPtrFrom = .V_MyPtr
                        MutexUnLock(EGNP_INT_Mux)
                        If TCallbacks.V_Server_StateUser <> 0 Then TCallbacks.V_Server_StateUser(TServID, TCUID, EGNP_USE_Join, TMyPtrFrom, TCRV)
                        If (.V_UserFlags and EGNP_APE_Banned) <> 0 Then TCRV = 1
                        If TCRV <> 0 Then
                            EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                            TSNE_Disconnect(V_TSNEID): Exit Do
                        End If
                        MutexLock(EGNP_INT_Mux)
                        .V_MyPtr = TMyPtrFrom
                        .V_State or= EGNP_CSE_Login or EGNP_CSE_Ready
                        If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_Ready, EGNP_INT_BuildUInteger(TCUID)), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                        .V_Server->V_PublicUpdate = 1
                        T = ""
                        T += EGNP_INT_BuildUInteger(TCUID)
                        T += EGNP_INT_BuildString(.V_Nickname)
                        T += EGNP_INT_BuildUInteger(.V_UserFlags)
                        EGNP_INT_AsyncSendToAll(.V_Server, EGNP_INT_BuildCMD(EGNP_CMD_UserJoin, T))
                        T1 = ""
                        TCPtr = V_ClientPtr->V_Server->V_ClientF
                        Do Until TCPtr = 0
                            If TCPtr = V_ClientPtr Then TCPtr = TCPtr->V_Next: Continue Do
                            If (TCPtr->V_State and EGNP_CSE_Ready) = 0 Then TCPtr = TCPtr->V_Next: Continue Do
                            T = ""
                            T += EGNP_INT_BuildUInteger(Cast(UInteger, TCPtr))
                            T += EGNP_INT_BuildString(TCPtr->V_Nickname)
                            T += EGNP_INT_BuildUInteger(TCPtr->V_UserFlags)
                            T1 += EGNP_INT_BuildCMD(EGNP_CMD_UserJoin, T)
                            TCPtr = TCPtr->V_Next
                        Loop
                        If T1 <> "" Then If EGNP_INT_AsyncSendToOne(V_TSNEID, T1, 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                        Exit Select
                    End If
                    TAPtr = TAPtr->V_Next
                Loop
                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                TSNE_Disconnect(V_TSNEID): Exit Do

            Case EGNP_CMD_AccCreate
                T = ""
                TOK = 0
                If ((.V_State and EGNP_CSE_Ident) = 0) or ((.V_State and EGNP_CSE_Ready) <> 0) Then
                    If .V_Server->V_UseAccounts = 0 Then
                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                        MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                    End If
                    If (.V_UserFlags and (EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                        MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                    End If
                    RV = EGNP_INT_GetDouble(TData, TSerial): If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                    T += EGNP_INT_BuildDouble(TSerial)
                    TOK = 1
                End If
                RV = EGNP_INT_GetString(TData, TS(1)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(2)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(3)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(1)) > &HFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(2)) > &HFFFF   Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TS(3)) > &HFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                TMyPtrFrom = .V_MyPtr
                MutexUnLock(EGNP_INT_Mux)
                If TCallbacks.V_Server_AccountAction <> 0 Then TCallbacks.V_Server_AccountAction(TServID, TCUID, EGNP_AAE_Create, TS(1), TUFlags, TMyPtrFrom, TCRV)
                If TCRV <> 0 Then
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_LoginDenied), 0)
                    TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                MutexLock(EGNP_INT_Mux)
                .V_MyPtr = TMyPtrFrom
                RV = EGNP_INT_Server_AccountAdd(.V_Server, TS(1), TS(2), TS(3))
                If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                If TOK = 0 Then
                    If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_AccLogin), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                Else: If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_AccCreate, T), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                End If

            Case Else
                If (.V_State and EGNP_CSE_Ready) = 0 Then
                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                End If
                Select Case TCMD
                    Case EGNP_CMD_Pong
                        .V_PingC = 0

                    Case EGNP_CMD_UserMessage
                        RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        RV = EGNP_INT_GetUInteger(TData, TUI(2)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        If Len(TS(1)) > &HFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        TCPtrS = EGNP_INT_Client_GetByID(.V_Server, TUI(1))
                        If TCPtrS <> 0 Then TMyPtrTo = TCPtrS->V_MyPtr Else TMyPtrTo = 0
                        TMyPtrFrom = .V_MyPtr
                        MutexUnLock(EGNP_INT_Mux)
                        If TCallbacks.V_Server_Message <> 0 Then TCallbacks.V_Server_Message(TServID, TCUID, TUI(1), TS(1), TUI(2), TMyPtrFrom, TMyPtrTo, TCRV)
                        MutexLock(EGNP_INT_Mux)
                        .V_MyPtr = TMyPtrFrom
                        If TCPtrS <> 0 Then TCPtrS->V_MyPtr = TMyPtrTo
                        If TCRV <> 0 Then Continue Do
                        TData1 = EGNP_INT_BuildUInteger(TCUID)
                        TData1 += EGNP_INT_BuildUInteger(TUI(1))
                        TData1 += EGNP_INT_BuildUInteger(TUI(2))
                        TData1 += EGNP_INT_BuildString(TS(1))
                        If TUI(1) <> 0 Then
                            TCPtrS = Cast(EGNP_INT_ServerClient_Type Ptr, TUI(1))
                            TCPtr = V_ClientPtr->V_Server->V_ClientF
                            Do Until TCPtr = 0
                                If TCPtr <> TCPtrS Then TCPtr = TCPtr->V_Next: Continue Do
                                If (TCPtr->V_State and EGNP_CSE_Ready) = 0 Then TCPtr = TCPtr->V_Next: Continue Do
                                EGNP_INT_AsyncSendToOne(TCPtr->V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_UserMessage, TData1))
                                Exit Do
                            Loop
                        Else: EGNP_INT_AsyncSendToAll(.V_Server, EGNP_INT_BuildCMD(EGNP_CMD_UserMessage, TData1))
                        End If

                    Case EGNP_CMD_UserData
                        RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        If Len(TS(1)) > &HFFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                        TCPtrS = EGNP_INT_Client_GetByID(.V_Server, TUI(1))
                        If TCPtrS <> 0 Then TMyPtrTo = TCPtrS->V_MyPtr Else TMyPtrTo = 0
                        TMyPtrFrom = .V_MyPtr
                        MutexUnLock(EGNP_INT_Mux)
                        If TCallbacks.V_Server_Data <> 0 Then TCallbacks.V_Server_Data(TServID, TCUID, TUI(1), TS(1), TMyPtrFrom, TMyPtrTo, TCRV)
                        MutexLock(EGNP_INT_Mux)
                        .V_MyPtr = TMyPtrFrom
                        If TCPtrS <> 0 Then TCPtrS->V_MyPtr = TMyPtrTo
                        If TCRV <> 0 Then Continue Do
                        TData1 = EGNP_INT_BuildUInteger(TCUID)
                        TData1 += EGNP_INT_BuildUInteger(TUI(1))
                        TData1 += EGNP_INT_BuildString(TS(1))
                        If TUI(1) <> 0 Then
                            TCPtrS = Cast(EGNP_INT_ServerClient_Type Ptr, TUI(1))
                            TCPtr = V_ClientPtr->V_Server->V_ClientF
                            Do Until TCPtr = 0
                                If TCPtr <> TCPtrS Then TCPtr = TCPtr->V_Next: Continue Do
                                If (TCPtr->V_State and EGNP_CSE_Ready) = 0 Then TCPtr = TCPtr->V_Next: Continue Do
                                EGNP_INT_AsyncSendToOne(TCPtr->V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_UserData, TData1))
                                Exit Do
                            Loop
                        Else: EGNP_INT_AsyncSendToAll(.V_Server, EGNP_INT_BuildCMD(EGNP_CMD_UserData, TData1))
                        End If
                    Case EGNP_GURU_UnknownCMD

                    Case Else
                        If .V_Server->V_UseAccounts = 0 Then
                            EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                            MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                        End If
                        If (.V_UserFlags and EGNP_APE_Registered) = 0 Then
                            EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                            MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                        End If
                        RV = EGNP_INT_GetDouble(TData, TSerial): If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                        Select Case TCMD
                            Case EGNP_CMD_AccList
                                If (.V_UserFlags and (EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                End If
                                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TS(1) = LCase(TS(1))
                                T = ""
                                T += EGNP_INT_BuildDouble(TSerial)
                                TAPtr = .V_Server->V_AccountF
                                Do Until TAPtr = 0
                                    If TS(1) <> "" Then If TS(1) <> TAPtr->V_UsernameL Then TAPtr = TAPtr->V_Next: Continue Do
                                    TCPtr = .V_Server->V_ClientF
                                    Do Until TCPtr = 0
                                        If TCPtr->V_Username = TAPtr->V_Username Then Exit Do
                                        TCPtr = TCPtr->V_Next
                                    Loop
                                    If TCPtr <> 0 Then
                                        T += EGNP_INT_BuildUInteger(Cast(UInteger, TCPtr))
                                    Else: T += EGNP_INT_BuildUInteger(TAPtr->V_UserFlags)
                                    End If
                                    T += EGNP_INT_BuildString(TAPtr->V_Username)
                                    T += EGNP_INT_BuildString(TAPtr->V_Nickname)
                                    T += EGNP_INT_BuildUInteger(TAPtr->V_UserFlags)
                                    TAPtr = TAPtr->V_Next
                                Loop
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_AccList, T), 0)

                            Case EGNP_CMD_AccDestroy
                                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(1)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TS(1) = LCase(TS(1))
                                If LCase(.V_Username) <> TS(1) Then
                                    If (.V_UserFlags and EGNP_APE_Administrator) = 0 Then
                                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                        MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                    End If
                                End If
                                TAPtr = .V_Server->V_AccountF
                                Do Until TAPtr = 0
                                    If TS(1) = TAPtr->V_UsernameL Then Exit Do
                                    TAPtr = TAPtr->V_Next
                                Loop
                                If TAPtr = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If TAPtr->V_Next <> 0 Then TAPtr->V_Next->V_Prev = TAPtr->V_Prev
                                If TAPtr->V_Prev <> 0 Then TAPtr->V_Prev->V_Next = TAPtr->V_Next
                                If .V_Server->V_AccountF = TAPtr Then .V_Server->V_AccountF = TAPtr->V_Next
                                If .V_Server->V_AccountL = TAPtr Then .V_Server->V_AccountL = TAPtr->V_Prev
                                DeAllocate(TAPtr)
                                RV = EGNP_INT_Server_AccountRestore(.V_Server)
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(TCMD, EGNP_INT_BuildDouble(TSerial) & EGNP_INT_BuildUInteger(RV)), 0)

                            Case EGNP_CMD_AccSetFlags
                                If (.V_UserFlags and (EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                End If
                                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(1)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TS(1) = LCase(TS(1))
                                TAPtr = .V_Server->V_AccountF
                                Do Until TAPtr = 0
                                    If TS(1) = TAPtr->V_UsernameL Then Exit Do
                                    TAPtr = TAPtr->V_Next
                                Loop
                                If TAPtr = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TAPtr->V_UserFlags = EGNP_APE_Registered or TUI(1)
                                RV = EGNP_INT_Server_AccountRestore(.V_Server)
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(TCMD, EGNP_INT_BuildDouble(TSerial) & EGNP_INT_BuildUInteger(RV)), 0)

                            Case EGNP_CMD_AccSetNick
                                If LCase(.V_Username) <> TS(1) Then
                                    If (.V_UserFlags and (EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                        MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                    End If
                                End If
                                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                RV = EGNP_INT_GetString(TData, TS(2)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(1)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(2)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TS(1) = LCase(TS(1))
                                TAPtr = .V_Server->V_AccountF
                                Do Until TAPtr = 0
                                    If TS(1) = TAPtr->V_UsernameL Then Exit Do
                                    TAPtr = TAPtr->V_Next
                                Loop
                                If TAPtr = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TAPtr->V_Nickname = TS(2)
                                RV = EGNP_INT_Server_AccountRestore(.V_Server)
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(TCMD, EGNP_INT_BuildDouble(TSerial) & EGNP_INT_BuildUInteger(RV)), 0)

                            Case EGNP_CMD_AccSetPass
                                If LCase(.V_Username) <> TS(1) Then
                                    If (.V_UserFlags and (EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                                        EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                        MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                    End If
                                End If
                                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                RV = EGNP_INT_GetString(TData, TS(2)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(1)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                If Len(TS(2)) = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TS(1) = LCase(TS(1))
                                TAPtr = .V_Server->V_AccountF
                                Do Until TAPtr = 0
                                    If TS(1) = TAPtr->V_UsernameL Then Exit Do
                                    TAPtr = TAPtr->V_Next
                                Loop
                                If TAPtr = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TAPtr->V_Password = TS(2)
                                RV = EGNP_INT_Server_AccountRestore(.V_Server)
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(TCMD, EGNP_INT_BuildDouble(TSerial) & EGNP_INT_BuildUInteger(RV)), 0)

                            Case EGNP_CMD_UserKick
                                If (.V_UserFlags and (EGNP_APE_Moderator or EGNP_APE_SuperModerator or EGNP_APE_Administrator)) = 0 Then
                                    EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_CommandDenied), 0)
                                    MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                                End If
                                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TCPtr = EGNP_INT_Client_GetByID(.V_Server, TUI(1))
                                If TCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_ParameterError), 0): TSNE_Disconnect(V_TSNEID): Exit Sub
                                TSNE_Disconnect(TCPtr->V_TSNEID)
                                EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(TCMD, EGNP_INT_BuildDouble(TSerial) & EGNP_INT_BuildUInteger(RV)), 0)

                            Case Else: If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_UnknownCMD), 0) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
                        End Select
                End Select
        End Select
    Loop
End With
MutexUnLock(EGNP_INT_Mux)
End Sub


Sub EGNP_INT_Server_NewConnection(ByVal V_TSNEID as UInteger, ByVal V_RequestID as Socket, ByVal V_IPA as String)
Dim RV as Integer
Dim TTSNEID as UInteger
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_F
Do Until TSPtr = 0
    If TSPtr->V_TSNEIDTCP = V_TSNEID Then Exit Do
    TSPtr = TSPtr->V_Next
Loop
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): TSNE_Create_Accept(V_RequestID, TTSNEID, "", 0, @EGNP_INT_Server_ConnectionDenied, 0, , , , Cast(Any Ptr, EGNP_GURU_InternalError)): Exit Sub
Dim TServID as UInteger = Cast(UInteger, TSPtr)
Dim TCRV as Integer
With *TSPtr
    If .V_Callbacks.V_Server_ConnectionRequest <> 0 Then .V_Callbacks.V_Server_ConnectionRequest(TServID, V_IPA, TCRV)
    If TCRV <> 0 Then MutexUnLock(EGNP_INT_Mux): TSNE_Create_Accept(V_RequestID, TTSNEID, "", 0, @EGNP_INT_Server_ConnectionDenied, 0, , , , Cast(Any Ptr, EGNP_CMD_ServerConnectionDenied)): Exit Sub
    If .V_Enabled = 0 Then MutexUnLock(EGNP_INT_Mux): TSNE_Create_Accept(V_RequestID, TTSNEID, "", 0, @EGNP_INT_Server_ConnectionDenied, 0, , , , Cast(Any Ptr, EGNP_CMD_ServerOffline)): Exit Sub
    If .V_ClientC >= .V_MaxPlayer Then MutexUnLock(EGNP_INT_Mux): TSNE_Create_Accept(V_RequestID, TTSNEID, "", 0, @EGNP_INT_Server_ConnectionDenied, 0, , , , Cast(Any Ptr, EGNP_CMD_ServerFull)): Exit Sub
    Dim TCPtr as EGNP_INT_ServerClient_Type Ptr = CAllocate(SizeOf(EGNP_INT_ServerClient_Type))
    Dim TIPA as String
    RV = TSNE_Create_Accept(V_RequestID, TTSNEID, TIPA, @EGNP_INT_Server_Disconnected, @EGNP_INT_Server_Connected, @EGNP_INT_Server_NewData, , , , TCPtr)
    If RV <> TSNE_Const_NoError Then DeAllocate(TCPtr): Exit Sub
    If .V_ClientL <> 0 Then
        .V_ClientL->V_Next = TCPtr
        .V_ClientL->V_Next->V_Prev = .V_ClientL
        .V_ClientL = .V_ClientL->V_Next
    Else
        .V_ClientL = TCPtr
        .V_ClientF = .V_ClientL
    End If
    .V_ClientC += 1
    With *.V_ClientL
        .V_Server           = TSPtr
        .V_TSNEID           = TTSNEID
        .V_TimeCon          = Now()
        .V_TimeOut          = Timer() + 60
        .V_TimePing         = Timer() + 10
        .V_IPA              = TIPA
        .V_State            = EGNP_CSE_Connecting
    End With
End With
MutexUnLock(EGNP_INT_Mux)
End Sub


Function EGNP_INT_Server_GetPtrByID(V_ServerID as UInteger) as EGNP_INT_Server_Type Ptr
Dim TXPtr as EGNP_INT_Server_Type Ptr = Cast(EGNP_INT_Server_Type Ptr, V_ServerID)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_F
Do Until TSPtr = 0
    If TSPtr = TXPtr Then Return TSPtr
    TSPtr = TSPtr->V_Next
Loop
Return 0
End Function


Function EGNP_Server_Create(ByRef R_ServerID as UInteger, V_Port as UShort, V_Name as String, V_Description as String, V_Password as String = "", V_MaxPlayer as UShort = 10, V_UDPPipePort as UShort = 0) as EGNP_GURU_Enum
If V_MaxPlayer < 1 Then Return EGNP_GURU_ParameterError
If V_Port < 1 Then Return EGNP_GURU_ParameterError
If V_Name = "" Then Return EGNP_GURU_ParameterError
If Len(V_Name) > &HFF Then Return EGNP_GURU_ParameterError
If V_Description = "" Then Return EGNP_GURU_ParameterError
If Len(V_Description) > &HFFF Then Return EGNP_GURU_ParameterError
Dim TTID(1 to 3) as UInteger
Dim RV as Integer
RV = TSNE_Create_Server(TTID(1), V_Port, 100, @EGNP_INT_Server_NewConnection)
If RV <> TSNE_Const_NoError Then Return RV
'RV = TSNE_Create_UDP_RX(TTID(2), V_UDPPipePort)
'If RV <> TSNE_Const_NoError Then TSNE_Disconnect(TTID(1)): Return RV
'RV = TSNE_Create_UDP_TX(TTID(3), V_UDPPipePort)
'If RV <> TSNE_Const_NoError Then TSNE_Disconnect(TTID(1)): TSNE_Disconnect(TTID(2)): Return RV
MutexLock(EGNP_INT_Mux)
If EGNP_INT_Server_L <> 0 Then
    EGNP_INT_Server_L->V_Next = CAllocate(SizeOf(EGNP_INT_Server_Type))
    EGNP_INT_Server_L->V_Next->V_Prev = EGNP_INT_Server_L
    EGNP_INT_Server_L = EGNP_INT_Server_L->V_Next
Else
    EGNP_INT_Server_L = CAllocate(SizeOf(EGNP_INT_Server_Type))
    EGNP_INT_Server_F = EGNP_INT_Server_L
End If
With *EGNP_INT_Server_L
    .V_CreateTime       = Now()
    .V_Name             = V_Name
    .V_Description      = V_Description
    .V_PortTCP          = V_Port
    .V_Password         = V_Password
    .V_MaxPlayer        = V_MaxPlayer
    .V_PortUDP          = V_UDPPipePort
    .V_Enabled          = 0
    .V_TSNEIDTCP        = TTID(1)
    .V_TSNEIDUDPRX      = TTID(2)
    .V_TSNEIDUDPTX      = TTID(3)
End With
R_ServerID = Cast(UInteger, EGNP_INT_Server_L)
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_Destroy(V_ServerID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID(0 to 3) as UInteger
With *TSPtr
    If .V_TSNEIDTCP <> 0 Then TTID(1) = .V_TSNEIDTCP: .V_TSNEIDTCP = 0
    If .V_TSNEIDUDPRX <> 0 Then TTID(2) = .V_TSNEIDUDPRX: .V_TSNEIDUDPRX = 0
    If .V_TSNEIDUDPTX <> 0 Then TTID(3) = .V_TSNEIDUDPTX: .V_TSNEIDUDPTX = 0
End With
MutexUnLock(EGNP_INT_Mux)
TSNE_Disconnect(TTID(1))
TSNE_Disconnect(TTID(2))
TSNE_Disconnect(TTID(3))
TSNE_WaitClose(TTID(1))
TSNE_WaitClose(TTID(2))
TSNE_WaitClose(TTID(3))
MutexLock(EGNP_INT_Mux)
TSPtr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_InternalError
Dim TCPtr as EGNP_INT_ServerClient_Type Ptr
With *TSPtr
    TCPtr = .V_ClientF
    Do Until TCPtr = 0
        TSNE_Disconnect(TCPtr->V_TSNEID)
        TCPtr = TCPtr->V_Next
    Loop
End With
MutexUnLock(EGNP_INT_Mux)
Do
    MutexLock(EGNP_INT_Mux)
    TSPtr = EGNP_INT_Server_GetPtrByID(V_ServerID)
    If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_InternalError
    If TSPtr->V_ClientF = 0 Then MutexUnLock(EGNP_INT_Mux): Exit Do
    MutexUnLock(EGNP_INT_Mux)
    'USleep 10000
    Sleep 10, 1
Loop
MutexLock(EGNP_INT_Mux)
TSPtr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_InternalError
If TSPtr->V_Next <> 0 Then TSPtr->V_Next->V_Prev = TSPtr->V_Prev
If TSPtr->V_Prev <> 0 Then TSPtr->V_Prev->V_Next = TSPtr->V_Next
If EGNP_INT_Server_F = TSPtr Then EGNP_INT_Server_F = TSPtr->V_Next
If EGNP_INT_Server_L = TSPtr Then EGNP_INT_Server_L = TSPtr->V_Prev
DeAllocate(TSPtr)
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_SetCallbacks(V_ServerID as UInteger, V_Callbacks as EGNP_Callback_Type) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
TSPtr->V_Callbacks = V_Callbacks
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_Enable(V_ServerID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
TSPtr->V_Enabled = 1
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_Disable(V_ServerID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
TSPtr->V_Enabled = 0
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Sub EGNP_INT_Server_AccountClear(ByRef RV_AccF as EGNP_INT_Account_Type Ptr, ByRef RV_AccL as EGNP_INT_Account_Type Ptr)
Do Until RV_AccF = 0
    RV_AccL = RV_AccF->V_Next
    DeAllocate(RV_AccF)
    RV_AccF = RV_AccL
Loop
End Sub


Function EGNP_Server_AccountEnable(V_ServerID as UInteger, V_AccountFilePathName as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
TSPtr->V_UseAccounts = 1
Dim TFN as Integer = FreeFile()
If Open(V_AccountFilePathName for Binary as #TFN) <> 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_CantOpenFile
Dim T as String
Dim TFLen as UInteger = Lof(TFN)
Dim TFPos as UInteger
Dim TLen as Integer
Dim RV as Integer
Dim TUser as String
Dim TPass as String
Dim TNick as String
Dim TFlag as EGNP_AccountPermissions_Enum
With *TSPtr
    .V_AccountFile  = V_AccountFilePathName
    EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL)
    Do
        If (TFLen - TFPos) < 4 Then
            If (TFLen - TFPos) = 0 Then MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_NoError
            EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        End If
        T = Space(4)
        Get #TFN, TFPos + 1, T: TFPos += Len(T)
        TLen = (T[0] shl 24) or (T[1] shl 16) or (T[2] shl 8) or T[3]
        If TLen > &HFFFFF Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        If (TFPos + TLen) > TFLen Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        T = Space(TLen)
        Get #TFN, TFPos + 1, T: TFPos += Len(T)
        RV = EGNP_INT_GetUInteger(T, TFlag):    If RV <> EGNP_GURU_NoError Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        RV = EGNP_INT_GetString(T, TUser):      If RV <> EGNP_GURU_NoError Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        RV = EGNP_INT_GetString(T, TPass):      If RV <> EGNP_GURU_NoError Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        RV = EGNP_INT_GetString(T, TNick):      If RV <> EGNP_GURU_NoError Then EGNP_INT_Server_AccountClear(.V_AccountF, .V_AccountL): MutexUnLock(EGNP_INT_Mux): Close #TFN: Return EGNP_GURU_ParseLenError
        If .V_AccountL <> 0 Then
            .V_AccountL->V_Next = CAllocate(SizeOf(EGNP_INT_Account_Type))
            .V_AccountL->V_Next->V_Prev = .V_AccountL
            .V_AccountL = .V_AccountL->V_Next
        Else
            .V_AccountL = CAllocate(SizeOf(EGNP_INT_Account_Type))
            .V_AccountF = .V_AccountL
        End If
        With *.V_AccountL
            .V_Username     = TUser
            .V_UsernameL    = LCase(.V_Username)
            .V_Password     = TPass
            .V_Nickname     = TNick
            .V_UserFlags    = TFlag
        End With
    Loop
End With
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_AccountAdd(V_ServerID as UInteger, V_Username as String, V_Password as String, V_Nickname as String, V_Flags as EGNP_AccountPermissions_Enum = EGNP_APE_Registered) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim RV as EGNP_GURU_Enum = EGNP_INT_Server_AccountAdd(TSPtr, V_Username, OSC_Crypt(V_Username, V_Password, "egnp", 4), V_Nickname, V_Flags)
MutexUnLock(EGNP_INT_Mux)
Return RV
End Function


Function EGNP_Server_SetClientFlag(V_ServerID as UInteger, V_UserID as UInteger, V_Flags as EGNP_AccountPermissions_Enum) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TSCPtr as EGNP_INT_ServerClient_Type Ptr = EGNP_INT_Client_GetByID(TSPtr, V_UserID)
If TSCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
TSCPtr->V_UserFlags = V_Flags
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Server_SendData(V_ServerID as UInteger, V_ToUserID as UInteger, ByRef V_Data as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Server_Type Ptr = EGNP_INT_Server_GetPtrByID(V_ServerID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TSCPtr as EGNP_INT_ServerClient_Type Ptr
Dim TData1 as String = EGNP_INT_BuildUInteger(0)
TData1 += EGNP_INT_BuildUInteger(V_ToUserID)
TData1 += EGNP_INT_BuildString(V_Data)
If V_ToUserID <> 0 Then
    TSCPtr = EGNP_INT_Client_GetByID(TSPtr, V_ToUserID)
    If TSCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
    EGNP_INT_AsyncSendToOne(TSCPtr->V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_UserData, TData1))
Else: EGNP_INT_AsyncSendToAll(TSPtr, EGNP_INT_BuildCMD(EGNP_CMD_UserData, TData1))
End If
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function







'####################################################################################################################################################
'####################################################################################################################################################
'####################################################################################################################################################







'####################################################################################################################################################
Sub EGNP_INT_Client_Disconnected(ByVal V_TSNEID as UInteger, ByVal V_ClientPtr as EGNP_INT_Client_Type Ptr)
If V_ClientPtr = 0 Then Exit Sub
MutexLock(EGNP_INT_Mux)
V_ClientPtr->V_State = EGNP_CSE_Disconnected
Dim TCallbacks as EGNP_Callback_Type = V_ClientPtr->V_Callbacks
MutexUnLock(EGNP_INT_Mux)
If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(Cast(UInteger, V_ClientPtr), EGNP_CSE_Disconnected)
End Sub


Sub EGNP_INT_Client_Connected(ByVal V_TSNEID as UInteger, ByVal V_ClientPtr as EGNP_INT_Client_Type Ptr)
If V_ClientPtr = 0 Then TSNE_Disconnect(V_TSNEID): Exit Sub
MutexLock(EGNP_INT_Mux)
V_ClientPtr->V_State = EGNP_CSE_Connected
Dim TCallbacks as EGNP_Callback_Type = V_ClientPtr->V_Callbacks
MutexUnLock(EGNP_INT_Mux)
If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(Cast(UInteger, V_ClientPtr), EGNP_CSE_Connected)
End Sub


Sub EGNP_INT_Client_NewData(ByVal V_TSNEID as UInteger, ByRef V_Data as String, ByVal V_ClientPtr as EGNP_INT_Client_Type Ptr)
'Print "CDAT:" & V_ClientPtr
If V_ClientPtr = 0 Then TSNE_Disconnect(V_TSNEID): Exit Sub
Dim TLen as UInteger
Dim TCMD as EGNP_INT_CMD_Enum
Dim TData as String
Dim T as String
Dim TS(1 to 4) as String
Dim TUS as UShort
Dim TUI(1 to 6) as UInteger
Dim TD(1 to 3) as Double
Dim RV as EGNP_GURU_Enum
Dim TMyPtrFrom as Any Ptr
Dim TMyPtrTo as Any Ptr
Dim TUPtr as EGNP_User_Type Ptr
Dim TUPtr2 as EGNP_User_Type Ptr
Dim TWPtr as EGNP_INT_ClientAnswer_Type Ptr
Dim TWPtrN as EGNP_INT_ClientAnswer_Type Ptr
Dim TSerial as Double
MutexLock(EGNP_INT_Mux)
With *V_ClientPtr
    Dim TCallbacks as EGNP_Callback_Type = .V_Callbacks
    Dim TID as UInteger = Cast(UInteger, V_ClientPtr)
    .V_DataTCP += V_Data
    Do
        If Len(.V_DataTCP) < 8 Then MutexUnLock(EGNP_INT_Mux): Exit Sub
        If Len(.V_DataTCP) > &HFFFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_DATALenError)): Exit Sub
        TLen = (.V_DataTCP[0] shl 24) or (.V_DataTCP[1] shl 16) or (.V_DataTCP[2] shl 8) or .V_DataTCP[3]
        If TLen > &HFFFFFF Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_GURU_DATALenError)): Exit Sub
        If Len(.V_DataTCP) < TLen Then MutexUnLock(EGNP_INT_Mux): Exit Sub
        TCMD = (.V_DataTCP[4] shl 24) or (.V_DataTCP[5] shl 16) or (.V_DataTCP[6] shl 8) or .V_DataTCP[7]
        TData = Mid(.V_DataTCP, 9, TLen - 4)
        .V_DataTCP = Mid(.V_DataTCP, TLen + 5)
        If TCMD < 0 Then .V_LCMD = TCMD
        T = ""
        'Print #1, "IN  >" & EGNP_INT_GETCMDDESC(TCMD) & "<___>" & TLen & "<___>" & Len(TData) & "<"
        Select Case TCMD
            Case EGNP_CMD_ServerOffline
                MutexUnLock(EGNP_INT_Mux)
                TSNE_Disconnect(V_TSNEID)
                If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(TID, EGNP_CSE_DisconnectedUnavaible)
                Exit Do

            Case EGNP_CMD_ServerFull
                MutexUnLock(EGNP_INT_Mux)
                TSNE_Disconnect(V_TSNEID)
                If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(TID, EGNP_CSE_DisconnectedFull)
                Exit Do

            Case EGNP_CMD_ServerConnectionDenied
                MutexUnLock(EGNP_INT_Mux)
                TSNE_Disconnect(V_TSNEID)
                If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(TID, EGNP_CSE_DisconnectedConnectionDenied)
                Exit Do

            Case EGNP_CMD_Crypt1
            Case EGNP_CMD_Crypt2
            Case EGNP_CMD_Crypt3

            Case EGNP_CMD_Ident
                RV = EGNP_INT_GetString(TData, TS(1)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(2)):  If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetUShort(TData, TUS):    If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                If Len(TData) < 3 Then                   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                .V_ServerName               = TS(1)
                .V_ServerDescription        = TS(2)
                .V_ServerMaxPlayer          = TUS
                .V_ServerPublic             = IIf(TData[0] = 1, 1, 0)
                .V_ServerUseAccount         = IIf(TData[1] = 1, 1, 0)
                .V_ServerUseServerPass      = IIf(TData[2] = 1, 1, 0)

                T = ""
                T += EGNP_INT_BuildString(.V_Nickname)
                If .V_ServerUseServerPass = 1 Then
                    T += EGNP_INT_BuildString(.V_PasswordServer)
                Else: T += EGNP_INT_BuildString("")
                End If
                If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_Ident, T)) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do

            Case EGNP_CMD_AccLogin
                T += EGNP_INT_BuildString(.V_Username)
                T += EGNP_INT_BuildString(.V_Password)
                T += EGNP_INT_BuildString(.V_Nickname)
                If EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(EGNP_CMD_AccLogin, T)) <> TSNE_Const_NoError Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do

            Case EGNP_CMD_Ready
                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                .V_State    = EGNP_CSE_Ready
                .V_MyID     = TUI(1)
                MutexUnLock(EGNP_INT_Mux)
                If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(TID, EGNP_CSE_Ready)
                MutexLock(EGNP_INT_Mux)

            Case EGNP_CMD_UserJoin
                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetUInteger(TData, TUI(2)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                TUPtr = EGNP_INT_User_Add(V_ClientPtr, TUI(1), TS(1), TUI(2))
                If TUPtr = 0 Then Continue Do
                TMyPtrTo = TUPtr->V_MyPtr
                MutexUnLock(EGNP_INT_Mux)
                If TCallbacks.V_StateUser <> 0 Then TCallbacks.V_StateUser(TUI(1), EGNP_USE_Join, TMyPtrTo)
                MutexLock(EGNP_INT_Mux)
                TUPtr->V_MyPtr = TMyPtrTo

            Case EGNP_CMD_UserLeave
                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                TUPtr = EGNP_INT_User_Get(V_ClientPtr, TUI(1))
                If TUPtr = 0 Then Continue Do
                TMyPtrTo = TUPtr->V_MyPtr
                EGNP_INT_User_Del(V_ClientPtr, TUI(1))
                MutexUnLock(EGNP_INT_Mux)
                If TCallbacks.V_StateUser <> 0 Then TCallbacks.V_StateUser(TUI(1), EGNP_USE_Leave, TMyPtrTo)
                MutexLock(EGNP_INT_Mux)

            Case EGNP_CMD_UserMessage
                If TCallbacks.V_Message = 0 Then Continue Do
                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetUInteger(TData, TUI(2)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetUInteger(TData, TUI(3)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                TUPtr = EGNP_INT_User_Get(V_ClientPtr, TUI(1))
                If TUPtr <> 0 Then TMyPtrFrom = TUPtr->V_MyPtr Else TMyPtrFrom = 0
                TUPtr2 = EGNP_INT_User_Get(V_ClientPtr, TUI(2))
                If TUPtr2 <> 0 Then TMyPtrTo = TUPtr2->V_MyPtr Else TMyPtrTo = 0
                MutexUnLock(EGNP_INT_Mux)
                TCallbacks.V_Message(TUI(1), TUI(2), TS(1), TUI(3), TMyPtrTo, TMyPtrFrom)
                MutexLock(EGNP_INT_Mux)
                If TUPtr <> 0 Then TUPtr->V_MyPtr = TMyPtrFrom
                If TUPtr2 <> 0 Then TUPtr2->V_MyPtr = TMyPtrTo

            Case EGNP_CMD_UserData
                If TCallbacks.V_Data = 0 Then Continue Do
                RV = EGNP_INT_GetUInteger(TData, TUI(1)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetUInteger(TData, TUI(2)):   If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                RV = EGNP_INT_GetString(TData, TS(1)):      If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                TUPtr = EGNP_INT_User_Get(V_ClientPtr, TUI(1))
                If TUPtr <> 0 Then TMyPtrFrom = TUPtr->V_MyPtr Else TMyPtrFrom = 0
                TUPtr2 = EGNP_INT_User_Get(V_ClientPtr, TUI(2))
                If TUPtr2 <> 0 Then TMyPtrTo = TUPtr2->V_MyPtr Else TMyPtrTo = 0
                MutexUnLock(EGNP_INT_Mux)
                TCallbacks.V_Data(TUI(1), TUI(2), TS(1), TMyPtrTo, TMyPtrFrom)
                MutexLock(EGNP_INT_Mux)
                If TUPtr <> 0 Then TUPtr->V_MyPtr = TMyPtrFrom
                If TUPtr2 <> 0 Then TUPtr2->V_MyPtr = TMyPtrTo

            Case EGNP_CMD_AccCreate, EGNP_CMD_AccList, EGNP_CMD_AccDestroy, EGNP_CMD_AccSetFlags, EGNP_CMD_AccSetNick, EGNP_CMD_AccSetPass
                RV = EGNP_INT_GetDouble(TData, TSerial):    If RV <> EGNP_GURU_NoError Then MutexUnLock(EGNP_INT_Mux): EGNP_INT_AsyncSendToOne(V_TSNEID, EGNP_INT_BuildCMD(RV)): TSNE_Disconnect(V_TSNEID): Exit Sub
                TWPtr = .V_AnswerF
                Do Until TWPtr = 0
                    TWPtrN = TWPtr->V_Next
                    If TWPtr->V_TimeOut < Timer() Then
                        If TWPtr->V_Next <> 0 Then TWPtr->V_Next->V_Prev = TWPtr->V_Prev
                        If TWPtr->V_Prev <> 0 Then TWPtr->V_Prev->V_Next = TWPtr->V_Next
                        If .V_AnswerF = TWPtr Then .V_AnswerF = TWPtr->V_Next
                        If .V_AnswerL = TWPtr Then .V_AnswerL = TWPtr->V_Prev
                        DeAllocate(TWPtr)
                    End If
                    TWPtr = TWPtrN
                Loop
                If .V_AnswerL <> 0 Then
                    .V_AnswerL->V_Next = CAllocate(SizeOf(EGNP_INT_ClientAnswer_Type))
                    .V_AnswerL->V_Next->V_Prev = .V_AnswerL
                    .V_AnswerL = .V_AnswerL->V_Next
                Else
                    .V_AnswerL = CAllocate(SizeOf(EGNP_INT_ClientAnswer_Type))
                    .V_AnswerF = .V_AnswerL
                End If
                With *.V_AnswerL
                    .V_TimeOut  = Timer() + 10
                    .V_Serial   = TSerial
                    .V_CMD      = TCMD
                    .V_Answer   = TData
                End With

            Case EGNP_GURU_UnknownCMD
            Case EGNP_GURU_LoginDenied
            Case EGNP_GURU_NickDenied
            Case EGNP_GURU_CommandDenied
            Case Else: MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(V_TSNEID): Exit Do
        End Select
    Loop
End With
MutexUnLock(EGNP_INT_Mux)
End Sub


Function EGNP_INT_Client_GetPtrByID(V_ClientID as UInteger) as EGNP_INT_Client_Type Ptr
Dim TXPtr as EGNP_INT_Client_Type Ptr = Cast(EGNP_INT_Client_Type Ptr, V_ClientID)
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_F
Do Until TCPtr = 0
    If TCPtr = TXPtr Then Return TCPtr
    TCPtr = TCPtr->V_Next
Loop
Return 0
End Function


Function EGNP_Client_Destroy(V_ClientID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTSNESocket as TSNE_Socket Ptr
TTSNESocket = TSNE_INT_GetPtr(TCPtr->V_TSNEIDTCP): If TTSNESocket <> 0 Then TTSNESocket->V_Event.V_AnyPtr = 0
TTSNESocket = TSNE_INT_GetPtr(TCPtr->V_TSNEIDUDPTX): If TTSNESocket <> 0 Then TTSNESocket->V_Event.V_AnyPtr = 0
TTSNESocket = TSNE_INT_GetPtr(TCPtr->V_TSNEIDUDPRX): If TTSNESocket <> 0 Then TTSNESocket->V_Event.V_AnyPtr = 0
If TCPtr->V_Next <> 0 Then TCPtr->V_Next->V_Prev = TCPtr->V_Prev
If TCPtr->V_Prev <> 0 Then TCPtr->V_Prev->V_Next = TCPtr->V_Next
If EGNP_INT_Client_F = TCPtr Then EGNP_INT_Client_F = TCPtr->V_Next
If EGNP_INT_Client_L = TCPtr Then EGNP_INT_Client_L = TCPtr->V_Prev
DeAllocate(TCPtr)
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Client_Create(ByRef R_ClientID as UInteger, V_CallbackSet as EGNP_Callback_Type) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
If EGNP_INT_Client_L <> 0 Then
    EGNP_INT_Client_L->V_Next = CAllocate(SizeOf(EGNP_INT_Client_Type))
    EGNP_INT_Client_L->V_Next->V_Prev = EGNP_INT_Client_L
    EGNP_INT_Client_L = EGNP_INT_Client_L->V_Next
Else
    EGNP_INT_Client_L = CAllocate(SizeOf(EGNP_INT_Client_Type))
    EGNP_INT_Client_F = EGNP_INT_Client_L
End If
With *EGNP_INT_Client_L
    .V_LCMD             = EGNP_CMD_ServerUnavaible
    .V_State            = EGNP_CSE_Connecting
    .V_Callbacks        = V_CallbackSet
End With
R_ClientID = Cast(UInteger, EGNP_INT_Client_L)
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Client_Disconnect(V_ClientID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound

MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Client_Connect(V_ClientID as UInteger, V_Host as String, V_Port as UShort, V_Nickname as String, V_PasswordServer as String = "", V_Username as String = "", V_Password as String = "", V_PortUDP as UShort = 0) as EGNP_GURU_Enum
If V_Host = "" Then Return EGNP_GURU_ParameterError
If V_Port < 1 Then Return EGNP_GURU_ParameterError
If V_Nickname = "" Then Return EGNP_GURU_ParameterError
If V_PasswordServer <> "" Then If Len(V_PasswordServer) > &HFFF Then Return EGNP_GURU_ParameterError
If V_Username <> "" Then
    If Len(V_Username) < 4 Then Return EGNP_GURU_ParameterError
    If Len(V_Username) > &HFFF Then Return EGNP_GURU_ParameterError
End If
If V_Password <> "" Then
    If Len(V_Password) < 8 Then Return EGNP_GURU_ParameterError
    If Len(V_Password) > &HFFF Then Return EGNP_GURU_ParameterError
End If
Dim TTID as UInteger
Dim RV as Integer
MutexLock(EGNP_INT_Mux)
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TCallbacks as EGNP_Callback_Type = TCPtr->V_Callbacks
MutexUnLock(EGNP_INT_Mux)
If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(Cast(UInteger, TCPtr), EGNP_CSE_Connecting)
MutexLock(EGNP_INT_Mux)
RV = TSNE_Create_Client(TTID, V_Host, V_Port, @EGNP_INT_Client_Disconnected, @EGNP_INT_Client_Connected, @EGNP_INT_Client_NewData, , , , Cast(EGNP_INT_Client_Type Ptr, V_ClientID))
If RV <> TSNE_Const_NoError Then
    MutexUnLock(EGNP_INT_Mux)
    If TCallbacks.V_StateConnection <> 0 Then TCallbacks.V_StateConnection(Cast(UInteger, TCPtr), EGNP_CSE_DisconnectedUnavaible)
    DeAllocate(TCPtr)
    Return RV
End If
TCPtr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then MutexUnLock(EGNP_INT_Mux): TSNE_Disconnect(TTID): Return EGNP_GURU_ExternalError
With *TCPtr
    .V_Host                 = V_Host
    .V_PortTCP              = V_Port
    .V_PortUDP              = V_PortUDP
    .V_Nickname             = V_Nickname
    .V_PasswordServer       = V_PasswordServer
    .V_Username             = V_Username
    .V_Password             = OSC_Crypt(V_Username, V_Password, "egnp", 4)
    .V_TSNEIDTCP            = TTID
End With
MutexUnLock(EGNP_INT_Mux)
Return EGNP_GURU_NoError
End Function


Function EGNP_Client_WaitConnected(V_ClientID as UInteger) as EGNP_GURU_Enum
Dim TTot as Double = Timer() + 60
Dim TSPtr as EGNP_INT_Client_Type Ptr
Do
    MutexLock(EGNP_INT_Mux)
    Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
    If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
    If (TSPtr->V_State and EGNP_CSE_Disconnected) <> 0 Then
        Dim TLCMD as EGNP_INT_CMD_Enum = TSPtr->V_LCMD
        MutexUnLock(EGNP_INT_Mux)
        Return TLCMD
    End If
    If TSPtr->V_State = EGNP_CSE_Ready Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_NoError
    If TTot < Timer() Then
        TSNE_Disconnect(TSPtr->V_TSNEIDTCP)
        MutexUnLock(EGNP_INT_Mux)
        Return EGNP_GURU_Timeout
    End If
    MutexUnLock(EGNP_INT_Mux)
    'USleep 10000
    Sleep 10, 1
Loop
Return EGNP_GURU_CantConnect
End Function


Function EGNP_Client_GetUserIDByNick(V_ClientID as UInteger, V_Nickname as String) as UInteger
If V_ClientID = 0 Then Return 0
If V_Nickname = "" Then Return 0
Dim S as String = LCase(V_Nickname)
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return 0
Dim TID as UInteger
Dim TCPtr as EGNP_User_Type Ptr = TSPtr->V_UserF
Do Until TCPtr = 0
    If LCase(TCPtr->V_Nickname) = S Then
        TID = TCPtr->V_ClientID
        MutexUnLock(EGNP_INT_Mux)
        Return TID
    End If
    TCPtr = TCPtr->V_Next
Loop
Return 0
End Function


Function EGNP_Client_GetMyID(V_ClientID as UInteger) as UInteger
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return 0
Function = TSPtr->V_MyID
MutexUnLock(EGNP_INT_Mux)
End Function


Sub EGNP_Client_Lock()
MutexLock(EGNP_INT_Mux)
End Sub

Sub EGNP_Client_UnLock()
MutexUnLock(EGNP_INT_Mux)
End Sub


Function EGNP_Client_GetUserTypeByID(V_ClientID as UInteger, V_UserID as UInteger) as EGNP_User_Type Ptr
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then Return 0
Return EGNP_INT_User_Get(TCPtr, V_UserID)
End Function


Function EGNP_Client_GetUserTypeFirst(V_ClientID as UInteger) as EGNP_User_Type Ptr
Dim TCPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TCPtr = 0 Then Return 0
Return TCPtr->V_UserF
End Function


Function EGNP_Client_SendMessage(V_ClientID as UInteger, V_ToUserID as UInteger, V_Message as String, V_MessageType as EGNP_MessageType_Enum = EGNP_MTE_Regular) as EGNP_GURU_Enum
If V_Message = "" Then Return EGNP_GURU_ParameterError
If Len(V_Message) > &HFFF Then Return EGNP_GURU_ParameterError
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
MutexUnLock(EGNP_INT_Mux)
Dim T as String
T += EGNP_INT_BuildUInteger(V_ToUserID)
T += EGNP_INT_BuildUInteger(V_MessageType)
T += EGNP_INT_BuildString(V_Message)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_UserMessage, T)) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Return EGNP_GURU_NoError
End Function


Function EGNP_Client_SendData(V_ClientID as UInteger, V_ToUserID as UInteger, ByRef V_Data as String) as EGNP_GURU_Enum
If Len(V_Data) > &HFFFF Then Return EGNP_GURU_ParameterError
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
MutexUnLock(EGNP_INT_Mux)
Dim T as String
T += EGNP_INT_BuildUInteger(V_ToUserID)
T += EGNP_INT_BuildString(V_Data)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_UserData, T)) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Return EGNP_GURU_NoError
End Function


Function EGNP_INT_WaitAnswer(V_ClientID as UInteger, V_CMD as EGNP_INT_CMD_Enum, V_Serial as Double, ByRef R_Answer as String) as EGNP_GURU_Enum
Dim TTot as Double = Timer() + 10
Dim TSPtr as EGNP_INT_Client_Type Ptr
Dim TWPtr as EGNP_INT_ClientAnswer_Type Ptr
Do
    If TTot < Timer() Then Return EGNP_GURU_Timeout
    MutexLock(EGNP_INT_Mux)
    TSPtr = EGNP_INT_Client_GetPtrByID(V_ClientID)
    If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
    If (TSPtr->V_State and EGNP_CSE_Disconnected) <> 0 Then
        Dim TLCMD as EGNP_INT_CMD_Enum = TSPtr->V_LCMD
        MutexUnLock(EGNP_INT_Mux)
        Return TLCMD
    End If
    With *TSPtr
        TWPtr = .V_AnswerF
        Do Until TWPtr = 0
            If (TWPtr->V_CMD <> V_CMD) or (TWPtr->V_Serial <> V_Serial) Then TWPtr = TWPtr->V_Next: Continue Do
            If TWPtr->V_Next <> 0 Then TWPtr->V_Next->V_Prev = TWPtr->V_Prev
            If TWPtr->V_Prev <> 0 Then TWPtr->V_Prev->V_Next = TWPtr->V_Next
            If .V_AnswerF = TWPtr Then .V_AnswerF = TWPtr->V_Next
            If .V_AnswerL = TWPtr Then .V_AnswerL = TWPtr->V_Prev
            R_Answer = TWPtr->V_Answer
            DeAllocate(TWPtr)
            MutexUnLock(EGNP_INT_Mux)
            Return EGNP_GURU_NoError
        Loop
    End With
    MutexUnLock(EGNP_INT_Mux)
    Sleep 10, 1
Loop
Return EGNP_GURU_InternalError
End Function


Function EGNP_Client_Account_List(V_ClientID as UInteger, V_UserSelect as String, R_ListD() as EGNP_Account_Type, ByRef R_ListC as UInteger) as EGNP_GURU_Enum
R_ListC = 0
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_UserSelect)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccList, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccList, TSerial, T)
Dim TUser as String
Dim TNick as String
Dim TID as UInteger
Dim TFlag as EGNP_AccountPermissions_Enum
Do
    If T = "" Then Exit Do
    RV = EGNP_INT_GetUInteger(T, TID):      If RV <> EGNP_GURU_NoError Then R_ListC = 0: Return RV
    RV = EGNP_INT_GetString(T, TUser):      If RV <> EGNP_GURU_NoError Then R_ListC = 0: Return RV
    RV = EGNP_INT_GetString(T, TNick):      If RV <> EGNP_GURU_NoError Then R_ListC = 0: Return RV
    RV = EGNP_INT_GetUInteger(T, TFlag):    If RV <> EGNP_GURU_NoError Then R_ListC = 0: Return RV
    R_ListC += 1
    Redim Preserve R_ListD(R_ListC) as EGNP_Account_Type
    With R_ListD(R_ListC)
        .V_ClientID     = TID
        .V_Username     = TUser
        .V_Nickname     = TNick
        .V_UserFlags    = TFlag
    End With
Loop
Return RV
End Function


Function EGNP_Client_Account_Create(V_ClientID as UInteger, V_Username as String, V_Password as String, V_Nickname as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildString(OSC_Crypt(V_Username, V_Password, "egnp", 4))
T += EGNP_INT_BuildString(V_Nickname)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccCreate, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccCreate, TSerial, T)
Return RV
End Function


Function EGNP_Client_Account_Destroy(V_ClientID as UInteger, V_Username as String, V_Password as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildString(OSC_Crypt(V_Username, V_Password, "egnp", 4))
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccDestroy, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccDestroy, TSerial, T)
Return RV
End Function


Function EGNP_Client_Account_SetNickname(V_ClientID as UInteger, V_Username as String, V_Nickname as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildString(V_Nickname)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccSetNick, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccSetNick, TSerial, T)
Return RV
End Function


Function EGNP_Client_Account_SetPassword(V_ClientID as UInteger, V_Username as String, V_Password as String) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildString(OSC_Crypt(V_Username, V_Password, "egnp", 4))
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccSetPass, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccSetPass, TSerial, T)
Return RV
End Function


Function EGNP_Client_Account_SetFlags(V_ClientID as UInteger, V_Username as String, V_Flags as EGNP_AccountPermissions_Enum) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildString(V_Username)
T += EGNP_INT_BuildUInteger(V_Flags)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_AccSetFlags, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_AccSetFlags, TSerial, T)
Return RV
End Function


Function EGNP_Client_Kick(V_ClientID as UInteger, V_KickClientID as UInteger) as EGNP_GURU_Enum
MutexLock(EGNP_INT_Mux)
Dim TSPtr as EGNP_INT_Client_Type Ptr = EGNP_INT_Client_GetPtrByID(V_ClientID)
If TSPtr = 0 Then MutexUnLock(EGNP_INT_Mux): Return EGNP_GURU_IDnotFound
Dim TTID as UInteger = TSPtr->V_TSNEIDTCP
Dim T as String
Do
    If EGNP_INT_CMDSerial <> Timer() Then EGNP_INT_CMDSerial = Timer(): Exit Do
    Sleep 1, 1
Loop
Dim TSerial as Double = EGNP_INT_CMDSerial
MutexUnLock(EGNP_INT_Mux)
T += EGNP_INT_BuildDouble(TSerial)
T += EGNP_INT_BuildUInteger(V_KickClientID)
If EGNP_INT_AsyncSendToOne(TTID, EGNP_INT_BuildCMD(EGNP_CMD_UserKick, T), 0) <> TSNE_Const_NoError Then TSNE_Disconnect(TTID): Return EGNP_GURU_TransmissionError
Dim RV as EGNP_GURU_Enum = EGNP_INT_WaitAnswer(V_ClientID, EGNP_CMD_UserKick, TSerial, T)
Return RV
End Function

#ENDIF