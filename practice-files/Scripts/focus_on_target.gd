extends Camera3D

# the default object that the camera will look at
@export var default_target: Node3D 

# the object that the camera is currently looking at
# this is altered based on the last Node the player clicked
@export var current_target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_instance_valid(default_target):
		default_target = self
	if not is_instance_valid(default_target):
		default_target = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(current_target):
		self.look_at(current_target.position)
	else:
		current_target = default_target

# Called when there is an input event.
func _input(event):
	# we will only handle input when there is an input from pressing a mouse button 
	if not event is InputEventMouseButton or not event.pressed:
		return
	
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			var space_state = get_world_3d().direct_space_state
			var mouse_pos = get_viewport().get_mouse_position()
			#print("[DEBUG] mouse clicked at ", mouse_pos)
			var world_pos = project_position(mouse_pos, position.z)
			
			var ray_length = 1000
			var from = self.project_ray_origin(mouse_pos)
			var to = from + self.project_ray_normal(mouse_pos) * ray_length
			
			var hit_dict = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
			if not hit_dict.is_empty():
				print("[DEBUG] we clicked something ", mouse_pos)
				current_target = hit_dict
				print("[Debug] default camera target changed to " + hit_dict.name)
		MOUSE_BUTTON_RIGHT:
			current_target = default_target
			print("[Debug] default camera target changed to " + current_target.name)
