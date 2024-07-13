extends CookingTable
class_name GrillTable

func _match_food_data(keys: Array) -> FoodData:
	keys.sort()
	match keys:
		#Khai Pam
		[3, 3, 5, 6]:
			return GameManager.all_food_menus["KHAI_PAM"]
		#Ong Pu Na
		[3, 4, 4, 5]:
			return GameManager.all_food_menus["ONG_PU_NA"]
		#Aeb Pla Nil
		[0, 5, 6, 9]:
			return GameManager.all_food_menus["AEB_PLA_NIL"]
		_:
			return GameManager.all_food_menus["UNKNOWN_FOOD"]
