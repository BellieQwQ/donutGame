extends Enemy

var player: Player
@export var larva: PackedScene
@export var rocks: PackedScene

@onready var playerDetector = $PlayerDetector
@onready var sceneSpawner = $SceneSpawner
@onready var wakeTimer = $WakeUpTimer
@onready var spawnLarva = $SpawnLarvaTimer

func _ready():
	playerDetector.body_entered.connect(on_player_entered)

func on_player_entered(body):
	if body.is_in_group("player"):
		player = body as Player
		wakeTimer.start()
		spawnLarva.start()

func _on_wake_up_timer_timeout():
	for i in range(4):
		var newRocks = rocks.instantiate()
		
		var velocity = Vector2.ZERO
		match i:
			0:
				velocity = Vector2(-800, -1600)  
			1:
				velocity = Vector2(-300, -2200)   
			2:
				velocity = Vector2(300, -2200)    
			3:
				velocity = Vector2(800, -1600)   

		
		newRocks.initialVelocity = velocity
		get_parent().add_child(newRocks)
		newRocks.global_position = sceneSpawner.global_position


func _on_spawn_larva_timer_timeout():
	var newLarva = larva.instantiate()
	get_parent().add_child(newLarva)
	newLarva.global_position = sceneSpawner.global_position
	
	queue_free()
