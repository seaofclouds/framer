# http://groups.google.com/group/sinatrarb/browse_thread/thread/84d525759af8615a
require 'fileutils'

class Staticizer
  def initialize(app, cache_path)
    @app = app
    @cache_path = cache_path
  end

  def call(env)
    status, headers, body = @app.call(env)
    
    if status != 200

    elsif status == 200
      filename = File.join(@cache_path, env['PATH_INFO'])
      filename += 'index' if filename =~ /\/$/
      filename += '.html' unless filename =~ /\.\w+$/

      dirname = File.dirname(filename)
      FileUtils.mkdir_p dirname

      File.open(filename, 'wb') do |io|
        body.each { |part| io.write(part) }
      end

      body = File.open(filename, 'rb')
    end

    [status, headers, body]
  end
end