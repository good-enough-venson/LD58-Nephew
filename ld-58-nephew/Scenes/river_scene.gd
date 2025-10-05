extends Node2D

# The odds of picking up each stone. I've 
@export var find_stone_odds = {
	11:100,7:50,5:40,3:10,2:4,1:1
}

func get_new_stone() -> Stone:
	for key in find_stone_odds.keys():
		if randi() % find_stone_odds[key] == 0:
			return Stone.new(key)
	return Stone.new(1)

func try_pick_stone() -> void:
	var new_stone = get_new_stone()
	if PocketInventory.add_stone(new_stone):
		print("Picked up a new %s!" % new_stone.name)
	else: print("Pocket is full.")

func try_toss_stone() -> void:
	if PocketInventory.pop_stone():
		print("Chucked a stone in the river.")
	else: print("No stones left.")

func _on_pick_stones_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_pick_stone()

func _on_chuck_stones_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_toss_stone()
