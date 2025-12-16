# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# User.find_or_create_by!(email: "admin@yopmail.com") do |user|
#     user.password = "admin@1234"
#     user.password_confirmation = "Cmf@1234"
#     user.role = "1"
#     user.name = "Admin"
#     user.permission = '2'
# end

user = User.find_by(email: "admin@yopmail.com")

if user
  user.password = "Cmf@1234"
  user.password_confirmation = "Cmf@1234"
  user.save!(validate: false)  # ← IMPORTANT
else
  User.create!(
    email: "admin@yopmail.com",
    password: "Cmf@1234",
    password_confirmation: "Cmf@1234",
    role: "1",
    name: "Admin",
    permission: "2"
  )
end

