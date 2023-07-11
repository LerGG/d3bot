#cs ---------------------------------------------------------------------------

    @Main:      JinAcution.au3

    @Project:   Jin Shop
    @Version:   1.0
    @Created:   14.06.2012
    @Author:    TeTuBe

    @Environment:   Windows
    @References:    /

    @Description:   D3 auction tool.
    @Usage:         Set up acutions automatical.

#ce ---------------------------------------------------------------------------

#include-once

; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#Include <GuiEdit.au3>
#include <Date.au3>

#include <JinAuctionGlobal.au3>
#include <JinShopGlobal.au3>
#include <startD3.au3>
#include <JinShop.au3>


; ----------------------------------------------------------------------------
; GUI Mode
; ----------------------------------------------------------------------------
Opt("GUIOnEventMode", 1)

; ----------------------------------------------------------------------------
; Main GUI Elements
; ----------------------------------------------------------------------------

; Main Window
$mainWindow = GUICreate("Jin Bot", 600, 450)

; Top Menu Bar
$startD3_Button     = GUICtrlCreateButton("Run Bot", 10, 10, 100, 33)
$settings_Button    = GUICtrlCreateButton("Settings", 110, 10, 100, 33)
$auctions_Button    = GUICtrlCreateButton("Auction", 210, 10, 100, 33)
$help_Button        = GUICtrlCreateButton("Help", 310, 10, 100, 33)
$exit_Button        = GUICtrlCreateButton("Exit", 410, 10, 100, 33)

; Middle Shop Panel
GUICtrlCreateGroup("Shop-Bot", 10, 60, 290, 200)

; Middle Auction Panel
GUICtrlCreateGroup("Auction-Bot", 300, 60, 290, 200)

; Bottom Common log edit.
GUICtrlCreateLabel("Common Log:", 10, 270, 90, 20)
$log_Edit = GUICtrlCreateEdit("", 10, 290, 290, 150, $ES_READONLY + $ES_AUTOVSCROLL)
GUICtrlSetBkColor($log_Edit, 0xFFFFFF)

; Bottom item log edit.
GUICtrlCreateLabel("Item Log:", 300, 270, 90, 20)
$item_Edit = GUICtrlCreateEdit("", 300, 290, 290, 150, $ES_READONLY + $ES_AUTOVSCROLL)
GUICtrlSetBkColor($item_Edit, 0xFFFFFF)

; ----------------------------------------------------------------------------
; Global GUI Variables (needed for window communication)
; ----------------------------------------------------------------------------
; Windows
GLobal $auctionWindow
Global $settingsWindow
Global $loginWindow

; Getters.
Global $get_password
GLobal $get_D3_Path
Global $get_Resume_Checksum
Global $get_Error_Checksum
Global $get_Login_Checksum
Global $get_StartGame_Checksum
Global $get_Town_Checksum
Global $get_Trinket_Checksum
GLobal $get_Item_1
Global $get_Item_2
Global $get_Item_3
Global $get_Item_4
Global $get_Stash_1
Global $get_Stash_2
Global $get_Stash_3
Global $get_Inventory_1

; ----------------------------------------------------------------------------
; GUI Events
; ----------------------------------------------------------------------------

; [X] button
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")

; Menu Events
GUICtrlSetOnEvent($startD3_Button, "_guiStartD3")
GUICtrlSetOnEvent($settings_Button, "_guiSettings")
GUICtrlSetOnEvent($auctions_Button, "_guiOpenAuction")
GUICtrlSetOnEvent($exit_Button, "_quit")

; ----------------------------------------------------------------------------
; GUI State
; ----------------------------------------------------------------------------
GUISetState(@SW_SHOW)

;~ while 1
;~     sleep(1000)
;~ wend

; ----------------------------------------------------------------------------
; @Function: _guiStartD3
; ----------------------------------------------------------------------------
Func _guiStartD3()

    ; Creates Login window.
    $loginWindow = GUICreate("JinBot - Starting D3", 210, 130, -1, -1 , 0 , 0, $mainWindow)
    GUISetState(@SW_SHOW)
    GUICtrlCreateLabel("Please enter your password.", 10, 10, 190)

    ; Password field and window buttons.
    $get_password = GUICtrlCreateInput("", 10, 30, 180, "", $ES_PASSWORD)
    $login_Button = GUICtrlCreateButton("Login", 10, 60, 90, 30)
    $login_Close_Button = GUICtrlCreateButton("Close", 100 , 60, 90, 30)

    ; loginWindow events.
    GUICtrlSetOnEvent($login_Button, "_guiSetPassword")
    GUICtrlSetOnEvent($login_Close_Button, "_guiCloseLogin")

