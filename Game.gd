extends Control

#0: select binds and start bets
#1: verify if there is more than one person betting, open 3 cards and start bets
#2: verify if there is more than one person betting, open 1 card and start bet
#3: verify if there is more than one person betting, open 1 card and start bet
#4: verify if there is more than one person betting, if not, not open hands and select winner
var step:int
var packet:Packet
var id_player_actual:int
var id_button:int
var big_bind:int
var small_bind:int
var actual_bet:int
var players: Array[Player]
var table: Array[Card]
@onready var bet_menu = $BetMenu
# Called when the node enters the scene tree for the first time.
func _ready():
	packet = Packet.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_bet_menu_call_check():
	players[id_player_actual].actual_bet = actual_bet
	players[id_player_actual].stack -= actual_bet
	next_player()
	#call/check animation

func _on_bet_menu_fold():
	players[id_player_actual].is_playing = false
	next_player()
	#fold animation

func _on_bet_menu_raise(value):
	players[id_player_actual].actual_bet = value
	players[id_player_actual].stack -= value
	actual_bet = value
	next_player()
	#raise animation

func next_player():
	if bet_menu.visible:
		bet_menu.visible = false
	#select next player
	#verify if was ended
		#start next step of the round
	#verify if is the player, another player or a ia
	#open menu or wait the other player or start ia
	pass

func next_step():
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
	#1: Start the round
	packet.set_new_packet()
	#2: Set big and small binds
	players.map(set_player_start)
	bet_menu.big_bind = big_bind
	var small_binder = players[(id_button+1)%players.size()]
	var bet = select_bet(small_binder,small_bind)
	small_binder.actual_bet = bet
	small_binder.stack -= bet
	Bet.pot = bet
	actual_bet = bet
	players[(id_button+1)%players.size()] = small_binder
	var big_binder = players[(id_button+2)%players.size()]
	bet = select_bet(big_binder,big_bind)
	big_binder.actual_bet = bet
	big_binder.stack -= bet
	if bet > actual_bet:
		actual_bet = bet
	Bet.pot += bet
	players[(id_button+2)%players.size()] = big_binder
	bet_menu.actual_bet = actual_bet
	id_player_actual = (id_button+2)%players.size()
	next_player()

func flop():
	add_card_to_table(3)
	pass

func river():
	add_card_to_table(1)
	pass

func turn():
	add_card_to_table(1)
	pass
	
func end_round():
	pass
	
func select_bet(player:Player, bet:int)->int:
	if player.stack < bet:
		return player.stack
	return bet

func set_player_start(player:Player) -> Player:
	player.is_playing = true
	player.hand = Hand.new(packet.get_card(), packet.get_card())
	return player

func add_card_to_table(quantity:int):
	for i in range(quantity):
		var card = packet.get_card()
		table.append(card)
		draw_card_to_table(card)
	
func draw_card_to_table(card:Card):
	pass
