require 'json'
require 'redcarpet'

get '/posts/view' do
  posts = Post.all
  bloggers = User.all.select { |user| user.posts.size > 0 }
  tags = Tag.all.select do |tag|
    tag.posts.any? { |post| user_admin? ? post : post.active }
  end

  erb :posts, locals: { texts: get_texts, tags: tags, bloggers: bloggers, posts: posts }
end

get '/posts' do
  author_id = params['authorId'].to_i
  tag = params['tag'] || "all"
  criteria = params['criteria']
  order = params['order']
  user = User.get(author_id)

  posts_by_author = get_posts_by_author(user)
  posts_by_tag = get_posts_by_tag(tag)

  query = posts_by_author & posts_by_tag

  if criteria == 'date'
    query = order_by_date(query, order)
  elsif criteria == 'cc'
    query = order_by_cc(query, order)
  else
    query
  end

  serialize_query(query).to_json
end

get '/posts/create' do
  check_admin_and_redirect
  erb :create_post, locals: { texts: get_texts }
end

get '/posts/:id/view' do
  id = params[:id].to_i
  post = Post.get(id)

  if !post || (!post.active && !user_admin?)
    redirect '/'
  end

  renderer = Redcarpet::Render::HTML.new()
  markdown = Redcarpet::Markdown.new(renderer)
  post_content = post.postContents.first(:language => session['lng'])

  unless post_content
    redirect '/'
  end

  erb :view_post, locals: { post: post, post_content: post_content, body: markdown.render(post_content.body), markdown_renderer: markdown, texts: get_texts }
end

get '/comments/:id/edit' do
  comment = get_post_comment(params[:id].to_i)
  comment.to_json
end

get '/posts/:id/edit' do
  post_content = get_post_content(params[:id])

  {
    post_content: post_content,
    active: Post.get(params[:id]).active
  }.to_json
end

post '/posts' do
  title = params[:title]
  body = params[:body]
  image_url = params[:imageUrl]
  language = params[:language]
  active = params[:active]
  user = User.get(session[:user_id].to_i)
  tags = get_unique_tags(params[:tags])

  post = Post.new(date: Time.now, active: active, image_url: image_url)
  post_content = PostContent.new(title: title, body: body, language: language, post_id: post.id)

  post.postContents << post_content
  user.posts << post
  tags.each { |tag| post.tags << tag }
  post.save

  post.id.to_s
end

post '/posts/:id/comment' do
  user_id = session['user_id'].to_i
  comment_text = params['text']
  user = User.get(user_id)
  post = Post.get(params[:id].to_i)

  comment = Comment.new(text: comment_text)
  comment.post = post
  comment.user = user
  user.comments << comment
  post.comments << comment

  comment.save
end

put '/posts/:id' do
  title = params[:title]
  body = params[:body]
  post_id = params[:id].to_i
  language = params[:language]
  post = Post.get(post_id)

  post_content = PostContent.new(title: title, body: body, language: language, post_id: post_id)

  post.postContents << post_content

  post.save
end

put '/posts/:id/edit' do
  post_content = get_post_content(params[:id])
  post = Post.get(params[:id])

  post_content.update({
                        :body => params[:body],
                        :title => params[:title]
  })

  post.update({ :active => params[:active] })
end

put '/comments/:id/edit' do
  comment = get_post_comment(params[:id].to_i)
  comment.update({ :text => params[:text]})
end

put '/comments/:id/delete' do
  comment = get_post_comment(params[:id].to_i)
  comment.destroy
end

put '/posts/:id/delete' do
  post = Post.get(params[:id])
  post.comments.destroy
  post.postContents.destroy
  post.tags.clear
  post.destroy
end

def get_post_content post_id
  post = Post.get(post_id)

  post_content = post.postContents.select do |content|
    content.language == session['lng']
  end

  post_content[0]
end

def get_post_comment comment_id
  Comment.get(comment_id)
end

def get_posts_by_author(author)
  if (author)
    Post.all(:user => author)
  else
    Post.all
  end
end

def get_posts_by_tag(tag)
  if tag != "all"
    Tag.all(:text => tag).posts
  else
    Post.all
  end
end

def order_by_date(query, order)
  query.all(:order => (order == 'desc' ? :date.desc : :date.asc))
end

def order_by_cc(query, order)
  query.sort_by do |post|
    order == 'desc' ? -post.comments.count :  post.comments.count
  end
end

def serialize_query(query)
  data = []
  query.each do |post|
    post_content = post.postContents.select { |content| content.language =session['lng'] }[0]
    if post_content
      if post.active || admin?(session[:user_id])
        data << {
          'title': post_content.title,
          'author': User.get(post.user_id),
          'body': post_content.body,
          'date': post.date.strftime("%d.%m.%Y"),
          'image': post.image_url,
          'commentCount': post.comments.count,
          'language': session['lng'],
          'id': post.id,
          'tags': post.tags.map { |tag| "#" + tag.text }
        }
      end
    end
  end

  data
end

def get_unique_tags(tags)
  tags.split(" ").uniq.map { |tag| Tag.first_or_new(text: tag) }
end