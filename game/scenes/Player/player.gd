class_name Player
extends CharacterBody2D

var enemy : Enemy
var lives = 3

var isFacingRight = true
var isSprinting = false
var isJumping = false
var invincible = false

var coyoteTime = 0.12
var coyoteTimer = 0

var jumpBufferTime = 0.2
var jumpBufferTimer = 0

var knockbackHeight = -2000
var knockbackForce = 1000
var knockbackDirection = 0

var direction = 0
var slideDirection = 0
var jumpHeight = 800 # previously 700
var timeToJumpPeak = 0.55
var timeToDescent = 0.45

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

signal playerHurt

const SPEED = 900
const SPRINT_SPEED = 2000
const ACCELERATION = 3000
const DECELERATION = 12000
const SKID_THRESHOLD = 1000
const SLIDE_SPEED = 3000
const SLIDE_DECELERATION = 3000
const SKID_DECELERATION = 4500

@onready var stateMachine = $StateMachine
@onready var animator = $AnimatedSprite2D
@onready var standingCollision = $StandingHitbox
@onready var crouchingCollision = $CrouchingHitbox
@onready var jumpingCollision = $JumpingHitbox
@onready var slidingCollision = $SlidingHitbox
@onready var slideDuration = $SlideDuration
@onready var slideCooldown = $SlideCooldown
@onready var slideDetector = $slideDetector
@onready var FXmanager = $FXManager
@onready var invincibleTime = $InvincibleTime
@onready var knockTime = $KnockTime

func _ready():
	playerHurt.connect(_on_player_hurt)

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
