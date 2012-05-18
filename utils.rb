require 'uri'

class Utils

  #•¶Žš—ñ’†‚ÌURI•”•ª‚ðaƒ^ƒO‚É•ÏŠ·‚µ‚½•¶Žš—ñ‚ð•Ô‚µ‚Ü‚·
  def self.replace_uri_to_a(s)
    str = s.dup
    uri_reg = URI.regexp(%w[http https])
    str.gsub!(uri_reg) {%Q{<a href="#{$&}" target="_blank">#{$&}</a>}}
    return str
  end

end