#cs ---------------------------------------------------------------------------

    @Main:      JinMain.au3

    @Project:   Jin Shop
    @Version:   1.0
    @Created:   14.06.2012
    @Author:    TeTuBe

    @Environment:   Windows
    @References:    /

    @Description:   Main Routin.
    @Usage:         Run JinMain.au3

#ce ---------------------------------------------------------------------------

#include "src\JinShopGlobal.au3"
#include "src\JinAuctionGlobal.au3"
#include "src\JinGUI.au3"
#include "src\JinAuction.au3"
#include "src\JinShop.au3"

_main()

Func _main()
	$status = $statusStarted
	_JinInit()
	_logTime($status)
	$status = $statusPaused

	While 1
		If $status <> $statusPaused Then
			_start()
		EndIf
		sleep(100)
	WEnd

EndFunc
