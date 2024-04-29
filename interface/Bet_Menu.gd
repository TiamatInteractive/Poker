extends Control

var pot:int = 1000
@export var big_bind = 120
@export var actual_bet:int = 0
@export var max_bet:int = 10000
var raise_value:int = 0
signal call_check()
signal raise(value:int)
signal fold()

# Called when the node enters the scene tree for the first time.
func _ready():
	pot = Bet.pot
	$BetContainer.visible = false
	if actual_bet > 0:
		$ActionContainer/Check.text = "Call"
	if max_bet > pot:
		$BetContainer/Buttons/Pot.visible = true
	else:
		$BetContainer/Buttons/Pot.visible = false
	if max_bet > int(pot/2 * 3):
		$BetContainer/Buttons/TwoThirdPot.visible = true
	else:
		$BetContainer/Buttons/Pot.visible = false
	if max_bet > int(pot/2):
		$BetContainer/Buttons/HalfPot.visible = true
	else:
		$BetContainer/Buttons/Pot.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BetContainer/Value/RaiseValue.text = str(raise_value)
	$BetContainer/Value/RaiseSlider.value = raise_value


func _on_raise_pressed():
	$ActionContainer.visible = false
	$BetContainer.visible = true

func _on_return_pressed():
	$ActionContainer.visible = true
	$BetContainer.visible = false

func _on_pot_pressed():
	raise_value = pot

func _on_two_third_pot_pressed():
	raise_value = int(pot/2*3)


func _on_half_pot_pressed():
	raise_value = int(pot/2)



func _on_all_in_pressed():
	raise_value = max_bet


func _on_raise_slider_value_changed(value):
	raise_value = value


func _on_check_pressed():
	call_check.emit()

func _on_fold_pressed():
	fold.emit()

func _on_bet_pressed():
	raise.emit(raise_value)
