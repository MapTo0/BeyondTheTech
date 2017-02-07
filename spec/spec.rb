require File.expand_path '../spec_helper.rb', __FILE__

describe "Anonymous navigation routes" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should allow accessing the posts page" do
    get '/posts/view'
    expect(last_response).to be_ok
  end

  it "should allow accessing the login page" do
    get '/login'
    expect(last_response).to be_ok
  end

  it "should allow accessing the register page" do
    get '/register'
    expect(last_response).to be_ok
  end

  it "should not allow accessing users page" do
    get '/users'
    expect(last_response).not_to be_ok
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eql 'http://example.org/'
  end

  it "should not allow accessing profile page" do
    get '/profile'
    expect(last_response).not_to be_ok
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eql 'http://example.org/'
  end

  it "should not allow accessing create post page" do
    get '/posts/create'
    expect(last_response).not_to be_ok
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eql 'http://example.org/'
  end
end
