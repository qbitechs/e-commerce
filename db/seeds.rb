# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a super admin user
super_admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password"
end

# Create two stores with different subdomains, each belonging to the super admin
store1 = Store.find_or_create_by!(name: "Store One", subdomain: "store1", user: super_admin)
store2 = Store.find_or_create_by!(name: "Store Two", subdomain: "store2", user: super_admin)

# Add categories and products to each store
ActsAsTenant.with_tenant(store1) do
  category1 = Category.find_or_create_by!(name: "Electronics", store: store1)
  category2 = Category.find_or_create_by!(name: "Books", store: store1)
  Product.find_or_create_by!(name: "Product A", price: 10, stock: 100, sku: "A1", category: category1)
  Product.find_or_create_by!(name: "Product C", price: 15, stock: 60, sku: "C1", category: category2)
  Customer.find_or_create_by!(first_name: "Alice", last_name: "Smith", email: "alice@store1.com") do |customer|
    customer.password = "password"
  end
end

ActsAsTenant.with_tenant(store2) do
  category1 = Category.find_or_create_by!(name: "Clothing", store: store2)
  category2 = Category.find_or_create_by!(name: "Toys", store: store2)
  Product.find_or_create_by!(name: "Product B", price: 20, stock: 50, sku: "B1", category: category1)
  Product.find_or_create_by!(name: "Product D", price: 25, stock: 30, sku: "D1", category: category2)
  Customer.find_or_create_by!(first_name: "Bob", last_name: "Jones", email: "bob@store2.com") do |customer|
    customer.password = "password"
  end
end
