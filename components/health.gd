class_name Health extends Node2D


# Signals
signal health_changed(new_health: int, old_health: int)
signal died()
signal invulnerable_changed(is_invulnerable: bool)

## Maximum health that the entity can have.
@export_range(1, 999999, 1) var MAX_HEALTH := 100
## Health value will be set to max health on ready.
@export var health := 100
## Invlunerability time after taking a hit in seconds.
@export_range(0, 5.0, 0.01) var invulnerability_time := 1.0
var invulnerable := false
@onready var invulnerability_timer : Timer = Timer.new()


func _ready():
	health = MAX_HEALTH
	invulnerability_timer.autostart = false
	invulnerability_timer.one_shot = true
	invulnerability_timer.set_wait_time(invulnerability_time)
	invulnerability_timer.timeout.connect(_on_invulnerability_timer_timeout)


func take_damage(damage: int) -> void:
	if invulnerable:
		damage = 0
	invulnerable = true
	invulnerability_timer.start()
	invulnerable_changed.emit(invulnerable)
	
	var old_health := health
	health = max(0, health - damage)
	if health == 0:
		died.emit()
	health_changed.emit(health, old_health)
	

func heal(amount: int) -> void:
	var old_health := health
	health = min(MAX_HEALTH, health + amount)
	health_changed.emit(health, old_health)


func _on_invulnerability_timer_timeout():
	invulnerable = false
	invulnerable_changed.emit(invulnerable)
