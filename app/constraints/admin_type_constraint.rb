class AdminTypeConstraint
  def initialize(super_admin:)
    @super_admin = super_admin
  end

  def matches?(request)
    session_id = request.cookie_jar.signed[:session_id]
    return false unless session_id
    session = Session.find_by(id: session_id)
    return false unless session&.user
    @super_admin ? session.user.super_admin? : !session.user.super_admin?
  end
end
