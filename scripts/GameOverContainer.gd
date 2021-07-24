extends Container

export(NodePath) var animationPlayerPath = null
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("AnimationPlayer")

func _ready() -> void:
  if Game.isDebug:
    showWithDelay()

func _on_bird_hit() -> void:
  showWithDelay()

func _on_bird_grounded() -> void:
  showWithDelay()

func showWithDelay() -> void:
  animationPlayer.play("Show")
