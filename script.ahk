; Author: Michael Weger
; A macro for playing Marisa+Patchy in Touhou 11: Subterranean Animism
; Allows the player to quick cycle between shot types

#NoEnv   					 ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  					 ; Enable warnings to assist with detecting common errors.
SendMode Input  			 ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force		 ; Prevents multiple instances of this script from simeotaneously running.

;===================================================================================================
; Variable and constant declaration.
;===================================================================================================

; Current shot type being used.
; Defaults to kShotsFireSign at the start of each session but persists between stages.
currentShotType := 0

; Constants defining the different shot types available with Patchy
kShotsFireSign  := 0
kShotsWaterSign := 1
kShotsWoodSign  := 2
kShotsMetalSign := 3
kShotsEarthSign := 4


;===================================================================================================
;Shortcuts
;===================================================================================================
Hotkey  *Space,    CycleShots        ; Pressing Space will cycle shot types
Hotkey  *C,        SetShotsFireSign  ; Pressing C will set the shot type to Fire Sign.
HotKey  *A,        SetShotsWaterSign ; Pressing A will set the shot type to Water Sign.
HotKey  *S,        SetShotsWoodSign  ; Pressing S will set the shot type to Wood Sign.
HotKey  *V,        SetShotsMetalSign ; Pressing V will set the shot type to Metal Sign.
HotKey  *D,        SetShotsEarthSign ; Pressing D will set the shot type to Earth Sign.
HotKey  *RControl, Reset             ; Resets the script logic to shot type 0.
									 ; Players will need to hit reset when they die in the middle of a SetShot hotkey or use the default shot change.


;===================================================================================================
;GUI
;===================================================================================================
Gui, Add, Button, w130 gReset, % "Reset"
Gui, Add, Button, w130 gStop,  % "Stop"
Gui, Add, Text, vShotText, % "Active Shot: Fire Sign____" ; The text here needs to be large enough to store the other shot names, but it won't allow whitespace even in quotes
Gui, Add, Picture, w130 h100 vShotImage, images/Fire Sign.png
Gui, Color, EB3636
Gui, Show, w150 h190, % "[SA] MarisaPatchy Shot Macro"
UpdateGUI()


;===================================================================================================
;Timed Tasks
;===================================================================================================
#Persistent
SetTimer, UpdateGUI, 1000
return


;===================================================================================================
; Triggers
;===================================================================================================

; We only want this script to do anything while tabbed into SA
#IfWinActive Touhou Chireiden - Subterranean Animism

CycleShots:
	CycleShots()
	return

SetShotsFireSign:
	SetShots(kShotsFireSign)
	return

SetShotsWaterSign:
	SetShots(kShotsWaterSign)
	return

SetShotsWoodSign:
	SetShots(kShotsWoodSign)
	return

SetShotsMetalSign:
	SetShots(kShotsMetalSign)
	return

SetShotsEarthSign:
	SetShots(kShotsEarthSign)
	return

Reset:
	currentShotType = 0
	UpdateGUI()
	return

UpdateGUI:
	UpdateGUI()
	return

Stop:
	GuiClose:
	GuiEscape:
	ExitApp
	return


;===================================================================================================
; Functions
;===================================================================================================

; Cycles through shot types in order one at a time
CycleShots()
{
	; Global variables
	global currentShotType
	global kShotsFireSign
	global kShotsEarthSign
	
	; Store current states to restore them later
	lShiftInitialState := GetKeyState("LShift", "P")
	zInitialState      := GetKeyState("Z")
	

	; Release LShift and Z and wait for game to update in case Marisa is already focused and firing
	SendInput, {Blind} {LShift up} {Z up}
	Sleep, 40
	
	; Swap shot type and wait for game to update
	SendInput, {Blind} {LShift down} {Z down}
	Sleep, 40
	
	; Force keys up and restore any prior input
	SendInput, {Blind} {LShift up} {Z up}
	
	if(lShiftInitialState && zInitialState)
		SendInput, {Blind} {LShift down} {Z down}
		
	else if(lShiftInitialState)
		SendInput, {Blind} {LShift down}
		
	else if(zInitialState)
		SendInput, {Blind} {Z down}
	
	
	currentShotType++
	
	if(currentShotType > kShotsEarthSign)
		currentShotType := kShotsFireSign
	
	UpdateGUI()
}


; Sets shot type to the specified type
SetShots(shotType)
{
	; Global variables
	global currentShotType
	global kShotsEarthSign
	
	difference  := shotType - currentShotType
	
	if(difference > 0)
		loopCounter := Abs(difference)
	
	else
		loopCounter := difference + kShotsEarthSign + 1
	
	Loop, %loopCounter%
	{
		Sleep, 40
		CycleShots()
	}
}

ShotTypeToString(shotType)
{
	; Global variables
	global kShotsFireSign
	global kShotsWaterSign
	global kShotsWoodSign
	global kShotsMetalSign
	global kShotsEarthSign
	
	shotTypeStr := ""
	
	if(shotType == kShotsFireSign)
		shotTypeStr := "Fire Sign"
	
	else if(shotType == kShotsWaterSign)
		shotTypeStr := "Water Sign"
	
	else if(shotType == kShotsWoodSign)
		shotTypeStr := "Wood Sign"
		
	else if(shotType == kShotsMetalSign)
		shotTypeStr := "Metal Sign"
	
	else if(shotType == kShotsEarthSign)
		shotTypeStr := "Earth Sign"
	
	return shotTypeStr
}

ShotTypeToColor(shotType)
{
	; Global variables
	global kShotsFireSign
	global kShotsWaterSign
	global kShotsWoodSign
	global kShotsMetalSign
	global kShotsEarthSign
	
	shotTypeColor := 000000
	
	if(shotType == kShotsFireSign)
		shotTypeColor := "EB3636"
	
	else if(shotType == kShotsWaterSign)
		shotTypeColor := "0CB0FC"
	
	else if(shotType == kShotsWoodSign)
		shotTypeColor := "24FC0C"
		
	else if(shotType == kShotsMetalSign)
		shotTypeColor := "FCDC0C"
	
	else if(shotType == kShotsEarthSign)
		shotTypeColor := "FC880C"
	
	return shotTypeColor
}

; Updates the GUI based on the current shot
UpdateGUI()
{
	; Global Variables
	global currentShotType
	
	shotName  := ShotTypeToString(currentShotType)
	shotColor := ShotTypeToColor(currentShotType)
	
	GuiControl,, ShotText, % "Active Shot: " . shotName
	GuiControl,, ShotImage, % "images/" . shotName . ".png"
	Gui +LastFound  
	Gui, Color, % shotColor

}