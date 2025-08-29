extends CharacterBody2D

var isFacingRight = true
var isSprinting = false
var canJump = true
var isJumping = false
var isCrouching = false
var isSkidding = false
var isSliding = false
var canSlide = true

var direction = 0
var slideDirection = 0
var jumpHeight = 700
var timeToJumpPeak = 0.6
var timeToDescent = 0.5

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

const SPEED = 600
const SPRINT_SPEED = 1400
const ACCELERATION = 1600
const DECELERATION = 3000
const SKID_THRESHOLD = 700
const SLIDE_SPEED = 3000
const SLIDE_DECELERATION = 2500

@onready var animatedSprite = $AnimatedSprite2D
@onready var standingCollision = $StandingHitbox
@onready var crouchingCollision = $CrouchingHitbox
@onready var slidingCollision = $SlidingHitbox
@onready var slideDuration = $SlideDuration
@onready var slideCooldown = $SlideCooldown

func _physics_process(delta):
	setCollision()
	getDirection()
	sprint()
	applyAcceleration(direction)
	performSlide()
	performJump()
	performCrouch()
	applyGravity(delta)
	flip()
	animationPLayer()
	move_and_slide()
	
func getDirection():
	if isSliding:
		return
	
	if Input.is_action_pressed("ui_right"):
		direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction = -1
	else:
		direction = 0
	
func flip():
	if direction != 0 and ((isFacingRight and direction < 0) or (!isFacingRight and direction > 0)):
		scale.x *= -1
		isFacingRight = !isFacingRight
	
func sprint():
	isSprinting = Input.is_action_pressed("Sprint")
	
func applyAcceleration(playerDirection):
	var targetSpeed = (SPRINT_SPEED if isSprinting else SPEED) * direction
	var delta = get_physics_process_delta_time()
	
	if sign(direction) != sign(velocity.x) and direction != 0 and abs(velocity.x) > SKID_THRESHOLD:
		isSkidding = true
	else:
		isSkidding = false
	
	if isCrouching and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		return
		
	if playerDirection == 0:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, targetSpeed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, targetSpeed, ACCELERATION * delta)
	
func applyGravity(delta):
	if velocity.y < 0:
		velocity.y += jumpGravity * delta
	else:
		velocity.y += fallGravity * delta
	
func performCrouch():
	if is_on_floor() and Input.is_action_pressed("ui_down") and !isSliding:
		isCrouching = true
	else:
		isCrouching = false
	
func performJump():
	if is_on_floor() and !isSliding:
		canJump = true
	else:
		canJump = false
		isJumping = false
	
	if Input.is_action_just_pressed("ui_up") and canJump:
		velocity.y = jumpVelocity
		isJumping = true
	
	if velocity.y < 0 and !Input.is_action_pressed("ui_up"):
		velocity.y *= 0.8
	
func performSlide():
	var delta = get_physics_process_delta_time()
	
	if is_on_floor() and isSprinting and abs(velocity.x) > 800 and Input.is_action_just_pressed("Slide") and canSlide:
		slideDirection = sign(velocity.x)
		velocity.x = slideDirection * SLIDE_SPEED
		isSliding = true
		slideDuration.start()
	
	if isSliding:
		velocity.x = move_toward(velocity.x, 0, SLIDE_DECELERATION * delta)
		canJump = false
		canSlide = false
	
func setCollision():
	standingCollision.disabled =true
	crouchingCollision.disabled = true
	slidingCollision.disabled = true
	
	if isCrouching:
		crouchingCollision.disabled = false
	elif isSliding:
		slidingCollision.disabled = false
	else:
		standingCollision.disabled = false
	
func animationPLayer():
	if isCrouching:
		if animatedSprite.animation != "Crouch":
			animatedSprite.play("Crouch")
		elif !animatedSprite.is_playing():
			animatedSprite.frame = animatedSprite.sprite_frames.get_frame_count("Crouch") - 1
		return
	
	if !is_on_floor():
		if velocity.y < 0:
			animatedSprite.play("Jump")
		else:
			animatedSprite.play("Fall")
	else:
		if isSkidding:
			animatedSprite.play("Skidding")
		elif isSliding:
			animatedSprite.play("Slide")
		elif direction == 0 and abs(velocity.x) > 0:
			animatedSprite.play("Idle")
		elif abs(velocity.x) >= 200 and isSprinting:
			animatedSprite.play("Run")
		elif abs(velocity.x) >= 200 and !isSprinting:
			animatedSprite.play("Walk")
		elif velocity.x == 0 and !isCrouching:
			animatedSprite.play("Idle")
	
func _on_slide_duration_timeout():
	isSliding = false
	canJump = true
	slideCooldown.start()
	
func _on_slide_cooldown_timeout():
	canSlide = true
