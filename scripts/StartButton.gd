extends TextureButton

export(NodePath) var birdPath = null
export(NodePath) var pipeSpawnerPath = null

onready var bird: Bird = get_node(birdPath) if birdPath != null else Utils.get_main_node().get_node("Bird")
onready var pipeSpawner: PipeSpawner = get_node(pipeSpawnerPath) if pipeSpawnerPath != null else Utils.get_main_node().get_node("PipeSpawner")

func _ready() -> void:
  connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
  pipeSpawner.set_state(pipeSpawner.State.PLAYING)
  # bird.set_state(bird.State.JUMPING)
  hide()
