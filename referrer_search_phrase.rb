require 'uri'
require 'CGI'

class SearchEngine < Struct.new(:name, :host_regex, :path_regex, :query_variable); end

class ReferrerSearchPhrase < Object
  
  def self.get(http_referrer_string)
    referrer_search_phrase = nil
    begin
      parsed_uri = URI.parse(http_referrer_string)
      if referred_engine = self.was_referred_by_a_supported_search_engine(parsed_uri)
        referrer_search_phrase = self.get_search_phrase(referred_engine, parsed_uri)
      end
    rescue
    end
    referrer_search_phrase
  end
  
  private
  
  @@search_engines = [
    SearchEngine.new(:google, /www.google\./,   /\/search/, 'q'),
    SearchEngine.new(:yahoo,  /search.yahoo\./, /\/search/, 'p'),
    SearchEngine.new(:bing,   /www.bing.com/,   /\/search/, 'q'),
    ]
  
  def self.was_referred_by_a_supported_search_engine(parsed_uri)
    referred_engine = nil
    @@search_engines.each do |search_engine|
      if (parsed_uri.host =~ search_engine.host_regex && parsed_uri.path =~ search_engine.path_regex)
        referred_engine = search_engine
        break
      end
    end
    referred_engine
  end
  
  def self.get_search_phrase(referred_engine, parsed_uri)
    search_phrase = nil
    begin
      search_phrase = CGI::unescape(parsed_uri.query.split("&").map{|e| e.split("=")}.assoc(referred_engine.query_variable).last)
    rescue
    end
    search_phrase
  end
  
end
