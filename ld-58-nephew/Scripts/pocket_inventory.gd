extends Node

var max_held_stone_count = 11
var stones: Array[Stone] = []

signal onInventoryChange()

func add_stone(stone: Stone) -> bool:
	if stones.size() + 1 > max_held_stone_count:
		SfxManager.on_decline()
		return false
	stones.append(stone)
	onInventoryChange.emit()
	SfxManager.on_pick_stone()
	return true

func pop_stone() -> Stone:
	var _stone = stones.pop_back()
	if _stone: onInventoryChange.emit()
	else: SfxManager.on_decline()
	return _stone

# Removes all or none of the requested group.
# Stones are matched by value.
func remove_stones(requested:Array[Stone]) -> bool:
	for stone in requested:
		if stones.find_custom(func(_s:Stone) -> bool: return _s.value == stone.value) < 0:
			return false
		
	for stone in requested:
		stones.remove_at(stones.find_custom(func(_s:Stone) -> bool: return _s.value == stone.value))
	
	onInventoryChange.emit()
	return true
