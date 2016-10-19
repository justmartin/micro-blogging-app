class User <ActiveRecord::Base
	has_many :posts

	def full_name
		first_name + " " + last_name
	end
end

class Post <ActiveRecord::Base
	belongs_to :user

	def custom_created_at
		created_at.strftime("%D")
	end
end