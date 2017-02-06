class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :required => true, :unique => true,
           :format => :email_address,
           :messages => {
              :presence  => "AUTH_EMAIL_PRESENCE",
              :is_unique => "AUTH_EMAIL_UNIQUE",
              :format    => "AUTH_EMIAL_FORMAT"
            }
  property :username, String, :unique => true, :length => 3..25,
           :messages => {
             :is_unique => "AUTH_USERNAME_UNIQUE",
             :length    => "AUTH_USERNAME_LENGTH"
            }
  property :password, BCryptHash
  property :admin, Boolean

  has n, :posts
  has n, :comments
end
