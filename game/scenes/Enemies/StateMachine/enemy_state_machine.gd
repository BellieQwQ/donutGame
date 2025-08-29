class_name EnemyStateMachine
extends Node

@export var initialState: EnemyState
var currentState: EnemyState
var states: Dictionary = {}

func _ready() -> void:
	var enemy = get_parent()
	
	# Register all states once machine is booted
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.stateMachine = self
			child.enemy = enemy
	
	# Start with initial state // Prevents starting without initial state
	if initialState:
		# changeState(initialState.name.to_lower())
		call_deferred("changeState", initialState.name.to_lower())
	
func _process(delta: float) -> void:
	if currentState:
		currentState.onProcess(delta)
	
func _physics_process(delta: float) -> void:
	if currentState:
		currentState.onPhysicsProcess(delta)
	
func _input(event: InputEvent) -> void:
	if currentState:
		currentState.handleInput(event)
	
func changeState(newState: String):
	if currentState:
		currentState.exitState()
	
	currentState = states.get(newState.to_lower())
	
	if currentState:
		currentState.enterState()
