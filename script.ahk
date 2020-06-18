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
; Defaults to kShotsForward at the start of each session but persists between stages.
currentShotType := 0

; Constants defining the different shot types available with Patchy
kShotsForward  := 0
kShotsSpread   := 1
kShotsTriple   := 2
kShotsSidewise := 3
kShotsBackward := 4


;===================================================================================================
;Shortcuts
;===================================================================================================
Hotkey  *Space,   CycleShots        ; Pressing Space will cycle shot types
Hotkey  *C,       SetShotsForward   ; Pressing C will set the shot type to forward.
HotKey  *D,       SetShotsSpread    ; Pressing D will set the shot type to spread.
HotKey  *S,       SetShotsTriple    ; Pressing S will set the shot type to triple.
HotKey  *A,       SetShotsSidewise  ; Pressing A will set the shot type to sidewise.
HotKey  *F,       SetShotsBackward  ; Pressing F will set the shot type to backward.


;===================================================================================================
;GUI
;===================================================================================================
Gui, Add, Button, gStop, % "Stop"
Gui, Show, w250 h50, % "[SA] MarisaPatchy Shot Macro"
return


;===================================================================================================
; Triggers
;===================================================================================================

; We only want this script to do anything while tabbed into SA
#IfWinActive Touhou Chireiden - Subterranean Animism

CycleShots:
	CycleShots()
	return

SetShotsForward:
	SetShots(kShotsForward)
	return

SetShotsSpread:
	SetShots(kShotsSpread)
	return

SetShotsTriple:
	SetShots(kShotsTriple)
	return

SetShotsSidewise:
	SetShots(kShotsSidewise)
	return

SetShotsBackward:
	SetShots(kShotsBackward)
	return

Reset:
	currentShotType = 0
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
	global kShotsForward
	global kShotsBackward
	
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
	
	if(currentShotType > kShotsBackward)
		currentShotType := kShotsForward
}


; Sets shot type to the specified type
SetShots(shotType)
{
	; Global variables
	global currentShotType
	global kShotsBackward
	
	difference  := shotType - currentShotType
	
	if(difference > 0)
		loopCounter := Abs(difference)
	
	else
		loopCounter := difference + kShotsBackward + 1
	
	Loop, %loopCounter%
	{
		Sleep, 40
		CycleShots()
	}
}