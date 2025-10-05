extends Node

var winCondition: Array[Stone]

var difficulty = 0

var difficultyLevels = {
	0:[1,10],
	1:[5, 15],
	2:[10,50],
	3:[40,90],
}

func _ready() -> void:
	var a = difficultyLevels[difficulty][0]
	var b = difficultyLevels[difficulty][1]
	
	for i in range(5): winCondition.append(Stone.new((randi() % (b-a)) + a))
