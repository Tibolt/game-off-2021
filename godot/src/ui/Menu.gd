extends Control

onready var music = $Menu_music
onready var sound = $Sound
onready var musicBar = $VBoxContainer2/musicBar
onready var soundBar = $VBoxContainer2/soundBar


func _process(delta):
	if musicBar.value == musicBar.min_value:
		music.stream_paused = true
	else:
		music.stream_paused = false
		music.volume_db = musicBar.value
		
	if soundBar.value == soundBar.min_value:
		sound.stream_paused = true
	else:
		sound.stream_paused = false
		sound.volume_db = soundBar.value
		
	if Input.is_action_just_pressed("l_attack"):
		sound.play()
	get_volume()

func get_volume():
	GlobalStats.music_volume = music.volume_db
	GlobalStats.sound_volume = sound.volume_db

