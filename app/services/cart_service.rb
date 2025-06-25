class CartService
  def initialize(session, current_customer = nil)
    @session = session
    @current_customer = current_customer
  end

  def find_or_create_cart
    @current_cart ||= find_or_create_cart_internal
  end

  def find_existing_cart
    if @current_customer
      find_customer_cart
    else
      find_session_cart
    end
  end

  def merge_anonymous_cart_on_login(customer)
    session_cart = find_session_cart
    return unless session_cart&.anonymous?

    authenticated_cart = Cart.find_or_create_for_customer(customer)
    authenticated_cart.merge_with(session_cart)

    @current_cart = authenticated_cart
    clear_session_cart_id
  end

  private

  def find_or_create_cart_internal
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

  def find_customer_cart
    return nil unless @current_customer
    Cart.find_by(customer: @current_customer)
  end

  def find_session_cart
    session_cart_id = @session[:cart_id]
    return nil unless session_cart_id

    Cart.find_by(id: session_cart_id, customer_id: nil)
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
