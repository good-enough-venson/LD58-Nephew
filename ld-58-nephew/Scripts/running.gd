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
	"High Court Alchemist",
	"Royal Court Alchemist",
	"Grand Royal Court Alchemist"
]

var winCondition: Array[Stone]
var difficultyLevels = {
	0:[1,10],
	1:[5, 15],
	2:[10,50],
	3:[40,90],
}

var player_rank = 0
var current_scene: Node = null
var mission_dialog_index = 0

func _ready() -> void:
	roll_win_condition()
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func roll_win_condition() -> void:
	winCondition.clear()
	var difficulty = clamp(player_rank, 0, difficultyLevels.size()-1)
	var offset = difficultyLevels[difficulty][0]
	var values:Array = range(difficultyLevels[difficulty][1]-offset)
	var _log = ""
	
	for i in range(5):
		var _vi = randi() % values.size()
		winCondition.append(Stone.new(values[_vi] + offset))
		_log += "%s(%d), " % [str(winCondition.back().sort_id_fam_sib), winCondition.back().value]
		values.remove_at(_vi)
	
	winCondition.sort_custom(func(x:Stone,y:Stone) -> bool: \
		return x.sort_id_fam_sib > y.sort_id_fam_sib)
	print(_log)

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
