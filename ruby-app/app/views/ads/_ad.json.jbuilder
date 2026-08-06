json.extract! ad, :id, :title, :description, :price, :category, :created_at, :updated_at
json.url ad_url(ad, format: :json)
