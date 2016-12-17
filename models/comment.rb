class Comment
  include DataMapper::Resource

  property :id, Serial
  # author
  # text
end

DataMapper.finalize