EndFunc   ;==>_guiStartD3

; ----------------------------------------------------------------------------
; @Function: _guiSetPassword()
; ----------------------------------------------------------------------------
Func _guiSetPassword()

    ; Reads entered Password.
	$password = GUICtrlRead($get_password)

    ; Checks if any pw is entered.
    If $password = "" Then
        MsgBox(0, "Login", "Please enter a Password")
        Return
    Else
        GUISetState(@SW_HIDE, $loginWindow)
        _startD3()
		_sell()
		; Needed to close auction panel properly.
		SLeep(500)
		_start()
    Endif

EndFunc   ;==>_guiSetPassword

; ----------------------------------------------------------------------------
; @Function: _guiCloseLogin()
; ----------------------------------------------------------------------------
Func _guiCloseLogin()

    GUISetState(@SW_HIDE, $loginWindow)

EndFunc   ;==>_guiCloseLogin

; ----------------------------------------------------------------------------
; @Function: _guiSettings()
; ----------------------------------------------------------------------------
Func _guiSettings()

    ; Creates Login window.
    $settingsWindow = GUICreate("JinBot - Settings", 400, 300 , -1, -1 , 0 , 0, $mainWindow)
    GUISetState(@SW_SHOW)

    ; Paths Group
    GUICtrlCreateGroup("Path", 10, 10, 370, 40)
    GUICtrlCreateLabel("Diablo 3:", 20, 30, 60, 15)
    $get_D3_Path = GUICtrlCreateInput($d3Path, 70, 30, 300, 15)

    ; Checksums Group
    GUICtrlCreateGroup("Checksums", 10, 60, 370, 150)
    ; Login Checksum
    GUICtrlCreateLabel("Login:", 20, 10*8, 120, 15)
    $get_Login_Checksum = GUICtrlCreateInput($checksum1, 110, 10*8, 120, 15)
    ; Town Checksum
    GUICtrlCreateLabel("Town Buff:", 20, 10*10 , 120, 15)
    $get_Town_Checksum = GUICtrlCreateInput($checksum5, 110, 10*10, 120, 15)
    ; Resume Checksum
    GUICtrlCreateLabel("Resume Game:", 20, 10*12, 120, 15)
    $get_Resume_Checksum = GUICtrlCreateInput($checksum3, 110, 10*12, 120, 15)
    ; StartGame Checksum
    GUICtrlCreateLabel("Start Game:", 20, 10*14, 120, 15)
    $get_StartGame_Checksum = GUICtrlCreateInput($checksum4, 110, 10*14, 120, 15)
    ; Error Checksum
    GUICtrlCreateLabel("Fail Login:", 20, 10*16, 120, 15)
    $get_Error_Checksum = GUICtrlCreateInput($checksum2, 110, 10*16, 120, 15)
    ; Trinket Checksum
    GUICtrlCreateLabel("Trinket:", 20, 10*18 , 120, 15)
    $get_Trinket_Checksum = GUICtrlCreateInput($checksum6, 110, 10*18, 120, 15)

    ; Save Button
    $settings_Save_Button = GUICtrlCreateButton("Save", 10 , 230, 90, 30)
    GUICtrlSetOnEvent($settings_Save_Button, "_guiSaveSettings")

    ; Close Button
    $settings_Close_Button = GUICtrlCreateButton("Close", 100, 230, 90, 30)
    GUICtrlSetOnEvent($settings_Close_Button, "_guiCloseSettings")

EndFunc   ;==>_guiSettings()

