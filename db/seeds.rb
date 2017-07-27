# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: 'testuser', 
             email: 'test@email.com', 
             password: 'password', 
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               activated: true,
               password:              password,
               password_confirmation: password)
end

# get first six users
users = User.order(:created_at).take 6

50.times do
  content = Faker::Lorem.sentence 5
  users.each { |u| u.microposts.create!(content: content) }
end
