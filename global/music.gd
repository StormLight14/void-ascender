extends Node2D

@onready var music_player = %MusicPlayer

@export var current_music: AudioStream
@export var loop = true

func _ready():
	music_player.stream = current_music

func _on_music_player_finished():
	if loop:
		music_player.playing = true
