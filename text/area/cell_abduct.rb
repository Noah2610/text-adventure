@name = "Cell".blue
@desc = [
	"A tiny little prison cell.",
	"There's a #{find_person(:guard_abduct).name} in front, he's staring at you.",
	"The #{find_areaObject(:cell_wall_abduct).name} behind you looks very fragile."
].join("\n")
@desc_passive = "The #@name I was in looks terrible."
