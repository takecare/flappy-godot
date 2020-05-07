extends Node

func _ready() -> void:
  pass

func get_main_node():
  var root = get_tree().get_root()
  return root.get_child(root.get_child_count() - 1)

func get_screen_size():
  return get_viewport().get_visible_rect().size

func get_path_or_node(path, name) -> Node:
  return get_node(name) if not path else get_node(path)
