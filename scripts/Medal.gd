extends TextureRect

class_name Medal

const SPRITE_BRONZE = preload("res://sprites/medal_bronze.png")
const SPRITE_SILVER = preload("res://sprites/medal_silver.png")
const SPRITE_GOLD = preload("res://sprites/medal_gold.png")
const SPRITE_PLATINUM = preload("res://sprites/medal_platinum.png")

signal medal_attributed

export(NodePath) var lastScorePath = null

onready var lastScore: HBoxContainer = get_node(lastScorePath) if lastScorePath != null else get_node("../LastScore")

func _ready():
  hide()
  texture = null
  for child in get_children():
    if child.has_method("_on_medal_attributed"):
      var _result = self.connect("medal_attributed", child, "_on_medal_attributed")
  if Game.isDebug:
    show()
  else:
    var _result = lastScore.connect("last_score_count_finished", self, "_on_last_score_counting_finished")
    _result = Game.connect("best_score_changed", self, "_on_best_score_changed")

func _on_best_score_changed(_bestScore, medal) -> void:
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
  if texture != null:
    emit_signal("medal_attributed")

func _on_last_score_counting_finished() -> void:
  show()
