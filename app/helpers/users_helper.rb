module UsersHelper
  def load_start_year
    Date.today.year - Settings.year.start
  end

  def load_end_year
    Date.today.year - Settings.year.end
  end

  def sub_email_user
    length = @current_user.email.length
    sub_email = @current_user.email.first(Settings.sub_email.num_first)
    sub_email << "*" * (length - Settings.sub_email.num_sub) << "@gmail.com"
  end

  def sub_phone_user
    sub_phone = @current_user.phone.first(Settings.sub_phone.num_first)
    sub_phone << "*" * Settings.sub_phone.num_sub
  end

  def check_img_comment url
    url.present? ? url : "user-default.jpg"
  end
end
