require File.expand_path '../spec_helper.rb', __FILE__

RSpec.describe 'Authorization' do
  def create_and_login_regular_user
    post '/register', { 'username': 'test',
                        'email': 'mail@mail.com',
                        'password': 'password' }
  end

  def create_user(email='admin@abv.bg', username='admin', admin)
    User.create(email: email,
                username: username,
                password: 'admin',
                admin: admin)
  end

  def create_and_login_regular_user
    post '/register', { 'username': 'test',
                        'email': 'mail@mail.com',
                        'password': 'password' }
  end

  def create_post(user: user, tags: "", date: Time.now)
    post = Post.new(date: date, active: true, image_url: 'http://chromespot.com/wp-content/uploads/2013/02/url.jpg')
    post_content = PostContent.new(title: 'test', body: 'body', language: 'en', post_id: post.id)
    post.postContents << post_content
    user.posts << post

    tags = tags.split(" ").uniq.map { |tag| post.tags << Tag.first_or_new(text: tag) }
    post.save
  end

  def add_post_comments(post, comment_count)
    create_user(admin: true)
    comment_count.times do |time|
      comment = Comment.new(text: "test")
      comment.post = post
      comment.user = User.get(1)
      User.get(1).comments << comment
      post.comments << comment

      comment.save
    end
  end

  context 'filtering' do
    it 'gets all posts' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user)
      create_post(user: first_user)
      create_post(user: second_user)

      get '/posts', { 'authorId': 'all',
                      'tag': 'all',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 3
    end

    it 'gets all posts per user' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user)
      create_post(user: first_user)
      create_post(user: second_user)

      get '/posts', { 'authorId': '1',
                      'tag': 'all',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 2
    end

    it 'gets all posts per tag #tag3' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, tags: "tag1 tag2")
      create_post(user: first_user, tags: "tag3 tag4 tag1")
      create_post(user: second_user, tags: "tag1 tag3")

      get '/posts', { 'authorId': 'all',
                      'tag': 'tag3',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 2
    end

    it 'gets all posts per tag #tag4' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, tags: "tag1 tag2")
      create_post(user: first_user, tags: "tag3 tag4")
      create_post(user: second_user, tags: "tag1 tag3")

      get '/posts', { 'authorId': 'all',
                      'tag': 'tag4',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 1
    end

    it 'gets all posts per tag #tag1' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, tags: "tag1 tag2")
      create_post(user: first_user, tags: "tag3 tag1")
      create_post(user: second_user, tags: "tag1 tag3")

      get '/posts', { 'authorId': 'all',
                      'tag': 'tag1',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 3
    end

    it 'gets all posts per tag and user' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, tags: "tag1 tag2")
      create_post(user: first_user, tags: "tag3 tag1 tag4")
      create_post(user: second_user, tags: "tag1 tag3")

      get '/posts', { 'authorId': first_user.id,
                      'tag': 'tag1',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 2
    end

    it 'gets all posts per tag and user' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, tags: "tag1 tag2")
      create_post(user: first_user, tags: "tag3 tag1 tag4")
      create_post(user: second_user, tags: "tag1 tag3")

      get '/posts', { 'authorId': second_user.id,
                      'tag': 'tag4',
                      'criteria': "",
                      'byCommentCount': "" }

      post_count = (JSON.parse last_response.body).size
      expect(post_count).to eq 0
    end
  end

  context 'ordering' do
    it 'orders by date desc' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      first_post = create_post(user: first_user, date: Time.now - (7200 * 24))
      second_post = create_post(user: first_user)
      third_post = create_post(user: second_user, date: Time.now - (3600 * 24))

      get '/posts', { 'authorId': 'all',
                      'tag': 'all',
                      'criteria': "date",
                      'order': "desc" }

      response_posts = (JSON.parse last_response.body)

      expect(response_posts[0]['id']).to eq 2
      expect(response_posts[1]['id']).to eq 3
      expect(response_posts[2]['id']).to eq 1
    end

    it 'orders by date asc' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user, date: Time.now - (7200 * 24))
      create_post(user: first_user)
      create_post(user: second_user, date: Time.now - (3600 * 24))

      get '/posts', { 'authorId': 'all',
                      'tag': 'all',
                      'criteria': "date",
                      'order': "asc" }

      response_posts = (JSON.parse last_response.body)

      expect(response_posts[0]['id']).to eq 1
      expect(response_posts[1]['id']).to eq 3
      expect(response_posts[2]['id']).to eq 2
    end

    it 'orders by comment count desc' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user)
      create_post(user: first_user)
      create_post(user: second_user)

      add_post_comments(Post.get(1), 1)
      add_post_comments(Post.get(2), 5)
      add_post_comments(Post.get(3), 3)

      get '/posts', { 'authorId': 'all',
                      'tag': 'all',
                      'criteria': "cc",
                      'order': "desc" }

      response_posts = (JSON.parse last_response.body)

      expect(response_posts[0]['id']).to eq 2
      expect(response_posts[1]['id']).to eq 3
      expect(response_posts[2]['id']).to eq 1
    end

    it 'orders by comment count asc' do
      first_user = create_user(true)
      second_user = create_user('email@email.com', 'tester', true)
      create_post(user: first_user)
      create_post(user: first_user)
      create_post(user: second_user)

      add_post_comments(Post.get(1), 1)
      add_post_comments(Post.get(2), 5)
      add_post_comments(Post.get(3), 3)

      get '/posts', { 'authorId': 'all',
                      'tag': 'all',
                      'criteria': "cc",
                      'order': "asc" }

      response_posts = (JSON.parse last_response.body)

      expect(response_posts[0]['id']).to eq 1
      expect(response_posts[1]['id']).to eq 3
      expect(response_posts[2]['id']).to eq 2
    end
  end

  context 'creating' do
    it 'adds comments to a post' do
      create_and_login_regular_user
      create_post(user: User.get(1))

      post '/posts/1/comment', { text: "test" }
      post '/posts/1/comment', { text: "test" }

      expect(User.get(1).comments.size).to eq 2
    end

    it 'creates a post' do
      create_and_login_regular_user
      put '/user', action: 'add', userId: 1

      post '/posts', { imageUrl: "http://google.bg", tags: "" }

      expect(Post.all.size).to eq 1
    end
  end
end
