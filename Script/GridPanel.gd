class_name DialogueBox
extends Control

var text_label: RichTextLabel
var background: Panel

var default_text = "Move cursor to explore tiles..."
var dialogue_height = 120  # Fixed height for dialogue area

func _ready():
	
	await get_tree().process_frame  # Wait one frame to ensure children are ready
	print("DialogueBox _ready() called")
	print("Background node: ", background)
	print("TextLabel node: ", text_label)
	
	background = get_node("Background") as Panel
	text_label = get_node("TextLabel") as RichTextLabel
	
	if background == null:
		print("Available children:")
		for child in get_children():
			print("  - ", child.name, " (", child.get_class(), ")")
	#setup_ui()
	#show_text(default_text)

func setup_ui():
	# Basic setup - size will be set externally
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.9)  # Dark semi-transparent
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.3, 0.3, 0.3, 1.0)  # Lighter border
	background.add_theme_stylebox_override("panel", style)
	text_label.bbcode_enabled = true
	text_label.scroll_active = false
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func resize_to_width(screen_width: float):
	# Set dialogue box to full screen width
	size.x = screen_width
	size.y = dialogue_height
	
	# Make background fill the control
	#background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Set up text label with margins
	#text_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#text_label.position = Vector2(20, 10)  # Left and top margin
	#text_label.size = Vector2(screen_width - 40, dialogue_height - 20)  # Account for margins

func position_below_grid(grid_bottom: float):
	# Position the dialogue box below the grid with some spacing
	position.y = grid_bottom + 20
	position.x = 0

func show_text(text: String):
	text_label.text = "[center]%s[/center]" % text

func show_tile_info(tile: Tile):
	var tile_type_names = {
		Tile.TileType.EDGE: "Edge",
		Tile.TileType.CENTER: "Center"
	}
	
	var type_name = tile_type_names.get(tile.tile_type, "Unknown")
	var position_text = "Position: (%d, %d)" % [tile.grid_pos.x, tile.grid_pos.y]
	
	var message = ""
	match tile.tile_type:
		Tile.TileType.EDGE:
			message = "[color=lightblue]Edge Tile[/color] - Player can move here! | %s" % position_text
		Tile.TileType.CENTER:
			message = "[color=lightcoral]Center Tile[/color] - Enemy territory... | %s" % position_text
	
	show_text(message)

func clear_text():
	show_text(default_text)
