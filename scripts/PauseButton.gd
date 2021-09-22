extends TextureButton

func _ready() -> void:
  var _result = connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  if !Game.is_paused():
    Game.pause()
  else:
    release_focus()
    Game.unpause()
