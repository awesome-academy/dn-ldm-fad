module Admin::ProductsHelper
  def checked_status_radio boolean
    boolean ? {checked: true} : {}
  end
end
