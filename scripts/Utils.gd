extends Node

func _ready() -> void:
  pass

func get_main_node() -> Node:
  var root = get_tree().get_root()
  return root.get_child(root.get_child_count() - 1)

func get_screen_size() -> Vector2:
  return get_viewport().get_visible_rect().size

func get_path_or_node(path, name) -> Node:
  return get_node(name) if not path else get_node(path)

func get_main_camera() -> Camera2D:
  return Utils.get_main_node().get_node("Camera")
