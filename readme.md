# Diablo 3 Shop and Auctionhouse bot

This is a research project to show the capabilities of autoIT in combination with
virtual machines for bots run with optical character recognition (OCR) and pixel detection
using windows OCR functions as well as showing autoIT rapid deployment inside Windows
virtual machines.
Includes a graphical user interface as well as extended logging capabilties.
Do not use this bot in real Diablo 3 since it is against the terms of services!

## Idea

To read the stats of given items, we use screen shot the item and do image transformation.
After that, we extract the image text with microsoft OCR functions and compare
the stats extracted with the pickit.ini files to look for certain stats.
The auction house bot is build on pixel detection and checksums to track the state
of auctions, creation of auctions as well as retrieving money.

## Setup

- run JinMain.au3
- Starts the setup on first runtime to setup pickits and config .inis
