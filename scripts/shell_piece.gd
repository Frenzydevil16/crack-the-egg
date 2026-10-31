extends Polygon2D
class_name ShellPiece

## Individual broken eggshell shard that explodes outwards on 10,000 clicks
## Draws a crisp dark cartoon border around the shard polygon.

var velocity: Vector2 = Vector2.ZERO
var angular_velocity: float = 0.0
var gravity: float = 1250.0
var lifetime: float = 2.4
var time_alive: float = 0.0
var outline_color: Color = Color(0.14, 0.08, 0.05, 1.0)

func _process(delta: float) -> void:
	time_alive += delta
	velocity.y += gravity * delta
	position += velocity * delta
	rotation += angular_velocity * delta
	
	if time_alive > lifetime - 0.7:
		modulate.a = max(0.0, (lifetime - time_alive) / 0.7)
	
	if time_alive >= lifetime:
		queue_free()

func _draw() -> void:
	if polygon.size() >= 3:
		var pts = polygon.duplicate()
		pts.append(polygon[0])
		draw_polyline(pts, outline_color, 5.0, true)
