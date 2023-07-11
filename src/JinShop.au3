;- ---------------------------------------------------------------------------
;- @Main: jinshop.au3
;-
;- @Project: Jin Shop
;- @Version: 1.0
;- @Created: 04.06.2012
;- @Author: abraXas, TeTuBe
;-----------------------------------------------------------------------------
;- @Environment: Windows
;- @References: /
;-
;- @Description: D3 Shopbot for Act3.
;- @Usage: Buy D3 Items from a vendor.
;- ---------------------------------------------------------------------------

#include-once

; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <ScreenCapture.au3>
#include <Array.au3>

#include <JinShopGlobal.au3>
#include <JinShopInit.au3>
#include <JinGUI.au3>
#include <StartD3.au3>
#include <JinAuction.au3>

; ----------------------------------------------------------------------------
; JinShop Globals
; ----------------------------------------------------------------------------
Global $oError = ObjEvent("AutoIt.Error", "_OCRErrFunc")


; ----------------------------------------------------------------------------
; Set Hotkeys
; ----------------------------------------------------------------------------
HotKeySet("{" & $startHotkey & "}", "_startBot")
HotKeySet("{" & $pauseHotkey & "}", "_pause")
HotKeySet("{" & $quitHotkey & "}", "_quit")
HotKeySet("{" & $runsHotkey & "}", "_showRuns")


; -----------------------------------------------------------------------
; @Function: _start()
; -----------------------------------------------------------------------
Func _start()
	; Check if D3 is already running.
	_checkD3()

	While 1

        ; Creates auctions and sells items after 30 runs.
		If $createAuctionTimer = 30 then
			_guiCommonLog(0, "Checking Auctions")
			_sell()
			$createAuctionTimer = 0
			; Needed to close auction panel properly.
			Sleep(500)
		EndIF
		$createAuctionTimer += 1

		; Join game
		Sleep(Random(50, 150))
		MouseClick("left",230, 415) ; "Resume Game" Button

		$i = 0
		While PixelChecksum(670, 915, 710, 950) <> $checksum5
			Sleep(250)
			If $i > 160 Then
				If $JinShop_debug Then _guiCommonLog(1, "Timeout while joining game.")
				_checkD3()
				ContinueLoop 2
			EndIf
			$i += 1
		WEnd

		; Counts the game joins.
		$runs += 1

		; Logs current time.
		$status = $statusJoined
		_logTime($status)

		; Move to merchant
		_moveToMerchant()

		If _browseItems() = False Then ContinueLoop

		If $status <> $statusPaused Then
			; Leave game
			Send("{ESC}")
			Send("{ESC}")
			MouseClick("left", 950, 580)
		EndIF
		; Check menu
		$i = 0
		Do
			Sleep(250)
			If $i > 80 Then
				If $JinShop_debug Then _guiCommonLog(1, "Timeout while leaving game.")
				_checkD3()
				$i = 0
			EndIf
			$i += 1
			$checksum = PixelChecksum(75, 390, 395, 445)
		Until $checksum = $checksum3 Or $checksum = $checksum4

	WEnd
EndFunc   ;==>_start


; -----------------------------------------------------------------------
; @Function: _checkD3()
; -----------------------------------------------------------------------
Func _checkD3()
	If ProcessExists($d3Proc) Then

		; Check if D3 is active
		If WinActive($d3Title) = 0 Then
			If WinActivate($d3Title) = 0 Then
				If $JinShop_debug Then _guiCommonLog(1, "Error while activating Diablo III window.")
				_startD3()
			EndIf
			If WinWaitActive($d3Title, "", 15) = 0 Then
				If $JinShop_debug Then _guiCommonLog(1, "Timeout while activating Diablo III window.")
				_startD3()
			EndIf
		EndIf

		; Check menu
		If _checkMenu() = False Then _startD3()

	Else
		_startD3()

	EndIf
EndFunc   ;==>_checkD3


; -----------------------------------------------------------------------
; @Function: _checkMenu()
; -----------------------------------------------------------------------
Func _checkMenu()
	$checksum = PixelChecksum(75, 390, 395, 445)
	If $checksum <> $checksum3 And $checksum <> $checksum4 Then
		If $JinShop_debug Then _guiCommonLog(1, "Not in menu.")
		Return False
	EndIf

	Return True
EndFunc   ;==>_checkMenu


