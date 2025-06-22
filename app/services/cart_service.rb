class CartService
  def initialize(session, current_customer = nil)
    @session = session
    @current_customer = current_customer
  end

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def merge_anonymous_cart_on_login(customer)
    return unless @current_cart&.anonymous?

    authenticated_cart = Cart.find_or_create_for_customer(customer)
    authenticated_cart.merge_with(@current_cart)

    @current_cart = authenticated_cart
    clear_session_cart_id
  end

  private

  def find_or_create_cart
    if @current_customer
      # User is logged in
      Cart.find_or_create_for_customer(@current_customer)
    else
      # Anonymous user
      session_cart_id = @session[:cart_id]
      if session_cart_id
        Cart.find_by(id: session_cart_id, customer_id: nil) || create_session_cart
      else
        create_session_cart
      end
    end
  end

  def create_session_cart
    cart = Cart.create!(session_id: generate_session_id)
    @session[:cart_id] = cart.id
    cart
  end

  def generate_session_id
    SecureRandom.hex(16)
  end

  def clear_session_cart_id
    @session.delete(:cart_id)
  end
end
