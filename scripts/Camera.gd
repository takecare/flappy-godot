extends Camera2D

export(float) var hOffsetMultiplier = 0.25
export(NodePath) var playerPath = null

var player

func _ready() -> void:
  var screensize = Utils.get_screen_size()
  offset.x = -screensize.x * hOffsetMultiplier
  if not playerPath:
    player = Utils.get_main_node().get_node("Bird")
  else:
    player = get_node(playerPath)

func _process(_delta: float) -> void:
  position = Vector2(player.position.x, position.y)

func get_correct_position() -> Vector2:
  var cameraPos = get_camera_position()
  return Vector2(cameraPos.x + offset.x, cameraPos.y + offset.y)