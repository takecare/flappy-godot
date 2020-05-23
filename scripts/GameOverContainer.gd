extends VBoxContainer

func _ready() -> void:
  pass

func _on_bird_flying() -> void:
  print("bird flying")

func _on_bird_jumping() -> void:
  print("bird jumping")
  pass

func _on_bird_hit() -> void:
  print("bird hit")
  show()

func _on_bird_grounded() -> void:
  print("bird grounded")
  show()
