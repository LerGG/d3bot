#cs --------------------------------------------------------------------------

	@Main: 	JinShopGlobal.au3

	@Project: 	JinShop
	@Version:	1.0
	@Created:	09.06.2012
	@Author:	abraXas, TeTuBe

	@Environment:	Windows
	@References:	/

	@Description:	Header for global settings.
	@Usage:			Include.

#ce --------------------------------------------------------------------------


#include-once


; ----------------------------------------------------------------------------
; Debugging
; ----------------------------------------------------------------------------
Global Const $JinShop_debug     = True
Global Const $JinShopInit_debug = True
Global Const $StartD3_debug		= True


; ----------------------------------------------------------------------------
; AutoIt Options
; ----------------------------------------------------------------------------
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)

; ----------------------------------------------------------------------------
; Bot Status
; ----------------------------------------------------------------------------
Global Enum $statusStarted = -1, $statusPaused, $statusJoined, $statusFound, $statusWaiting ; Bot status
Global $waitingTime = 0 ; time while bot sleeps
GLobal $status

; ----------------------------------------------------------------------------
; Item Types
; ----------------------------------------------------------------------------
Global Enum $itemRing, $itemAmulet

; ----------------------------------------------------------------------------
; Paths
; ----------------------------------------------------------------------------
Global Const $logPath		= "logs"
Global Const $imgPath		= "img"
Global Const $settingsPath	= "settings"
Global Const $pickitPath	= "pickit"

; ----------------------------------------------------------------------------
; Files
; ----------------------------------------------------------------------------
Global Const $itemFile		    = $logPath & "\" & @YEAR & "." & @MON & "." & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "_itemlog.txt"
Global Const $logFile		    = $logPath & "\" & @YEAR & "." & @MON & "." & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "_log.txt"
Global Const $settingsFile	    = $settingsPath & "\settings.ini"
Global Const $imgFile		    = $imgPath		& "\item.jpg"
GLobal Const $pickitFileRings	= $pickitPath &	"\pickitRings.ini"		; pickit ini file for Rings.
GLobal Const $pickitFileAmulets	= $pickitPath &	"\pickitAmulets.ini"	; pickit ini file for Amulets.

; ----------------------------------------------------------------------------
; Login
; ----------------------------------------------------------------------------
Global $password		    = ""
Global $d3Path		        = IniRead($settingsFile, "Login", "D3PATH",			"")
Global Const $authUse		= IniRead($settingsFile, "Login", "AUTH_USE",		0)
Global Const $authPath		= IniRead($settingsFile, "Login", "AUTH_PATH",		"")
Global Const $authPassword	= IniRead($settingsFile, "Login", "AUTH_PASSWORD",	"")


; ----------------------------------------------------------------------------
; Checksums
; ----------------------------------------------------------------------------
Global $checksum1 = IniRead($settingsFile, "Checksum", "LOGIN_CHECKSUM", "") ; "Login" Button, grayed out
Global $checksum2 = IniRead($settingsFile, "Checksum", "ERROR_CHECKSUM", "") ; "OK" Button for Errors
Global $checksum3 = IniRead($settingsFile, "Checksum", "RESUME_CHECKSUM", "") ; "Resume Game" Button
Global $checksum4 = IniRead($settingsFile, "Checksum", "START_CHECKSUM", "") ; "Start Game" Button
Global $checksum5 = IniRead($settingsFile, "Checksum", "TOWN_CHECKSUM", "") ; "In Town" Buff
Global $checksum6 = IniRead($settingsFile, "Checksum", "TRINKET_CHECKSUM", "") ; "Trinket" tab Icon


; ----------------------------------------------------------------------------
; Hotkeys
; ----------------------------------------------------------------------------
Global Const $startHotkey	= IniRead($settingsFile, "Hotkeys", "START_HOTKEY",	"F1")
Global Const $pauseHotkey	= IniRead($settingsFile, "Hotkeys", "PAUSE_HOTKEY",	"F2")
Global Const $quitHotkey	= IniRead($settingsFile, "Hotkeys", "QUIT_HOTKEY",	"F3")
Global Const $runsHotkey	= IniRead($settingsFile, "Hotkeys", "RUNS_HOTKEY",	"F6")

; ----------------------------------------------------------------------------
; Run Variables
; ----------------------------------------------------------------------------
Global $runs = IniRead($settingsFile, "RunCount", "RUNS", 0) ; Run Count
Global $createAuctionTimer = 0

; ----------------------------------------------------------------------------
; StartD3 Globals
; ----------------------------------------------------------------------------
Global Const $d3Proc = "Diablo III.exe"
Global Const $d3Title = "Diablo III"
Global Const $authProc = "WinAuth.exe"
Global Const $authTitle = "WinAuth - authenticator"
