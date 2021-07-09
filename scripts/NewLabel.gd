extends TextureRect

func _ready():
  hide()
  var _result = Game.connect("best_score_changed", self, "_show")

func _show(_bestScore, _medal):
  show()
  $"NewLabelAnimationPlayer".play("FlashNew")
