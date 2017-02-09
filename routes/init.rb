before do
  session['lng'] = session['lng'] || 'en'
end

require_relative 'home'
require_relative 'users'
require_relative 'auth'
require_relative 'posts'