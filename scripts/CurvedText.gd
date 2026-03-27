# https://forum.godotengine.org/t/circular-curved-text-effects/127592/3
@tool
extends Path2D
class_name CurvedText

@export var text: String:
	set(value):
		if text != value:
			text = value
			queue_redraw()


@export var label_settings: LabelSettings:
	set(value):
		if is_instance_valid(label_settings) and label_settings.changed.is_connected(queue_redraw):
			label_settings.changed.disconnect(queue_redraw)

		label_settings = value

		if is_instance_valid(label_settings):
			label_settings.changed.connect(queue_redraw)

@export var start_offset:float = 0:
	set(value):
		if start_offset != value:
			start_offset = value
			queue_redraw()

@export var text_cutoff:int = -1:
	set(value):
		if text_cutoff != value:
			text_cutoff = value
			queue_redraw()

var _line = TextLine.new()


func _draw() -> void:
	# Get the font, font size and color from the ThemeDB
	var font = ThemeDB.fallback_font
	var font_size = ThemeDB.fallback_font_size
	var font_color = Color.WHITE
	var outline_color = Color.WHITE
	var outline_size = 0

	# If the label_settings is valid, then use the values from it
	if is_instance_valid(label_settings):
		font = label_settings.font
		font_size = label_settings.font_size
		font_color = label_settings.font_color
		outline_color = label_settings.outline_color
		outline_size = label_settings.outline_size

	# Clear the line and add the new string
	_line.clear()
	_line.add_string(text, font, font_size)
	# Get the primary TextServer
	var ts = TextServerManager.get_primary_interface()
	# And get the glyph information from the line
	var glyphs = ts.shaped_text_get_glyphs(_line.get_rid())
	if text_cutoff != -1: glyphs = glyphs.slice(0, text_cutoff)

	var offset = start_offset
	for glyph_data in glyphs:
		# Sample the curve with rotation at the offset
		var trans = curve.sample_baked_with_rotation(offset)
		# set the draw matrix to that transform
		draw_set_transform_matrix(trans)
		# draw the glyph
		ts.font_draw_glyph_outline(glyph_data["font_rid"], get_canvas_item(), font_size, outline_size, Vector2.ZERO, glyph_data["index"], outline_color, 2.0)
		ts.font_draw_glyph(glyph_data["font_rid"], get_canvas_item(), font_size, Vector2.ZERO, glyph_data["index"], font_color, 2.0)
		# add the advance to the offset
		offset += glyph_data.get("advance", 0.0)
