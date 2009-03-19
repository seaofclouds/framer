APP_ROOT = File.dirname(File.expand_path(__FILE__)) unless defined?(APP_ROOT)
$LOAD_PATH.unshift('../sinatra/lib') #use latest version of sinatra

require 'rubygems'
require 'RedCloth'
require 'lorem' #required until i can fix faker's paragraphs
require 'faker'
require 'compass'
require 'sinatra'
require 'haml'
require 'staticizer'

use Staticizer, "./static"

# set variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, "views"

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = File.join(Sinatra::Application.views, 'stylesheets')
    config.output_style = :compact
  end
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
  
  def demo(page, options={})
    haml "demo/_#{page}".to_sym, options.merge!(:layout => false)
  end
    
  def bodyselectors
    klass = "blueprint"
    klass += " #{@bodyclass}" if @bodyclass
    klass += " oldbrowser" unless browser?(:firefox) || browser?(:safari)
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

  def lorem(type, amount)
    if type == :paragraph
      RedCloth.new(Faker::Lorem.paragraph(amount)).to_html
    elsif type == :paragraphs
      # for some reason, faker doesn't work with paragraphs...
      RedCloth.new(Lorem::Base.new('paragraphs', amount).output).to_html
    elsif type == :sentence
      Faker::Lorem.sentence(amount)
    elsif type == :title
      Faker::Lorem.sentence(amount).gsub('.','')
    elsif type == :sentences
      Faker::Lorem.sentences(amount).join(' ')
    elsif type == :words
      Faker::Lorem.words(amount).join(' ')
    else
      "You've got no lorems"
    end
  end
  
  def name(type)
    if type == :full
      Faker::Name.name
    elsif type == :first
      Faker::Name.first_name
    elsif type == :last
      Faker::Name.last_name
    elsif type == :user
      Faker::Lorem.words(2)
    end
  end
  
  def link_to(type,action,text)
    if type == 'view'
      "<a href='"+action+"' alt='go to "+text+"'>"+text+"</a>"
    elsif type == 'js'
      "<a href='javascript:void(0);' class='"+action+"'>"+text+"</a>"
    end
  end
  
  def media(type,id,width,height,text)
    "<div id='"+id.to_s+"' class='media media-"+type.to_s+"'><img class='media-crosshair' src='/images/image-cross-hair.png' width='"+width.to_s+"' height='"+height.to_s+"' /><p class='media-size'>"+width.to_s+"w x "+height.to_s+"h</p><p class='media-text'>"+text+"</p></div>"
  end
  
end

not_found do
  headers["Status"] = "301 Moved Permanently"
  redirect("/")
end

# define demo pages

get '/' do
  @bodyid = "demo"
  haml "= RedCloth.new(File.read('./readme.textile')).to_html", :layout => :"demo/layout"
end

get '/demo' do
  haml :"demo/index".to_sym, :layout => :"demo/layout"
end

get '/demo/:name' do
  @bodyid = "demo-#{params[:name]}"
  haml :"demo/_#{params[:name]}".to_sym, :layout => :"demo/layout"
end

# define stylesheets

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/#{params[:name]}", :sass => Compass.sass_engine_options
end

# define app pages
 
get '/:name' do
  @bodyid = "#{params[:name]}"
  haml params[:name].to_sym
end