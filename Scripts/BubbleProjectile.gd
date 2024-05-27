extends CharacterBody2D

@export var speed = 1500
var type: Globals.Bubble

signal bubble_touched

func _ready() -> void:
  pass

func _physics_process(delta: float) -> void:
  var collision := move_and_collide(velocity * delta)
  if collision:
    var body := collision.get_collider()
    if body.is_in_group("bubbles"): bubble_touched.emit(self)
    else:
      var normal := collision.get_normal()
      velocity = velocity.bounce(normal)

func set_type(type: Globals.Bubble) -> void:
  self.type = type
  $Sprite2D.modulate = type.color

# deprecated
func set_color(color: Color) -> void:
  # self.color = color
  $Sprite2D.modulate = color
