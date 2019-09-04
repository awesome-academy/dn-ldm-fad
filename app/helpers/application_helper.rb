module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "layout.name_app"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def checked_image object, name
    object.picture? ? object.picture.url : "#{name.to_s}-default.jpg"
  end
end
