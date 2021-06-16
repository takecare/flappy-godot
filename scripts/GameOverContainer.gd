extends VBoxContainer

func _ready() -> void:
  pass

func _on_bird_hit() -> void:
  showWithDelay()

func _on_bird_grounded() -> void:
  showWithDelay()

func showWithDelay() -> void:
  get_node("AnimationPlayer").play("Show")
