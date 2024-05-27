extends Node2D

var type: Globals.Bubble = Globals.bubbleTypes.pick_random()
var Projectile := preload('res://Scenes/BubbleProjectile.tscn')

@onready var first_ray := $RayCast2D
signal shoot

var bouncing = null

func _ready() -> void:
  $Sprite2D.modulate = type.color

func _process(delta: float) -> void:
  if Input.is_action_pressed("ui_left"):
    rotation -= 1.1 * delta
  elif Input.is_action_pressed("ui_right"):
    rotation += 1.1 * delta


  if Input.is_action_just_pressed("ui_select"):
    var proj := Projectile.instantiate()
    proj.velocity = Vector2.from_angle(rotation - PI/2) * proj.speed
    proj.position = position
    proj.set_type(type)
    shoot.emit(proj)
    type = Globals.bubbleTypes.pick_random()
    $Sprite2D.modulate = type.color

func _physics_process(delta: float) -> void:
  if first_ray.is_colliding():
    if bouncing:
      bouncing.queue_free()
      bouncing = null
    var body = first_ray.get_collider()
    if not body or body.is_in_group("bubbles"): return
    var new_ray := first_ray.duplicate()
    bouncing = new_ray
    add_child(new_ray)
    
    var coll_point = first_ray.get_collision_point()
    new_ray.global_position = coll_point
    var forward = coll_point - first_ray.global_position
    var reflection = forward.bounce(first_ray.get_collision_normal())
    new_ray.global_rotation = 0
    new_ray.target_position = reflection * 100
  else: 
    if bouncing: bouncing.queue_free()
    bouncing = null
