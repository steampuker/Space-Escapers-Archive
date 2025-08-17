extends ColorRect

@export var scene: PackedScene
@export var duration := 1.0

func _ready():
	visible = false

func changeScene():
	var tween = create_tween()
	visible = true
	
	tween.tween_property(self, "color:a", 1.0, duration).from(0.0)
	tween.tween_interval(0.1)
	await tween.finished
	
	get_tree().change_scene_to_packed(scene)
