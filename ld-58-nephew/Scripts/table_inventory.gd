extends Node

# Table as dict: Vector2i(position) -> Stone
var table_stones: Dictionary = {}  # Key: Vector2i(x, y), Value: Stone

# Grid size (adjust for your UI/table size)
const GRID_WIDTH: int = 20
const GRID_HEIGHT: int = 10

func try_place_stone(pos: Vector2i, forceDrop = false) -> Dictionary:
	var data = {
		"pos":pos, "dropped":false, 
		"picked":false, "stone":null,
	}
	
	pos = clamp_position(pos)
	var _oldStone: Stone = null
	if table_stones.has(pos):
		_oldStone = table_stones[pos]
	
	# search for a nearby empty space if we are forcing a drop.
	if forceDrop: pos = find_nearest_free(pos)
	
	data.pos = pos
	
	# If the space is empty, we'll try to add a stone from the pocket inventory
	if _oldStone == null:
		var _newStone = PocketInventory.pop_stone()
		if _newStone:
			table_stones[pos] = _newStone
			data.stone = _newStone
			data.dropped = true
		return data
	
	# Otherwise, we'll try to put the stone from that space into the pocket inventory
	if PocketInventory.add_stone(_oldStone):
		data.stone = _oldStone
		data.picked = true
		table_stones.erase(pos)
	
	return data

# Place a stone at a position (with collision check)
func place_stone(stone: Stone, pos: Vector2i) -> bool:
	pos = clamp_position(pos)  # Ensure within grid
	if table_stones.has(pos):
		# Position occupied - for now, allow overlap as per your request
		# To prevent: return false
		print("Warning: Overlapping at %s" % pos)  # Or find_nearest_free(pos)
	stone.position = pos
	table_stones[pos] = stone
	AudioManager.play_sfx(load("res://assets/sfx/place.wav"))
	return true

# Remove a stone from its position
func remove_stone(pos: Vector2i) -> Stone:
	if table_stones.has(pos):
		var stone = table_stones[pos]
		table_stones.erase(pos)
		return stone
	return null

# Get stone at position
func get_stone_at(pos: Vector2i) -> Stone:
	return table_stones.get(pos, null)

# Clamp position to grid
func clamp_position(pos: Vector2i) -> Vector2i:
	pos.x = clamp(pos.x, 0, GRID_WIDTH - 1)
	pos.y = clamp(pos.y, 0, GRID_HEIGHT - 1)
	return pos

# Optional: Find nearest free position if occupied
func find_nearest_free(start_pos: Vector2i) -> Vector2i:
	if not table_stones.has(start_pos):
		return start_pos
	for dx in range(-2, 3):
		for dy in range(-2, 3):
			var new_pos = clamp_position(start_pos + Vector2i(dx, dy))
			if not table_stones.has(new_pos):
				return new_pos
	return Vector2i(-1,-1)

# Get all table stones (for saving/iterating)
func get_all_stones() -> Array[Stone]:
	return table_stones.values()
