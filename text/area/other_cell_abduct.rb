@name = "Other Cell".blue
@desc = "It looks way tidier than any of the other cells.\nThe bed also seems to be of a much higher quality."
#                                                 find_areaObject(:other_cell_bed)
@desc_passive = "It looks cleaner than any other cell."
@text = {
	open_locked_door:          "The #{find_areaObject(:other_cell_door_abduct).name} is locked.",
	open_unlocked_closed_door: "The door is closed, I still have to #{"open".red} it before traversing this blockage."
}
