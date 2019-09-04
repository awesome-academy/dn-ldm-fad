module ScopesModule
  extend ActiveSupport::Concern

  included do
    scope :sort_by_created_at, ->{order created_at: :desc}
  end
end
