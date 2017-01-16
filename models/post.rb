class Post
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :active, Boolean
  property :title, String
  property :body, String
  property :imageURL, String # an URL

  has 1, :user
  has n, :comments
end