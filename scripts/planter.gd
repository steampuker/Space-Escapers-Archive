extends Node2D
class_name PlantSpot

@export var growth_time := 10.0
@export var plantfloor: TileMapLayer
@export var plant_indicator: Label

@onready var fred := $"../Fred"

var seeds: int = 0
var blacklisted_cells: Array[Rect2i]
var tasker: Tasker

func _ready():
	tasker = get_tree().get_first_node_in_group("Tasker")
	fred.fed.connect(feedFred)
	plant_indicator.text = "x" + str(seeds)

func feedFred():
	seeds = maxi(seeds - 1, 0)
	plant_indicator.text = "x" + str(seeds)
	tasker.addTask(Tasker.Tasks.FED_FRED)

func addSeeds(amount: int):
	seeds = mini(seeds + amount, 5)
	plant_indicator.text = "x" + str(seeds)

func harvested(rect: Rect2i, tl: Array[Vector2i]):
	blacklisted_cells.remove_at(blacklisted_cells.find(rect))
	plantfloor.set_cell(rect.position, 0, tl[0])
	plantfloor.set_cell(rect.position + Vector2i.RIGHT, 0, tl[1])
	plantfloor.set_cell(rect.position + Vector2i.DOWN, 0, tl[2])
	plantfloor.set_cell(rect.position + Vector2i.ONE, 0, tl[3])
	tasker.addTask(Tasker.Tasks.CROP_HARVESTED)
	
	addSeeds(1 + randi_range(0, 1))

func plant(pos: Vector2i):
	var rect = Rect2i()
	rect.position = pos
	rect.size = Vector2i(2, 2)
	
	for r in blacklisted_cells:
		if(rect.intersects(r)): 
			print("Huu: ", r);
			return
	
	blacklisted_cells.append(rect)
	
	var tile_info: Array[Vector2i]
	tile_info.resize(4)
	tile_info[0] = plantfloor.get_cell_atlas_coords(pos)
	tile_info[1] = plantfloor.get_cell_atlas_coords(pos + Vector2i.RIGHT)
	tile_info[2] = plantfloor.get_cell_atlas_coords(pos + Vector2i.DOWN)
	tile_info[3] = plantfloor.get_cell_atlas_coords(pos + Vector2i.ONE)
	
	plantfloor.set_cell(pos, 0, Vector2i(0, 4))
	plantfloor.set_cell(pos + Vector2i.RIGHT, 0, Vector2i(0, 4))
	plantfloor.set_cell(pos + Vector2i.DOWN, 0, Vector2i(0, 4))
	plantfloor.set_cell(pos + Vector2i.ONE, 0, Vector2i(0, 4))
	
	var plantera = preload("res://assets/prefabs/plant.tscn").instantiate()
	plantera.occupied_rect = rect
	plantera.tile_data = tile_info
	plantera.growth_time = growth_time
	add_child(plantera)
	plantera.position = plantfloor.map_to_local(pos) + plantfloor.position + Vector2(plantfloor.tile_set.tile_size / 2)
	plantera.harvested.connect(harvested)
	tasker.addTask(Tasker.Tasks.CROP_PLANTED)
	
	seeds -= 1
	plant_indicator.text = "x" + str(seeds)
