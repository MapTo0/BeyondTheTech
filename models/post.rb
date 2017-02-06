class Post
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :active, Boolean
  property :image_url, String, :length => 1000

  has n, :postContents
  has n, :comments
  has n, :tags, :through => Resource

  belongs_to :user
end