module Admin::CategoriesHelper
  def check_description description
    description.present? ? description : t("admin.categories.des_empty")
  end
end
