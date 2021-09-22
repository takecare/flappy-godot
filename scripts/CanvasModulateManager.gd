extends Node2D

const NON_MODULATED = Color(1, 1, 1, 1)

export(Color) var modulated = Color(1, 1, 1, 1)
export(Array, NodePath) var nodes = [null]

func _ready() -> void:
  var _result = Game.connect("paused", self, "_on_paused")
  _result = Game.connect("unpaused", self, "_on_unpaused")
  pass

func _on_paused() -> void:
  modulate()

func _on_unpaused() -> void:
  reset()

func modulate() -> void:
  # iterate through each node path, getting the node
  #  and calling set_color(modulated) on it
  for path in nodes:
    var node: CanvasModulate = get_node(path)
    if node == null:
      push_warning("Unexpected null node, path is " + path)
    node.set_color(modulated)

func reset() -> void:
  for path in nodes:
    var node: CanvasModulate = get_node(path)
    node.set_color(NON_MODULATED)
