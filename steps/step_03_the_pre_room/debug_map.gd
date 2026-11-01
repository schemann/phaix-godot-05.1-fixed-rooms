extends Control
## Draws the chain from above, centred on the player. It reads the level's data only.

const Level := preload("level.gd")

const PIXELS_PER_METRE := 4.0
const BACKGROUND_COLOR := Color(0.0, 0.0, 0.0, 0.55)
const LIVE_COLOR := Color(0.72, 0.78, 0.9, 0.9)
const CURRENT_COLOR := Color(1.0, 0.8, 0.25)
const REMOVED_COLOR := Color(0.6, 0.6, 0.6, 0.8)
const PLAYER_COLOR := Color(1.0, 0.35, 0.3)
const LOCKED_COLOR := Color(0.3, 0.85, 0.45) ## Locked rooms on the map: green, Color(0.3, 0.85, 0.45). Red on this map is a miss and nothing else.
const MISSED_COLOR := Color(1.0, 0.2, 0.2) ## A fixed room that did not fit: where its box would have stood.

@export var level: Level

func _process(_delta: float) -> void:
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		visible = not visible

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), BACKGROUND_COLOR)

	var player_position := Vector2(level.player.global_position.x, level.player.global_position.z)
	for plan in level.chain.plans:
		var rect := _map_rect(plan.bounds, player_position)
		if not level.rooms.has(plan.index):
			draw_rect(rect, REMOVED_COLOR, false)
		elif plan.index == level.current:
			draw_rect(rect, CURRENT_COLOR)
		else:
			draw_rect(rect, LIVE_COLOR)
		if plan.locked:
			draw_rect(rect.grow(-3.0), LOCKED_COLOR, false, 3.0)
	for miss in level.chain.misses:
		draw_rect(_map_rect(miss.bounds, player_position), MISSED_COLOR, false, 3.0)

	# The player is always in the middle of the panel; the line shows where the player looks.
	var forward := -level.player.global_transform.basis.z
	var middle := size / 2.0
	draw_line(middle, middle + Vector2(forward.x, forward.z) * 14.0, PLAYER_COLOR, 2.0)
	draw_circle(middle, 4.0, PLAYER_COLOR)

	var text := "seed %d - room %d - %d live" % [level.chain_seed, level.current, level.rooms.size()]
	draw_string(ThemeDB.fallback_font, Vector2(10.0, 22.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16)

## A room's box from above, as a rectangle on the map: centred on the player, scaled to pixels.
func _map_rect(bounds: AABB, player_position: Vector2) -> Rect2:
	return Rect2(
		(Vector2(bounds.position.x, bounds.position.z) - player_position) * PIXELS_PER_METRE + size / 2.0,
		Vector2(bounds.size.x, bounds.size.z) * PIXELS_PER_METRE
	)
