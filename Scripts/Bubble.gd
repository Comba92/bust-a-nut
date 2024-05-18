extends StaticBody2D

@export var color: Color
@onready var radius = $BubbleSize.shape.radius
@onready var diameter = radius * 2

var grid_position = Vector2.ZERO
var neighbors = []

func old_world_to_grid(pos: Vector2) -> Vector2:
  # wx = r + d * gx, gx = (wx - r) / d
  # wy = d * gy, gy = wy/d
  var ny = roundi(pos.y / diameter)
  var nx = roundi(
    pos.x / diameter if roundi(pos.y) % 2 == 0 else (pos.x - radius) / diameter)
  return Vector2(nx, ny)

func world_pos_to_grid(pos: Vector2) -> Vector2:
  var ny = roundi(pos.y / (diameter * Globals.triangular_height))
  var offset = 0 if ny % 2 == 0 else radius
  var nx = roundi((pos.x - offset) / diameter)
  return Vector2(nx, ny)

func align_pos_to_grid(pos: Vector2, origin: Vector2) -> Vector2:
  var row_height = roundi(diameter * Globals.triangular_height)
  var ny = roundi((pos.y - origin.y) / row_height) * row_height
  var offset = 0 if floori(pos.y / row_height) % 2 == 0 else radius
  var nx = roundi((pos.x - origin.x - offset) / diameter) * diameter + offset
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
