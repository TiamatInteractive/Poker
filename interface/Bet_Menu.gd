extends Control

var pot:int = 1000
@export var min_bet = 120:
	get:
		return min_bet
	set(value):
		min_bet = value
		if actual_bet < min_bet:
			$BetContainer/Value/RaiseSlider.min_value = min_bet
		else:
			$BetContainer/Value/RaiseSlider.min_value = actual_bet
@export var actual_bet:int = 0:
	get:
		return actual_bet
	set(value):
		actual_bet = value
		if actual_bet > 0:
			$ActionContainer/Check.text = "Call"
		if actual_bet < min_bet:
			$BetContainer/Value/RaiseSlider.min_value = min_bet
		else:
			$BetContainer/Value/RaiseSlider.min_value = actual_bet
@export var max_bet:int = 10000 :
	get:
		return max_bet
	set(value):
		max_bet = value
		if max_bet > pot:
			$BetContainer/Buttons/Pot.visible = true
		else:
			$BetContainer/Buttons/Pot.visible = false
		if max_bet > int(pot/3 * 2):
			$BetContainer/Buttons/TwoThirdPot.visible = true
		else:
			$BetContainer/Buttons/Pot.visible = false
		if max_bet > int(pot/2):
			$BetContainer/Buttons/HalfPot.visible = true
		else:
			$BetContainer/Buttons/Pot.visible = false
		$BetContainer/Value/RaiseSlider.max_value = max_bet
		
		
var raise_value:int = 120
signal call_check()
signal raise(value:int)
signal fold()

# Called when the node enters the scene tree for the first time.
func _ready():
	pot = Bet.pot
	$BetContainer.visible = false
	$BetContainer/Value/RaiseSlider.step = 1
	

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
	raise_value = int(pot/3*2)


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


func _on_property_list_changed():
	pass # Replace with function body.
