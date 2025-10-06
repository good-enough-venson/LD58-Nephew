extends Node2D

class SpeechBubbleDeal:
	var texts: Array[String]
	var label: Label
	
	func _init(text:String, splitChar="*") -> void:
		texts = text.split(splitChar,false)
		
		

@export var king_sprite: Node2D
@export var king_bubble: Node2D
@export var king_text: Label

@export var inspector_bubble: Node2D
@export var inspector_text: Label

var subtext_index = 0

var mission_monologues = [
	# index 0: Intro, esentially.
	[ 
		"hello most esteemed nephew of the Grand Royal Court Alchemist... yeah no more.",
		"everyone has to climb the ladder around here.. no nepotism. maybe one day you'll take his title though.",
		"anyway, your orders have been sent to your laboratory... come back when you're ready to advance.",
		"...come back when you're ready to advance..",
	],
	# index 1: Level 1, player in court without required stones.
	[
		"I can inspect runestones to discover their attributes.. but I'm too busy to be helping apprentices...",
		"..if you're having trouble sourcing rune stones, try the rocks down by the river..",
		"...come back when you're ready to advance..",
	],
	# index 2: Level 1, player has required stones.
	[
		"so you were able to figure it out at last.. I guess you just dug around and got lucky...",
		"*TAKESTONES*but welcome to the court, I guess. you're now a full fledged Court Alchemist!",
		"..if you fancy working up the ranks a bit, you'll find your new orders in your laboratory.",
		"..you'll report directly to the king when you are ready to apply for a higher rank.",
	],
	# index 3: Level 2, player in court without required stones.
	[
		"What are you doing in my court? Get out until you can bring me the stones I requested!",
		"Do you have them? Were are they? I don't see any rune stones! GET OUT!!",
		"GUARDS!!!"
	],
	[
		"Well, it looks like your uncle underpraised you to me, my boy!",
		"*TAKESTONES*I hereby grant the title of High Court Alchemist to you.",
		"You'll find your new orders in your laboratory, but feel free to enjoy your promotion for now!",
		"Are you enjoying your new rank?"
	],
	# index 5: Level 3
	[
		"Done any great deeds yet?",
		"Do you happen to know any highly skilled alchemists?",
		"There's been some recent... unfortunate accidents in the court..",
		"...",
		"Feel free to consult my runestone inspector. He knows a great deal about them.",
		"..."
	],
	[
		"What? Can it be? Do I see the rare rune stones which I requested of you so long ago?",
		"I was beginning to think that you had tired of research. But no! You have succeeded!",
		"Ministers and Gentlemen of the court, I hereby promote this alchemist to- drumroll...",
		"*TAKESTONES*ROYAL COURT ALCHEMIST!!! Yes, applause applause. Congratulations.",
		"If you'd like, you can marry my daughter...",
		"...in your mind. There's absolutely no scope for her in this game.",
		"Enjoying the party, my new Royal Court Alchemist?"
	],
	# index 7: Level 4
	[
		"How's your research coming?",
		"The study of rune stones... Many a man's life work.",
		"...",
		"Your uncle's health is failing... He is a great man, and the world's finest alchemist.",
		"...",
		"And you're also becoming an accomplished alchemist. I have high hopes for you!",
		"..."
	],
	[
		"My dear friend... I regret to inform you that your uncle has passed away.",
		"...",
		"He was a great man, and left a lasting legacy. The empire greatly profited from his life.",
		"However, it looks like this is a bittersweet moment, for there is a seat open at the top of Alchemy.",
		"And with your latest achievement, I bestow upon you that title which your uncle lost in death.",
		"*TAKESTONES*Behold. Our new Grand Royal Court Alchemist.",
		"...",
		"It's time to leave that dingy old lab behind.",
		"...",
		"Game Over.",
		"The End.",
		"...",
		"Unless you want to keep playing around with rune stones, then be my guest!",
		"..."
	],
	# index 9: Game cleared: just playing around with runestones.
	[
		"Welcome to my court, friend!",
		"Hope my daughter's treating you well...",
		"..in your head.",
		"...",
		"Get your mind out of the gutter! I'm talking about scope creep. Scope creep!",
		"It's creeping right now. As I type these lines..............",
		"Yeah, I'm going to stop right here. There's way too much more to do.",
		"..."
	],
]

