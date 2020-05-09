extends Node2D

class_name Pipes, "res://sprites/pipe_icon.png"

# onready var name = get_node()

var top: Node setget ,get_top
var bottom: Node setget ,get_bottom

func get_top() -> Node:
  return get_node("Top")

func get_bottom() -> Node:
  return get_node("Bottom")

func set_opening(opening: int):
  var spacing: int = opening / 2
  get_top().position.y -= spacing
  get_bottom().position.y += spacing

func _ready() -> void:
  pass
