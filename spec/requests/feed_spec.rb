# frozen_string_literal: true

require 'rails_helper'

describe '/feed' do
  let!(:agency1) { FactoryBot.create :agency, agency_name: 'Middle', priority: 9 }
  let!(:agency2) { FactoryBot.create :agency, agency_name: 'Top', priority: 10 }
  let!(:agency3) { FactoryBot.create :agency, agency_name: 'Lowest', priority: 1 }
  let!(:apartment1) do
    ap = FactoryBot.build(:custom_apartment, rental_agency: agency1.agency_name, price: '$1000')
    ap.save
    ap
  end
  let!(:apartment2) do
    ap = FactoryBot.build(:custom_apartment, rental_agency: agency2.agency_name, price: '$1100')
    ap.save
    ap
  end
  let!(:apartment3) do
    ap = FactoryBot.build(:custom_apartment, address: 'Addr3', rental_agency: agency3.agency_name, price: '$2000')
    ap.save
    ap
  end

  it "should have the title 'Apartments'" do
    visit '/feed/'
    expect(page).to have_selector('h1', text: 'Apartments')
  end

  it 'should have table apartments' do
    visit '/feed/'
    expect(page).to have_css('table.apartments')
  end

  it 'should have data rows with right apartments and agencies' do
    visit '/feed/'
    expect(page.html).to match(%r{tr.*404\sEast\s88th\sStreet.*5D.*NY.*\$1,100.*Top.*/tr}m)
    expect(page.html).to match(%r{tr.*Addr3.*5D.*NY.*\$2,000.*Lowest.*/tr}m)
  end
end
