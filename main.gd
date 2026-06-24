extends Node2D

@export var unit_scene: PackedScene

@onready var units: Node2D = $Units
@onready var spawn_button: Button = $HUD/SpawnButton

func _ready() -> void:
	spawn_button.pressed.connect(_on_spawn_button_pressed)

func _on_spawn_button_pressed() -> void:
	_spawn_unit(1, Vector2(180, 520))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_spawn_unit(-1, Vector2(1100, 520))

func _spawn_unit(team: int, pos: Vector2) -> void:
	var unit = unit_scene.instantiate()
	unit.team = team
	unit.position = pos
	units.add_child(unit)
