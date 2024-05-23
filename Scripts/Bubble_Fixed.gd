extends StaticBody2D

var color: Color
@onready var radius: float = $CollisionShape2D.shape.radius
@onready var diameter := radius * 2

var grid_position := Vector2.ZERO
var neighbors := []

func set_color(color: Color) -> void:
  self.color = color
  $Sprite2D.modulate = color

func set_grid_position(position: Vector2):
  grid_position = position
  name = 'Bubble' + str(grid_position)
  $CoordinateLabel.text = str(grid_position)

func _on_mouse_entered() -> void:
  $CoordinateLabel.visible = true

func _on_mouse_exited() -> void:
  $CoordinateLabel.visible = false
