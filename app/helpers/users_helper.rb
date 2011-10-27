module UsersHelper
  
  def gravatar_for(user, options = { :size => 95 })
    gravatar_image_tag(user.email.downcase, :alt => user.username,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
