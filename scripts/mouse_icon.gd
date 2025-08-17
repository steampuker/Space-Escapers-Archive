extends TextureRect

@export var offset: Vector2

func _process(_delta):
	global_position = get_global_mouse_position() + offset
