extends Node2D

var color: Color = Globals.colors.pick_random()
var Projectile = preload('res://Scenes/Bubble_Projectile.tscn')
signal shoot()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotation -= 1.1 * delta
	elif Input.is_action_pressed("ui_right"):
		rotation += 1.1 * delta

	if Input.is_action_just_pressed("ui_select"):
		var proj = Projectile.instantiate()
		proj.transform = transform
		proj.set_color(color)
		shoot.emit(proj)
		color = Globals.colors.pick_random()
		$Sprite2D.modulate = color
