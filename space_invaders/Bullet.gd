extends Area2D

# Declare member variables here. Examples:
export var speed = 100  # How fast the bullet will move (pixels/sec).
var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
 
    if (position.y < 0) or (position.y > screen_size.y):
        queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    position.y = position.y - speed * delta
    
func _on_Bullet_body_entered(body):
    if 'Mob' in body.name:
        queue_free()