require File.expand_path '../spec_helper.rb', __FILE__

RSpec.describe 'User' do
  def create_and_login_user
    post '/register', 'username': 'test',
                      'email': 'mail@mail.com',
                      'password': 'password'
  end

  def create_and_login_admin
    User.create(email: 'admin@abv.bg',
                username: 'admin',
                password: 'admin',
                admin: true)
  end

  context 'user role namangement' do
    it 'gives user admin rights' do
      create_and_login_user
      put '/user', action: 'add', userId: 1

      expect(User.get(1).admin).to be_truthy
    end
  end

  context 'user info management' do
    it 'changes user password' do
      create_and_login_user
      put '/user/password', oldPassword: 'password',
                            newPassword: 'newpassword'

      expect(User.get(1).password).to eq 'newpassword'
    end

    it 'does not change user password when old is incorrect' do
      create_and_login_user
      put '/user/password', oldPassword: 'wrong',
                            newPassword: 'newpassword'

      expect(User.get(1).password).to eq 'password'
    end
  end

  context 'forgotten password' do
    it 'should send email with forgotten password' do
      create_and_login_user
      allow(Pony).to receive(:deliver)

      expect(Pony).to receive(:deliver) do |mail|
        expect(mail.to).to eq ['mail@mail.com']
        expect(mail.subject).to eq 'New Password'
      end

      post '/user/password', email: 'mail@mail.com'
    end
  end
end