var has_stones = false

# We're using a temp index so that the correct dialog shows up
#  if the player comes in with the right runestones, but reverts
#  if the player leaves without completing the dialog and losing them.
var dialog_index:int = 0

func _ready() -> void:
	on_enter_court()

func on_enter_court() -> void:
	inspector_bubble.visible = false
	king_bubble.visible = false
	king_sprite.visible = Running.mission_dialog_index > 1
	dialog_index = Running.mission_dialog_index
	subtext_index = 0
	
	has_stones = check_has_required_stones()
	
	match dialog_index:
		0: 
			Running.player_rank = 0
			inspector_text.text = advance_monologue()
			inspector_bubble.visible = true
			Running.mission_dialog_index = 1
		1: 
			if has_stones: 
				#Running.mission_dialog_index = 2
				dialog_index = 2
		2: 
			if Running.player_rank == 1:
				Running.mission_dialog_index = 3
				dialog_index = 3
				
				if has_stones: 
					Running.mission_dialog_index = 4
					dialog_index = 4
		3: 
			if has_stones:
				#Running.mission_dialog_index = 4
				dialog_index = 4
		4: 
			if Running.player_rank == 2:
				Running.mission_dialog_index = 5
				dialog_index = 5
				if has_stones: 
					Running.mission_dialog_index = 6
					dialog_index = 6
		5: 
			if has_stones:
				#Running.mission_dialog_index = 6
				dialog_index = 6
		6: 
			if Running.player_rank == 3:
				Running.mission_dialog_index = 7
				dialog_index = 7
				if has_stones: 
					Running.mission_dialog_index = 8
					dialog_index = 8
		7: 
			if has_stones:
				#Running.mission_dialog_index = 8
				dialog_index = 8
		8: 
			if Running.player_rank == 4:
				Running.mission_dialog_index = 9
				dialog_index = 9

func on_click_king() -> void:
	match dialog_index:
		0,1,2: return
		3,4,5,6,7,8,9:
			king_text.text = advance_monologue()
			king_bubble.visible = true
			inspector_bubble.visible = false

func on_click_inspector() -> void:
	match dialog_index:
		0,1,2: 
			inspector_text.text = advance_monologue()
			inspector_bubble.visible = true
		3,5,7,9: 
			var hint = try_get_hint()
			if hint: inspector_text.text = hint
			inspector_bubble.visible = true
			king_bubble.visible = false

func try_rank_up() -> void:
	if PocketInventory.remove_stones(Running.winCondition.duplicate()):
		# Confirm the dialog index after taking stones
		Running.mission_dialog_index = dialog_index
		Running.player_rank+=1
		Running.roll_win_condition()

func advance_monologue() -> String:
	var index_a = clampi(dialog_index, 0, mission_monologues.size()-1)
	var index_b = clampi(subtext_index, 0, mission_monologues[index_a].size()-1)
	subtext_index+=1
	var logue:String = mission_monologues[index_a][index_b]
	if logue.begins_with("*TAKESTONES*"):
		logue = logue.substr(12)
		try_rank_up()
	return logue

func try_get_hint() -> String:
	return "...you want something?"

func check_has_required_stones() -> bool:
	var _stones = PocketInventory.stones.duplicate()
	var _required = Running.winCondition.duplicate()
	for stone in _required:
		if _stones.find_custom(func(_s:Stone) -> bool: return _s.value == stone.value) < 0:
			return false
	return true


func _on_king_click_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): on_click_king()
func _on_inspector_click_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"): on_click_inspector()
