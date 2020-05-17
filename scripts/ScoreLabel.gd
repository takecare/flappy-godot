extends Label

func _ready() -> void:
  var _result = Game.connect("score_changed", self, "_on_score_changed")
  _result = Game.connect("best_score_changed", self, "_on_best_score_changed")

func _on_score_changed(score: int) -> void:
  set_text(str(score))
  pass

func _on_best_score_changed(score: int) -> void:
  pass