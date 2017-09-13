@name = "Prisoner".green
@desc = "I'm a human, just like you! I've been here for a #{"long".bold} time."
@desc_passive = "He looks as if he's been here for a long time already.\nAnd he stinks."

@text = {
	try_to_wake_up:  "I #{"could".italic} wake him up, but who knows how he's going to react.\nAside from that, his #{find_area(:other_cell_abduct).name} might have some goodies.",
	wake_up_accept:  "Fine, wake him up, whatever.\nI wake him up.",
	talk_sleeping:   "He's sleeping, I'll have to #{"wake".red} him up first.",
	talk_start:      "Why hello there fellow human, how did you get here?"
}

@text_talk[:cornfield]    = "Ah, yes the #{"cornfield-graffiti-that-attracts-aliens-scenario".bold},\nAbout 30 years ago the exact same thing happened with me. I've been here ever since."
@text_talk[:how_long]     = "I've been here quite some time, probably close to 30 years now."
@text_talk[:escape_no]    = "I don't know, I've been here so long, I don't think I could return to my normal life on earth.\nAt least here I'm #{"special".red}."
@text_talk[:escape_yes]   = "Well, maybe you're right, maybe we should find a way to get out of here.\nMaybe I'll become president or something on earth, when everybody gets wind of my amazing space abduction story."
@text_talk[:unlock_cell]  = "But you gotta find a way to get me out of this cell first.\nMaybe you have something that could unlock this #{find_areaObject(:other_cell_door_abduct).name}?"
@text_talk[:special]      = "Well, I was even more special before you arrived. I mean, think about it, have you ever heard of somebody being kidnapped by #{"aliens".green}?\nI must be #{"famous".red} on earth."
@text_talk[:famous]       = "Yeah, people must be admiring me for having the courage of being kidnapped!"
@text_talk[:not_famous]   = "Oh, well that's sad...\nMaybe I'll become famous in space for being the best prisoner anyone's ever had!"
@text_talk[:how_get_here] = "That's a funny story, not so funny when you consider the outcome but hey.\nI drew some #{"alien symbol".red} into a cornfield, that's when they arrived and abducted me."
@text_talk[:symbol]       = "Yeah that #{"symbol".red} started everything.\nIf I hadn't forgotten what it looks like it might be useful to get some more information about this whole abduction thing."

@text_take = {
	keychain_abduct: "A great, this is perfect!\nHow did you get this #{find_item(:keychain_abduct).name}?"
}
