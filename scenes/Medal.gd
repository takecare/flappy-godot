extends TextureRect

const SPRITE_BRONZE = preload("res://sprites/medal_bronze.png")
const SPRITE_SILVER = preload("res://sprites/medal_silver.png")
const SPRITE_GOLD = preload("res://sprites/medal_gold.png")
const SPRITE_PLATINUM = preload("res://sprites/medal_platinum.png")

export(NodePath) var lastScorePath = null

onready var lastScore: HBoxContainer = get_node(lastScorePath) if lastScorePath != null else get_node("../LastScore")

func _ready():
  hide()
  var _result = lastScore.connect("last_score_count_finished", self, "_on_last_score_counting_finished")
  _result = Game.connect("best_score_changed", self, "_on_best_score_changed")
  
func _on_best_score_changed(_bestScore, medal) -> void:
  print(medal)
  match medal:
    Game.Medals.PLATINUM:
      texture = SPRITE_PLATINUM
    Game.Medals.GOLD:
      texture = SPRITE_GOLD
    Game.Medals.SILVER:
      texture = SPRITE_SILVER
    Game.Medals.BRONZE:
      texture = SPRITE_BRONZE
    _:
      texture = null

func _on_last_score_counting_finished() -> void:  
  show()
