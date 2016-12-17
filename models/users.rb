class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format  => :email_address
  property :username, String
  property :password, BCryptHash
  property :admin, Boolean

  # belongs_to :post
  # belongs_to :comment

  # validates_length_of  :password, :min => 8
end

DataMapper.finalize