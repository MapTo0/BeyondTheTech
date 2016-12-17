class Post
  include DataMapper::Resource

  property :id, Serial
  property :date, DateTime
  property :valid, Boolean
  property :title, String
  property :body, String
  property :image, String # an URL

  has n, :comments
  has 1, :user
end

DataMapper.finalize