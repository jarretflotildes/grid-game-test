class_name Tile
extends Area2D

enum TileType { EDGE, CENTER }

@export var grid_pos: Vector2i
@export var tile_type: TileType
@export var tile_size: Vector2 = Vector2(64, 64)

@onready var background = $Background
@onready var border = $Background/Border

var default_colors = {
	TileType.EDGE: Color.LIGHT_BLUE,
	TileType.CENTER: Color.LIGHT_CORAL
}

func _ready():
	background.size = tile_size
	background.color = default_colors[tile_type]
	border.size = tile_size
	
func highlight():
	background.color = Color.BLUE
	
func unhighlight():
	background.color = default_colors[tile_type]
