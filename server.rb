require 'sinatra'
require 'pg'
require 'pry'


def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end

# db_connection do |conn|
#    conn.exec(query)
#  end



get '/articles/new' do


  erb :index

end

get '/articles' do



@results = db_connection do |conn|
  conn.exec('SELECT articles.title, articles.url, articles.description FROM articles')
end

  erb :show

end

post '/articles' do

  article_title = params['title']
  article_url = params['url']
  article_description = params['description']

query = "INSERT INTO articles (title, url, description)
        VALUES ($1, $2, $3)"

db_connection do |conn|
   conn.exec_params(query, [article_title, article_url, article_description])
end


  # Send the user back to the home page which shows
  # the list of tasks
  redirect '/articles'
end


