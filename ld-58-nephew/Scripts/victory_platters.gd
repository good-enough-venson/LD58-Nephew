extends Node2D

@export var stone_nodes: Array[Node2D]
@export var labels: Array[Label]
@export var platters: Array[Sprite2D]

func updateUI() -> void:
	var _winCond = Running.winCondition.duplicate()
	for i in range(stone_nodes.size()):
		#stone_nodes[i].visible = TableInventory.victory_stones[i] != null
		if TableInventory.victory_stones.size() > i:
			stone_nodes[i].update_graphic(TableInventory.victory_stones[i])
		
		if _winCond.size() > i:
			if labels.size() > i:
				labels[i].text = _winCond[i].glyph
				labels[i].modulate = _winCond[i].color
			if platters.size() > i:
				platters[i].modulate = _winCond[i].color
		else:
			if labels.size() > i:
				labels[i].text = ""
				labels[i].modulate = Color.WHITE
			if platters.size() > i:
				platters[i].modulate = Color.WHITE
		

func _ready() -> void:
	updateUI()
	
func try_enplate_deplate(platter:int) -> void:
	var _served = null if platter >= TableInventory.victory_stones.size() else \
		TableInventory.victory_stones[platter]
	
	# Try to add a stone from the pocket inventory
	if _served == null:
		# Check to make sure that the last stone matches the requirement.
		var _stoneVal = PocketInventory.stones[PocketInventory.stones.size()-1].value
		var _winCond = Running.winCondition.duplicate()
		
		if _winCond.size() > platter and _stoneVal != _winCond[platter].value:
			print("Wrong Stone")
			return
		
		var _stone = PocketInventory.pop_stone()
		if _stone:
			TableInventory.victory_stones[platter] = _stone
			if stone_nodes.size() > platter:
				stone_nodes[platter].update_graphic(_stone)
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(_served):
		TableInventory.victory_stones[platter] = null
		if stone_nodes.size() > platter:
			stone_nodes[platter].update_graphic(null)

func _on_platter_0_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_enplate_deplate(0)
func _on_platter_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_enplate_deplate(1)
func _on_platter_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_enplate_deplate(2)
func _on_platter_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_enplate_deplate(3)
func _on_platter_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): try_enplate_deplate(4)
