extends CharacterBody2D

@export var follower_node : Node2D

func _physics_process(_delta):
	follower_node.position = position
