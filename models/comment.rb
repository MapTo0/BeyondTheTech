class Comment
  include DataMapper::Resource

  property :id, Serial
  property :text, String, :length => 20000

  belongs_to :post
  belongs_to :user
end