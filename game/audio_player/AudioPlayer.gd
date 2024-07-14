extends Node


onready var music_player := $MusicPlayer

func turn_music(isPlaying):
	music_player.playing = isPlaying
