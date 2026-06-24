extends Node2D

@export var unit_scene: PackedScene

@onready var units: Node2D = $Units
@onready var spawn_button: Button = $HUD/SpawnButton
@onready var player_base = $PlayerBase
@onready var enemy_base = $EnemyBase
@onready var hud: CanvasLayer = $HUD

var _result_label: Label
var _game_over: bool = false

func _ready() -> void:
	spawn_button.pressed.connect(_on_spawn_button_pressed)
	player_base.destroyed.connect(_on_base_destroyed)
	enemy_base.destroyed.connect(_on_base_destroyed)
	_build_result_label()

func _on_spawn_button_pressed() -> void:
	if _game_over:
		return
	_spawn_unit(1, Vector2(180, 520))

func _unhandled_input(event: InputEvent) -> void:
	if _game_over:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_spawn_unit(-1, Vector2(1100, 520))

func _spawn_unit(team: int, pos: Vector2) -> void:
	var unit = unit_scene.instantiate()
	unit.team = team
	unit.position = pos
	units.add_child(unit)

func _on_base_destroyed(team: int) -> void:
	if _game_over:
		return
	_game_over = true
	if team == 1:
		_result_label.text = "YOU LOSE"
		_result_label.modulate = Color(1, 0.3, 0.3)
	else:
		_result_label.text = "YOU WIN"
		_result_label.modulate = Color(0.3, 1, 0.3)
	_result_label.visible = true
	get_tree().paused = true

func _build_result_label() -> void:
	_result_label = Label.new()
	_result_label.add_theme_font_size_override("font_size", 80)
	_result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_result_label.anchor_right = 1.0
	_result_label.offset_top = 280.0
	_result_label.offset_bottom = 440.0
	_result_label.visible = false
	_result_label.process_mode = Node.PROCESS_MODE_ALWAYS
	hud.add_child(_result_label)
