class_name Enemy
extends Node

@export var health: int
@export var damageProp: PackedScene
@onready var spawner = $DamageSpawner
