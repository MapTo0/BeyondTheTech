class Post
  include DataMapper::Resource

  property :id, Serial
  # author
  # comments
  # title
  # text
  # image
end

DataMapper.finalize