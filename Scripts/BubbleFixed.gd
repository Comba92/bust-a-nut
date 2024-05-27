extends StaticBody2D

var color: Color
@onready var radius: float = $CollisionShape2D.shape.radius
@onready var diameter := radius * 2

var grid_position := Vector2.ZERO
var neighbors := []

func set_color(color: Color) -> void:
  self.color = color
  $Sprite2D.modulate = color

func is_on_even_row():
  return roundi(grid_position.y) % 2 == 0

func set_grid_position(grid_pos: Vector2):
  grid_position = grid_pos
  name = 'Bubble' + str(grid_position)
  $CoordinateLabel.text = str(grid_position)
  
  position.y = grid_pos.y * (diameter * Globals.triangular_height)
  var is_even_row := roundi(grid_pos.y) % 2 == 0
  var offset: float = 0 if is_even_row else radius
  position.x = grid_pos.x * diameter + offset

func _on_mouse_entered() -> void:
  $CoordinateLabel.visible = true

func _on_mouse_exited() -> void:
  $CoordinateLabel.visible = false
