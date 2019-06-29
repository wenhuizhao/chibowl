json.extract! department, :id, :name, :desc, :parent_id, :created_at, :updated_at
json.url department_url(department, format: :json)
