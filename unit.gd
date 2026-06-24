extends Area2D

@export var stats: UnitStats
@export var team: int = 1   # 1 = player (moves right), -1 = enemy (moves left)

const FRIENDLY_SPACING: float = 45.0   # gap units keep when queueing behind a friendly

var hp: float
var _attack_cooldown: float = 0.0
var _dead: bool = false
var _hp_bar_fill: ColorRect

func _ready() -> void:
	if stats == null:
		stats = UnitStats.new()
	hp = stats.max_hp
	_color_by_team()
	_build_health_bar()

func _physics_process(delta: float) -> void:
	var enemy = _nearest_enemy_ahead()
	if enemy != null:
		_attack(enemy, delta)
		return
	if _friendly_blocking_ahead():
		return
	var target_base = _enemy_base_in_range()
	if target_base != null:
		_attack(target_base, delta)
		return
	_attack_cooldown = 0.0
	position.x += stats.speed * team * delta

func _attack(target, delta: float) -> void:
	_attack_cooldown -= delta
	if _attack_cooldown <= 0.0:
		target.take_damage(stats.damage)
		_attack_cooldown = 1.0 / stats.attack_rate

func take_damage(amount: float) -> void:
	if _dead:
		return
	hp -= amount
	_hp_bar_fill.size = Vector2(40.0 * clampf(hp / stats.max_hp, 0.0, 1.0), 5.0)
	if hp <= 0.0:
		_dead = true
		queue_free()

func is_alive() -> bool:
	return not _dead

func _nearest_enemy_ahead():
	var best = null
	var best_gap: float = stats.attack_range
	for other in get_parent().get_children():
		if other == self:
			continue
		if not other.has_method("take_damage") or not other.is_alive():
			continue
		if other.team == team:
			continue
		var gap: float = (other.position.x - position.x) * team
		if gap > 0.0 and gap <= best_gap:
			best_gap = gap
			best = other
	return best

func _enemy_base_in_range():
	for b in get_tree().get_nodes_in_group("bases"):
		if b.team == team:
			continue
		if not b.is_alive():
			continue
		var gap: float = (b.front_x() - global_position.x) * team
		if gap > 0.0 and gap <= stats.attack_range:
			return b
	return null

func _friendly_blocking_ahead() -> bool:
	for other in get_parent().get_children():
		if other == self:
			continue
		if not other.has_method("take_damage") or not other.is_alive():
			continue
		if other.team != team:
			continue
		var gap: float = (other.position.x - position.x) * team
		if gap > 0.0 and gap <= FRIENDLY_SPACING:
			return true
	return false

func _color_by_team() -> void:
	var body := get_node_or_null("Body")
	if body is ColorRect:
		body.color = Color(0.06, 0.0, 0.70) if team == 1 else Color(0.70, 0.10, 0.0)

func _build_health_bar() -> void:
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.size = Vector2(40, 5)
	bg.position = Vector2(-20, -72)
	add_child(bg)
	_hp_bar_fill = ColorRect.new()
	_hp_bar_fill.color = Color(0.2, 0.8, 0.2) if team == 1 else Color(0.85, 0.2, 0.2)
	_hp_bar_fill.size = Vector2(40, 5)
	_hp_bar_fill.position = Vector2(-20, -72)
	add_child(_hp_bar_fill)
