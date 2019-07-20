FactoryBot.define do
  factory :apartment do
    address { FFaker::Address.street_name }
    apartment { FFaker::Address.secondary_address }
    city { FFaker::Address.city }
    rental_agency { FFaker::Company.name }
    price { "$#{1000 + Random.rand(1000)}" }
  end

  factory :custom_apartment, class: Apartment do
    address { '404 East 88th Street' }
    apartment { '5D' }
    city { 'NY' }
    rental_agency { 'cooper_and_cooper' }
    price { "$2550" }
  end
end
