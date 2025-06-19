class CartService
  def initialize(session, current_customer = nil)
    @session = session
    @current_customer = current_customer
  end

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def add_to_cart(product, quantity = 1)
    return false unless product&.stock && product.stock >= quantity

    current_cart.add_product(product, quantity)
  end

  def remove_from_cart(product)
    current_cart.remove_product(product)
  end

  def update_cart_item(product, quantity)
    current_cart.update_quantity(product, quantity)
  end

  def clear_cart
    current_cart.cart_items.destroy_all
  end

  def merge_anonymous_cart_on_login(customer)
    return unless @current_cart&.anonymous?

    authenticated_cart = Cart.find_or_create_for_customer(customer)
    authenticated_cart.merge_with(@current_cart)

    @current_cart = authenticated_cart
    clear_session_cart_id
  end

  def transfer_cart_to_customer(customer)
    return unless @current_cart&.anonymous?

    @current_cart.update!(customer: customer, session_id: nil)
    clear_session_cart_id
  end

  private

  def find_or_create_cart
    if @current_customer
      # User is logged in
      cart = Cart.find_or_create_for_customer(@current_customer)
      merge_session_cart_if_exists(cart)
      cart
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

  def merge_session_cart_if_exists(authenticated_cart)
    session_cart_id = @session[:cart_id]
    return unless session_cart_id

    session_cart = Cart.find_by(id: session_cart_id, customer_id: nil)
    return unless session_cart

    authenticated_cart.merge_with(session_cart)
    clear_session_cart_id
  end

  def generate_session_id
    SecureRandom.hex(16)
  end

  def clear_session_cart_id
    @session.delete(:cart_id)
  end
end
