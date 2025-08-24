extends TileMapLayer

var GridWidth = 8
var GridHeight = 4
var Dict = {}

func _ready():
	makeGrid()
			
func makeGrid():
	for x in GridWidth:
		for y in GridHeight:
			if(is_edge(x,y) == true):
				set_cell(Vector2(x,y),1,Vector2i(0,0))
			else:
				set_cell(Vector2(x,y),2,Vector2i(0,0))
			
			Dict[str(Vector2(x,y))] = {
				"Type": "Default"
			}

func is_edge(x: int, y: int) -> bool:
	return x == 0 or x == GridWidth - 1 or y == 0 or y == GridHeight - 1

func _process(delta):
	var global_mouse = get_global_mouse_position()
	var local_mouse = to_local(global_mouse)
	var tile = local_to_map(local_mouse)
	
	print("Tile coords: ", tile)
	
	if(Dict.has(str(tile))):
		print("Tile data: ", Dict[str(tile)])
	else:
		print("No tile data for: ", str(tile))
