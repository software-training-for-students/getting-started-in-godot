extends Camera3D
class_name FocusCameraOnTarget
## This script implements camera focus functionality on player mouse clicks
##
## Attach to a [Camera3D] node to allow it to focus on a target [StaticBody3D] when the player clicks on it
## 
## @Author: Xander Grabowski

## the default [Node3D] that the camera will look at by default
@export 
var default_target: Node3D 

## the object that the [Camera3D] is currently looking at
## this is altered based on the last Node with a [StaticBody3D] the player clicked
@export
var current_target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_instance_valid(default_target):
		push_error("ERROR [focus_on_target.gd]: No default target was set for camera")
		return
	
	self.look_at(default_target.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(current_target):
		self.look_at(current_target.global_position)
	else:
		current_target = default_target

# Called when there is an input event.
func _input(event):
	# we will only handle input when there is an input from pressing a mouse button 
	if not event is InputEventMouseButton or not event.pressed:
		return
	
	# Here we wanna find out what button was pressed on the mouse
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			var mouse_pos = get_viewport().get_mouse_position()
			#print("[DEBUG] mouse clicked at ", mouse_pos)
			
			var ray_length = 1000
			var from = project_ray_origin(mouse_pos)
			var to = from + project_ray_normal(mouse_pos) * ray_length
			var space_state = get_world_3d().direct_space_state

			var query = PhysicsRayQueryParameters3D.create(from, to)
			
			var raycast_hit = space_state.intersect_ray(query)

			if not raycast_hit.is_empty():
				# print("[DEBUG] we clicked something ", raycast_hit)
				current_target = raycast_hit.collider
				print("[Debug] current_target changed to " + current_target.name)
		MOUSE_BUTTON_RIGHT:
			current_target = default_target
			print("[Debug] default camera target changed to " + current_target.name)
