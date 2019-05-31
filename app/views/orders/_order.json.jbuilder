json.extract! order, :id, :user_id, :status, :order_date, :detail, :created_at, :updated_at
json.url order_url(order, format: :json)
