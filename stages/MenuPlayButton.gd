extends TextureButton

func _ready() -> void:
  connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  StageManager.changeToGameStage()
