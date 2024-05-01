extends Control

var card:Card :
	get:
		return card
	set(value):
		card = value
		change_all() 

func _ready():
	change_all()
	
func change_all():
	if ["H", "D"].has(card.color):
		$VBoxContainer/HBoxContainer2/DownLabel.label_settings = load("res://assets/fonts/red.tres")
		$VBoxContainer/HBoxContainer3/MidLabel.label_settings = load("res://assets/fonts/red_big.tres")
		$VBoxContainer/HBoxContainer/UpLabel.label_settings = load("res://assets/fonts/red.tres")
	var text = card.color.to_upper()
	$VBoxContainer/HBoxContainer/UpSymbol.texture = load("res://assets/image/"+card.color.to_upper()+".png")
	$VBoxContainer/HBoxContainer2/DownSymbol.texture = load("res://assets/image/"+card.color.to_upper()+".png")
	$VBoxContainer/HBoxContainer2/DownLabel.text = card.get_text()
	$VBoxContainer/HBoxContainer3/MidLabel.text = card.get_text()
	$VBoxContainer/HBoxContainer/UpLabel.text = card.get_text()
