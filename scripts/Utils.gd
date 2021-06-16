extends Node

func _ready() -> void:
  pass

func get_main_node() -> Node:
  var root = get_tree().get_root()
  return root.get_child(root.get_child_count() - 1)

func get_screen_size() -> Vector2:
  return get_viewport().get_visible_rect().size

func get_main_camera() -> Camera2D:
  return Utils.get_main_node().get_node("Camera") as Camera2D
