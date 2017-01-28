class Comment
  include DataMapper::Resource

  property :id, Serial
  property :text, String
  belongs_to :post
  has 1, :user
end