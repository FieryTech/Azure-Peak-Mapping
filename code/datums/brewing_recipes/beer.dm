/datum/brewing_recipe/beer
	name = "Wheat Beer"
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer
	needed_reagents = list(/datum/reagent/water = 99)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 4)
	brewed_amount = 4
	brew_time = 2 MINUTES
	sell_value = 15

/datum/brewing_recipe/beer/oat
	name = "Oat Ale"
	reagent_to_brew = /datum/reagent/consumable/ethanol/ale
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/oat = 4)
