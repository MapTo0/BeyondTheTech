helpers do
  def admin? user_id
    current_user = User.get(user_id)
    current_user && current_user.admin
  end

  def user_admin?
    admin? session['user_id']
  end

  def redirect_to_home
    redirect '/'
  end

  def check_auth_and_redirect
    unless session['user_id']
      redirect_to_home
    end
  end

  def check_admin_and_redirect
    unless user_admin?
      redirect_to_home
    end
  end

  def get_texts
    texts = File.read('i18n/' + session['lng'] + '_texts.json')
    JSON.parse(texts)
  end

  def redirect_logged_users
    if session['user_id']
      redirect_to_home
    end
  end
end
