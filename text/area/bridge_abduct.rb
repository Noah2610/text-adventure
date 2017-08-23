@name = "Bridge".blue
@desc_passive = "Looks like the main control room of the #{find_area(:spaceship_abduct).name}."
@desc = [
	"It's a large room with many computers and panels.",
	"There's one computer that seems unlocked and sticks out from the rest of them.",
	"It looks like it's a #{find_areaObject(:console_abduct).name}."
].join("\n")
