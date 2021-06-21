extends HBoxContainer

export(NodePath) var lastScorePath = null
onready var lastScore: Node = get_node(lastScorePath) if lastScorePath != null else get_node("../ScorePanelContainer/LastScore")

export(NodePath) var animationPlayerPath = null
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("../AnimationPlayer")

func _ready():
  modulate = Color(1, 1, 1, 0)
  var _result = lastScore.connect("last_score_count_finished", self, "_fadeIn")
  _result = lastScore.connect("last_score_count_finished", self, "_focusPlayButton")

func _fadeIn():
  animationPlayer.play("Show Buttons")

func _focusPlayButton():
  get_node("Play").grab_focus()
  pass
