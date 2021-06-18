extends Container

func _ready() -> void:
  pass

func _on_bird_hit() -> void:
  showWithDelay()

func _on_bird_grounded() -> void:
  showWithDelay()

# bug: this is being called again when the bird hits the ground after hitting a pipe
func showWithDelay() -> void:
  get_node("AnimationPlayer").play("Show")
