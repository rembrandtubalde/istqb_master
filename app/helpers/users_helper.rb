module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: "please upload your avatar to gravatar.com", class: "gravatar")
  end
  
  	def passed_tests(user, pass)
	  if pass
		  passed = 0
		  user.attempts.each do |att|
			passed += 1 if att.answer == att.correct_answer
		  end
		  passed_tests = passed
	  else
		  failed = 0
		  user.attempts.each do |att|
			failed += 1 if !(att.answer == att.correct_answer)
		  end
		  passed_tests = failed
	  end
	end
end
