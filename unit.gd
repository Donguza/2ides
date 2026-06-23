extends Area2D

@export var speed: float = 100.0   # pixels per second
@export var direction: int = 1     # 1 = walks right (your units), -1 = left (enemy, later)

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta
