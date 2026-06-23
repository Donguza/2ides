extends Node2D

@export var unit_scene: PackedScene

@onready var units: Node2D = $Units
@onready var spawn_button: Button = $HUD/SpawnButton

func _ready() -> void:
	spawn_button.pressed.connect(_on_spawn_button_pressed)

func _on_spawn_button_pressed() -> void:
	var unit = unit_scene.instantiate()
	unit.position = Vector2(180, 520)
	units.add_child(unit)