; -----------------------------------------------------------------------
; @Function: _moveToMerchant()
; -----------------------------------------------------------------------
Func _moveToMerchant()
	Sleep(Random(50, 150))
	MouseMove(1170, 975)
	MouseDown("left")
	Sleep(Random(110, 145))
	MouseUp("left")
	Sleep(Random(1600, 1700))
	MouseDown("left")
	Sleep(Sleep(Random(110, 145)))
	MouseUp("left")
	Sleep(Random(1600, 1700))
	MouseClick("left", 1170, 975)
EndFunc   ;==>_moveToMerchant


; -----------------------------------------------------------------------
; @Function: _browseItems()
; -----------------------------------------------------------------------
Func _browseItems()

	; Switch to "Trinkets" tab
	$i = 0
	While PixelChecksum(491, 435, 525, 535) <> $checksum6
		Sleep(250)
		If $i > 30 Then
			If $JinShop_debug Then _guiCommonLog(1, "Timeout while shopping.")
			If _repairGame() = False Then
				If $JinShop_debug Then _guiCommonLog(1, "Repairing failed.")
				_checkD3()
			EndIf
			Return False
		EndIf
		$i += 1
	WEnd
	MouseClick("left", 510, 490, 1, 5)

	MouseMove(70, 215)
	$delay = Random(150, 180)
	Sleep($delay)
	_checkStats(0, 0)

	MouseMove(290, 215)
	$delay = Random(150, 180)
	Sleep($delay)
	_checkStats(1, 0)

	MouseMove(70, 325)
	$delay = Random(150, 180)
	Sleep($delay)
	_checkStats(0, 1)

	MouseMove(290, 325)
	$delay = Random(150, 180)
	Sleep($delay)
	_checkStats(1, 1)

	Return True
EndFunc   ;==>_browseItems


; -----------------------------------------------------------------------
; @Function: _repairGame()
; -----------------------------------------------------------------------
Func _repairGame()
	Send("{ESC}")
	MouseClick("left", 950, 580)

	; Check menu
	Return _checkMenu()
EndFunc   ;==>_repairGame


; -----------------------------------------------------------------------
; @Function: _checkStats()
;
; -----------------------------------------------------------------------
; @Rings:
; -----------------------------------------------------------------------
; Vitality
;   1. >= 140 Vita / 65 Str
;   2. >= 140 Vita / 65 Dex
;   3. >= 65 Vita / 140 Int
;   4. >= 70 Vita / 40 Allres
;   5. >= 71 Vita / 39 Allres
; Ias
;   1. == 71 Dex / 15 Ias
;   2. == 71 Int / 15 Ias
;   2. == 71 Vit / 15 Ias
;
; -----------------------------------------------------------------------
; @Amulets:
; -----------------------------------------------------------------------
; Vitality
;   1. >= 210 Vita / 90 Str
;   2. >= 210 Vita / 90 Dex
;   3. >= 90 Vita / 210 Int
;   4. >= 90 Vita / 215 Dex
; Ias
;   1. >= 108 Dex / 15 Ias
;   2. >= 105 Int / 15 Ias
; Mf
;   1. >= 109 Int / 25 Mf
; -----------------------------------------------------------------------
Func _checkStats($column, $itemType)

	; $column 0 = left, $column 1 = right

	Local $keep = False
	Local $xoffset = 223
	Local $yoffset = 25
	Local $doubletitle = False

	If $column = 0 Then
		$pixel = PixelGetColor(320, 95)
	ElseIf $column = 1 Then
		$pixel = PixelGetColor(320+$xoffset, 95)
	EndIf
	If $pixel = 0x000000 Then
		$doubletitle = True
	EndIf

	Local $y = 150
	If $column = 0 And $doubletitle = 0 Then
		While 1
			PixelSearch(300-4, $y-4, 300+4, $y+4, 0x8D8E89, 10)
			If @error Then ExitLoop
			$y += 20
		WEnd
		If $y <= 170 Then Return
		_ScreenCapture_Capture($imgFile, 300+4, 150-9, 675, $y+9-20, False)
	ElseIf $column = 1 And $doubletitle = 0 Then
		While 1
			PixelSearch(300+$xoffset-4, $y-4, 300+$xoffset+4, $y+4, 0x8D8E89, 10)
			If @error Then ExitLoop
			$y += 20
		WEnd
		If $y <= 170 Then Return
		_ScreenCapture_Capture($imgFile, 300+$xoffset+4, 150-9, 675+$xoffset, $y+9-20, False)
	ElseIf $column = 0 And $doubletitle = 1 Then
		While 1
			PixelSearch(300-4, $y+$yoffset-4, 300+4, $y+$yoffset+4, 0x8D8E89, 10)
			If @error Then ExitLoop
			$y += 20
		WEnd
		If $y <= 170 Then Return
		_ScreenCapture_Capture($imgFile, 300+4, 150+$yoffset-9, 675, $y+$yoffset+9-20, False)
	ElseIf $column = 1 And $doubletitle = 1 Then
		While 1
			PixelSearch(300+$xoffset-4, $y+$yoffset-4, 300+$xoffset+4, $y+$yoffset+4, 0x8D8E89, 10)
			If @error Then ExitLoop
			$y += 20
		WEnd
		If $y <= 170 Then Return
		_ScreenCapture_Capture($imgFile, 300+$xoffset+4, 150+$yoffset-9, 675+$xoffset, $y+$yoffset+9-20, False)
	EndIf


	$sTooltip = _OCRGetText($itemType)
	$keep = _checkPickit(StringStripWS($sTooltip, 8), $itemType)

	; Called when an item is found.
	If $keep Then
		; Changes bot status.
		$status = $statusFound

		; Gets how many items have been found and writes new value back.
		$itemsFound = IniRead($settingsFile, "RunCount", "FOUND", 0)
		$itemsFound += 1
		IniWrite($settingsFile, "RunCount", "FOUND", $itemsFound)

		; Logs time, pops msg box and pauses bot.
		_logTime($status)
		Beep(500, 5000)
		If $itemType = $itemRing Then
			MsgBox(0, "Match", "Found a Ring!" & @LF & @LF & $sToolTip & @LF & @LF & @HOUR & ":" & @MIN & ":" & @SEC)
		ElseIf $itemType = $itemAmulet Then
			MsgBox(0, "Match", "Found an Amulet!" & @LF & @LF & $sToolTip & @LF & @LF & @HOUR & ":" & @MIN & ":" & @SEC)
		EndIf
		_pause()
	EndIf

