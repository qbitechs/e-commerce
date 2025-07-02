class Current < ActiveSupport::CurrentAttributes
  attribute :session, :store
  delegate :admin_user, to: :session, allow_nil: true
end
