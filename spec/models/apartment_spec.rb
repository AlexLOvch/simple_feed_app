require 'rails_helper'

RSpec.describe Apartment, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:agency_apartments) }
    it { is_expected.to have_many(:agencies) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:apartment) }
    it { is_expected.to validate_presence_of(:city) }
  end

  describe '#save' do
    let(:agency1) { FactoryBot.create :agency }

    context 'when apartment is uniq' do
      let(:apartment) { FactoryBot.build(:apartment, rental_agency: agency1.agency_name) }

      it 'adds new apartments record' do
        expect { apartment.save }.to change { Apartment.count }.by(1)
      end

      it 'adds new agency_apartments record' do
        expect { apartment.save }.to change { AgencyApartment.count }.by(1)
      end

      it 'sets new agency_apartments record with properly set relations' do
        apartment.save
        relation_record = AgencyApartment.last
        expect(relation_record.apartment_id).to eq apartment.id
        expect(relation_record.agency_id).to eq agency1.id
      end

      it 'saves new agency_apartments record with properly set price' do
        apartment.save
        expect(AgencyApartment.first.price).to eq apartment.price[1..-1].to_i
      end
    end

    context 'when apartment is already present' do
      let(:agency2) { FactoryBot.create :agency }
      let!(:existent_apartment) { FactoryBot.create(:custom_apartment, rental_agency: agency1.agency_name) }
      let(:apartment) { FactoryBot.build(:custom_apartment, rental_agency: agency2.agency_name) }

      it 'does not add new apartments record' do
        expect { apartment.save }.to_not change { Apartment.count }
      end

      it 'adds new agency_apartments record' do
        expect { apartment.save }.to change { AgencyApartment.count }.from(1).to(2)
      end

      it 'sets new agency_apartments record with properly set relations' do
        apartment.save
        relation_record = AgencyApartment.last
        expect(relation_record.apartment_id).to eq existent_apartment.id
        expect(relation_record.agency_id).to eq agency2.id
      end

      it 'saves new agency_apartments record with properly set price' do
        apartment.save
        expect(AgencyApartment.first.price).to eq apartment.price[1..-1].to_i
      end
    end
  end

  describe '.with_topmost_agency' do
    let!(:agency1) { FactoryBot.create :agency, priority: 9 }
    let!(:agency2) { FactoryBot.create :agency, priority: 10 }
    let!(:agency3) { FactoryBot.create :agency}
    let!(:apartment1) { ap = FactoryBot.build(:custom_apartment, rental_agency: agency1.agency_name); ap.save; ap }
    let!(:apartment2) { ap = FactoryBot.build(:custom_apartment, rental_agency: agency2.agency_name); ap.save; ap }
    let!(:apartment3) { ap = FactoryBot.build(:apartment, rental_agency: agency3.agency_name); ap.save; ap }

    it 'returns all apartments with max prioritized agency' do
      comparable_fields = [:address, :apartment, :city, :rental_agency]
      results = Apartment.with_topmost_agency.map{|ap|ap.slice(*comparable_fields)}
      expect(results).to eq ([apartment2.slice(*comparable_fields), apartment3.slice(*comparable_fields)])
    end

    it 'returns all apartments with price of max prioritized agency' do
      prices = Apartment.with_topmost_agency.map{|ap|ap.price.to_i}
      expect(prices).to eq ([apartment2.price[1..-1].to_i, apartment3.price[1..-1].to_i])
    end

  end

end
