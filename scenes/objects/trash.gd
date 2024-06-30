extends Interactive

func interact(player: Player):
	var is_holding = player.is_holding_dish()
	if is_holding:
		player.destroy_dish()
	print(player.is_holding_dish())
