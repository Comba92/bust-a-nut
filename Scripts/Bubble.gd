extends StaticBody2D

@export var color: Color
@onready var radius = $BubbleSize.shape.radius
@onready var diameter = radius * 2

var grid_position = Vector2.ZERO
var neighbors = []

func world_pos_to_grid(pos: Vector2) -> Vector2:
  var ny = roundi(pos.y / (diameter * Globals.triangular_height))
  var offset = 0 if ny % 2 == 0 else radius
  var nx = roundi((pos.x - offset) / diameter)
  return Vector2(nx, ny)

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
  grid_position = world_pos_to_grid(position)
  name = 'Bubble' + str(grid_position)
  $Label.text = str(grid_position)

func _on_mouse_entered() -> void:
    $Label.visible = true

func _on_mouse_exited() -> void:
  $Label.visible = false
