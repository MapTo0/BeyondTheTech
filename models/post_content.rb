class PostContent
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :body, String, :length => 10000
  property :language, String
  property :post_id, Integer

  belongs_to :post
end