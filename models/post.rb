class Post
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :active, Boolean
  property :title, String
  property :body, String, :length => 1000
  property :image_url, String # an URL

  has 1, :user
  has n, :comments, :required => false
  has n, :tags, :required => false
end