require "rails_helper"

RSpec.describe "Ads", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:user) do
    User.create!(
      email: "rspec@example.com",
      password: "Password123!",
      password_confirmation: "Password123!"
    )
  end

  let!(:ad) do
    Ad.create!(
      title: "Test Advertisement",
      description: "Test description",
      price: 99.99,
      category: "Test"
    )
  end

  before do
    sign_in user
  end

  describe "GET /ads" do
    it "returns a successful response" do
      get ads_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /ads/new" do
    it "returns a successful response" do
      get new_ad_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /ads" do
    it "creates an advertisement" do
      expect {
        post ads_path, params: {
          ad: {
            title: "New Advertisement",
            description: "New description",
            price: 50.00,
            category: "Technology"
          }
        }
      }.to change(Ad, :count).by(1)

      expect(response).to redirect_to(ad_path(Ad.last))
    end
  end

  describe "GET /ads/:id" do
    it "returns a successful response" do
      get ad_path(ad)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /ads/:id/edit" do
    it "returns a successful response" do
      get edit_ad_path(ad)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /ads/:id" do
    it "updates the advertisement" do
      patch ad_path(ad), params: {
        ad: {
          title: "Updated Advertisement",
          description: "Updated description",
          price: 120.00,
          category: "Updated"
        }
      }

      expect(response).to redirect_to(ad_path(ad))

      ad.reload

      expect(ad.title).to eq("Updated Advertisement")
      expect(ad.price).to eq(120.00)
    end
  end

  describe "DELETE /ads/:id" do
    it "destroys the advertisement" do
      expect {
        delete ad_path(ad)
      }.to change(Ad, :count).by(-1)

      expect(response).to redirect_to(ads_path)
    end
  end
end
