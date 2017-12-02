json.extract! record, :id, :description, :amount, :balance, :created_at, :updated_at
json.url record_url(record, format: :json)
