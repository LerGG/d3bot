#cs --------------------------------------------------------------------------
	
	@Main: 	StartD3.au3
	
	@Project: 	JinShop
	@Version:	1.0
	@Created:	07.06.2012
	@Author:	abraXas, TeTuBe
	
	@Environment:	Windows
	@References:	/
	
	@Description:	Header for starting up Diablo 3
	@Usage:			Include and use _startD3()
	
#ce --------------------------------------------------------------------------

#include-once

; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <JinShopGlobal.au3>
#include <JinGUI.au3>

; ----------------------------------------------------------------------------
; @Function: _startD3()
; ----------------------------------------------------------------------------
Func _startD3()
	While 1
		If _checkProc($d3Proc) = False Then ContinueLoop
		If _runD3() = False Then ContinueLoop
		If _login() = False Then ContinueLoop
		Return
	WEnd
EndFunc   ;==>_startD3

; ----------------------------------------------------------------------------
; @Function: _checkProc()
; ----------------------------------------------------------------------------
Func _checkProc($procName)
	; Check if process already exits and if it does, close it.
	$pid = ProcessExists($procName)
	If $pid Then
		If $StartD3_debug Then _guiCommonLog(1, $procName & " is already running.")
		ProcessClose($pid)
		ProcessWaitClose($pid)
		If @error Then
			If $StartD3_debug Then _guiCommonLog(1, "Error while attempting to terminate " & $procName & ".")
			Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>_checkProc

; ----------------------------------------------------------------------------
; @Function: _runD3()
; ----------------------------------------------------------------------------
Func _runD3()
	Run($d3Path & " -launch")
	If WinWaitActive($d3Title, "", 15) = 0 Then
		If $StartD3_debug Then _guiCommonLog(1, "Timeout while starting Diablo III.")
		Return False
	EndIf

	MouseMove(0, 0)

	$i = 0
	While PixelChecksum(800, 835, 1115, 870) <> $checksum1
		Sleep(250)
		If $i > 40 Then
			If $StartD3_debug Then _guiCommonLog(1, "Timeout while starting Diablo III.")
			Return False
		EndIf
		$i += 1
	WEnd

	Return True
EndFunc   ;==>_runD3

; ----------------------------------------------------------------------------
; @Function: _login()
; ----------------------------------------------------------------------------
Func _login()
	While 1
		Send($password, 1)
		Send("{ENTER}")


		; ACHTUNG BUGGED! ( IMMER TRUE KP WIESO)
;~ 		If $authUse = True Then
;~ 			$i = 0
;~ 			While PixelChecksum(800, 835, 1115, 870) <> $checksum1
;~ 				Sleep(250)
;~ 				If PixelChecksum(870, 615, 1050, 650) = $checksum2 Then
;~ 					If $StartD3_debug Then _guiCommonLog(1, "Error while logging in.")
;~ 					If _repairLogin() = False Then
;~ 						Return False
;~ 					Else
;~ 						ContinueLoop 2
;~ 					EndIf
;~ 				EndIf
;~ 				If $i > 240 Then
;~ 					If $StartD3_debug Then _guiCommonLog(1, "Timeout while logging in.")
;~ 					If _repairLogin() = False Then
;~ 						Return False
;~ 					Else
;~ 						ContinueLoop 2
;~ 					EndIf
;~ 				EndIf
;~ 				$i += 1
;~ 			WEnd
;~ 			$authCode = _getAuthCode()
;~ 			If WinActivate($d3Title) = 0 Then
;~ 				If $StartD3_debug Then _guiCommonLog(1, "Error while activating Diablo III window.")
;~ 				Return False
;~ 			EndIf
;~ 			If WinWaitActive($d3Title, "", 15) = 0 Then
;~ 				If $StartD3_debug Then _guiCommonLog(1, "Error while activating Diablo III window.")
;~ 				Return False
;~ 			EndIf
;~ 			Send($authCode)
;~ 			Send("{ENTER}")
;~ 		EndIf

		$i = 0
		Do
			Sleep(250)
			If PixelChecksum(870, 615, 1050, 650) = $checksum2 Then
				If $StartD3_debug Then _guiCommonLog(1, "Error while logging in.")
				If _repairLogin() = False Then
					Return False
				Else
					ContinueLoop 2
				EndIf
			EndIf
			If $i > 240 Then
				If $StartD3_debug Then _guiCommonLog(1, "Timeout while logging in.")
				If _repairLogin() = False Then
					Return False
				Else
					ContinueLoop 2
				EndIf
			EndIf
			$i += 1
			$checksum = PixelChecksum(75, 390, 395, 445)
		Until $checksum = $checksum3 Or $checksum = $checksum4
		Return True
	WEnd
EndFunc   ;==>_login

; ----------------------------------------------------------------------------
; @Function: _repairLogin()
; ----------------------------------------------------------------------------
Func _repairLogin()
	Send("{ESC}")
	Sleep(500)
	If PixelChecksum(800, 835, 1115, 870) <> $checksum1 Then
		If $StartD3_debug Then _guiCommonLog(1, "Repairing failed.")
		Return False
	EndIf

	Return True
EndFunc   ;==>_repairLogin

; ----------------------------------------------------------------------------
; @Function: getAuthCode()
; ----------------------------------------------------------------------------
Func _getAuthCode()
	While 1
		If _checkProc($authProc) = False Then ContinueLoop
		If _runAuth() = False Then ContinueLoop
		$authCode = _generateAuthCode()
		If $authCode = False Then ContinueLoop

		MouseMove(0, 0)
		Return $authCode
	WEnd
EndFunc   ;==>_getAuthCode

; ----------------------------------------------------------------------------
; @Function: _runAuth()
; ----------------------------------------------------------------------------
Func _runAuth()
	Run($authPath)
	If WinWaitActive("Password", "", 15) = 0 Then
		If $StartD3_debug Then _guiCommonLog(1, "Timeout while starting authenticator (password window).")
		Return False
	EndIf

	Send($authPassword, 1)
	Send("{ENTER}")

	If WinWaitActive($authTitle, "", 15) = 0 Then
		If $StartD3_debug Then _guiCommonLog(1, "Timeout while starting authenticator (password window).")
		Return False
	EndIf

	Return True
EndFunc   ;==>_runAuth

; ----------------------------------------------------------------------------
; @Function: _genrateAuthCode()
; ----------------------------------------------------------------------------
Func _generateAuthCode()
	$size = WinGetPos($authTitle)
	If @error Then
		If $StartD3_debug Then _guiCommonLog(1, "WinAuth window was not found.")
		Return False
	EndIf

	MouseClick("left", $size[2] / 2, $size[3] / 2)
	Sleep(100)

	ProcessClose($authProc)
	If @error Then
		If $StartD3_debug Then _guiCommonLog(1, "Error while attempting to terminate " & $authProc & ".")
		Return False
	EndIf

	$authCode = ClipGet()
	If @error Or StringIsDigit($authCode) = 0 Then
		If $StartD3_debug Then _guiCommonLog(1, "Error while getting authentication code.")
		Return False
	EndIf

	Return $authCode
EndFunc   ;==>_generateAuthCode