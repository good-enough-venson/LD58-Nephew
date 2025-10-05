extends Node2D

@export var origin_sprite:Sprite2D
@export var left_pigeon_sprite:Sprite2D
@export var right_pigeon_sprite:Sprite2D
@export var catalyst_sprite:Sprite2D
@export var product_sprite:Sprite2D

@export var origin_label:Label
@export var left_pigeon_label:Label
@export var right_pigeon_label:Label
@export var catalyst_label:Label
@export var product_label:Label

@export var origin_stone:Stone = null
@export var left_pigeon_stone:Stone = null
@export var right_pigeon_stone:Stone = null
@export var catalyst_stone:Stone = null
@export var product_stone:Stone = null

func updateGraphic(sprite: Sprite2D, label: Label, stone: Stone = null) -> void:
	if stone == null:
		label.text = Stone.nullGlyph
		label.modulate = Color.WHITE
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.modulate = Color.WHITE
		sprite.visible = false
		
	else:
		sprite.visible = true
		sprite.modulate = stone.color
		label.text = stone.glyph
		label.modulate = stone.color

func UpdateUI() -> void:
	updateGraphic(origin_sprite, origin_label, origin_stone)
	updateGraphic(left_pigeon_sprite,left_pigeon_label,left_pigeon_stone)
	updateGraphic(right_pigeon_sprite,right_pigeon_label,right_pigeon_stone)
	updateGraphic(catalyst_sprite,catalyst_label,catalyst_stone)
	updateGraphic(product_sprite,product_label,product_stone)

func get_pigeons() -> Array[Stone]:
	var _pp:Array[Stone] = []
	if left_pigeon_stone: _pp.append(left_pigeon_stone)
	if right_pigeon_stone: _pp.append(right_pigeon_stone)
	return _pp

func try_alchemy() -> void:
	if !origin_stone or !catalyst_stone or !product_stone: return
	var _valuesLib = Grimoire.TryAlchemy(origin_stone,catalyst_stone,get_pigeons())
	if _valuesLib.product != null:
		product_stone = _valuesLib.product
		UpdateUI()

func _ready() -> void:
	UpdateUI()

func _on_origin_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if origin_stone == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			origin_stone = _stone
			updateGraphic(origin_sprite, origin_label, origin_stone)
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(origin_stone):
		origin_stone = null
		updateGraphic(origin_sprite, origin_label, origin_stone)

func _on_pigeon_0_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if left_pigeon_stone == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			left_pigeon_stone = _stone
			updateGraphic(left_pigeon_sprite, left_pigeon_label, left_pigeon_stone)
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(left_pigeon_stone):
		left_pigeon_stone = null
		updateGraphic(left_pigeon_sprite, left_pigeon_label, left_pigeon_stone)


func _on_pigeon_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if right_pigeon_stone == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			right_pigeon_stone = _stone
			updateGraphic(right_pigeon_sprite, right_pigeon_label, right_pigeon_stone)
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(right_pigeon_stone):
		right_pigeon_stone = null
		updateGraphic(right_pigeon_sprite, right_pigeon_label, right_pigeon_stone)


func _on_catalyst_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if catalyst_stone == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			catalyst_stone = _stone
			updateGraphic(catalyst_sprite, catalyst_label, catalyst_stone)
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(catalyst_stone):
		catalyst_stone = null
		updateGraphic(catalyst_sprite, catalyst_label, catalyst_stone)


func _on_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if product_stone == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			product_stone = _stone
			updateGraphic(product_sprite, product_label, product_stone)
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(product_stone):
		product_stone = null
		updateGraphic(product_sprite, product_label, product_stone)
