class_name Player
extends CharacterBody2D

var enemy : Enemy
var lives = 3

var isFacingRight = true
var isSprinting = false
var isJumping = false
var blockedAbove = false
var canJump = true
var invincible = false

var coyoteTime = 0.12
var coyoteTimer = 0

var jumpCount = 0
var maxJumps = 1

var jumpBufferTime = 0.2
var jumpBufferTimer = 0

var knockbackHeight = -2800
var knockbackForce = 1000
var knockbackDirection = 0

var direction = 0
var slideDirection = 0
var jumpHeight = 800 #- 300 
var timeToJumpPeak = 0.48 #- 0.10
var timeToDescent = 0.42 #- 0.09

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

signal playerHurt

var punchDamage = 25

const SPEED = 900
const SPRINT_SPEED = 2000
const ACCELERATION = 3000
const DECELERATION = 12000
const SKID_THRESHOLD = 1000
const SLIDE_SPEED = 4500
const SLIDE_DECELERATION = 7000
const SKID_DECELERATION = 4500

@onready var stateMachine = $StateMachine
@onready var animator = $AnimatedSprite2D
@onready var standingCollision = $StandingHitbox
@onready var crouchingCollision = $CrouchingHitbox
@onready var jumpingCollision = $JumpingHitbox
@onready var slidingCollision = $SlidingHitbox
@onready var slideDuration = $Timers/SlideDuration
@onready var slideCooldown = $Timers/SlideCooldown
@onready var slideDetector = $slideDetector
@onready var FXmanager = $FXManager
@onready var invincibleTime = $Timers/InvincibleTime
@onready var knockTime = $Timers/KnockTime
@onready var punchTimer = $Timers/PunchTimer
@onready var punchMarker = $SceneSpawners/Punch
@onready var slideMarker = $SceneSpawners/Slide

@export var punchScene: PackedScene 

enum DamageType { NORMAL, ELECTRIC }
var lastDamageReceived: DamageType = DamageType.NORMAL

func _ready():
	playerHurt.connect(_on_player_hurt)
	#CharmManager.equipCharm(CharmManager.CharmName.NONE) # Charm here
	#CharmManager.applyPlayerMods(self)
	CharmManager.register_player(self)

func _physics_process(_delta):
	blockedAbove = slideDetector.is_colliding()
	
func applyCornerCorrection():
	var amount = 30
	var delta = get_physics_process_delta_time()
	
	if velocity.y < 0 and test_move(global_transform, Vector2(0, velocity.y * delta)):
		for i in range(1, amount + 1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(i * j, 0)), Vector2(0, velocity.y * delta)):
					translate(Vector2(i * j, 0))
					return

func _on_player_hurt():
	stateMachine.changeState("Hurt")
	lives -= 1
	print(str(lives))
	
