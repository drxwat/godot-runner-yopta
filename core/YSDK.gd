extends Node

var window := JavaScript.get_interface("window")

var init_SDK_callback = JavaScript.create_callback(self, "init_SDK")

var player_info = {
	"name": "",
	"is_authenticated": false,
	"hi_score": 0
}
var is_authenticated := false

func _ready() -> void:
	if window:
		print("Initializing SDK")
		window.initSDK(init_SDK_callback)

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
