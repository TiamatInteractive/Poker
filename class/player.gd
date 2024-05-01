class_name Player

var chair:int
var hand: Hand
var stack: int
var actual_bet: int
var is_playing: bool : 
	get:
		return is_playing
	set(value):
		if value && stack == 0:
			is_playing = false
			return
		is_playing = value
var was_played: bool
var is_ia:bool

func _init(stack_:int,chair_:int, is_ia_:bool = true):
	stack = stack_
	actual_bet = 0
	is_playing = true
	was_played = false
	is_ia = is_ia_
	chair = chair_