EndFunc   ;==>_checkStats

; -----------------------------------------------------------------------
; @Function: _checkPickit()
; -----------------------------------------------------------------------
Func _checkPickit($_sTooltip, $_itemType)
	If $_itemType = $itemRing Then
		$pickitFile = $pickitFileRings
	ElseIf $_itemType = $itemAmulet Then
		$pickitFile = $pickitFileAmulets
	EndIf

	$sectionNames = IniReadSectionNames($pickitFile)

	For $i = 1 To $sectionNames[0]
		Local $match[4] = [1, 0, 0, 0]
		$pickitSec = IniReadSection($pickitFile, $sectionNames[$i])

		For $j = 1 To $pickitSec[0][0]
			If StringInStr($_sTooltip, $pickitSec[$j][0]) Then
				If StringInStr($pickitSec[$j][0], "by") Then
					; Value is at the END of the string
					$value = StringRegExp($_sTooltip, $pickitSec[$j][0] & "(\d*)", 1)
				Else
					; Value is at the START of the string
					$value = StringRegExp($_sTooltip, "(\d*)" & $pickitSec[$j][0], 1)
				EndIf

				If $value[0] >= Number($pickitSec[$j][1]) Then $match[$j] = 1
			EndIf
		Next


		If _ArrayMin($match, 1, 0, $pickitSec[0][0]) = 1 Then Return True
	Next

	Return False
EndFunc

; -----------------------------------------------------------------------
; @Function: _OCRGetText()
; -----------------------------------------------------------------------
Func _OCRGetText($itemType)
	Local $oDoc = ObjCreate("MODI.Document")
	$oDoc.Create($imgFile)
	If @error Then Return SetError(1)
	$oDoc.Ocr(9, True, False) ; ENGLISH = 9
	If @error Then Return SetError(2)

	_logItem($oDoc.Images(0).Layout.Text, $itemType)

	Return $oDoc.Images(0).Layout.Text
EndFunc   ;==>_OCRGetText


