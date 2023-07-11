#cs ----------------------------------------------------------------------------

	@Main: 	JinShopInit.au3

	@Project: 	JinShop
	@Version:	1.0
	@Created:	09.06.2012
	@Author:	abraXas, TeTuBe

	@Environment:	Windows
	@References:	/

	@Description:	Header for initialsing
	@Usage:			Include and use _JinInit()

#ce ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <JinShopGlobal.au3>


; -----------------------------------------------------------------------
; @Function: _JinInit()
; @Description: Bot setup.
; -----------------------------------------------------------------------
Func _JinInit()
	If FileExists($settingsFile) Then Return

	_createDirs()
	_createInis()
	MsgBox(0, "JinShop Setup", "JinShop is running for the first time. Open the settings and fill in all values.")
EndFunc   ;==>_JinInit


; -----------------------------------------------------------------------
; @Function: _createDirs()
; @Description: Creates neccesary Dirs.
; -----------------------------------------------------------------------
Func _createDirs()
	DirCreate($logPath)
	DirCreate($settingsPath)
	DirCreate($imgPath)
	DirCreate($pickitPath)
EndFunc   ;==>_createDirs

; -----------------------------------------------------------------------
; @Function: _createInis()
; @Description: Creates neccesray inis.
; -----------------------------------------------------------------------
Func _createInis()

	; Creates settings.ini

	; Login
	IniWrite($settingsFile, "Login", "D3PATH", "")
	IniWrite($settingsFile, "Login", "AUTH_USE", 0)
	IniWrite($settingsFile, "Login", "AUTH_PATH", "")
	IniWrite($settingsFile, "Login", "AUTH_PASSWORD", "")
	; Runcount
	IniWrite($settingsFile, "RunCount", "RUNS", 0)
	IniWrite($settingsFile, "RunCount", "FOUND", 0)
	IniWrite($settingsFile, "Hotkeys", "START_HOTKEY", "F1")
	IniWrite($settingsFile, "Hotkeys", "STOP_HOTKEY", "F2")
	IniWrite($settingsFile, "Hotkeys", "QUIT_HOTKEY", "F3")
	IniWrite($settingsFile, "Hotkeys", "RUNS_HOTKEY", "F6")
	; Checksums
	IniWrite($settingsFile, "Checksum", "LOGIN_CHECKSUM", 0)
	IniWrite($settingsFile, "Checksum", "ERROR_CHECKSUM", 0)
	IniWrite($settingsFile, "Checksum", "RESUME_CHECKSUM", 0)
	IniWrite($settingsFile, "Checksum", "START_CHECKSUM", 0)
	IniWrite($settingsFile, "Checksum", "TOWN_CHECKSUM", 0)
	IniWrite($settingsFile, "Checksum", "TRINKET_CHECKSUM", 0)

	; Auction
	IniWrite($settingsFile, "Auction", "PRICE_STASH_1", 0)
	IniWrite($settingsFile, "Auction", "PRICE_STASH_2", 0)
	IniWrite($settingsFile, "Auction", "PRICE_STASH_3", 0)
	IniWrite($settingsFile, "Auction", "PRICE_INVENTORY_1", 0)
    IniWrite($settingsFile, "Auction", "SELL_STASH_1", 0)
    IniWrite($settingsFile, "Auction", "SELL_STASH_2", 0)
    IniWrite($settingsFile, "Auction", "SELL_STASH_3", 0)
    IniWrite($settingsFile, "Auction", "SELL_INVENTORY_1", 0)

	; Creates pickitRings.ini
    IniWrite($pickitFileRings, "VitaStrRings", "Vitality", 140)
    IniWrite($pickitFileRings, "VitaStrRings", "Strength", 65)
    IniWrite($pickitFileRings, "VitaDexRings", "Vitality", 140)
    IniWrite($pickitFileRings, "VitaDexRings", "Dexterity", 65)
    IniWrite($pickitFileRings, "IntVitaRings", "Intelligence", 140)
    IniWrite($pickitFileRings, "IntVitaRings", "Vitality", 65)
    IniWrite($pickitFileRings, "AllresVitaRings", "ResistancetoAllElements", 40)
    IniWrite($pickitFileRings, "AllresVitaRings", "Vitality", 71)

	; Creates pickitAmulets.ini
    IniWrite($pickitFileAmulets, "VitaStrAmus", "Vitality", 210)
    IniWrite($pickitFileAmulets, "VitaStrAmus", "Strength", 90)
    IniWrite($pickitFileAmulets, "VitaDexAmus", "Vitality", 210)
    IniWrite($pickitFileAmulets, "VitaDexAmus", "Dexterity", 90)
    IniWrite($pickitFileAmulets, "DexVitaAmus", "Dexterity", 215)
    IniWrite($pickitFileAmulets, "DexVitaAmus", "Vitality", 100)
    IniWrite($pickitFileAmulets, "IntVitaAmus", "Intelligence", 210)
    IniWrite($pickitFileAmulets, "IntVitaAmus", "Vitality", 90)
    IniWrite($pickitFileAmulets, "IasDexAmus", "AttackSpeedIncreasedby", 7)
    IniWrite($pickitFileAmulets, "IasDexAmus", "Dexterity", 108)
    IniWrite($pickitFileAmulets, "IasIntAmus", "AttackSpeedIncreasedby", 7)
    IniWrite($pickitFileAmulets, "IasIntAmus", "Intelligence", 105)
    IniWrite($pickitFileAmulets, "MfIntAmus", "%BetterChanceofFindingMagicalItems", 25)
    IniWrite($pickitFileAmulets, "MfIntAmus", "Intelligence", 109)
    IniWrite($pickitFileAmulets, "CritDexAmus", "CriticalHitChanceIncreasedby", 5)
    IniWrite($pickitFileAmulets, "CritDexAmus", "Dexterity", 105)
    IniWrite($pickitFileAmulets, "CritIntAmus", "CriticalHitChanceIncreasedby", 5)
    IniWrite($pickitFileAmulets, "CritIntAmus", "Intelligence", 105)

EndFunc   ;==>_createInis
