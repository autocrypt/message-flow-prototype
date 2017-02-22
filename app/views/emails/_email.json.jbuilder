json.extract! email, :id, :from, :to, :subject, :body, :source, :created_at, :updated_at
json.url email_url(email, format: :json)