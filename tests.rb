require 'test/unit'
require 'benchmark'
require 'referrer_search_phrase'

class Tests < Test::Unit::TestCase
  
  GOOGLE_URLS = { 
    "http://www.google.com/search?hl=en&source=hp&q=foo+bar&aq=f&oq=&aqi=g8g-s1g1"                => "foo bar",
    "http://www.google.co.uk/search?hl=en&source=hp&q=foo&btnG=Google+Search&meta=&aq=f&oq="      => "foo",
    "http://www.google.co.jp/search?hl=ja&source=hp&q=bar&btnG=Google+検索&lr=&aq=f&oq="            => nil, #japan URLs mess with URI.parse
    "http://www.google.ie/search?hl=en&source=hp&q=guinness&btnG=Google+Search&meta=&aq=f&oq="    => "guinness",
    "http://www.google.de/search?hl=de&q=Schweinshaxen&btnG=Suche&meta=&aq=f&oq="                 => "Schweinshaxen",
    "http://www.goooooogle.com/search?hl=de&q=Schweinshaxen&btnG=Suche&meta=&aq=f&oq="            => nil
    }
  
  YAHOO_URLS = {
    "http://search.yahoo.com/search?p=guinness&toggle=1&cop=mss&ei=UTF-8&fr=yfp-t-701"            => "guinness",
    "http://uk.search.yahoo.com/search;_ylt=A0oGk3DKzuBKaD0AxQdLBQx.?p=stout&fr2=sb-top&fr=yfp-t-702&rd=r1&sao=1" => "stout",
    "http://de.search.yahoo.com/search?p=Schweinshaxen&fr=yfp-t-501&ei=UTF-8&rd=r1"               => "Schweinshaxen",
    "http://de.search.yahoooo.com/search?p=Schweinshaxen&fr=yfp-t-501&ei=UTF-8&rd=r1"             => nil,
    "http://search.yahoo.co.jp/search?p=yen&search.x=1&fr=top_ga1_sa&tid=top_ga1_sa&ei=UTF-8&aq=&oq=" => "yen",
  }
  
  BING_URLS = {
    "http://www.bing.com/search?q=foo+bar&go=&form=QBLH&filt=all&qs=n"                            => "foo bar",
    "http://www.bing.com/search?q=guinness&go=&form=QBLH&filt=all&qs=n"                           => "guinness",
    "http://www.bing.com/search?q=yen&go=&form=QBLH&filt=all"                                     => "yen"
  }
  
  search_engines = {:google => GOOGLE_URLS, :yahoo => YAHOO_URLS, :bing => BING_URLS}
  
  search_engines.each_pair do |engine, tests|
    tests.each_pair do |referrer, expected_phrase|
      send :define_method, "test_#{engine}_#{(expected_phrase || "").split.join("_")}" do
        assert_equal(expected_phrase, ReferrerSearchPhrase.get(referrer))
      end
    end
  end
  
  Benchmark.bm do |x| 
    urls = search_engines.values.flatten.dup
    14.times do
      urls << urls.dup
    end
    urls = urls.flatten
    x.report("Parsing #{urls.size} URLs"){ 
      urls.each{|url| ReferrerSearchPhrase.get(url)}
    } 
  end

end