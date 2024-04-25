class_name Card

var number: int
var color: String

func _init(n:int, c:String):
	number = n
	color = c

func get_value()->int:
	if number>1:
		return number
	return 14
