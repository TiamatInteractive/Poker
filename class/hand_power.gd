extends Node

# Return 0 or [5-14], 0 being that there is not flush and 2-14 the highest value from the flush
func flush(hand:Hand, table: Array)->int:
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
		var id = naipe_equal_id.size()
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
	if biggest_naipe_value > 4:
		return naipe_biggest_number[biggest_naipe_id]
	return 0

# Return 0 or [5-14], 0 being that there is not straight and 2-14 the highest value from the straight
func straight(all_cards:Array)->int:
	var biggest_number = 0
	var straight_size = 0
	var max_straight_size = 0
	for i in range(1,all_cards.size()):
		var card1 = all_cards[i].get_value()
		var card2 = all_cards[i-1].get_value()
		if all_cards[i].get_value()==all_cards[i-1].get_value()-1:
			straight_size+=1
			if straight_size == 1:
				biggest_number = all_cards[i-1].get_value()
		elif all_cards[i].get_value()!=all_cards[i-1].get_value():
			straight_size = 0
		if straight_size == 4:
			break
	if straight_size==3:
		if all_cards[0].number==all_cards[all_cards.size()-1].number-1:
			straight_size+=1
	if straight_size==4:
		return biggest_number
	return 0
	
# Return 0 or [5-14], 0 being that there is not a straight_flush and 2-14 the highest value from the straight_flush
func straight_flush(all_cards:Array)->int:
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
	var straight_flush_value = straight(all_cards.filter(func(card): return card.color == naipe_color))
	return straight_flush_value
	
# Return 0 or [1000-1014] or [3000-3014] or [7000-7014]
# 0 being that there is no multiple value
# [1000-1014] being that there at most a pair and return the value of the pair
# [3000-3014] being that the most valuable a three of a kind and return the value of the three of a kind
# [7000-7014] being that the most valuable a four of a kind and return the value of the four of a kind

func verify_multiple(all_cards:Array)->int:
	var multiple = 0
	var value = 0
	var is_multi_equal = 0
	for i in range(1,all_cards.size()):
		if all_cards[i].number==all_cards[i-1].number:
			is_multi_equal +=1
		else:
			if is_multi_equal > multiple:
				value = all_cards[i-1].get_value() - 1
				multiple = is_multi_equal
			is_multi_equal = 0
	if is_multi_equal > multiple:
		value = all_cards[all_cards.size()-1].get_value()-1
		multiple = is_multi_equal
	if multiple == 3:
		return 70000 + value
	if multiple == 2:
		return 30000 + value
	if multiple == 1:
		return 10000 + value
	return 0
	
# Return 0 or [1000-1014]
# 0 being that there is no second pair value
# [1000-1014] being that there is a second pair and return the value of the pair
func verify_multiple_secondary(all_cards:Array)->int:
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
				value = all_cards[i-1].get_value() - 2
				multiple = is_multi_equal
			elif is_multi_equal>multiple_second:
				value_second = all_cards[i-1].get_value() - 2
				multiple_second = is_multi_equal
			is_multi_equal = 0
	if multiple_second == 1:
		return 10000 + value_second
	return 0
func get_high_card_pair(hand:Hand, table:Array, look_at_most:int, not_this:Array[int])-> int:
	table.sort_custom(compare_by_value)
	var cards = hand.get_card().filter(func(card): return !not_this.has(card.get_value()))
	cards.sort_custom(compare_by_value)
	var second_pointer = 0
	table = table.filter(func(card): return !not_this.has(card.get_value()))
	var total_looked = 0
	var total = 0
	var first = look_at_most != 1
	for i in cards:
		while second_pointer<table.size() && i.get_value() <= table[second_pointer].get_value():
			second_pointer +=1
			total_looked +=1
		if total_looked >= look_at_most:
			break
		if first:
			first = false
			total += (i.get_value()-1)*14
		else:
			total += i.get_value()-2
	return total
	
func get_high_card(hand:Hand, table:Array)-> int:
	table.sort_custom(compare_by_value)
	var card1 = hand.card1
	var card2 = hand.card2
	if card1.get_value() < card2.get_value():
		var cop = card1
		card1 = card2
		card2 = cop
	var card_atual = card1
	var cont = 0
	var find = 0
	var total = 0
	while cont + find<5 && find<2 && cont<table.size():
		if card_atual.get_value() > table[cont].get_value():
			if find == 0:
				total += (card_atual.get_value()-1) * 14
				card_atual = card2
			else:
				total += card_atual.get_value() -2
			find +=1
		else:
			cont += 1
	return total
	
func get_value_hand(hand:Hand, table:Array):
	var is_flush = flush(hand,table.duplicate())
	var all_cards:Array = table.duplicate()
	all_cards.append_array(hand.get_card())
	all_cards.sort_custom(compare_by_value)
	var is_straight = straight(all_cards)
	if is_flush > 0 && is_straight > 0:
		var is_straight_flush = straight_flush(all_cards)
		if is_straight_flush == 14:
			return 90000
		if is_straight_flush>0:
			return 80000 + is_straight_flush
	var mult_level = verify_multiple(all_cards)
	if mult_level >= 70000:
		return ((mult_level-70000)*14+70000) + get_high_card_pair(hand,table, 1, [mult_level-70000+1])
	var secondary_mult_level = verify_multiple_secondary(all_cards)
	if mult_level >= 30000 && secondary_mult_level>=10000:
		return 20000 + ((mult_level-30000)*14+30000) + secondary_mult_level
	if is_flush > 0:
		return 50000 + is_flush
	if is_straight > 0:
		return 40000 + is_straight
	if mult_level >= 30000:
		var tree_of_kind = (mult_level-30000)*14*14+30000
		var high_card = get_high_card_pair(hand,table, 2,[mult_level-30000+1])
		return tree_of_kind + high_card
	if secondary_mult_level >= 10000:
		var first_pair = (mult_level-10000)*14*14+10000
		var second_pair = (secondary_mult_level-10000)*14+10000
		var hish_card = get_high_card_pair(hand,table, 1, [mult_level-10000+1,secondary_mult_level-10000+2])
		return first_pair + second_pair + hish_card
	if mult_level >= 10000:
		var pair = (mult_level-10000)*14*14+10000
		var high_card = get_high_card_pair(hand,table, 3,[mult_level-10000+1])
		return pair + high_card
	return get_high_card(hand,table)
	
func compare_by_value(a,b):
	return a.get_value() > b.get_value()
