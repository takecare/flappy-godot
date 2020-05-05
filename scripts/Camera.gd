extends Camera2D

export(float) var HORIZONTAL_OFFSET = 0.25
export(NodePath) var playerPath = null

var player

func _ready() -> void:
  var screensize = get_viewport().get_visible_rect().size
  offset.x = -screensize.x * HORIZONTAL_OFFSET
  if playerPath == null:
    player = get_tree().get_root().get_child(0).get_node("Bird")
  else:
    player = get_node(playerPath)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
  position = Vector2(player.position.x, position.y)
