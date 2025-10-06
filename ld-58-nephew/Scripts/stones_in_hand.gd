extends Node2D

var spriteArray:Array[Sprite2D] = []
var labelArray:Array[Label] = []

func _ready() -> void:
	#Grab all stone graphics and initialize them.
	for child in get_children():
		if child is Sprite2D:
			var grandchild = child.get_child(0)
			if grandchild is Label:
				resetGraphic(child, grandchild)
				spriteArray.append(child)
				labelArray.append(grandchild)
			else: print("No Label Found")
		else: print("No Sprite Found")
	
	PocketInventory.onInventoryChange.connect(updateUI)
	updateUI()

func resetGraphic(sprite: Sprite2D, label: Label) -> void:
	label.text = Stone.nullGlyph
	label.modulate = Color.WHITE
	sprite.flip_h = true if randf() > 0.5 else false
	sprite.flip_h = true if randf() > 0.5 else false
	sprite.modulate = Color.WHITE
	sprite.visible = false

func updateUI() -> void:
	var _stones = PocketInventory.stones.duplicate()
	# Go through the sprite array.
	for i in range(spriteArray.size()):
		# If we have run out of stones, reset this one.
		if _stones.size() - 1 - i < 0:
			resetGraphic(spriteArray[i], labelArray[i])
			continue
		#otherwise, update this graphic.
		var stone = _stones[_stones.size() - 1 - i]
		if stone == null:
			print("NullStoneError!")
			
		spriteArray[i].visible = true
		spriteArray[i].modulate = stone.color
		labelArray[i].text = stone.glyph
		labelArray[i].modulate = stone.color
