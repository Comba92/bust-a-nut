extends CharacterBody2D

@export var speed = 800
@onready var color: Color

signal bubble_touched

func _physics_process(delta: float) -> void:
  move_and_collide(-transform.y * speed * delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
  bubble_touched.emit(self)

func set_color(color: Color) -> void:
  self.color = color
  $Sprite2D.modulate = color
