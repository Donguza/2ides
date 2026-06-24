class_name Base
extends ColorRect

@export var team: int = 1          # 1 = player base (left), -1 = enemy base (right)
@export var max_hp: float = 300.0

signal destroyed(team)

var hp: float
var _dead: bool = false
var _hp_bar_fill: ColorRect

func _ready() -> void:
	hp = max_hp
	add_to_group("bases")
	_build_health_bar()

func front_x() -> float:
	# The edge facing the enemy, where attackers line up.
	if team == 1:
		return global_position.x + size.x   # player base: right edge
	return global_position.x                # enemy base: left edge

func take_damage(amount: float) -> void:
	if _dead:
		return
	hp -= amount
	_hp_bar_fill.size = Vector2(size.x * clampf(hp / max_hp, 0.0, 1.0), 12.0)
	if hp <= 0.0:
		_dead = true
		destroyed.emit(team)

func is_alive() -> bool:
	return not _dead

func _build_health_bar() -> void:
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.size = Vector2(size.x, 12)
	bg.position = Vector2(0, -18)
	add_child(bg)
	_hp_bar_fill = ColorRect.new()
	_hp_bar_fill.color = Color(0.2, 0.8, 0.2) if team == 1 else Color(0.85, 0.2, 0.2)
	_hp_bar_fill.size = Vector2(size.x, 12)
	_hp_bar_fill.position = Vector2(0, -18)
	add_child(_hp_bar_fill)
