json.extract! product, :id, :name, :category_id, :chef_id, :price, :desc, :created_at, :updated_at
json.url product_url(product, format: :json)
