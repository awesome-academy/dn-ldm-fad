module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "layout.name_app"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def display_error object, field, custom_field_name = nil
    return unless object.errors[field].present?
    name = custom_field_name ? custom_field_name : field.to_s.titlecase
    raw "<span class=\"error_message\">  #{name}
      #{object.errors[field].first}</span>"
  end

  def check_description description
    description.present? ? description : t("admin.categories.des_empty")
  end

  def checked_image object, name
    object.picture? ? object.picture.url : "#{name.to_s}-default.jpg"
  end
end
