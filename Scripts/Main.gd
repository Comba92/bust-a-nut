extends Node2D

const Bubble := preload("res://Scenes/BubbleFixed.tscn")
const Projectile := preload("res://Scenes/BubbleProjectile.tscn")
@onready var bubbles := $Bubbles

@export var max_width := 8
@export var max_height := 2
@export var pop_count := 3

var bubbles_list := {}

# se siamo sulla riga pari, in alto e in basso controllo a sinistra e in centro
# se siamo sulla riga dispari, in alto e in basso controllo in centro e a destra
const even_row_directions := [
  Vector2(-1, -1), Vector2(0, -1),
  Vector2.LEFT, Vector2.RIGHT,
  Vector2(-1, 1), Vector2(0, 1),
]
const odd_row_directions := [
  Vector2(0, -1), Vector2(1, -1),
  Vector2.LEFT, Vector2.RIGHT,
  Vector2(0, 1), Vector2(1, 1),
]

func world_pos_to_grid(pos: Vector2) -> Vector2:
  var radius = Bubble.instantiate().get_node("BubbleSize").shape.radius
  var diameter = radius * 2
  var ny := roundi(pos.y / (diameter * Globals.triangular_height))
  var offset = 0 if ny % 2 == 0 else radius
  var nx := roundi((pos.x - offset) / diameter)
  return Vector2(nx, ny)


func add_bubble(grid_pos: Vector2, color: Color) -> Node:
  var bubble := Bubble.instantiate()
  bubbles.add_child(bubble)
  
  bubble.position.y = grid_pos.y * (bubble.diameter * Globals.triangular_height)
  var is_even_row := roundi(grid_pos.y) % 2 == 0
  var offset: float = 0 if is_even_row else bubble.radius
  bubble.position.x = grid_pos.x * (bubble.diameter) + offset
  bubble.set_grid_position(grid_pos)
  bubble.set_color(color)
  
  bubbles_list[grid_pos] = bubble
  
  var directions := even_row_directions if is_even_row else odd_row_directions
  for dir in directions:
    var pos = bubble.grid_position + dir
    if bubbles_list.has(pos):
      var neighbor = bubbles_list[pos]
      bubble.neighbors.append(neighbor)
      neighbor.neighbors.append(bubble)
  
  return bubble

func remove_bubble(bubble):
  if not bubbles_list.has(bubble.grid_position): return
  
  bubbles_list.erase(bubble.grid_position)
  for neighbor in bubble.neighbors:
    neighbor.neighbors.erase(bubble)
  
  bubble.queue_free()

func _ready() -> void:
  for y in range(0, max_height):
    for x in range(0, max_width):
      if (y % 2 == 1 and x == max_width-1): continue
      add_bubble(Vector2(x, y), Globals.colors.pick_random())


func find_neighbors() -> void:
  for bubble in bubbles_list.values():
    bubble.neighbors.clear()

    var is_even_row := roundi(bubble.grid_position.y) % 2 == 0
    var directions := even_row_directions if is_even_row else odd_row_directions
    
    for d in directions:
      var p = bubble.grid_position + d
      if bubbles_list.has(p):
        var n = bubbles_list[p]
        bubble.neighbors.append(n)


func dfs_colors(bubble: Node, visited: Dictionary) -> Array:
  visited[bubble] = true
  for n in bubble.neighbors:
    if not visited.has(n) and n.color == bubble.color:
      dfs_colors(n, visited)
  
  return visited.keys()

func dfs_attached(bubble: Node, visited: Dictionary) -> bool:
  if bubble.grid_position.y == 0: return true
  
  visited[bubble] = true
  for n in bubble.neighbors:
    var is_upper = n.grid_position.y <= bubble.grid_position.y
    if not visited.has(n) and is_upper:
      if dfs_attached(n, visited): return true

  return false
  
func find_hanging() -> Array:
  var hanging := []
  
  for bubble in bubbles_list.values():
    var attached := dfs_attached(bubble, {})
    if not attached: hanging.append(bubble)

  return hanging

func pop_bubbles(bubble) -> void:
  var connected_colors := dfs_colors(bubble, {})
  if connected_colors.size() < pop_count: return
  
  for b in connected_colors:
    remove_bubble(b)
  
  var hanging := find_hanging()
  for b in hanging:
    remove_bubble(b)


func _process(delta: float) -> void:
  if Input.is_action_just_pressed("ui_down"):
    for b in bubbles.get_children():
      pop_bubbles(b)

func _on_cannon_shoot(projectile) -> void:
  add_child(projectile)
  projectile.bubble_touched.connect(_on_projectile_bubble_touched)
  
func _on_projectile_bubble_touched(proj) -> void:
  # necessary to prevent multiple collisions (and multiple spawning of bubbles)
  proj.bubble_touched.disconnect(_on_projectile_bubble_touched)
  proj.queue_free()

  var grid_pos := world_pos_to_grid(proj.global_position - bubbles.global_position)
  var bubble := add_bubble(grid_pos, proj.color)
  
  pop_bubbles(bubble)