; -----------------------------------------------------------------------
; @Function: _OCRErrFunc
; -----------------------------------------------------------------------
Func _OCRErrFunc()
	$HexNumber = Hex($oError.number, 8)
	MsgBox(0, @ScriptName, "We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oError.description & @CRLF & _
			"err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			"err.number is: " & @TAB & $HexNumber & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oError.helpcontext)
	SetError(1) ; to check for after this function returns
EndFunc   ;==>_OCRErrFunc


; -----------------------------------------------------------------------
; @Function: _logItems()
; -----------------------------------------------------------------------
Func _logItem($sItemText, $itemType)
	Local $hFile = FileOpen($itemFile, 1)
	; Check if file opened for reading OK
	If $hFile = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	; Prints item type.
	If $itemType = $itemRing Then
		FileWriteLine($hFile, "#ItemType: Ring")
        _guiItemLog("Ring - " & $sItemText)
	ElseIf $itemType = $itemAmulet Then
		FileWriteLine($hFile, "#ItemType: Amulet")
        _guiItemLog("Amulet - " & $sItemText)
	EndIf
	; Prints item attributes.
	FileWriteLine($hFile, $sItemText)
	FileClose($hFile)
EndFunc   ;==>_logItem


; -----------------------------------------------------------------------
; @Function: _logTime()
; -----------------------------------------------------------------------
Func _logTime($currentStatus)
	Local $hFile = FileOpen($logFile, 1)
	; Check if file opened for reading OK
	If $hFile = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	; Prints different status.
	If $currentStatus = $statusStarted Then
		FileWriteLine($hFile, "Bot started: " & @HOUR & ":" & @MIN & ":" & @SEC)
        _guiCommonLog(0, "Bot Started")
	ElseIf $currentStatus = $statusPaused Then
		FileWriteLine($hFile, "-Run: " & $runs & " - Bot Paused: " & @HOUR & ":" & @MIN & ":" & @SEC)
        _guiCommonLog(0, "Bot Paused")
	ElseIf $currentStatus = $statusJoined Then
		FileWriteLine($hFile, "+Run: " & $runs & " - Game Joined: " & @HOUR & ":" & @MIN & ":" & @SEC)
        _guiCommonLog(0, "Game Joined")
	ElseIf $currentStatus = $statusFound Then
		FileWriteLine($hFile, "#Run: " & $runs & " - Item Found: " & @HOUR & ":" & @MIN & ":" & @SEC)
        _guiCommonLog(0, "Item Found")
	ElseIf $currentStatus = $statusWaiting Then
		FileWriteLine($hFile, "#Run: " & $runs & " - Waiting: " & @HOUR & ":" & @MIN & ":" & @SEC)
        _guiCommonLog(0, "Waiting.")
	EndIf
	FileClose($hFile)
EndFunc   ;==>_logTime


; -----------------------------------------------------------------------
; @Function: _showRuns()
; -----------------------------------------------------------------------
Func _showRuns()
	MsgBox(0, "Runs", $runs)
EndFunc   ;==>_showRuns


; -----------------------------------------------------------------------
; @Function: _pause()
; -----------------------------------------------------------------------
Func _pause()
	$status = $statusPaused
	_logTime($status)

EndFunc   ;==>_pause

; -----------------------------------------------------------------------
; @Function: _startBot()
; -----------------------------------------------------------------------
Func _startBot()
	$status = $statusStarted
	_logTime($status)
EndFunc

; -----------------------------------------------------------------------
; @Function: _quit()
; -----------------------------------------------------------------------
Func _quit()
	IniWrite($settingsFile, "RunCount", "RUNS", $runs)
	Exit
EndFunc   ;==>_quit


; Problemchecks and restarting WIP
#cs
	Func CheckD3()
	If Not WinExists("Diablo III") Then
	$succesRate = (($runs / $matches) * 100)
	FileWriteLine($file, "!!! - Where Was Diablo? - " & @HOUR & ":" & @MIN & "." & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @LF)
	FileWriteLine($file, "Succes rate - " & $succesRate & "%" & @LF)
	FileWriteLine($file, "-----------------------------------------------------------------------" & @LF)
	ProcessClose("Diablo III.exe")
	Run("JinShop.exe")
	Exit
	EndIf

	If Not WinActive("Diablo III") Then
	$msgCheck = MsgBox(4, "JinShop", "Diablo got minimized. Do you want to restart?")
	Select
	Case $msgCheck = 6
	WinActivate("Diablo III")
	Case $msgCheck = 7
	$succesRate = (($runs / $matches) * 100)
	FileWriteLine($file, "Session ended - " & @HOUR & ":" & @MIN & "." & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @LF)
	FileWriteLine($file, "Succes rate - " & $succesRate & "%" & @LF)
	FileWriteLine($file, "-----------------------------------------------------------------------" & @LF)
	Exit
	EndSelect
	EndIf
	EndFunc
#ce

