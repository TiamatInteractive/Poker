extends Control

var id_player_actual:int
var big_bind:int
var actual_bet:int
var players: Array[Player]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	#select next player
	#verify if was ended
		#start next step of the game
	#verify if is the player, another player or a ia
	#open menu or wait the other player or start ia
	pass

func next_step():
	#0: select binds and start bets
	#1: verify if there is more than one person betting, open 3 cards and start bets
	#2: verify if there is more than one person betting, open 1 card and start bet
	#3: verify if there is more than one person betting, open 1 card and start bet
	#4: verify if there is more than one person betting, if not, not open hands and select winner
	pass

func start_game():
	pass
