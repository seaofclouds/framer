require 'rubygems'
require 'RedCloth'
require 'sinatra'
require 'staticizer'

use Staticizer, "./static"

module Sinatra
  module Sass
  private
    def render_sass(content, options = {})
      ::Sass::Engine.new(content, options).render
    end
  end
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"../stylesheets/#{params[:name]}", :style => :compact, :load_paths => [File.join(Sinatra.application.options.views, 'stylesheets')]
end

get '/' do
  haml "= RedCloth.new(File.read('./readme.textile')).to_html", :layout => :layout_lite
end

get '/:name' do
  haml params[:name].to_sym
end

helpers do
  
  def browser?(b)
    user_agents = {
      :firefox   => /Firefox/,
      :safari=> /Safari/
    }
    user_agents[b] &&
      request.env["HTTP_USER_AGENT"] &&
      request.env["HTTP_USER_AGENT"] =~ user_agents[b]
  end
  
  def partial(page, options={})
    haml "_#{page}".to_sym, options.merge!(:layout => false)
  end
  
  def bodyselectors
    klass = "oldbrowser " unless browser?(:firefox) || browser?(:safari)
    klass += "blueprint"
    klass += " #{@body_class}" if @bodyclass
    if @bodyid && klass
      {:id => @bodyid, :class => klass}
    elsif @bodyid
      {:id => @bodyid}
    elsif klass
      {:class => klass}
    else
      {}
    end
  end
  
  def page_title(title = nil)
    if title
      "this is a framer wireframe of >> "+ title
    else
      "framer"
    end
  end
  
end