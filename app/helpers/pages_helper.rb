module PagesHelper

  def title
    @title ? "Twitter | #{@title}" : 'Twitter'
  end
end
