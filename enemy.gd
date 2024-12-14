class_name Enemy
extends StaticBody3D


@onready var body_mesh: MeshInstance3D = $"Visual/character-male-f2/character-male-f/Skeleton3D/body-mesh"
@onready var head_mesh: MeshInstance3D = $"Visual/character-male-f2/character-male-f/Skeleton3D/head-mesh"

signal player_collided(type:GlobalVars.Type);
var lerping = false
var lerp_speed:float = 1.5
var target_position: Vector3
@export var type:GlobalVars.Type = GlobalVars.current_enemy_type
#var type = GlobalVars.current_enemy_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../EnteringCombatAlert".visible = false
	var material = body_mesh.mesh.surface_get_material(0).duplicate()
	if(type == GlobalVars.Type.GRASS):
		material.albedo_color = Color.GREEN
	elif(type == GlobalVars.Type.FIRE):
		material.albedo_color = Color.RED
	elif(type == GlobalVars.Type.WATER):
		material.albedo_color = Color.BLUE	
		
	body_mesh.set_surface_override_material(0, material)
	head_mesh.set_surface_override_material(0, material)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if lerping:
		
	# Smoothly interpolate AreaA's position to AreaB's position
		var current_position = global_transform.origin
		var new_position = current_position.lerp(target_position, lerp_speed * delta)
		global_transform.origin = new_position
		$"../EnteringCombatAlert".visible = true
		# Stop lerping when close enough to the target
		if current_position.distance_to(target_position) < 0.1:
			$"../Gems_Overlay/EnteringCombatSFX".play()
			
			lerping = false
			GlobalVars.unfreeze(type)
			print_debug("ENTRA EN COMBATE CON ENEMIGO")
			#TODO aca llamar a la escena de pelea
			GlobalVars.current_enemy_type = type
			print("the enemy element is", type)
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://Scenes/combat.tscn")
			
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	emit_signal("player_collided",type)
	lerping = true
	target_position = area.global_transform.origin
	pass # Replace with function body.
