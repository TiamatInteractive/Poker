extends Control

func set_players_value(players:Array):
	for i in players:
		set_player_value(i)
		
func set_player_value(player:Player):
	var path = "HBoxContainer/Player " + str(player.chair+1)
	get_node(path).visible = true
	get_node(path + "/Mark").text = player.mark
	get_node(path + "/Nome").text = player.name
	get_node(path + "/Dinheiro").text = str(player.stack)
	get_node(path + "/Action").text = player.action
	get_node(path + "/Bet").text = str(player.actual_bet)
