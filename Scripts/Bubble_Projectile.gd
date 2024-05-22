extends CharacterBody2D

@export var speed = 800
@onready var color: Color

signal bubble_touched

func _ready() -> void:
  pass

func _physics_process(delta: float) -> void:
  move_and_collide(velocity * delta)

func set_color(color: Color) -> void:
  self.color = color
  $Sprite2D.modulate = color

func _on_area_2d_body_entered(body: Node2D) -> void:
  if body.is_in_group("bubbles"):
    bubble_touched.emit(self)
  else: velocity.x = -velocity.x
