class Tag
  include DataMapper::Resource

  property :id, Serial
  property :text, String
  has n, :posts, :through => Resource
end