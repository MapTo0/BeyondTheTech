require File.expand_path '../spec_helper.rb', __FILE__

RSpec.describe 'Authorization' do
  def create_and_login_regular_user
    post '/register', { 'username': 'test',
                        'email': 'mail@mail.com',
                        'password': 'password' }
  end

  context 'regular user' do
    it 'allows accessing profile page' do
      create_and_login_regular_user
      get '/user/profile'
      expect(last_response).to be_ok
    end

    it 'does not allow accessing users page' do
      create_and_login_regular_user
      get '/users'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end

    it 'does not allow accessing create post page' do
      create_and_login_regular_user
      get '/posts/create'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end

    it 'does not allow accessing login page' do
      create_and_login_regular_user
      get '/login'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end

    it 'does not allow accessing register page' do
      create_and_login_regular_user
      get '/register'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end
  end

  context 'anonymous user' do
    it 'allows accessing the home page' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'allows accessing the posts page' do
      get '/posts/view'
      expect(last_response).to be_ok
    end

    it 'allows accessing the login page' do
      get '/login'
      expect(last_response).to be_ok
    end

    it 'allows accessing the register page' do
      get '/register'
      expect(last_response).to be_ok
    end

    it 'does not allow accessing users page' do
      get '/users'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end

    it 'does not allow accessing profile page' do
      get '/user/profile'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end

    it 'does not allow accessing create post page' do
      get '/posts/create'
      expect(last_response).not_to be_ok
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eql 'http://example.org/'
    end
  end
end
