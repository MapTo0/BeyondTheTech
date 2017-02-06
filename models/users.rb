class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format  => :email_address
  property :username, String, :unique => true, :length => 3..50
  property :password, BCryptHash
  property :admin, Boolean

  has n, :posts
  has n, :comments
end