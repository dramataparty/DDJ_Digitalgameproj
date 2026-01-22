extends Node
## ============================================================
## VISUAL FEEDBACK HANDLING (pop & fade emojis)
## ============================================================

enum Mode { 
	NORMAL, 
	HAND, 
	HAMMER_PLIERS, 
	SCISSORS
}

signal mode_changed(new_mode)

# ============================================================
# Mode variable with setter/getter
# ============================================================
var _mode = Mode.NORMAL

func set_mode(m):
	if _mode == m:
		return
	_mode = m
	mode_changed.emit(m)
	_show_mode_feedback()

func get_mode():
	return _mode

# ============================================================
# Node references
# ============================================================
@onready var feedback_label = get_node("FeedbackLabel")
@onready var tween = get_node("Tween")

# ============================================================
# Emoji dictionaries
# ============================================================
var mode_emojis = {
	Mode.NORMAL: "🖱️",
	Mode.HAND: "✋",
	Mode.HAMMER_PLIERS: "🔨🔧",
	Mode.SCISSORS: "✂️📎"
}

var action_emojis = {
	"select": "✅",
	"cut": "✂️",
	"hammer": "🔨",
	"grab": "🤲"
}

# ============================================================
# Show current mode
# ============================================================
func _show_mode_feedback():
	if not feedback_label:
		return
	var emoji = mode_emojis.get(_mode, "❓")
	_play_feedback_animation("Mode: %s" % emoji)

# ============================================================
# Show action feedback
# ============================================================
func show_action_feedback(action):
	if not feedback_label:
		return
	var emoji = action_emojis.get(action, "❓")
	_play_feedback_animation("Action: %s" % emoji)
	await get_tree().create_timer(1.0).timeout
	_show_mode_feedback()

# ============================================================
# Internal pop & fade animation
# ============================================================
func _play_feedback_animation(text):
	if not feedback_label or not tween:
		return
	
	feedback_label.text = text
	feedback_label.modulate = Color(1,1,1,1)
	feedback_label.rect_scale = Vector2(1,1)
	
	# Stop existing tweens
	tween.kill(feedback_label, "modulate")
	tween.kill(feedback_label, "rect_scale")
	
	# Pop effect
	tween.tween_property(feedback_label, "rect_scale", Vector2(1.5,1.5), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.tween_property(feedback_label, "rect_scale", Vector2(1,1), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT, 0.15)
	
	# Fade slightly
	tween.tween_property(feedback_label, "modulate:a", 0.7, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)
	tween.start()
