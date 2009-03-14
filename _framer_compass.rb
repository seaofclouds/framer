require 'rubygems'
require 'RedCloth'
require 'sinatra'
gem 'chriseppstein-compass', '~> 0.5'
require 'compass'
require 'staticizer'

use Staticizer, "./static"

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = File.dirname('stylesheets')
  end
end

get '/stylesheets/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :screen, :sass => Compass.sass_engine_options
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
    klass = "oldbrowser" unless browser?(:firefox) || browser?(:safari)
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
      "wireframe of >> "+ title
    else
      "wireframe"
    end
  end
  
end