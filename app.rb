require 'sinatra'
require 'pry'
require_relative 'lib/annotator'

get '/' do
  <<-HTML
  <html>
  <head><title>Multi file upload</title></head>
  <body>
    <form action="/upload" method="post" enctype="multipart/form-data">
      <input type="file" name="input_data" />
      <input type="file" name="input_meta" multiple />
      <input type="submit" />
    </form>
  </body>
  </html>
  HTML
end

post '/upload' do
  content_type :text

  annotator_path = "/home/grosscol/workspace/bit-stomach/example/annotation_proc.r"
  Annotator.thread_annotation(annotator_path)

  res = "I received the following files:\n"
  res << params['input_data'][:filename]
  res << "\n"
  res << params['input_meta'][:filename]
  res

end

  
