extends CanvasLayer

const FADE_IN_ANIMATION = "FadeToBlack"
const FADE_OUT_ANIMATION = "FadeFromBlack"

export(NodePath) var animationPlayerPath = null
export(NodePath) var overlayPath = null

onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("AnimationPlayer")
onready var overlay: TextureRect = get_node(overlayPath) if overlayPath != null else get_node("BlackOverlay")

var nextStage: String = ""

func _ready() -> void:
  overlay.hide()

func changeToGameStage() -> void:
  changeStage("res://stages/GameStage.tscn")

func changeStage(stageName: String) -> void:
  if (stageName.empty()):
    push_error("stageName cannot be empty!")
  nextStage = stageName
  overlay.show()
  animationPlayer.play(FADE_IN_ANIMATION)

func _fadeout_finished() -> void:
  overlay.hide()
  nextStage = ""

func _fadein_finished() -> void:
  var _result = get_tree().change_scene(nextStage)
  animationPlayer.play(FADE_OUT_ANIMATION)
