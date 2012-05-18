require 'uri'

class Utils

  #文字列中のURI部分をaタグに変換した文字列を返します
  def self.replace_uri_to_a(s)
    str = s.dup
    uri_reg = URI.regexp(%w[http https])
    str.gsub!(uri_reg) {%Q{<a href="#{$&}" target="_blank">#{$&}</a>}}
    return str
  end

end