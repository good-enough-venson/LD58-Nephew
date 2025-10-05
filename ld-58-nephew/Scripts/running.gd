extends Node

static var Scenes = {
	"Court":"res://Scenes/title_screen.tscn",
	"Tutorial":"",
	"Laboratory":"res://Scenes/lab_scene.tscn",
	"River":"res://Scenes/river_scene.tscn",
	"Credits":"res://Scenes/credits_scene.tscn",
}

static var Titles = [
	"Apprentice Alchemist",
	"Court Alchemist",
	"Master Court Alchemist",
	"Royal Court Alchemist",
	"Grand Royal Court Alchemist"
]

var winCondition: Array[Stone]
var difficulty = 0
var difficultyLevels = {
	0:[1,10],
	1:[5, 15],
	2:[10,50],
	3:[40,90],
}

var current_scene: Node = null

func _ready() -> void:
	var a = difficultyLevels[difficulty][0]
	var b = difficultyLevels[difficulty][1]
	
	for i in range(5): winCondition.append(Stone.new((randi() % (b-a)) + a))
	winCondition.sort_custom(func(x:Stone,y:Stone) -> bool: \
		return x.sort_id_fam_sib > y.sort_id_fam_sib)
	
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(path:String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Scene path does not exist: %s" % path)
		return
	
	# Free the current scene
	if current_scene:
		current_scene.queue_free()
	
	# Load and instantiate the new scene
	var new_scene = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
