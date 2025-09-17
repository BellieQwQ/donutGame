extends Area2D

func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area):
	if !area.is_in_group("playerPunch"):
		return
	
	var enemy = get_owner()
	if enemy == null:
		enemy = get_parent()
	
	if enemy and enemy.has_method("onPunched"):
		enemy.onPunched(area)
