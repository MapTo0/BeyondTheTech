require 'json'
require 'pry'
require 'redcarpet'

get '/posts/view' do
  posts = Post.all
  bloggers = User.all.delete_if { |user| user.posts.size == 0 }

  if user_admin?
    tags = Tag.all
  else
    tags = Tag.all.select { |tag| tag.posts.any? { |post| post.active }}
  end

  erb :posts, locals: { texts: get_texts, tags: tags, bloggers: bloggers, posts: posts }
end

get '/posts' do
  author_id = params['authorId'].to_i
  tag = params['tag'] || "all"
  byDate = params['byDate']
  byCommentCount = params['byCommentCount']

  user = User.get(author_id)
  query = Post.all

  # refactor this piece of shit
  if author_id > 0
    query = query.all(:user => user)
    if tag != "all"
      query = query & Tag.all(:text => tag).posts
    end
  else
    if tag != "all"
      query = Tag.all(:text => tag).posts
    end
  end

  if byDate != ""
    query = query.all(:order => (byDate == 'desc' ? :date.desc : :date.asc))
  end

  if byCommentCount != ""
    query = query.sort_by do |post|
      if byCommentCount == 'desc'
        -post.comments.count
      else
        post.comments.count
      end
    end
  end

  data = []

  query.each do |post|
    post_content = post.postContents.select { |content| content.language == session['lng'] }[0]

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

  p Post.get(4).comments
  data.to_json
end

get '/posts/create' do
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

post '/posts' do
  title = params[:title]
  body = params[:body]
  image_url = params[:imageUrl]
  language = params[:language]
  active = params[:active]
  user = User.get(session[:user_id].to_i)
  tags = params[:tags].split(" ").uniq.map { |tag| Tag.first_or_new(text: tag) }

  post = Post.new(date: Time.now, active: active, image_url: image_url)
  postContent = PostContent.new(title: title, body: body, language: language, post_id: post.id)

  post.postContents << postContent
  user.posts << post
  tags.each { |tag| post.tags << tag }
  post.save

  post.id.to_s
end

put '/posts/:id' do
  title = params[:title]
  body = params[:body]
  post_id = params[:id].to_i
  language = params[:language]
  post = Post.get(post_id)

  postContent = PostContent.new(title: title, body: body, language: language, post_id: post_id)

  post.postContents << postContent

  post.save
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

get '/posts/:id/edit' do
  post_content = get_post_content(params[:id])
  { post_content: post_content, active: Post.get(params[:id]).active }.to_json
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

def admin? user_id
  current_user = User.get(user_id)
  current_user && current_user.admin
end

def user_admin?
  admin? session['user_id']
end

get '/comments/:id/edit' do
  comment = get_post_comment(params[:id].to_i)
  comment.to_json
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
