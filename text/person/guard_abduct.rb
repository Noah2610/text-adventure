@name = "Guard".red
@desc_passive = "The guard is watching me.\nHe has a #{find_item(:keychain_abduct).name} on his belt.\nOne of those keys probably unlocks this cell."
@desc = "I AM A GUARD"
@text = {
	desc_sleeping:             "The guard has fallen asleep.\nMaybe there's a way for me to grab that #{find_item(:keychain_abduct).name} off his person somehow?",
	desc_sleeping_nokeychain:  "The guard has fallen asleep.\nI grabbed his #{find_item(:keychain_abduct).name}.",
	talk:                      "I gesture the guard that I want to talk,\nbut it just keeps staring at me.",
	talk_sleeping:             "Do I really want to wake him up?",
	use_stick_awake:           "What? Do I poke him until he drops his keys and kicks them over to me?\nOr until he gives in to my unlimited stick poking power?",
	use_stick_asleep:          "I slowly and carefully move the stick towards the guard and get the #{find_item(:keychain_abduct).name}.",
	use_stick_again:           "I already grabbed his #{find_item(:keychain_abduct).name},\ndo I want to poke him awake now?"
}
