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

func get_text()->String:
	if get_value()<11:
		return str(number)
	if get_value()==11:
		return "J"
	if get_value()==12:
		return "Q"
	if get_value()==13:
		return "K"
	return "A"
