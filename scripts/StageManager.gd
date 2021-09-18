extends CanvasLayer

const FADE_IN_ANIMATION = "FadeToBlack"
const FADE_OUT_ANIMATION = "FadeFromBlack"

export(NodePath) var animationPlayerPath = null
export(NodePath) var overlayPath = null

onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("AnimationPlayer")
onready var overlay: TextureRect = get_node(overlayPath) if overlayPath != null else get_node("BlackOverlay")

var nextStage: String = ""
var isChangingState = false

func _ready() -> void:
  overlay.hide()

func changeToGameStage() -> void:
  Game.reset_score()
  change_stage("res://stages/GameStage.tscn")

func change_stage(stageName: String) -> void:
  if (stageName.empty()):
    push_error("stageName cannot be empty!")
    return
  if isChangingState:
    push_warning("State change already in progress")
    return
  nextStage = stageName
  isChangingState = true
  overlay.show()
  animationPlayer.play(FADE_IN_ANIMATION)

func _fadeout_finished() -> void:
  overlay.hide()
  nextStage = ""

func _fadein_finished() -> void:
  var _result = get_tree().change_scene(nextStage)
  isChangingState = false
  animationPlayer.play(FADE_OUT_ANIMATION)
