class_name Packet

var packet: Array[Card]

func _ready():
	set_new_packet()

func set_new_packet():
	packet = []
	var naipe = ["E","P","C","O"]
	for i in range(1,14):
		for j in naipe:
			packet.append(Card.new(i,j))
	packet.shuffle()

func get_card() -> Card:
	return packet.pop_front()
	
