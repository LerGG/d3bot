#cs ---------------------------------------------------------------------------

    @Main:      JinAcution.au3

    @Project:   Jin Shop
    @Version:   1.0
    @Created:   14.06.2012
    @Author:    TeTuBe

    @Environment:   Windows
    @References:    /

    @Description:   D3 auction tool.
    @Usage:         Set up auctions automatical.

#ce ---------------------------------------------------------------------------

#include-once

; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <JinAuctionGlobal.au3>
#include <JinShop.au3>

; ----------------------------------------------------------------------------
; Hotkeys
; ----------------------------------------------------------------------------
HotKeySet("{F7}", "_sell")

; ----------------------------------------------------------------------------
; @Function: _sellStash()
; ----------------------------------------------------------------------------
Func _sellStash($xStart, $yStart)

	_openStash($currentStash)
	Sleep(200)

	; Current x cord.
	Local $x = $xStart
	; Current y cord
	Local $y = $yStart

	; Start coordinates, left-top stash slot.
	Local $xToStart = $xStart
	Local $yToStart = $yStart

	; Loop variables.
	Local $row
	Local $column

;~ 	While _isEmptyStash($currentStash)
;~ 		If Not _checkAuctionCount() Then
;~ 			Return
;~ 		EndIf
;~ 		_sellItem()
;~ 		If Not _checkAuctionCount() Then
;~ 			Return
;~ 		EndIf
;~ 	WEnd

	; Iterates over all rows.
	For $rows = 0 To UBound($aStash, 2)
		If Not _checkAuctionCount() Then
			Return
		EndIf
		_OpenSellTab()
		; Iterates over all columns in current row.
		For $columns = 0 To UBound($aStash, 1)
			If _slotHasItem($x, $y) Then
				_mouseMove($x, $y)
				$x = $x + $xStashSlotOffset
				_createAuction($currentItemPrice)
				If Not _checkAuctionCount() Then
					Return
				EndIf
				ContinueLoop
			Else
				$x = $x + $xStashSlotOffset
				ContinueLoop
			EndIf
		Next

		; Moves to next row.
		$y = $y + $yStashSlotOffset
		; Resets x.
		$x = $xToStart
	Next

EndFunc   ;==>_sellStash

; ----------------------------------------------------------------------------
; @Function: _setStashStart()
; ----------------------------------------------------------------------------
Func _setStashStart()

	; Sets start slot
	$xStashLastPos = $xStashStartPos
	$yStashLastPos = $yStashStartPos

EndFunc   ;==>_setStashStart

; ----------------------------------------------------------------------------
; @Function: _checkAuctionCount()
; ----------------------------------------------------------------------------
Func _checkAuctionCount()

	_openAuctionTab()
	Sleep(200)

    ; Makes sure, scrollbar slider is scrolled top.
	_scrollTop()
	Sleep(200)

	If _scrollBarActive() Then
		; Scrolls 4 items down.
		_scrollBottom()
		; Returns False if 10 items counted.
		If PixelGetColor(1550,480) = 0x000000 Then
			Return False
		EndIf
		Return True
	Else
		Return True
	EndIf

EndFunc   ;==>_checkAuctionCount

; ----------------------------------------------------------------------------
; @Function: _slotHasItem()
; ----------------------------------------------------------------------------
Func _slotHasItem($xCord, $yCord)

	Local $xCurrent = $xCord
	Local $yCurrent = $yCord
    ; Color, when a slot has an item.
	Local $filledSlotColor = 0x253369
    ; 2x Offset <= 1 stash slot
    Local $slotOffset = 20
	PixelSearch($xCurrent - 20, $yCurrent - 20, $xCurrent + 20, $yCurrent + 20, $filledSlotColor, 6)

    ; Returns True, if the item color was found, else false.
	If Not @error Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>_slotHasItem

;~ Func _sellItem()

;~ 	Local $itemCord = PixelSearch(390, 280, 765, 830, 0x253369, 5)
;~ 	If Not @Error Then
;~ 		_mouseMove($itemCord[0], $itemCord[1])
;~ 		_createAuction($currentItemPrice)
;~ 	EndIf
;~ EndFunc


; ----------------------------------------------------------------------------
; @Function: _scrollBarActive()
; ----------------------------------------------------------------------------
Func _scrollBarActive()

	Local $scrollBarColorHex = 0xFFC784
	PixelSearch(1550-5, 305-5,1550+5, 305+5, $scrollBarColorHex)

	; Returns false if not active, else true.
	If @Error Then
		Return False
	Else
		Return True
	EndIf

EndFunc   ;==>_scrollBarActive

; ----------------------------------------------------------------------------
; @Function: _scrollTop()
; ----------------------------------------------------------------------------
Func _scrollTop()

	_MouseMove(1550, 305)
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)

EndFunc   ;==>_scrollTop

; ----------------------------------------------------------------------------
; @Function: _scrollBottom()
; ----------------------------------------------------------------------------
Func _scrollBottom()

	_MouseMove(1550,500)
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)
	MouseClick("left")
	Sleep(200)

EndFunc   ;==>_scrollBottom

; ----------------------------------------------------------------------------
; @Function: _clickAuctionButton()
; ----------------------------------------------------------------------------
Func _clickAuctionButton()

	_mouseMove(235, 635)
	MouseClick("left")

EndFunc   ;==>_clickAuctionButton

; ----------------------------------------------------------------------------
; @Function: _closeAuctionPanel()
; ----------------------------------------------------------------------------
Func _closeAuctionPanel()
	_mouseMove(1580, 110)
	Sleep(100)
	MouseClick("left")

EndFunc   ;==>_closeAuctionPanel

