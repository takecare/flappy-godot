extends HBoxContainer

export(NodePath) var lastScorePath = null
onready var lastScore: Node = get_node(lastScorePath) if lastScorePath != null else get_node("../ScorePanelContainer/LastScore")

export(NodePath) var animationPlayerPath = null
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("../AnimationPlayer")

func _ready():
  show()
  set_opaque()
  var _result = lastScore.connect("last_score_count_finished", self, "_fade_in")
  _result = lastScore.connect("last_score_count_finished", self, "_focus_play_button")

func set_opaque():
  modulate = Color(1, 1, 1, 0)

func _fade_in():
  animationPlayer.play("Show Buttons")

func _focus_play_button():
  get_node("Play").grab_focus()
