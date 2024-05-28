extends Node

@onready var animation_player := $AnimationPlayer
@onready var music := $Music

var initial_volume: float

# Constants
const BUS_LAYOUT := preload("res://addons/ggt-audio/ggt-audio-bus-layout.tres")
const min_volume: float = -80.0

func _ready() -> void:
	AudioServer.set_bus_layout(BUS_LAYOUT)
	initial_volume = music.volume_db

func start_music(track: AudioStream) -> void:
	music.stream = track
	music.play()

func stop_music() -> void:
	music.stop()

func start_music_with_fade_in(track: AudioStream, fade_in_duration: float) -> void:
	
	music.stream = track
	music.play()
	
	assert(!is_zero_approx(fade_in_duration), "The fade in duration is nearly 0.0")
	music_fade_in(fade_in_duration)

func music_fade_out_and_stop(fade_out_duration: float):
	assert(!is_zero_approx(fade_out_duration), "The fade out duration is nearly 0.0")
	music_fade_out(fade_out_duration)

func music_fade_in(duration: float = 0.0) -> void:
	var anim: Animation = animation_player.get_animation("music_fade_in")
	anim.length = duration
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, "Music:volume_db")
	
	anim.track_insert_key(track_index, 0.0, min_volume)
	anim.track_insert_key(track_index, duration, initial_volume)
	
	animation_player.get_animation("music_fade_out").clear()
	animation_player.play("music_fade_in")

func music_fade_out(duration: float = 0.0) -> void:
	var anim: Animation = animation_player.get_animation("music_fade_out")
	anim.length = duration
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, "Music:volume_db")

	var current_volume = music.volume_db

	anim.track_insert_key(track_index, 0.0, current_volume)
	anim.track_insert_key(track_index, duration, min_volume)
	
	animation_player.get_animation("music_fade_in").clear()
	animation_player.play("music_fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "music_fade_out":
		stop_music()