; ----------------------------------------------------------------------------
; @Function: _guiSaveSettings()
; ----------------------------------------------------------------------------
Func _guiSaveSettings()

    ; D3 Path.
    $d3Path = GUICtrlRead($get_D3_Path)

    ; Login button greyed out.
    $checksum1 = GUICtrlRead($get_Login_Checksum)
    ; "ok" button for errors (login only).
    $checksum2 = GUICtrlRead($get_Error_Checksum)
    ; Resume game Button.
    $checksum3 = GUICtrlRead($get_Resume_Checksum)
    ; Start game Button.
    $checksum4 = GUICtrlRead($get_StartGame_Checksum)
    ; "in Town" Buff
    $checksum5 = GUICtrlRead($get_Town_Checksum)
    ; Trinket Tab
    $checksum6 = GUICtrlRead($get_Trinket_Checksum)

	; Checks for Empty fields.
    select
        Case $d3Path = ""
            MsgBox(0, "Settings", "Missing Diablo 3 Path.")
            Return
        Case $checksum1 = ""
            MsgBox(0, "Settings", "Missing Login Checksum.")
            Return
        Case $checksum2 = ""
            MsgBox(0, "Settings", "Missing Error Checksum.")
            Return
        Case $checksum3 = ""
            MsgBox(0, "Settings", "Missing Resume Game Checksum.")
            Return
        Case $checksum4 = ""
            MsgBox(0, "Settings", "Missing Start Game Checksum.")
            Return
        Case $checksum5 = ""
            MsgBox(0, "Settings", "Missing in Town Checksum.")
            Return
        Case $checksum6 = ""
            MsgBox(0, "Settings", "Missing Trinket Tab Checksum.")
            Return
        Case Else
			; Write entrys into ini file.
			IniWrite($settingsFile, "Login", "D3PATH", $d3Path)
			IniWrite($settingsFile, "Checksum", "LOGIN_CHECKSUM", $checksum1)
			IniWrite($settingsFile, "Checksum", "ERROR_CHECKSUM", $checksum2)
			IniWrite($settingsFile, "Checksum", "RESUME_CHECKSUM", $checksum3)
			IniWrite($settingsFile, "Checksum", "START_CHECKSUM", $checksum4)
			IniWrite($settingsFile, "Checksum", "TOWN_CHECKSUM", $checksum5)
			IniWrite($settingsFile, "Checksum", "TRINKET_CHECKSUM", $checksum6)
            MsgBox(0, "Settings", "Settings saved.")
            GUISetState(@SW_HIDE, $settingsWindow)
    EndSelect

EndFunc   ;==>_guiSaveSettings

; ----------------------------------------------------------------------------
; @Function: _guiCloseSettings()
; ----------------------------------------------------------------------------
Func _guiCloseSettings()

    GUISetState(@SW_HIDE, $settingsWindow)

EndFunc   ;==>_guiCloseSettings

; ----------------------------------------------------------------------------
; @Function: _guiOpenAuction()
; ----------------------------------------------------------------------------
Func _guiOpenAuction()

    ; Creates Login window.
    $auctionWindow = GUICreate("JinBot - Auction", 400, 300, -1, -1 , 0 , 0, $mainWindow)
    GUISetState(@SW_SHOW)

    ; Prices Group
    GUICtrlCreateGroup("Price", 10, 10, 185, 105)
    ; Item 1
    GUICtrlCreateLabel("Stash 1:", 20, 10*3, 60, 15)
    $get_Item_1 = GUICtrlCreateInput($stashPrice1, 80, 10*3, 100, 15)
    ; Item 2
    GUICtrlCreateLabel("Stash 2:", 20, 10*5, 60, 15)
    $get_Item_2 = GUICtrlCreateInput($stashPrice2, 80, 10*5, 100, 15)
    ; Item 3
    GUICtrlCreateLabel("Stash 3:", 20, 10*7, 60, 15)
    $get_Item_3 = GUICtrlCreateInput($stashPrice3, 80, 10*7, 100, 15)
    ; Item 4
    GUICtrlCreateLabel("Inventory 1:", 20, 10*9, 60, 15)
    $get_Item_4 = GUICtrlCreateInput($invPrice1, 80, 10*9, 100, 15)

    ; Sell Group
    GUICtrlCreateGroup("Sell Options", 195, 10, 185, 105)
    $get_Stash_1     = GUICtrlCreateCheckbox("Sell Stash 1", 205, 10*3, 80, 15)
    $get_Stash_2     = GUICtrlCreateCheckbox("Sell Stash 2", 205, 10*5, 80, 15)
    $get_Stash_3     = GUICtrlCreateCheckbox("Sell Stash 3", 205, 10*7, 80, 15)
    $get_Inventory_1 = GUICtrlCreateCheckbox("Sell Inventory 1", 205, 10*9, 100, 15)

    ; Checkbox pre values read from ini.
	; Unchecked == 4, Checked == 1
    If $sellStash1 = 1 Then
        GUICtrlSetState ($get_Stash_1, $GUI_CHECKED)
    Else
        GUICtrlSetState ($get_Stash_1, $GUI_UNCHECKED)
    EndIf

    If $sellStash2 = 1 Then
        GUICtrlSetState ($get_Stash_2, $GUI_CHECKED)
    Else
        GUICtrlSetState ($get_Stash_2, $GUI_UNCHECKED)
    EndIf

    If $sellStash3 = 1 Then
        GUICtrlSetState ($get_Stash_3, $GUI_CHECKED)
    Else
        GUICtrlSetState ($get_Stash_3, $GUI_UNCHECKED)
    EndIf

    If $sellInventory1 = 1 Then
        GUICtrlSetState ($get_Inventory_1, $GUI_CHECKED)
    Else
        GUICtrlSetState ($get_Inventory_1, $GUI_UNCHECKED)
    EndIf


    ; Save Button
    $auction_Save_Button = GUICtrlCreateButton("Save", 10 , 240, 90, 30)
    GUICtrlSetOnEvent($auction_Save_Button, "_guiSaveAuction")

    $auction_Close_Button = GUICtrlCreateButton("Close", 100 , 240, 90, 30)
    GUICtrlSetOnEvent($auction_Close_Button, "_guiCloseAuction")

