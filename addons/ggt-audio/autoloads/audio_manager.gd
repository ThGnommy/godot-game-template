extends Node

const BUS_LAYOUT := preload("res://addons/ggt-audio/ggt-audio-bus-layout.tres")
@onready var animation_player := $AnimationPlayer
@onready var music := $Music

var initial_volume: float

func _ready() -> void:
	AudioServer.set_bus_layout(BUS_LAYOUT)
	initial_volume = music.volume_db

func start_music(track: AudioStream, fade_in_duration: float = 0.0) -> void:
	
	music.stream = track
	music.play()
	
	if is_zero_approx(fade_in_duration):
		return
	
	var anim = AnimationLibrary.new()
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	
	# Add a keyframe for the volume property at the start of the animation (volume = 0)
	anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(0, "AudioStreamPlayer:volume_db")
	anim.track_insert_key(0, 0.0, -80.0)  # Start volume (dB)

	# Add a keyframe for the volume property at the end of the animation (volume = 0 dB)
	anim.track_insert_key(0, fade_in_duration, initial_volume)  # End volume (dB)
	
	animation_player.add_animation_library("music_fade_in", anim)
	animation_player.set_current_animation("music_fade_in")
	animation_player.play("music_fade_in")

func stop_music() -> void:
	music.stop()
	
	
func music_fade_in(duration: float = 0.0) -> void:
	
	if is_zero_approx(duration):
		return
	
	var track_index = animation_player.add_track(Animation.TYPE_VALUE)
	
	# Add a keyframe for the volume property at the start of the animation (volume = 0)
	animation_player.add_track(Animation.TYPE_VALUE)
	animation_player.track_set_path(0, "AudioStreamPlayer:volume_db")
	animation_player.track_insert_key(0, 0.0, -80.0)  # Start volume (dB)

	# Add a keyframe for the volume property at the end of the animation (volume = 0 dB)
	animation_player.track_insert_key(0, duration, initial_volume)  # End volume (dB)
	animation_player.play("music_fade_in")
