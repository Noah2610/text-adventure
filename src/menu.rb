
# MAIN MENU

$savedir = "./saves/"
$current_savefile = false

class MainMenu

	def initialize
		@spacing = 24
		@menu_title = File.read("./art/title.txt")
		Dir.mkdir($savedir)  unless (Dir.exists?($savedir))
		@saves_exist = (Dir.entries($savedir).size > 2)
		Gem.win_platform? ? (system "cls") : (system "clear")
		welcome_msg = "WELCOME TO ...".bold.italic.red

=begin
		if (@saves_exist)
			print "\n"
			print " " * @spacing
			print_letters(welcome_msg,0.05)
			print "\n\n"
			print_letters(@menu_title,0.0005)
		else
			print "\n"
			print " " * @spacing
			print_letters(welcome_msg,0.2)
			sleep 1
			print "\n\n"
			print_letters(@menu_title,0.0025)
			sleep 1
		end
=end

		print "\n\n\n" + " " * @spacing + "Choose an option...".bold.blue

		@last_save = false
		@saves = []
	end


	def menu_load_save
		menu_load_input = true
		spacing = @spacing + 8
		while (menu_load_input) do
			ret = [" " * spacing + "Choose your savefile...".bold.blue, "#{"[0]".red} go back to main menu"]
			@saves.each_with_index do |file,i|
				ret.push("[#{i + 1}] ".red + file)
			end
			puts ret.join("\n" + " " * spacing)
			print " " * spacing + "> "
			input = gets.strip
			if (@saves.include? input)
				$current_savefile = input
				return true
			elsif (input.to_i - 1 >= 0 && !@saves[input.to_i - 1].nil?)
				$current_savefile = @saves[input.to_i - 1]
				return true
			elsif (input == "0")
				return false
			end
		end
	end


	def menu_choose
		menu_input = true

		while (menu_input) do
			opts = {}
			ret = [" " * @spacing]
			if (@saves_exist)
				last_save_time = 0
				@saves = Dir.entries($savedir)
				@saves.delete(".")
				@saves.delete("..")
				@saves.each do |file|
					time = File.mtime("#$savedir#{file}").to_i
					if (time > last_save_time)
						last_save_time = time
						@last_save = file
					end
				end
				opts = {
					"1" => :continue,
					"2" => :new,
					"3" => :load,
					"4" => :exit
				}
				ret.push("[1] Continue Game".red + " (#@last_save)")
				ret.push "[2] New Game".red
				ret.push "[3] Load Game".red
				ret.push "[4] Exit Game".red
			else
				opts = {
					"1" => :new,
					"2" => :exit
				}
				ret.push "[1] New Game".red
				ret.push "[2] Exit Game".red
			end

			puts ret.join("\n" + " " * @spacing)
			print " " * @spacing
			print "> "
			input = gets.strip
			case (opts[input])
				when :new
					menu_input = false
				when :continue
					$current_savefile = @last_save
					menu_input = false
				when :load
					menu_input = !menu_load_save
				when :exit
					exit
			end
		end
	end


	def print_letters (string,delay=0.1)
		skip = false
		string.split("").each do |let|
			if (let == "\e")
				skip = true
			elsif (skip && let == "m")
				skip = false
				print let
				next
			end
			if (skip)
				print let
				next
			end
			print let
			sleep delay
		end
	end

end

main_menu = MainMenu.new
main_menu.menu_choose

