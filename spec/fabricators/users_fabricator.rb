Fabricator(:user) do
  username { Faker::Name.name }
  email { Faker::Internet.email }
  password { 'password' }
end