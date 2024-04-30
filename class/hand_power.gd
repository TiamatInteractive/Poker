extends Node

# Return 0 or [5-14], 0 being that there is not flush and 2-14 the highest value from the flush
func flush(hand:Hand, table: Array[Card])->int:
	var cont = 0
	var biggest_naipe_id = 0
	var biggest_naipe_value = 0
	var naipe_biggest_number: Array[int]
	var naipe_equal_number: Array[int]
	var naipe_equal_id: Array[String]
	table.append_array(hand.get_card())
	for i in table:
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
			biggest_naipe_value = naipe_equal_number[id]
			biggest_naipe_id = id
		if biggest_naipe_value - cont <= -3:
			return 0
	if biggest_naipe_value>4:
		return naipe_biggest_number[biggest_naipe_id]
	return 0

# Return 0 or [5-14], 0 being that there is not straight and 2-14 the highest value from the straight
func straight(all_cards:Array[Card])->int:
	var biggest_number = 0
	var straight_size = 0
	for i in range(1,all_cards.size()):
		if all_cards[i].get_value()==all_cards[i-1].get_value()-1:
			straight_size+=1
			if straight_size == 1:
				biggest_number = all_cards[i].get_value()
		elif all_cards[i].get_value()!=all_cards[i-1].get_value():
			straight_size = 0
		if straight_size == 5:
			break
	if straight_size==4:
		if all_cards[0].number==all_cards[all_cards.size()-1].number-1:
			straight_size+=1
	if straight_size==5:
		return biggest_number
	return 0
	
# Return 0 or [5-14], 0 being that there is not a straight_flush and 2-14 the highest value from the straight_flush
func straight_flush(all_cards:Array[Card])->int:
	var naipe : Dictionary = {}
	for i in all_cards:
		if naipe.has(i.color):
			naipe[i.color] += 1
		else:
			naipe[i.color] = 1
	var naipe_color = ""
	var naipe_value = 0
	for i in naipe.keys():
		if naipe_value < naipe[i]:
			naipe_color = i
			naipe_value = naipe[i]
	var straight_flush_value = straight(all_cards.filter(func(card): return card.color != naipe_color))
	return straight_flush_value
	
# Return 0 or [1000-1014] or [3000-3014] or [7000-7014]
# 0 being that there is no multiple value
# [1000-1014] being that there at most a pair and return the value of the pair
# [3000-3014] being that the most valuable a three of a kind and return the value of the three of a kind
# [7000-7014] being that the most valuable a four of a kind and return the value of the four of a kind

func verify_multiple(all_cards:Array[Card])->int:
	var multiple = 0
	var value = 0
	var is_multi_equal = 0
	for i in range(1,all_cards.size()):
		if all_cards[i].number==all_cards[i-1].number:
			is_multi_equal +=1
		else:
			if is_multi_equal > multiple:
				value = all_cards[i-1].get_value()
				multiple = is_multi_equal
	if multiple == 3:
		return 7000 + value
	if multiple == 2:
		return 3000 + value
	if multiple == 1:
		return 1000 + value
	return 0
	
# Return 0 or [1000-1014]
# 0 being that there is no second pair value
# [1000-1014] being that there is a second pair and return the value of the pair
func verify_multiple_secondary(all_cards:Array[Card])->int:
	var multiple = 0
	var value = 0
	var multiple_second = 0
	var value_second = 0
	var is_multi_equal = 0
	for i in range(1,all_cards.size()):
		if all_cards[i].number==all_cards[i-1].number:
			is_multi_equal +=1
		else:
			if is_multi_equal > multiple:
				value_second = value
				multiple_second = multiple
				value = all_cards[i-1].get_value()
				multiple = is_multi_equal
			elif is_multi_equal>multiple_second:
				value_second = all_cards[i-1].get_value()
				multiple_second = is_multi_equal
	if multiple_second == 1:
		return 1000 + value_second
	return 0
	
# Return [2-14], being the best card that is not in the four of a kind
# and not in the first or second pair or three of a kind
func get_high_card_not_multiple(hand:Hand, is_four:bool, table:Array[Card])->int:
	#Sort array
	var card1 = hand.card1
	var card2 = hand.card2
	var is_equal = false
	if card1.get_value() == card2.get_value():
		is_equal = true
	if card2.get_value()>card1.get_value():
		var nothing = card1
		card1 = card2
		card2 = nothing
	var multiple = 0
	for i in table:
		if i.get_value() == card1.get_value():
			multiple+=1
	if is_four:
		if multiple < 3:
			return card1.get_value()
		if !is_equal:
			return card2.get_value()
		return 0
	if 	multiple == 0:
		return card1.get_value()
	multiple=0
	for i in table:
		if i.get_value() == card2.get_value():
			multiple+=1	
	if 	multiple == 0:
		return card2.get_value()
	return 0
	
func get_value_hand(hand:Hand, table:Array[Card]):
	
	var is_flush = flush(hand,table)
	var all_cards:Array[Card] = table
	all_cards.append_array(hand.get_card())
	all_cards.sort_custom(compare_by_value)
	var is_straight = straight(all_cards)
	if is_flush > 0 && is_straight > 0:
		var is_straight_flush = straight_flush(all_cards)
		if is_straight_flush == 14:
			return 9000
		if is_straight_flush>0:
			return 8000 + is_straight_flush
	var mult_level = verify_multiple(all_cards)
	if mult_level >= 7000:
		return mult_level + get_high_card_not_multiple(hand,true,table)
	var secondary_mult_level = verify_multiple_secondary(all_cards)
	if mult_level >= 3000 && secondary_mult_level>=1000:
		return 1000 + ((mult_level-3000)*20+3000) + secondary_mult_level
	if is_flush > 0:
		return 5000 + is_flush
	if is_straight > 0:
		return 4000 + is_straight
	if mult_level >= 3000:
		return mult_level + get_high_card_not_multiple(hand,false,table)
	if secondary_mult_level >= 1000:
		return ((mult_level-1000)*20+1000) + secondary_mult_level + get_high_card_not_multiple(hand,false,table)
	if mult_level >= 1000:
		return mult_level + get_high_card_not_multiple(hand,false,table)
	return get_high_card_not_multiple(hand,false,table)
	
func compare_by_value(a,b):
	return a.get_value() < b.get_value()
