class_name Player
extends CharacterBody2D

var isFacingRight = true
var isSprinting = false
var isJumping = false

var coyoteTime = 0.12
var coyoteTimer = 0

var jumpBufferTime = 0.2
var jumpBufferTimer = 0

var direction = 0
var slideDirection = 0
var jumpHeight = 800 # previously 700
var timeToJumpPeak = 0.55
var timeToDescent = 0.45

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

const SPEED = 800
const SPRINT_SPEED = 1800
const ACCELERATION = 2000
const DECELERATION = 4000
const SKID_THRESHOLD = 1000
const SLIDE_SPEED = 3000
const SLIDE_DECELERATION = 3000
const SKID_DECELERATION = 4500

@onready var animator = $AnimatedSprite2D
@onready var standingCollision = $StandingHitbox
@onready var crouchingCollision = $CrouchingHitbox
@onready var jumpingCollision = $JumpingHitbox
@onready var slidingCollision = $SlidingHitbox
@onready var slideDuration = $SlideDuration
@onready var slideCooldown = $SlideCooldown
@onready var slideDetector = $slideDetector

func applyCornerCorrection():
	var amount = 30
	var delta = get_physics_process_delta_time()
	
	if velocity.y < 0 and test_move(global_transform, Vector2(0, velocity.y * delta)):
		for i in range(1, amount + 1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(i * j, 0)), Vector2(0, velocity.y * delta)):
					translate(Vector2(i * j, 0))
					return
