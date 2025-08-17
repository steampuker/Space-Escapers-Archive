extends Node
class_name GUIHandler

@export var tilemap: TileMapLayer:
	set(value): highlighter.tilemap = value
	get(): return highlighter.tilemap

@export var selector: Node2D:
	set(value): highlighter.selector = value
	get(): return highlighter.selector

@export var player: PlayerBody
@export var plant_spot: PlantSpot
@export var plant_icon: TextureRect

var covering_player := false
var planting := false
var highlighter: TileHighlight = TileHighlight.new()

static func calculatePlayerGradient(p, distance) -> float:
	var distance_squared = distance * distance
	return (distance_squared - (p.global_position - p.get_global_mouse_position()).length_squared()) / distance_squared

func _ready():
	CursorHandler.init(3.0)
	plant_icon.visible = false
	
	highlighter.init(create_tween().set_loops())
	
	await get_tree().process_frame
	player.mouse_area.mouse_entered.connect(func(): covering_player = true)
	player.mouse_area.mouse_exited.connect(func(): covering_player = false)

func _process(_delta):
	processPlanting()

func processPlanting():
	if(plant_spot.seeds > 0 && Input.is_action_just_pressed("toggle_planting")):
		planting = !planting
		
		if(planting): CursorHandler.select(CursorHandler.FINGER_PLANT);
		else: CursorHandler.select(CursorHandler.ARROW)
	
	var alpha = calculatePlayerGradient(player, 48)
	var is_planting = planting && !covering_player && plant_spot.seeds > 0 && alpha > 0
	
	highlighter.visible = is_planting
	plant_icon.visible = is_planting
	
	if(is_planting): 
		highlighter.process(alpha)
		plant_icon.visible = highlighter.alpha_visible
		if(highlighter.alpha_visible && Input.is_action_just_pressed("click")):
			plant_spot.plant(highlighter.getMousePos())
			if(plant_spot.seeds <= 0):
				CursorHandler.select(CursorHandler.ARROW)
				planting = false
				highlighter.visible = false
				plant_icon.visible = false

class TileHighlight:
	var tilemap: TileMapLayer
	var selector: Node2D
	
	var visible: bool:
		set(v): selector.visible = v
		get(): return selector.visible
	
	var highlight_rect: Rect2
	var lerp_progress = 0.0
	var prev_map: Vector2i
	var tween: Tween
	
	var alpha: float
	var alpha_visible: bool = false
	
	func init(new_tween):
		selector.visible = false
		tween = new_tween
		tween.tween_property(self, "alpha", 0.5, 1.0).from(0.1)
		tween.tween_property(self, "alpha", 0.1, 1.0).from(0.5)
	
	func getMousePos():
		return tilemap.local_to_map(tilemap.get_local_mouse_position())
	
	func process(dist: float):
		selector.self_modulate.a = alpha * (1.0 if alpha_visible else 0.0) * (dist)
		
		var mouse_map = getMousePos()
		
		if(mouse_map == prev_map): 
			return
		
		if(tilemap.get_cell_source_id(mouse_map) == -1 || \
			tilemap.get_cell_source_id(mouse_map + Vector2i.ONE) == -1):
			alpha_visible = false
			return
		
		alpha_visible = true
		highlight_rect.position = tilemap.map_to_local(mouse_map) + Vector2(tilemap.tile_set.tile_size) / 2
		highlight_rect.size = Vector2(tilemap.tile_set.tile_size)
		selector.position += (highlight_rect.position - selector.position) * 0.5
		selector.scale = highlight_rect.size * 2.0
		selector.queue_redraw()
