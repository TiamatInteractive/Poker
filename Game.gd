extends Control

#0: select binds and start bets
#1: verify if there is more than one person betting, open 3 cards and start bets
#2: verify if there is more than one person betting, open 1 card and start bet
#3: verify if there is more than one person betting, open 1 card and start bet
#4: verify if there is more than one person betting, if not, not open hands and select winner
const card_base = preload("res://interface/Card_Base.tscn")
const xs_cards = [1, 0.50, 0.50, 0.50, 1, 1.50, 1.50, 1.50]
const ys_cards = [1.50, 1.50, 1, 0.50, 0.50, 0.50, 1, 1.50]
const x_offset = [72.5,45,0,-45,-72.5,-45,0,-45]
const y_offset = [0,45,72.5,45,0,-45,75.5,45]
const rotation_degrees_cards = [0, 45, 90, 135, 180, 225, 270, 315]
var start_stack:int
var step:int
var packet:Packet
var id_player_actual:int
var id_button:int
var big_bind:int
var small_bind:int
var actual_bet:int
var players: Array
var table: Array[Card]
var hands_draw: Array
var table_draw: Array
const scale1 = Vector2(0.25, 0.25)
@export var number_player:int
@export var debug:bool = true

@onready var bet_menu = $BetMenu
@onready var ui_menu = $UiBet
# Called when the node enters the scene tree for the first time.
func _ready():
	packet = Packet.new()
	step = 0
	id_button = randi_range(0, number_player-1)
	id_player_actual = id_button
	if debug:
		big_bind = 100
		small_bind = 50
		actual_bet = 0
		number_player = 2
		start_stack = 10000
	players.append(Player.new(start_stack, 0, false))
	for i in range(number_player-1):
		players.append(Player.new(start_stack, i+1))
	#for i in range(number_player):
		#players.append(Player.new(start_stack,i))
	ui_menu.set_players_value(players)
	$Start.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HBoxContainer.size = Vector2(get_viewport_rect().size.x,0)
	$HBoxContainer/Pot.text = "Pot: " + str(Bet.pot)
	$Mesa.size = get_viewport_rect().size

func _on_bet_menu_call_check():
	players[id_player_actual].was_played = true
	var t = players[id_player_actual].actual_bet
	players[id_player_actual].stack -= actual_bet - players[id_player_actual].actual_bet
	players[id_player_actual].actual_bet = actual_bet
	players[id_player_actual].action = "check"
	next_player(true)
	#call/check animation

func _on_bet_menu_fold():
	players[id_player_actual].is_playing = false
	players[id_player_actual].action = "fold"
	next_player(true)
	#fold animation

func _on_bet_menu_raise(value):
	players = players.map(set_player_not_played)
	players[id_player_actual].was_played = true
	players[id_player_actual].actual_bet = value
	players[id_player_actual].stack -= value
	actual_bet = value
	players[id_player_actual].action = "raise"
	next_player(true)
	#raise animation

func _on_start_timeout():
	Bet.pot = 0
	table = []
	id_button = (id_button + 1)%number_player
	step = 0
	next_step()
	
func _on_ia_timeout():
	_on_bet_menu_call_check()
	
func _on_fold_time_timeout():
	_on_bet_menu_fold()
	
func next_player(get_next:bool = false):
	ui_menu.set_player_value(players[id_player_actual])
	if bet_menu.visible:
		bet_menu.visible = false
	#select next player
	if get_next:
		for i in range(1, number_player):
			var id:int = (id_player_actual + i) % number_player
			if players[id].is_playing:
				id_player_actual = id
				break
	if players.filter(func(player): return player.is_playing).size() == 1:
		step = 4
		next_step()
		return
	#verify if was ended
	if players[id_player_actual].was_played:
		#start next step of the round
		next_step()
		return
	if players[id_player_actual].is_ia:
		$Ia.start()
		return
	$FoldTime.start()
	bet_menu.visible = true
	bet_menu.actual_bet = actual_bet
	var stack = players[id_player_actual].stack
	bet_menu.max_bet = players[id_player_actual].stack

func next_step():
	players = players.map(set_player_not_played)
	ui_menu.set_players_value(players)
	match step:
		0:
			start_round()
		#1: verify if there is more than one person betting, open 3 cards and start bets
		1:  flop()
		#2: verify if there is more than one person betting, open 1 card and start bet
		2:
			river()
		#3: verify if there is more than one person betting, open 1 card and start bet
		3:
			turn()
		#4: verify if there is more than one person betting, if not, not open hands and select winner
		4:
			end_round()
	step+=1

func start_round():
	for i in hands_draw:
		$Hands.remove_child(i)
	hands_draw = []
	for i in table_draw:
		$Table.remove_child(i)
	table_draw = []
	#1: Start the round
	packet.set_new_packet()
	#2: Set big and small binds
	players = players.map(set_player_start)
	bet_menu.min_bet = big_bind
	players[id_button].mark = "D"
	var small_binder = players[(id_button+1)%number_player]
	var bet = select_bet(small_binder,small_bind)
	small_binder.actual_bet = bet
	small_binder.stack -= bet
	small_binder.mark = "SB"
	actual_bet = bet
	players[(id_button+1)%number_player] = small_binder
	var big_binder = players[(id_button+2)%number_player]
	bet = select_bet(big_binder,big_bind)
	big_binder.actual_bet = bet
	big_binder.stack -= bet
	big_binder.mark = "BB"
	if bet > actual_bet:
		actual_bet = bet
	players[(id_button+2)%number_player] = big_binder
	bet_menu.actual_bet = actual_bet
	id_player_actual = (id_button+2)%number_player
	ui_menu.set_players_value(players)
	next_player(true)

