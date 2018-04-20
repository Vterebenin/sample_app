User.create!(name:  "Test Admin User",
             email: "niceserver11@mail.ru",
             password:              "123qwe",
             password_confirmation: "123qwe",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end