extends Node3D
class_name RotateAround
## This script implements simple orbital rotation
##
## Attach to a [Node3D] node to allow it to orbit around a follow [member target] node 
## 
## @Author: Xander Grabowski

## This is the [Node3D] that attached Node will rotate around
@export var target: Node3D

## The speed at which this object will rotate
@export var speed : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Error Checking: if we have no target assigned we'll rotate around ourself
	if not is_instance_valid(target):
		target = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This is the axis we want to rotate around
	var axis = Vector3.UP
	# This is the angle in radians of our rotation
	var angle = delta * speed
	
	# Rotate its basis
	var rotated_basis = self.transform.basis.rotated(axis, angle)
	# Rotate its origin
	var rotated_origin = target.position + (self.transform.origin - target.position).rotated(axis, angle)

	# Set the result back
	transform = Transform3D(rotated_basis, rotated_origin)
