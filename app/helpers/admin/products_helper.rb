module Admin::ProductsHelper
  def select_c collection
    collection.map{|c| [c.name, c.id]}
  end
end
