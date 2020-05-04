extends Camera2D

export(float) var HORIZONTAL_OFFSET = 0.25
export(NodePath) var player = null

func _ready() -> void:
  var screensize = get_viewport().get_visible_rect().size
  offset.x = -screensize.x * HORIZONTAL_OFFSET
  player = get_node("../Bird")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
  position = Vector2(player.position.x, position.y)
  pass
