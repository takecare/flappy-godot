extends HBoxContainer

export(NodePath) var lastScorePath = null
onready var lastScore: Node = get_node(lastScorePath) if lastScorePath != null else get_node("../ScorePanelContainer/LastScore")

export(NodePath) var animationPlayerPath = null
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("../AnimationPlayer")

func _ready():
  var _result = lastScore.connect("last_score_count_finished", self, "_fadeIn")
  # TODO: fade in as LastScore is finished with the counting animation

func _fadeIn():
  animationPlayer.play("Show Buttons")