; ----------------------------------------------------------------------------
; @Function: _openSellTab()
; ----------------------------------------------------------------------------
Func _openSellTab()

	_mouseMove(850, 160)
	Sleep(100)
	MouseClick("left")

EndFunc   ;==>_openSellTab

; ----------------------------------------------------------------------------
; @Function: _openAuctionTab()
; ----------------------------------------------------------------------------
Func _openAuctionTab()

	_mouseMove(1060, 160)
	Sleep(100)
	MouseClick("left")

EndFunc   ;==>_openAuctionTab

; ----------------------------------------------------------------------------
; @Function: _openCompletedTab()
; ----------------------------------------------------------------------------
Func _openCompletedTab()

	_mouseMove(1280, 160)
	Sleep(100)
	MouseClick("left")

EndFunc   ;==>_openCompletedTab

; ----------------------------------------------------------------------------
; @Function: _openSearchTab
; ----------------------------------------------------------------------------
Func _openSearchTab()

	_mouseMove(630, 160)
	Sleep(100)
	MouseClick("left")

EndFunc   ;==>_openSearchTab


; ----------------------------------------------------------------------------
; @Function: _openStash()
; ----------------------------------------------------------------------------
Func _openStash($stashToOpen)

	If $stashToOpen = 1 Then
		_openSellTab()
		_mouseMove(810,320)
		Sleep(100)
		MouseClick("left")
	ElseIf $stashToOpen = 2 Then
		_openSellTab()
		_mouseMove(810,435)
		Sleep(100)
		MouseClick("left")
	ElseIf $stashToOpen = 3 Then
		_openSellTab()
		_mouseMove(810,550)
		Sleep(100)
		MouseClick("left")
	EndIf

EndFunc   ;==>_openStash

; ----------------------------------------------------------------------------
; @Function: _sell()
; ----------------------------------------------------------------------------
Func _sell()

	_clickAuctionButton()

	; Flags stashes to sell as empty if they are empty.
	If _isEmptyStash(1) = False Then
		IniWrite($settingsFile, "Auction", "SELL_STASH_1", 4)
	ElseIf _isEmptyStash(2) = False Then
		IniWrite($settingsFile, "Auction", "SELL_STASH_2", 4)
	ElseIf _isEmptyStash(3) = False Then
		IniWrite($settingsFile, "Auction", "SELL_STASH_3", 4)
	EndIf

	Select
		; Stash 1 not empty.
		Case $sellStash1 = 1
			; Set correct Stash
			$currentStash = 1
			; Set stash items Price
			$currentItemPrice = $stashPrice1
			_setStashStart()
			_sellStash($xStashLastPos, $yStashLastPos)
			_closeAuctionPanel()
			; Reset current Stash
			$currentStash = 0
			Return
		; Stash 2 not empty.
	Case $sellStash2 = 1
			; Set correct Stash.
			$currentStash = 2
			; Set stash items price.
			$currentItemPrice = $stashPrice2
			_setStashStart()
			_sellStash($xStashLastPos, $yStashLastPos)
			_closeAuctionPanel()
			; Reset current Stash.
			$currentStash = 0
			Return
		; Stash 3 not empty.
		Case $sellStash3 = 1
			; Set correct Stash
			$currentStash = 3
			; Set stash items price.
			$currentItemPrice = $stashPrice3
			_setStashStart()
			_sellStash($xStashLastPos, $yStashLastPos)
			_closeAuctionPanel()
			; Reset current stash.
			$currentStash = 0
			Return
		Case Else
			Return _start()
	EndSelect

EndFunc   ;==>_sell


; ----------------------------------------------------------------------------
; @Function: _isEmptyStash()
; ----------------------------------------------------------------------------
Func _isEmptyStash($stashId)

	; Opens stash to check.
	If $stashId = 1 Then
		_openStash($stashId)
	ElseIf $stashId = 2 Then
		_openStash($stashId)
	ElseIf $stashId = 3 Then
		_openStash($stashId)
	EndIf

    ; Color, when a slot has an item.
	Local $filledSlotColor = 0x253369

	; Needed so pixelsearch properly.
	Sleep(500)

    ; Returns true if items are found, else false.
    PixelSearch(390, 280, 765, 830, 0x253369, 5)
    If @Error Then
        Return False
    Else
        Return True
    EndIf

EndFunc

; ----------------------------------------------------------------------------
; @Function: _createAuction()
; ----------------------------------------------------------------------------
Func _createAuction($currentPrice)

	Local $itemPrice = $currentPrice
	MouseClick("left")
	Sleep(200)
	Send($itemPrice)
	Sleep(200)
	Send("{TAB}")
	Sleep(200)
	Send("{ENTER}")
	Sleep(3000)
	Send("{ENTER}")

EndFunc   ;==>_createAuction

; ----------------------------------------------------------------------------
; @Function: _getGold()
; ----------------------------------------------------------------------------
Func _getGold()

	_openCompletedTab()
	Sleep(200)

	; Moves over "send to stash" button.
	_mouseMove(365*1.4, 315*1.4)
	Sleep(200)

	; Clicks the send to stash button.
    ; Random timings to avoid patterns.
    Local $j = Random(3, 4, 5)
	For $i = 0 To $j
		MouseClick("left")
        Local $time = Random(1800, 1900, 2000)
        Sleep($time)
	Next

EndFunc   ;==>_getGold

; ----------------------------------------------------------------------------
; @Function: _mouseMove()
; ----------------------------------------------------------------------------
Func _mouseMove($xCord, $yCord)

	Local $x = $xCord
	Local $y = $yCord
	MouseMove($x, $y, 200)

EndFunc   ;==>_mouseMove
