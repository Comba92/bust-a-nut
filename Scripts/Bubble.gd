extends StaticBody2D

@export var color: Color
@onready var radius = $BubbleSize.shape.radius
@onready var diameter = radius * 2

var grid_position := Vector2.ZERO
var neighbors := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

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
