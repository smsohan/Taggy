# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def formatted content
    simple_format(auto_link(content))
  end
end
