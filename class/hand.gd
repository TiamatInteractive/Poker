class_name Hand

var card1: Card
var card2: Card

func get_card()->Array[Card]:
	return [card1, card2]

func _init(_card1:Card, _card2:Card):
	card1 = _card1
	card2 = _card2
