extends Control

func set_players_value(players:Array):
	for i in range(1,9):
		var path = "HBoxContainer/Player " + str(i)
		get_node(path).visible = false
	for i in players:
		set_player_value(i)
		
func set_player_value(player):
	var path = "HBoxContainer/Player " + str(player.chair+1)
	get_node(path).visible = true
	get_node(path + "/Mark").text = player.mark
	get_node(path + "/Nome").text = player.name
	get_node(path + "/Dinheiro").text = str(player.stack)
	get_node(path + "/Action").text = player.action
	get_node(path + "/Bet").text = str(player.actual_bet)
