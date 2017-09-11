@name = "Prison Corridor".red
@desc = [
	"I'm in some sort of prisoner hallway,",
	"there are prisoner cells in the walls.",
	"They're all empty and dusty, except for one #{find_area(:other_cell_abduct).name}, which has a sleeping #{find_person(:prisoner_abduct).name} in it."
].join("\n")
@desc_passive = "Looks like a hallway filled with cells,\nI can't see very much from here though."
@text = {
	open_locked_door:          "I can't go there yet, incase you haven't noticed, there's a door blocking my way..\nMaybe if I had some sort of #{find_item(:keychain_abduct).name} I could unlock it.",
	open_unlocked_closed_door: "Well, I've unlocked the door, but traversing it comes with another problem if it's still #{"closed".red}."
}
