require 'sinatra'
require 'open3'
require 'json'

get '/' do
  erb :index, locals: {res: ''}
end

post '/' do
  uri = URI.parse('http://localhost:8081/code')
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path)
  request.set_form_data(params)
  response = http.request(request).body

  content_type :json
  response
end

post '/code' do
  pp params
  res =
      case params[:lang]
        when 'ruby'
          $stdout = StringIO.new
          begin
            eval(params[:code].strip)
            $stdout.string
          rescue Exception => e
            e.message
          end
        when 'python'
          Open3.popen3("python", "python_exec.py", params[:code].strip) do |stdin, stdout, stderr, wait_thr|
            err = stderr.read
            out = stdout.read

            if err.empty?
              out
            else
              err
            end
          end
      end
  content_type :json
  {res: res}.to_json
end
