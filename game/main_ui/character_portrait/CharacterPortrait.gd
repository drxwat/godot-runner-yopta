extends Panel


const DEFAULT_COLOR := Color("#3f3f3f")
const FOCUS_COLOR := Color("#ffffff")

export var points_to_unlock := 0
export (Globals.CharacterType) var character_type := Globals.CharacterType.BEAR

var character_texture : TextureRect

func _ready() -> void:
	character_texture = $CenterContainer/TextureRect
	character_texture.modulate = Color.black
	check_lock_status()

func check_lock_status():
	if not is_locked():
		character_texture.modulate = Color.white


func _on_CharacterPortrait_gui_input(event: InputEvent) -> void:

	var is_selected = (event is InputEventMouseButton and event.pressed) or event.is_action_pressed("jump")
	if is_selected and not is_locked():
		Globals.emit_signal("character_selected", character_type)

func focus():
	self_modulate = FOCUS_COLOR
	
func un_focus():
	self_modulate = DEFAULT_COLOR

func is_locked():
	return Globals.max_points < points_to_unlock


