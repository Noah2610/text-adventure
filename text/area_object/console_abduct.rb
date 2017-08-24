@name = "Command Console".blue
@desc = [
	"Looks like a #@name used to control the ship's system.",
	"Maybe I can find a way to tell it to head back to earth and let me escape this #{find_area(:spaceship_abduct).name}.",
	"I could try to #{"use".red} it but probably wouldn't understand anything because everything's in this gibberish alien language."
].join("\n")
@text = {
	turned_off:     "It doesn't seem to be running though.",
	turned_on:      "It's running, some indicator lights are on now and the screen has a bunch of gibberish alien symbols on it.",
	after_turn_on:  "After turning on the #@name lights start flashing up alien symbols on screen bla bla...",
	after_turn_off: "I turned #@name off.",
	use_turned_off: "I can't really use a turned off machine.",
	use:            "I can't read any of this."
}
