class Comment
  include DataMapper::Resource

  property :id, Serial
  belongs_to :post
  has 1, :user
end