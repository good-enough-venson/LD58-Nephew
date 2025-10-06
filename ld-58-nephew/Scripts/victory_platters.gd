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
	var _served = null
	var _log = "onTryEmplate(%d): " % platter
	
	if TableInventory.victory_stones.size() > platter:
		_served = TableInventory.victory_stones[platter]
	
	_log += "empty" if _served == null else "existing stone: %s" % _served.name
		
	# Try to add a stone from the pocket inventory
	if PocketInventory.stones.size() > 0 and _served == null:
		# Check to make sure that the last stone matches the requirement.
		var _stoneVal = PocketInventory.stones.back().value
		var _winCond = Running.winCondition.duplicate()
		
		if _winCond.size() > platter and _stoneVal != _winCond[platter].value:
			print("%s\nWrong Stone, %d -> %d" % [_log, _stoneVal, _winCond[platter]])
			SfxManager.on_decline()
			return
		
		var _stone = PocketInventory.pop_stone()
		_log += "\nTaking %s from pocket.. " % _stone.name
		
		if _stone:
			TableInventory.victory_stones[platter] = _stone
			_log += "and placing on platter[%d] " % platter
			SfxManager.on_set_stone_shelf()
			if stone_nodes.size() > platter:
				stone_nodes[platter].update_graphic(_stone)
			if check_has_required_stones():
				SfxManager.on_set_complete()
				
		print(_log)
		return
	
	# Try to put the stone back into the pocket inventory
	if _served != null and PocketInventory.add_stone(_served):
		TableInventory.victory_stones[platter] = null
		if stone_nodes.size() > platter:
			stone_nodes[platter].update_graphic(null)

func check_has_required_stones() -> bool:
	var _stones = TableInventory.victory_stones.duplicate()
	var _required = Running.winCondition.duplicate()
	for stone in _required:
		if _stones.find_custom(func(_s:Stone) -> bool: 
				if _s == null: return false
				return _s.value == stone.value) < 0:
			return false
	return true

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
