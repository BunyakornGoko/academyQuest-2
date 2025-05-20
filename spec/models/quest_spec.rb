require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe 'validations' do
    it 'is valid with a name and status' do
      quest = Quest.new(name: 'Test Quest', status: false)
      expect(quest).to be_valid
    end

    it 'is invalid without a name' do
      quest = Quest.new(status: false)
      expect(quest).not_to be_valid
      expect(quest.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a name less than 3 characters' do
      quest = Quest.new(name: 'AB', status: false)
      expect(quest).not_to be_valid
      expect(quest.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it 'is invalid with a name more than 100 characters' do
      quest = Quest.new(name: 'A' * 101, status: false)
      expect(quest).not_to be_valid
      expect(quest.errors[:name]).to include("is too long (maximum is 100 characters)")
    end

    it 'is invalid without a status' do
      quest = Quest.new(name: 'Valid Name')
      expect(quest).not_to be_valid
      expect(quest.errors[:status]).to include("is not included in the list")
    end
  end

  describe 'CRUD operations' do
    context 'Create' do
      it 'creates a new quest' do
        expect {
          Quest.create(name: 'New Quest', status: false)
        }.to change(Quest, :count).by(1)
      end

      it 'creates a quest using factory' do
        expect {
          create(:quest)
        }.to change(Quest, :count).by(1)
      end
    end

    context 'Read' do
      let!(:quest) { create(:quest, name: 'Read Test', status: true) }

      it 'retrieves a quest by id' do
        found_quest = Quest.find(quest.id)
        expect(found_quest).to eq(quest)
      end
    end

    context 'Update' do
      let!(:quest) { create(:quest, name: 'Original Name', status: false) }

      it 'updates a quest' do
        quest.update(name: 'Updated Name', status: true)
        quest.reload
        expect(quest.name).to eq('Updated Name')
        expect(quest.status).to be_truthy
      end
    end

    context 'Delete' do
      let!(:quest) { create(:quest) }

      it 'destroys a quest' do
        expect {
          quest.destroy
        }.to change(Quest, :count).by(-1)
      end
    end
  end

  describe 'attributes' do
    it 'has name and status attributes' do
      quest = Quest.new(name: 'Attribute Test', status: true)
      expect(quest.name).to eq('Attribute Test')
      expect(quest.status).to be_truthy
    end
  end
end
