extends TextureButton

func _ready() -> void:
  var _result = Game.connect("unpaused", self, "_on_unpaused")
  _result = connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  visible = false
  Game.pause()

func _on_unpaused() -> void:
  visible = true
