Fabricator(:review) do
  body { Faker::Lorem.paragraph }
  score { rand(5) }
end