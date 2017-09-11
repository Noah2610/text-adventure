@name = "Other Cell Door".blue
@desc = "The door to the cell with the unknown human prisoner in it."
@text = {
	desc_locked:       "It's locked.",
	desc_unlocked:     "I've unlocked it using the same #{find_item(:keychain_abduct).name} I used to unlock my cell.",
	desc_open:         "The door stands wide open.",
	unlock_door:       "I unlock the #@name using the #{find_item(:keychain_abduct).name}.",
	unlock_door_again: "I've already unlocked the #@name.",
	unlock_door_nokey: "I don't have a fitting key to unlock #@name.",
	open_door:         "I open #@name.",
	open_locked_door:  "I can't open #@name, it's locked."
}
