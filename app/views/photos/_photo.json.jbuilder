json.extract! photo, :id, :title, :product_id, :width, :height, :created_at, :updated_at
json.url photo_url(photo, format: :json)
