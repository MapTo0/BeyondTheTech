class Tag
  include DataMapper::Resource

  property :id, Serial
  property :text, String, :length => 20
  has n, :posts, :through => Resource
end