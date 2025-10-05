class_name PoolTable extends Node2D

# Preload the stone node scene
const STONE_NODE_SCENE = preload("res://Scenes/stone_node.tscn")

# Pool settings
@export var initial_pool_size: int = 20
var stone_nodes: Array[Node2D] = []  # Pool of StoneNode instances
var active_stones: Dictionary = {}  # Maps Stone to StoneNode for quick lookup

func _ready():
	# Initialize pool
	for i in range(initial_pool_size):
		var stone_node = STONE_NODE_SCENE.instantiate()
		stone_node.update_graphic()  # Start hidden
		add_child(stone_node)
		stone_nodes.append(stone_node)

# Get an available stone node (or instantiate a new one)
func get_stone_node(stone: Stone, pos: Vector2) -> Node2D:
	# Find inactive node
	for node in stone_nodes:
		if not node.visible:
			node.update_graphic(stone)
			node.global_position = pos
			active_stones[stone] = node
			return node
	
	# Expand pool if needed
	var new_node = STONE_NODE_SCENE.instance()
	add_child(new_node)
	new_node.update_graphic(stone)
	new_node.global_position = pos
	stone_nodes.append(new_node)
	active_stones[stone] = new_node
	return new_node

# Deactivate a stone node (return to pool)
func release_stone_node(stone: Stone):
	if active_stones.has(stone):
		var node = active_stones[stone]
		node.update_graphic()
		active_stones.erase(stone)

# Get all active stone nodes (for rendering/saving)
func get_active_nodes() -> Array:
	return active_stones.values()