EndFunc   ;==>_guiOpenAuction

; ----------------------------------------------------------------------------
; @Function: _guiSaveAuction()
; ----------------------------------------------------------------------------
Func _guiSaveAuction()

	; Read prices.
	$stashPrice1 = GUICtrlRead($get_Item_1)
	$stashPrice2 = GUICtrlRead($get_Item_2)
	$stashPrice3 = GUICtrlRead($get_Item_3)
	$stashPrice4 = GUICtrlRead($get_Item_4)

    ; Read slots to sell.
    $sellStash1     = GUICtrlRead($get_Stash_1)
	$sellStash2     = GUICtrlRead($get_Stash_2)
	$sellStash3     = GUICtrlRead($get_Stash_3)
	$sellInventory1 = GUICtrlRead($get_Inventory_1)

	; Writes prices into ini file.
	IniWrite($settingsFile, "Auction", "PRICE_STASH_1", $stashPrice1)
	IniWrite($settingsFile, "Auction", "PRICE_STASH_2", $stashPrice2)
	IniWrite($settingsFile, "Auction", "PRICE_STASH_3", $stashPrice3)
	IniWrite($settingsFile, "Auction", "PRICE_INVENTORY_1", $invPrice1)

    ; Writes sell info into ini file.
    IniWrite($settingsFile, "Auction", "SELL_STASH_1", $sellStash1)
	IniWrite($settingsFile, "Auction", "SELL_STASH_2", $sellStash2)
	IniWrite($settingsFile, "Auction", "SELL_STASH_3", $sellStash3)
	IniWrite($settingsFile, "Auction", "SELL_Inventory_1", $sellInventory1)

    MsgBox(0, "JinBot - Auction", "Your auction settings have been saved.")
    GUISetState(@SW_HIDE, $auctionWindow)

EndFunc   ;==>_guiSaveAuction

; ----------------------------------------------------------------------------
; @Function: _guiCloseAuction()
; ----------------------------------------------------------------------------
Func _guiCloseAuction()

    GUISetState(@SW_HIDE, $auctionWindow)

EndFunc   ;==>_guiCloseAcution

; ----------------------------------------------------------------------------
; @Function: _guiCommonLog()
; ----------------------------------------------------------------------------
Func _guiCommonLog($id, $logMsg)

    Select
        ; Normal log
        Case $id = 0
            GUICtrlSetData($log_Edit, "Run " & $runs& " ("& _NowTime() & ") - " & $logMsg & @CRLF, 1)
        ; Debug log
        Case $id = 1
            GUICtrlSetData($log_Edit, "Debug" & "(" & _NowTime() & ") - " & $logMsg & @CRLF, 1)
    EndSelect

EndFunc     ;==>_guiCommonLog()

; ----------------------------------------------------------------------------
; @Function: _guiItemLog()
; ----------------------------------------------------------------------------
Func _guiItemLog($itemMsg)

    GUICtrlSetData($item_Edit, _NowTime() & " " & $itemMsg & @CRLF, 1)

EndFunc     ;==>_guiItemLog()

; ----------------------------------------------------------------------------
; @Function: CLOSE_Clicked()
; ----------------------------------------------------------------------------
Func CLOSE_Clicked()

	Exit

EndFunc   ;==>CLOSE_Clicked
