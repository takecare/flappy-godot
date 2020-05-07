extends Camera2D

export(float) var HORIZONTAL_OFFSET = 0.25
export(NodePath) var playerPath = null

var player

func _ready() -> void:
  var screensize = Utils.get_size()
  offset.x = -screensize.x * HORIZONTAL_OFFSET
  if playerPath == null:
    player = Utils.get_main_node().get_node("Bird")
  else:
    player = get_node(playerPath)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
  position = Vector2(player.position.x, position.y)
