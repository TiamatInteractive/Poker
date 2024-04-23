extends MarginContainer

var card:Card

func _ready():
	card = Card.new(1,"E")
	$card_sprite.texture = load("res://assets/image/"+card.color+str(card.number)+".png")
