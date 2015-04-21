Fabricator(:payment) do
  user { Fabricate(:user) }
  amount { 999 }
  reference_id { Faker::Bitcoin.address }
end
