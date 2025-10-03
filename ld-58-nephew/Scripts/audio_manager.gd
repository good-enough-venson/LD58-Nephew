extends Node

# Preload or assign your streams in code/variables as needed
var bgm_pool: Array[AudioStreamPlayer] = []
var current_bgm: AudioStreamPlayer
var bgm_fade_time: float = 2.0  # Default fade duration in seconds

# SFX pool: Create 5-10 players to handle multiple SFX
var sfx_pool: Array[AudioStreamPlayer] = []
var sfx_pool_size: int = 10

# Bus indices (cache for performance)
var music_bus_index: int
var sfx_bus_index: int

# Lowpass effect index on Music bus
var lowpass_effect_index: int = 0  # Assuming it's the first effect added

func _ready():
	# Set up bus indices
	music_bus_index = AudioServer.get_bus_index("bgm")
	sfx_bus_index = AudioServer.get_bus_index("sfx")
	
	if music_bus_index == -1:
		push_error("bgm bus not found! Check Audio tab setup.")
	if sfx_bus_index == -1:
		push_error("sfx bus not found! Check Audio tab setup.")
	
	for i in range(3):
		var player = AudioStreamPlayer.new()
		player.bus = "bgm"
		add_child(player)
		bgm_pool.append(player)
	
	# Create BGM player
	current_bgm = bgm_pool[0]
	
	# Create SFX pool
	for i in range(sfx_pool_size):
		var player = AudioStreamPlayer.new()
		player.bus = "sfx"
		add_child(player)
		sfx_pool.append(player)
	
	# Disable lowpass by default (set cutoff high to pass all frequencies)
	set_lowpass(music_bus_index,false)
	set_lowpass(sfx_bus_index,false)

# Play looping BGM with optional fade
func play_bgm(stream: AudioStream, fade_time: float = bgm_fade_time):
	if current_bgm.stream == stream and current_bgm.playing:
		print("specified track is already playing")
		return
	
	# If we've reached this point, we're playing a new track.
	# We'll fade out the current playing track.
	if current_bgm.playing:
		var old_bgm = current_bgm
		var tween = create_tween()
		tween.tween_property(old_bgm, "volume_db", -80, fade_time)\
			.set_ease(Tween.EASE_OUT)
		tween.tween_callback(old_bgm.stop)
	
	# We grab the next available bgm player
	for player in bgm_pool:
		if not player.playing:
			if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
				stream.loop = true
			
			current_bgm = player
			current_bgm.stream = stream
			current_bgm.volume_db = -80  # Start silent
			current_bgm.play()
			var tween_in = create_tween()
			tween_in.tween_property(current_bgm, "volume_db", 0, fade_time/2)\
				.set_ease(Tween.EASE_IN)
			return

# Play oneshot SFX and can autoduck bgm
func play_sfx(stream: AudioStream, autoduck_music:bool = false):
	for player in sfx_pool:
		if not player.playing:
			# No loop for SFX
			if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
				stream.loop = false
			player.stream = stream
			player.play()
			if autoduck_music:
				duck_music(-6,0.2,stream.get_length())
			return
	print("No free SFX player available! 'n(consider increasing sfx_pool_size in res://Scripts/audio_manager.gd)")

# Duck music volume
func duck_music(db_reduction: float = -12, fade_time: float = 0, hold_time: float = 0):
	var original_volume = AudioServer.get_bus_volume_db(music_bus_index)
	var tween = create_tween()
	
	# Duck volume over time
	tween.tween_method(
		func(value): AudioServer.set_bus_volume_db(music_bus_index, value),
		original_volume,
		original_volume + db_reduction,
		fade_time
	)
	
	# If we're un-ducking, wait and then fade back in,
	if hold_time > 0:
		await get_tree().create_timer(hold_time-(fade_time*2)).timeout
		tween.tween_method(
			func(value): AudioServer.set_bus_volume_db(music_bus_index, value),
			original_volume + db_reduction,
			original_volume,
			fade_time
		)

# Enable/disable lowpass filter on specified bus
func set_lowpass(bus_index: int, enable: bool, cutoff_hz: float = 500, fade_time: float = 0):
	var lowpass = AudioServer.get_bus_effect(bus_index, lowpass_effect_index) as AudioEffectLowPassFilter
	if lowpass:
		if enable:
			if fade_time > 0:
				var tween = create_tween()
				tween.tween_property(lowpass, "cutoff_hz", cutoff_hz, fade_time)
			else:
				lowpass.cutoff_hz = cutoff_hz
		else: # Set to high value to disable (passes all frequencies)
			if fade_time > 0:
				var tween = create_tween()
				tween.tween_property(lowpass, "cutoff_hz", 22000, fade_time)
			else:
				lowpass.cutoff_hz = 22000
