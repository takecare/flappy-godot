extends AnimatedSprite

onready var xLimits = [self.position.x - 3, self.position.x + 4]
onready var yLimits = [self.position.y - 3, self.position.y + 4]

func _ready():
  hide()
  randomize()
  var _result = Game.connect("best_score_changed", self, "_show")

func _show(_bestScore, _medal):
  show() 
  $"SparkAnimationPlayer".play("Shine")

func move_to_random_pos() -> void:
  var newX = self.position.x + randi() % 2 * _randSign()
  var newY = self.position.y + randi() % 2 * _randSign()
  while newX > xLimits[1] || newX < xLimits[0]:
    newX = self.position.x + randi() % 2 * _randSign()
  while newY > yLimits[1] || newY < yLimits[0]:
    newY = self.position.y + randi() % 2 * _randSign()
  position = Vector2(newX, newY)

func _randSign() -> int:
  return 1 if randi() % 2 == 0 else -1
