module UsersHelper
  def load_start_year
    Date.today.year - 10
  end

  def load_end_year
    Date.today.year - 100
  end
end
