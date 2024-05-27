extends Node

const bubble_radius := 20
const bubble_diameter := bubble_radius*2
const colors := [Color.RED, Color.GREEN, Color.BLUE, Color.WHITE]
const triangular_height := sqrt(3) / 2

enum BubbleType { Color1, Color2, Color3, Color4 }

class Bubble:
  var type: BubbleType
  var color: Color
  
  func _init(type, color):
    self.type = type
    self.color = color

var bubbleTypes := [
  Bubble.new(BubbleType.Color1, Color.RED),
  Bubble.new(BubbleType.Color2, Color.GREEN),
  Bubble.new(BubbleType.Color3, Color.BLUE),
  Bubble.new(BubbleType.Color4, Color.WHITE),
]
