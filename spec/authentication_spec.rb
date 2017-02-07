require File.expand_path '../spec_helper.rb', __FILE__

RSpec.describe 'Authentication' do
  def create_and_login_regular_user
    post '/register', { 'username': 'test',
                        'email': 'mail@mail.com',
                        'password': 'password' }
  end

  context 'register' do
    it 'creates a user' do
      create_and_login_regular_user

      expect(last_response).to be_ok
      expect(User.all.size).to equal(1)
    end

    it 'does not create users with duplicate username or password' do
      create_and_login_regular_user
      create_and_login_regular_user

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq(403)
      expect(last_response.body).to include('email')
      expect(last_response.body).to include('username')
      expect(User.all.size).to equal(1)
    end

    it 'does not create users with invalid username' do
      post '/register', { 'username': 'tt',
                          'email': 'mail@mail.com',
                          'password': 'password' }

      expect(last_response.status).to eq(403)
      expect(last_response.body).to include('username')
      expect(User.all.size).to equal(0)
    end

    it 'does not create users with invalid username' do
      post '/register', { 'username': 'tttt',
                          'email': 'astest',
                          'password': 'password' }

      expect(last_response.status).to eq(403)
      expect(last_response.body).to include('email')
      expect(User.all.size).to equal(0)
    end
  end

  context 'login' do
    it 'signs a user in' do
      create_and_login_regular_user
      post '/login', { 'username': 'test',
                       'password': 'password' }

      expect(last_response).to be_ok
    end

    it 'rejects a user with wrong credentials' do
      create_and_login_regular_user
      post '/login', { 'username': 'asdf',
                       'password': 'password' }

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq(401)
    end
  end

  context 'logout' do
    it 'signs out a user' do
      create_and_login_regular_user
      get '/logout'
      expect(last_request.env['rack.session']['user_id']).to equal(nil)
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end
  end
end