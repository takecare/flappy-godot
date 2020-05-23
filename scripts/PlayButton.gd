extends TextureButton

func _ready() -> void:
  connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  get_tree().reload_current_scene()
  pass
