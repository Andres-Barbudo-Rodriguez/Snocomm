class Github
	def initialize(apple)
		@company = apple
	end


	def boot
		puts "https://www.github.com" + @company
	end
end

efi = Github.new("/apple")
efi.boot