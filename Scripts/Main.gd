extends Node2D

var Bubble = preload("res://Scenes/Bubble_Fixed.tscn")
var Projectile = preload("res://Scenes/Bubble_Projectile.tscn")
@onready var bubbles = $Bubbles

@export var max_width = 10
@export var max_height = 2

# se siamo sulla riga pari, in alto e in basso controllo a sinistra e in centro
# se siamo sulla riga dispari, in alto e in basso controllo in centro e a destra
const even_row_directions = [
    Vector2(-1, -1), Vector2(0, -1),
    Vector2.LEFT, Vector2.RIGHT,
    Vector2(-1, 1), Vector2(0, 1),
]
const odd_row_directions = [
    Vector2(0, -1), Vector2(1, -1), 
    Vector2.LEFT, Vector2.RIGHT,
    Vector2(0, 1), Vector2(1, 1),
]

func _ready() -> void:
  for y in range(0, max_height):
    var is_even_row = y % 2 == 0
    for x in range(0, max_width):
      if (y % 2 == 1 and x == max_width-1): continue
      
      var bubble = Bubble.instantiate()
      bubbles.add_child(bubble)
      var offset = 0 if is_even_row else bubble.radius
      bubble.position.x += offset + x*bubble.diameter
      bubble.position.y += y*bubble.diameter*Globals.triangular_height
      bubble.set_grid_position(bubble.position)
      bubble.set_color(Globals.colors.pick_random())
      print(bubble.position)
      
    find_neighbors()
      
func find_neighbors() -> void:
  for bubble in bubbles.get_children():
    var is_even_row = roundi(bubble.grid_position.y) % 2 == 0
    var directions = even_row_directions if is_even_row else odd_row_directions
    
    bubble.neighbors = []
    for d in directions:
      var p = bubble.grid_position + d
      var s = 'Bubble' + str(p)
      var b = bubbles.get_node(s)
      if b: bubble.neighbors.append(b)

func dfs_colors(bubble, visited) -> Dictionary:
  visited[bubble] = true
  for n in bubble.neighbors:
    if not visited.has(n) and n.color == bubble.color:
      dfs_colors(n, visited)
  
  return visited
  
func dfs_attached(bubble, visited) -> bool:
  if bubble.grid_position.y == 0: return true
  
  visited[bubble] = true
  var attached = false
  for n in bubble.neighbors:
    if not visited.has(n):
      attached = attached || dfs_attached(n, visited)
      
  return attached
  
func find_hanging():
  var hanging = []
  
  for bubble in bubbles.get_children():
    var attached = dfs_attached(bubble, {})
    if not attached: hanging.append(bubble)
    
  return hanging

func explode_bubbles(bubble) -> void:
  var connected_colors = dfs_colors(bubble, {})
  if connected_colors.size() < 3: return
  for b in connected_colors:
    bubbles.remove_child(b)
    
  find_neighbors()
  
  var hanging = find_hanging()
  for b in hanging:
    bubbles.remove_child(b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if Input.is_action_just_pressed("ui_down"):
    for b in bubbles.get_children():
      explode_bubbles(b)

func _on_cannon_shoot(projectile) -> void:
  add_child(projectile)
  projectile.bubble_touched.connect(_on_projectile_bubble_touched)
  
func _on_projectile_bubble_touched(proj) -> void:
  proj.queue_free()
  
  var bubble = Bubble.instantiate()
  bubbles.add_child(bubble)

  # PERFECTION
  var grid_pos = bubble.world_pos_to_grid(proj.global_position - bubbles.global_position)
  bubble.position.y = grid_pos.y * (bubble.diameter * Globals.triangular_height)
  var offset = 0 if roundi(grid_pos.y) % 2 == 0 else bubble.radius
  bubble.position.x = grid_pos.x * (bubble.diameter) + offset
  
  bubble.set_grid_position(bubble.position)
  bubble.set_color(proj.color)
  find_neighbors()
  explode_bubbles(bubble)

