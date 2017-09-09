@name = "Cell".blue
@desc = [
	"A tiny little prison cell.",
	"There's a #{find_person(:guard_abduct).name} in front, he has a #{find_item(:keychain_abduct).name} on him.",
	"The #{find_areaObject(:cell_wall_abduct).name} behind you looks very fragile."
].join("\n")
