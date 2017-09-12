@name = "Prisoner".green
@desc = "SELF DESCRIPTION"
@desc_passive = "He looks as if he's been here for a long time already.\nAnd he stinks."
@text = {
	try_to_wake_up:  "I #{"could".italic} wake him up, but who knows how he's going to react.\nAside from that, his #{find_area(:other_cell_abduct).name} might have some goodies.",
	wake_up_accept:  "Fine, wake him up, whatever.\nI wake him up.",
	talk_sleeping:   "He's sleeping, I'll have to #{"wake".red} him up first.",
	talk_start:      "Why hello there fellow human, how did you get here?"
}
