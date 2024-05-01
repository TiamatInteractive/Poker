extends Control

func set_players_value(players:Array[Player]):
	var cont = 0
	for i in players:
		var path = "HBoxContainer/Player " + str(cont)
		get_node(path + "Mark").text = ""
		cont+=1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
