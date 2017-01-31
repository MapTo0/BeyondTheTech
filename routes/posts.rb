require 'json'
require 'pry'
require 'redcarpet'

get '/posts' do
  tags = Tag.all
  bloggers = User.all.delete_if { |user| user.posts.size == 0 }
  author_id = params['authorId'].to_i || 0
  tag = params['tag'] || "all"
  byDate = params['byDate'] || ""
  byCommentCount = params['byCommentCount'] || ""

  user = User.get(author_id)
  query = Post.all

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

  erb :posts, locals: { texts: get_texts, tags: tags, bloggers: bloggers, posts: query }
end

get '/posts/query' do
  author_id = params['authorId'].to_i
  tag = params['tag']
  byDate = params['byDate']
  byCommentCount = params['byCommentCount']

  user = User.get(author_id)
  query = Post.all

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
  query
end

get '/posts/create' do
  erb :create_post, locals: { texts: get_texts }
end

get '/posts/:id/view' do
  id = params[:id].to_i
  post = Post.get(id)

  renderer = Redcarpet::Render::HTML.new()
  markdown = Redcarpet::Markdown.new(renderer)
  post_content = post.postContents.first(:language => session['lng'])

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

  p post.errors

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
  user_id = params['userId'].to_i
  comment_text = params['text']
  user = User.get(user_id)
  post = Post.get(params[:id].to_i)

  comment = Comment.new(text: comment_text)
  comment.post = post
  comment.user = user
  post.comments << comment

  comment.save
end