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
users = User.order(:created_at)
users_with_posts = users.take 6

# microposts
50.times do
  content = Faker::Lorem.sentence 5
  users_with_posts.each { |u| u.microposts.create!(content: content) }
end

# relationships
user = users.last
following = users[0..99]
followers = users[3..40]
following.each { |followed| user.follow followed }
followers.each { |follower| follower.follow user }
