extends HBoxContainer

export(NodePath) var lastScorePath = null
onready var lastScore: Node = get_node(lastScorePath) if lastScorePath != null else get_node("../ScorePanelContainer/LastScore")

func _ready():
  hide()
  lastScore.connect("last_score_count_finished", self, "show")
  # TODO: fade in as LastScore is finished with the counting animation
