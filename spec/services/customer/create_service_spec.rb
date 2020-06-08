# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer::CreateService do
  let(:user) { build(:user) }

  subject(:result) { described_class.call(user: user) }

  before(:each) do
    stub_request(:post, 'https://www.saltedge.com/api/v5/customers').
      to_return(body: response_data.to_json)
  end

  shared_examples 'fail result' do
    it 'and get success false' do
      expect(result.success?).to eq(false)
    end

    it 'and not update the user' do
      expect { result }.to_not change { [user.customer_id, user.secret] }.from([nil, nil])
    end
  end

  context 'with valid response params' do
    let(:response_data) do
      {
        data: {
          id: '18892',
          identifier: user.identifier,
          secret: 'AtQX6Q8vRyMrPjUVtW7J_O1n06qYQ25bvUJ8CIC80-8'
        }
      }
    end

    it 'attache customer to user' do
      expect { subject }.to change { [user.customer_id, user.secret] }
        .from([nil, nil]).to([response_data[:data][:id], response_data[:data][:secret]])

      expect(user.customer_id).to eq(response_data[:data][:id])
      expect(user.secret).to eq(response_data[:data][:secret])
    end
  end

  context 'with invalid response params' do
    context '.id' do
      let(:response_data) do
        {
          data: {
            id: nil,
            identifier: user.identifier,
            secret: 'AtQX6Q8vRyMrPjUVtW7J_O1n06qYQ25bvUJ8CIC80-8'
          }
        }
      end

      it_behaves_like 'fail result'
    end

    context '.secret' do
      let(:response_data) do
        {
          data: {
            id: '18892',
            identifier: user.identifier,
            secret: nil
          }
        }
      end

      it_behaves_like 'fail result'
    end

    context 'mismatch identifier' do
      let(:response_data) do
        {
          data: {
            id: '18892',
            identifier: SecureRandom.hex,
            secret: nil
          }
        }
      end

      it_behaves_like 'fail result'
    end
  end
end