module ApplicationHelper

	# Returns the full title on a per-page basic.
	def full_title(page_title = '')
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end

	def yeller(a=['o', 'l', 'd'])
		a = a.map { |n| n.upcase }
		print a.join("")
		
	end

	def random_subdomain
		puts ("a".."z").to_a.shuffle[0..7].join('')
	end

	def string_shuffle(s)
		s.split('').shuffle.join
	end




  
end