func flop():
	actual_bet = 0
	add_card_to_table(3)
	get_first_player()
	id_player_actual = id_button
	next_player(true)
	

func river():
	actual_bet = 0
	add_card_to_table(1)
	get_first_player()
	id_player_actual = id_button
	next_player(true)

func turn():
	actual_bet = 0
	add_card_to_table(1)
	get_first_player()
	id_player_actual = id_button
	next_player(true)
	
func end_round():
	var winner_point = 0
	var winner_id = []
	for i in range(players.size()):
		if !players[i].is_playing:
			continue
		var point = HandPower.get_value_hand(players[i].hand,table)
		print("points "+str(i)+"- "+str(point))
		if point>winner_point:
			winner_id = [i]
			winner_point = point
		elif point == winner_point:
			winner_id.append(i)
	var cont = 0
	for winner in winner_id:
		if cont > 0:
			cont +=1
		cont += 1
		print("winner: " + players[winner].hand.card1.get_text() + players[winner].hand.card1.color)
		print("winner: " + players[winner].hand.card2.get_text() + players[winner].hand.card2.color)
		var pot = Bet.pot
		var pot_value = Bet.pot/winner_id.size()
		players[winner].stack += pot_value
	players = players.filter(func(player:Player): return player.stack > 0)
	number_player = players.size()
	$Start.start()
	
func select_bet(player:Player, bet:int)->int:
	if player.stack < bet:
		return player.stack
	return bet

func set_player_start(player:Player) -> Player:
	player.is_playing = true
	player.mark = ""
	player.action = ""
	player.hand = Hand.new(packet.get_card(), packet.get_card())
	write_hand(player.hand, player.chair)
	print("1- " + player.hand.card1.get_text() + player.hand.card1.color)
	print("2- " + player.hand.card2.get_text() + player.hand.card2.color)
	print()
	return player
	
func set_player_not_played(player:Player) -> Player:
	player.was_played = false
	Bet.pot += player.actual_bet
	player.actual_bet = 0
	player.action = ""
	if !player.is_playing:
		player.action = "Fold"
	return player

func add_card_to_table(quantity:int):
	for i in range(quantity):
		var card = packet.get_card()
		print("table:" + card.get_text()+card.color)
		table.append(card)
		draw_card_to_table(card)
	
func draw_card_to_table(card:Card):
	var rect_size = get_viewport_rect().size / 2
	var new_card1 = card_base.instantiate()
	new_card1.card = card
	new_card1.size = Vector2(250,350)
	new_card1.position = Vector2(rect_size.x-180 + 70*table_draw.size(),rect_size.y-25)
	new_card1.pivot_offset = Vector2(0, 0)
	new_card1.scale = scale1
	$Table.add_child(new_card1, INTERNAL_MODE_BACK)
	table_draw.append(new_card1)
	

func write_hand(hand: Hand, chair:int):
	var rect_size = get_viewport_rect().size / 2
	var new_card1 = card_base.instantiate()
	new_card1.card = hand.card1
	new_card1.size = Vector2(250,350)
	new_card1.position = Vector2((rect_size.x)*xs_cards[chair],rect_size.y*ys_cards[chair])
	new_card1.pivot_offset = Vector2(0, 0)
	new_card1.rotation_degrees = rotation_degrees_cards[chair]
	new_card1.scale = scale1
	$Hands.add_child(new_card1, INTERNAL_MODE_BACK)
	hands_draw.append(new_card1)
	var new_card2 = card_base.instantiate()
	new_card2.card = hand.card2
	new_card2.size = Vector2(250,350)
	new_card2.position = Vector2((rect_size.x)*xs_cards[chair]+x_offset[chair],rect_size.y*ys_cards[chair]+y_offset[chair])
	new_card2.pivot_offset = Vector2(0, 0)
	new_card2.rotation_degrees = rotation_degrees_cards[chair]
	new_card2.scale = scale1
	$Hands.add_child(new_card2, INTERNAL_MODE_BACK)
	hands_draw.append(new_card2)

func get_first_player():
	for i in range(1, number_player):
		var id:int = (id_button + i) % number_player
		if players[id].is_playing:
			id_player_actual = id

func get_all_playing(player:Player):
	return player.is_playing

 
#1- 4C
#2- 9H
#
#1- AS
#2- 9D
#
#1- 6S
#2- 2D
#
#table:4S
#table:9S
#table:10C
#table:3C
#table:7H
#points 0- 0
#points 1- 0
#points 2- 0
#winner: 4C
#winner: 9H
#winner: AS
#winner: 9D
#winner: 6S
#winner: 2D
