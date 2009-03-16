$LOAD_PATH.unshift('../sinatra/lib') #use latest version of sinatra

require 'rubygems'
require 'RedCloth'
require 'lorem' #required until i can fix faker's paragraphs
require 'faker'
require 'sinatra'
require 'staticizer'

use Staticizer, "./static"
  
get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/#{params[:name]}", :sass => {:style => :compact, :load_paths => [File.join(Sinatra::Application.views, 'stylesheets')]}
end

get '/' do
  haml RedCloth.new(File.read('./readme.textile')).to_html, :layout => :layout_lite
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
    klass = "blueprint"
    klass += " #{@body_class}" if @bodyclass
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
    elsif type == :sentences
      Faker::Lorem.sentences(amount)
    elsif type == :words
      Faker::Lorem.words(amount)
    else
      "You've got no lorems"
    end
  end
  
  
end