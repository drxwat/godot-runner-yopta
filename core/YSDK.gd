extends Node

var window := JavaScript.get_interface("window")
var document = JavaScript.get_interface("document")

var init_SDK_callback = JavaScript.create_callback(self, "init_SDK")
var toggle_audio_callback = JavaScript.create_callback(self, "toggle_audio")

var player_info = {
	"name": "",
	"is_authenticated": false,
	"hi_score": 0
}
var is_authenticated := false

func _ready() -> void:
	if window:
#		print("Initializing SDK")
#		window.initSDK(init_SDK_callback)
		print("READY")
#		window.toggleMusic()
		print(document)
		document.onvisibilitychange = toggle_audio_callback
#		window.add_event_listener("visibilitychange", toggle_audio_callback)

func toggle_audio(event):
	AudioPlayer.turn_music(document.visibilityState == "visible")

func init_SDK(args):
	print(args)
	if args[0] == true:
		player_info.name = args[1]
		player_info.is_authenticated = args[2]
		player_info.hi_score = args[3]

func update_player_score(score: int):
	if is_authenticated and score > player_info.hi_score:
		print("updating score")
		player_info.hi_score = score
		window.updatePlayerScore(score)
