extends TextureButton

func _ready() -> void:
  var _result = connect("pressed", self, "_on_pressed")
  grab_focus()

func _on_pressed() -> void:
  StageManager.changeToGameStage()
