extends Node2D

@export var background_music:AudioStream
@export var title_music:AudioStream
@export var credits_music:AudioStream
@export var sample_sfx:AudioStream

func _ready() -> void:
	AudioManager.play_bgm(title_music)
	return


func _on_button_pressed() -> void:
	AudioManager.play_bgm(title_music)


func _on_button_2_pressed() -> void:
	AudioManager.play_bgm(background_music)


func _on_button_3_pressed() -> void:
	AudioManager.play_bgm(credits_music)


func _on_button_4_pressed() -> void:
	AudioManager.play_sfx(sample_sfx)
