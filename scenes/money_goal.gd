extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var goal = GameManager.GOAL_PROFIT
	text = "%s %d %s" % [tr("MONEY_GOAL"), goal, tr("BAHT")]
