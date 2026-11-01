extends SceneTree
## Checks that a fixed room stands where the table says, for seeds 1 to 2000. Data only, like the other checks:
## no level is started and no player walks, the chain is asked for its plans and the plans are read.
## The level's table is moved so that its vault stands at room 10, 30, 50 and 100, one chain per seed and
## room number, and every chain says where the vault really landed.
##
##   godot --headless --path godot/05.1-fixed-rooms -s res://steps/step_04_the_window/check_fixed.gd
##
## Options: `-- --seeds=200` checks seeds 1 to 200 only. `-- --rooms=30,50` tries other room numbers.
## The exit code is 0 if the vault landed in every seed and 1 if any seed lost it, so a build server can run it.

const Chain := preload("room_chain.gd")
const Level := preload("level.gd")

const DEFAULT_SEEDS := 2000
const DEFAULT_ROOMS: Array[int] = [10, 30, 50, 100]
const GOAL_ROOM := 300 ## Far behind every room number we try: the goal never gets in the way.
const LOOK_AHEAD := 10 ## Rooms made behind the room number, so a vault that landed late is still seen.

func _initialize() -> void:
	var seed_count := DEFAULT_SEEDS
	var room_numbers := DEFAULT_ROOMS.duplicate()
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--seeds="):
			seed_count = int(argument.trim_prefix("--seeds="))
		elif argument.begins_with("--rooms="):
			room_numbers.clear()
			for number in argument.trim_prefix("--rooms=").split(","):
				room_numbers.append(int(number))

	var level := Level.new() # only to read what the level stands on, it never enters the tree
	var table: Dictionary = level.fixed_rooms.duplicate()
	var chance := level.lock_chance
	level.free()

	print("fixed rooms %s, seeds 1-%d, lock chance %.1f" % [table_text(table), seed_count, chance])
	var lost := 0
	for number: int in room_numbers:
		var landings := {} ## How many rooms late the vault landed -> in how many seeds. -1: it never landed.
		var before := {} ## The room in front of the vault's number, in the seeds where the vault did not land on it -> in how many seeds.
		var first_lost := 0
		for chain_seed in range(1, seed_count + 1):
			if chain_seed % 100 == 0:
				await process_frame # every chain reads seven room scenes: let the engine empty its queue now and then
			var chain := chain_of(chain_seed, GOAL_ROOM, chance, moved(table, number), number)
			var late := landing_in(chain, number)
			landings[late] = landings.get(late, 0) + 1
			if late != 0:
				var type_name: String = Chain.Type.keys()[chain.plans[number - 1].type].to_lower()
				before[type_name] = before.get(type_name, 0) + 1
			if late < 0 and first_lost == 0:
				first_lost = chain_seed
		print("room %3d: %s" % [number, landings_text(landings)])
		if not before.is_empty():
			print("          the room in front of it, where it did not land: %s" % before_text(before))
		if first_lost > 0:
			print("          first seed without it: %d" % first_lost)
		lost += landings.get(-1, 0)
	print("FIXED ROOMS " + ("OK" if lost == 0 else "MISSED: %d times the vault never came" % lost))
	quit(1 if lost > 0 else 0)

## The chain of a seed, made far enough behind the room number to see where the vault landed.
static func chain_of(chain_seed: int, goal_room: int, chance: float, table: Dictionary, number: int) -> Chain:
	var chain := Chain.new(chain_seed, goal_room, chance, table)
	while chain.plans.size() < number + LOOK_AHEAD:
		chain.next_plan()
	return chain

static func landing_of(chain_seed: int, goal_room: int, chance: float, table: Dictionary, number: int) -> int:
	return landing_in(chain_of(chain_seed, goal_room, chance, table, number), number)

## How many rooms after its number the fixed vault of this chain stands: 0 is on its number, -1 it never came.
static func landing_in(chain: Chain, number: int) -> int:
	for plan in chain.plans:
		if plan.fixed and plan.type == Chain.Type.VAULT:
			return plan.index - number
	return -1

## The table with the vault moved to this room number. Every other entry moves with it, so a room in front of the vault stays in front of it.
static func moved(table: Dictionary, number: int) -> Dictionary:
	var shift := 0
	for key: int in table:
		if table[key] == Chain.Type.VAULT:
			shift = number - key
	var result := {}
	for key: int in table:
		result[key + shift] = table[key]
	return result

static func table_text(table: Dictionary) -> String:
	var parts: Array[String] = []
	for key: int in table:
		parts.append("%d: %s" % [key, Chain.Type.keys()[table[key]]])
	return "{" + ", ".join(parts) + "}"

static func landings_text(landings: Dictionary) -> String:
	var parts: Array[String] = []
	var keys := landings.keys()
	keys.sort()
	for late: int in keys:
		if late == 0:
			parts.append("on its number %d" % landings[late])
		elif late > 0:
			parts.append("%d late %d" % [late, landings[late]])
	parts.append("never %d" % landings.get(-1, 0))
	return ", ".join(parts)

static func before_text(before: Dictionary) -> String:
	var parts: Array[String] = []
	for type_name: String in before:
		parts.append("%s %d" % [type_name, before[type_name]])
	return ", ".join(parts)
