# frozen_string_literal: true

FactoryBot.define do
  factory :agency do
    agency_name { FFaker::Company.name }
    priority { Random.rand(10) }
  end
end
