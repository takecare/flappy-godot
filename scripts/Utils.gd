extends Node

func _ready() -> void:
  pass

func get_main_node():
  var root = get_tree().get_root()
  return root.get_child(root.get_child_count() - 1)

func get_size():
  return get_viewport().get_visible_rect().size
