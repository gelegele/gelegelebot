require 'uri'

class Utils

  TWITTER_URL = "http://twitter.com/"

  #文字列中の@xxxxをaタグに変換した文字列を返します
  def self.replace_twitter_name_to_a(s)
    name_reg = /(^|\s)@\w+/
    replaced = s.gsub(name_reg){|name| '<a href="' + TWITTER_URL + name.strip.sub("@", "") + '" target="_blank">' + name.strip + ' </a>'}
    return replaced
  end

  #文字列中のURI部分をaタグに変換した文字列を返します
  def self.replace_uri_to_a(s)
    #str = Utils.replace_twitter_name_to_uri(s)
    uri_reg = URI.regexp(%w[http https])
    replaced = s.gsub(uri_reg) {%Q{<a href="#{$&}" target="_blank">#{$&}</a>}}
    return replaced
  end

  #文字列中のURI部分と@xxxをaタグに変換した文字列を返します
  def self.replace_to_a(s)
    replaced = Utils.replace_uri_to_a(s)
    replaced = Utils.replace_twitter_name_to_a(replaced)
    return replaced
  end

end