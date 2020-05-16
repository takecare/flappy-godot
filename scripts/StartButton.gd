extends TextureButton

export(NodePath) var birdPath = null
export(NodePath) var pipeSpawnerPath = null

onready var bird: Bird = get_node(birdPath) if birdPath != null else Utils.get_main_node().get_node("Bird")
onready var pipeSpawner: PipeSpawner = get_node(pipeSpawnerPath) if pipeSpawnerPath != null else Utils.get_main_node().get_node("PipeSpawner")

func _ready() -> void:
  var _ignored = connect("pressed", self, "_on_pressed")
  grab_focus()

func _on_pressed() -> void:
  # these should be in some sort of "game manager"
  pipeSpawner.set_state(pipeSpawner.State.PLAYING)
  bird.set_state(bird.State.JUMPING)
  hide()
