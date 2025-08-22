class_name GridManager
extends Node2D

const GRID_WIDTH = 8
const GRID_HEIGHT = 8
const TILE_SIZE = Vector2(64, 64)

var tile_scene: PackedScene = preload("res://Scenes/Tile.tscn")

#Tiles
@onready var tile_container = $TileContainer
@onready var info_label = $GridUI/Info

var tiles: Array[Array] = []
var tile_size: Vector2
var current_cursor_pos: Vector2i = Vector2i(0, 0)

func _ready():
	calculate_tile_size()
	generate_grid()
	center_grid()
	update_cursor_display()
	
func center_grid():
	var screen_width = get_viewport().get_visible_rect().size.x
	var total_grid_width = GRID_WIDTH * tile_size.x
	var x_offset = (screen_width - total_grid_width) / 2.0
	tile_container.position.x = x_offset
	
func calculate_tile_size():
	var screen_size = get_viewport().get_visible_rect().size
	var usable_width = screen_size.x
	var usable_height = screen_size.y * 0.8
	# Calculate tile size to fit grid
	var tile_width = usable_width / GRID_WIDTH
	var tile_height = usable_height / GRID_HEIGHT
	# Use the smaller dimension to maintain aspect ratio, or use both for full stretch
	tile_size = Vector2(tile_width, tile_height)  # Full stretch
	#tile_size = Vector2.ONE * min(tile_width, tile_height)  # Maintain square aspect
	print("Calculated tile size: ", tile_size)

func generate_grid():
	tiles.resize(GRID_HEIGHT)
	
	for row in GRID_HEIGHT:
		tiles[row] = []
		tiles[row].resize(GRID_WIDTH)
		
		for col in GRID_WIDTH:
			var tile = tile_scene.instantiate()
			tile.grid_pos = Vector2i(col, row)
			tile.tile_size = tile_size
			tile.position = Vector2(col * tile_size.x, row * tile_size.y)
			# Determine tile type
			if is_edge_tile(col, row):
				tile.tile_type = Tile.TileType.EDGE
			else:
				tile.tile_type = Tile.TileType.CENTER
				
			tile_container.add_child(tile)
			tiles[row][col] = tile

func is_edge_tile(col: int, row: int) -> bool:
	# Top row, bottom row (before info), or left/right columns
	return (row == 0 or row == GRID_HEIGHT - 1 or 
			col == 0 or col == GRID_WIDTH - 1)

func _input(event):
	if event is InputEventKey and event.pressed:
		var old_pos = current_cursor_pos
		
		match event.keycode:
			KEY_UP:
				current_cursor_pos.y = max(0, current_cursor_pos.y - 1)
			KEY_DOWN:
				current_cursor_pos.y = min(GRID_HEIGHT - 1, current_cursor_pos.y + 1)
			KEY_LEFT:
				current_cursor_pos.x = max(0, current_cursor_pos.x - 1)
			KEY_RIGHT:
				current_cursor_pos.x = min(GRID_WIDTH - 1, current_cursor_pos.x + 1)
		
		if old_pos != current_cursor_pos:
			update_cursor_display()

func update_cursor_display():
	# Unhighlight all tiles
	for row in tiles:
		for tile in row:
			if tile:
				tile.unhighlight()
	
	# Highlight current tile
	var current_tile = get_tile_at(current_cursor_pos)
	if current_tile:
		current_tile.highlight()
		#Debug tiles
		update_info_display(current_tile)
		

func get_tile_at(pos: Vector2i) -> Tile:
	if pos.y >= 0 and pos.y < GRID_HEIGHT and pos.x >= 0 and pos.x < GRID_WIDTH:
		return tiles[pos.y][pos.x]
	return null

func update_info_display(tile: Tile):
	var type_name = ["Edge", "Center", "Info"][tile.tile_type]
	info_label.text = "Position: %s | Type: %s" % [tile.grid_pos, type_name]
