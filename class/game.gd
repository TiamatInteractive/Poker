extends Node

@export var number_players:int = 2
var table: Array[Card]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Return 0 or [2-14], 0 being that there is not flush and 2-14 the highest value from the flush
func flush(hand:Hand)->int:
	var cont = 0
	var biggest_naipe_id = 0
	var biggest_naipe_value = 0
	var naipe_biggest_number: Array[int]
	var naipe_equal_number: Array[int]
	var naipe_equal_id: Array[String]
	var test:Array[Card] = table
	test.append_array(hand.get_card())
	for i in test:
		cont+=1
		var is_new_naipe = true
		var id = 0
		for j in range(naipe_equal_id.size()):
			if naipe_equal_id[j] == i.color:
				is_new_naipe = false
				id = j
		if is_new_naipe:
			naipe_equal_number.append(0)
			naipe_equal_id.append(i.color)
			naipe_biggest_number.append(i.get_value())
		naipe_equal_number[id] += 1
		if i.get_value() > naipe_biggest_number[id]:
			naipe_biggest_number[id] = i.get_value()
		if naipe_equal_number[id] > biggest_naipe_value:
			biggest_naipe_value = naipe_equal_id[id]
			biggest_naipe_id = id
		if biggest_naipe_value - cont <= -3:
			return 0
	if biggest_naipe_value>4:
		return naipe_biggest_number[biggest_naipe_id]
	return 0

# Return 0 or [5-14], 0 being that there is not straight and 2-14 the highest value from the straight
func straight(hand:Hand)->int:
	return 0
	
# Return 0 or [5-14], 0 being that there is not a straight_flush and 2-14 the highest value from the straight_flush
func straight_flush(hand:Hand)->int:
	return 0
	
# Return 0 or [1000-1014] or [3000-3014] or [7000-7014]
# 0 being that there is no multiple value
# [1000-1014] being that there at most a pair and return the value of the pair
# [3000-3014] being that the most valuable a three of a kind and return the value of the three of a kind
# [7000-7014] being that the most valuable a four of a kind and return the value of the four of a kind

func verify_multiple(hand:Hand)->int:
	return 0
	
# Return 0 or [1000-1014]
# 0 being that there is no second pair value
# [1000-1014] being that there is a second pair and return the value of the pair
func verify_multiple_secondary(hand:Hand)->int:
	return 0
	
# Return [2-14], being the best card that is not in the four of a kind
# and not in the first or second pair or three of a kind
func get_high_card_not_multiple(hand:Hand)->int:
	return 0
	
func get_value_hand(hand:Hand):
	
	var is_flush = flush(hand)
	var is_straight = straight(hand)
	if is_flush > 0 && is_straight > 0:
		var is_straight_flush = straight_flush(hand)
		if is_straight_flush == 14:
			return 9000
		if is_straight_flush>0:
			return 8000 + is_straight_flush
	var mult_level = verify_multiple(hand)
	if mult_level >= 7000:
		return mult_level + get_high_card_not_multiple(hand)
	var secondary_mult_level = verify_multiple_secondary(hand)
	if mult_level >= 3000 && secondary_mult_level>=1000:
		return 1000 + ((mult_level-3000)*20+3000) + secondary_mult_level
	if is_flush > 0:
		return 5000 + is_flush
	if is_straight > 0:
		return 4000 + is_straight
	if mult_level >= 3000:
		return mult_level + get_high_card_not_multiple(hand)
	if secondary_mult_level >= 1000:
		return ((mult_level-1000)*20+1000) + secondary_mult_level + get_high_card_not_multiple(hand)
	if mult_level >= 1000:
		return mult_level + get_high_card_not_multiple(hand)
	return get_high_card_not_multiple(hand)
	
