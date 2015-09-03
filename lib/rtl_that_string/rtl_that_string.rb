require 'string-direction'

module RtlThatString
  # String borders
  # http://www.w3.org/International/questions/qa-bidi-unicode-controls#pairedcontrols
  RTL_START = "\u202F".freeze  # RIGHT-TO-LEFT MARK
  RTL_END   = "\u202E".freeze  # LEFT-TO-RIGHT MARK
  BIDI_START = "\u202B".freeze # RIGHT-TO-LEFT EMBEDDING (RLE)
  BIDI_END   = "\u202C".freeze # POP DIRECTIONAL FORMATTING (PDF)

  # Html wrapping tags
  # http://www.w3.org/International/questions/qa-bidi-unicode-controls#correspondance
  BDO_OPEN  = '<bdo dir="rtl">'.freeze
  BDO_CLOSE = '</bdo>'.freeze
  BDE_OPEN  = '<bde dir="rtl">'.freeze
  BDE_CLOSE = '</bde>'.freeze

  STRIP_TAGS_REGEX = /<.*?>/.freeze # Strip any html tag, with or without attributes

  # Wrap plain text or html in direction control unicode characters or tags
  #
  # If the string is detected as all RTL characters it will be bordered with
  # directional override characters. If it has mixed RTL and LTR it will get
  # wrapped with bi-directional override characters.
  #
  # If the `html: true` option is passed the string will get wrapped in either
  # a <bdo></bdo> or <bde></bde> tag.
  def with_rtl(options = {})
    return with_rtl_html(options) if options.delete(:html)

    case direction
    when StringDirection::RTL
      "#{RTL_START}#{self}#{RTL_END}"
    when StringDirection::BIDI
      "#{BIDI_START}#{self}#{BIDI_END}"
    else
      self
    end
  end

  # Modifies self with the result from `with_rtl`
  def with_rtl!(options = {})
    self.replace with_rtl(options)
  end

  private

  # Evaluate the direction of text in an HTML blob by first removing the HTML
  # tags, then checking the plain text, then returning a wrapped blob of HTML
  def with_rtl_html(options = {})
    plain_text = self.gsub(STRIP_TAGS_REGEX, '')

    case plain_text.direction
    when String::Direction::RTL
      "#{BDO_OPEN}#{self}#{BDO_CLOSE}"
    when StringDirection::BIDI
      "#{BDE_OPEN}#{self}#{BDE_CLOSE}"
    else
      self
    end
  end
end
