#cs --------------------------------------------------------------------------

	@Main: 	JinAuctionGlobal.au3

	@Project: 	Jin Shop
	@Version:	1.0
	@Created:	09.06.2012
	@Author:	abraXas, TeTuBe

	@Environment:	Windows
	@References:	/

	@Description:	Header for global settings.
	@Usage:			Include.

#ce --------------------------------------------------------------------------

#include-once

#include <JinShopGlobal.au3>

; ----------------------------------------------------------------------------
; Item Prices
; ----------------------------------------------------------------------------
Global $stashPrice1 = IniRead($settingsFile, "Auction", "PRICE_STASH_1", 0)
Global $stashPrice2 = IniRead($settingsFile, "Auction", "PRICE_STASH_2", 0)
Global $stashPrice3 = IniRead($settingsFile, "Auction", "PRICE_STASH_3", 0)
Global $invPrice1 	= IniRead($settingsFile, "Auction", "PRICE_INVENTORY_1", 0)
Global $currentItemPrice = 0


; ----------------------------------------------------------------------------
; Stash (7 x 10 spaces)
; ----------------------------------------------------------------------------
Global $aStash[7][10]
Global $stashItemCount = 70
Global $currentStash = 0

; ----------------------------------------------------------------------------
; Stash Position/Cords/Offsets
; ----------------------------------------------------------------------------
Global $xStashStartPos   = 415
Global $yStashStartPos   = 305
Global $xStashSlotOffset = 55 ;55x55 = 1 slot
Global $yStashSlotOffset = 55 ;55x55 = 1 slot
Global $xStashLastPos    = 0
Global $yStashLastPos    = 0

; ----------------------------------------------------------------------------
; Inventory (10 x 6 spaces)
; ----------------------------------------------------------------------------
Global $aInventory[10][6]
Global $stashItemCount = 60

; ----------------------------------------------------------------------------
; Inventory Position/Cords/Offsets
; ----------------------------------------------------------------------------
Global $xInventoryStartPos   = 0
Global $yInventoryStartPos   = 0
Global $xInventorySlotOffset = 0
Global $yInventorySlotOffset = 0

; ----------------------------------------------------------------------------
; Stashes and Inventorys (Sell variables)
; ----------------------------------------------------------------------------
Global $sellStash1      = IniRead($settingsFile, "Auction", "SELL_STASH_1", 0)
Global $sellStash2      = IniRead($settingsFile, "Auction", "SELL_STASH_2", 0)
Global $sellStash3      = IniRead($settingsFile, "Auction", "SELL_STASH_3", 0)
Global $sellInventory1  = IniRead($settingsFile, "Auction", "SELL_INVENTORY_1", 0)