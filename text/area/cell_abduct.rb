@name = "Cell".blue
@desc = [
	"A tiny little prison cell.",
	"There's a #{find_areaObject(:cell_bed_abduct).name} next to you.",
	"There's a #{find_person(:guard_abduct).name} in front, he's staring at you.",
	"The #{find_areaObject(:cell_wall_abduct).name} behind you looks very fragile.",
	"The #{find_areaObject(:cell_door_abduct).name} is locked."
].join("\n")
@desc_passive = "The #@name I was in looks terrible."
