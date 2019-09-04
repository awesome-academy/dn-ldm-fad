module ScopesModule
  extend ActiveSupport::Concern

  included do
    scope :sort_by_created_at, ->{order created_at: :desc}
    scope :sort_by_name, ->{order :name}
  end
end
