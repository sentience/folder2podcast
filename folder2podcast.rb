require 'sinatra'

hostname = `ifconfig`.split("\n").grep(/broadcast/).first.gsub(/.*inet (\d+\.\d+\.\d+\.\d+).*/, '\1') + ":4567"

get '/' do
  feed = "http://#{hostname}/feed?d=/Users/johndoe/Downloads/"
  "Visit <a href='#{feed}'>#{feed}</a> in your podcatcher!"
end

get '/feed' do
  if params[:d].nil?
    return "Please specify <code>d=/path/to/audiofiles</code>"
  end

  path = params[:d]

  items = Dir.glob(path + "*.mp3").map do |f|
    name = f.gsub(path, '')
    {
      'title' => name,
      'description' => name,
      'pub_date' => File.mtime(f),
      'url' => "http://#{hostname}/item?f=#{URI.encode(f)}"
    }
  end

  builder do |xml|
    xml.instruct! :xml, :version => "1.0" 
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "#{path} Podcast"
        xml.description "A feed of all the mp3 files in the #{path} folder"
        xml.link "http://#{hostname}/feed"

        items.each do |item|
          xml.item do
            xml.title item['title']
            xml.description item['description']
            xml.pubDate item['pub_date'].rfc822
            xml.link item['url']
            xml.guid item['url']
            xml.enclosure item['url']
          end
        end
      end
    end
  end
end

get '/item' do
  send_file params[:f]
end
