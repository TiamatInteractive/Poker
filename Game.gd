extends Node

@onready var address_entry = $Main_Menu/CenterContainer/VBoxContainer/Addres_Entry
@onready var main_menu = $Main_Menu
@onready var table = $PokerTable

const PORT = 18341
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	get_tree().paused = true

func _on_host_pressed():
	table.show()
	table.is_host = true
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(table.add_player)
	get_tree().paused = false
	table.big_binds = [200, 400, 800, 1600]
	table.start_stack = 20000
	table.add_player(multiplayer.get_unique_id())
	
func _on_join_pressed():
	table.show()
	main_menu.hide()
	enet_peer.create_client("localhost",PORT)
	multiplayer.multiplayer_peer = enet_peer
	get_tree().paused = false
	pass # Replace with function body.
