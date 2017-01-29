class Post
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :active, Boolean
  property :image_url, String, :length => 1000 # an URL

  has 1, :user
  has n, :comments
  has n, :postContents
  has n, :tags, :through => Resource
end