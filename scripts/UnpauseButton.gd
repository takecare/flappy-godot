extends TextureButton

func _ready() -> void:
  var _result = Game.connect("paused", self, "_on_paused")
  _result = connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  visible = false
  Game.unpause()

func _on_paused() -> void:
  visible = true
