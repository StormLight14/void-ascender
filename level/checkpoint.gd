extends Area2D

@onready var sprite_2d = $Sprite2D

signal captured(checkpoint)

func capture():
	sprite_2d.texture = preload("res://assets/level/flag_captured.png")

func reset():
	sprite_2d.texture = preload("res://assets/level/flag.png")

func _on_body_entered(body):
	captured.emit(self)
