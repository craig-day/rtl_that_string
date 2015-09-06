require 'string-direction'

module RtlThatString
  # String borders
  # http://www.w3.org/International/questions/qa-bidi-unicode-controls#pairedcontrols
  RTL_MARK = "\u202F".freeze  # RIGHT-TO-LEFT MARK
  LTR_MARK = "\u202E".freeze  # LEFT-TO-RIGHT MARK
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
      rtl_string_borders
    when StringDirection::BIDI
      majority_rtl? ? bidi_string_borders : self
    else
      self
    end
  end

  # Modifies self with the result from `with_rtl`
  def with_rtl!(options = {})
    self.replace with_rtl(options)
  end

  # Evaluate the direction of text in an HTML blob by first removing the HTML
  # tags, then checking the plain text, then returning a wrapped blob of HTML
  def with_rtl_html(options = {})
    plain_text = self.gsub(STRIP_TAGS_REGEX, '')

    case plain_text.direction
    when StringDirection::RTL
      rtl_html_borders
    when StringDirection::BIDI
      plain_text.majority_rtl? ? bidi_html_borders : self
    else
      self
    end
  end

  protected

  def majority_rtl?
    dir_counts = split(' ').each_with_object({}) do |token, h|
      dir = token.direction
      h[dir] ||= 1
      h[dir] += 1
    end

    dir_counts[StringDirection::RTL] > dir_counts[StringDirection::LTR]
  end

  private

  def rtl_string_borders
    prepend(RTL_MARK).concat(LTR_MARK)
  end

  def bidi_string_borders
    prepend(BIDI_START).concat(BIDI_END)
  end

  def rtl_html_borders
    prepend(BDO_OPEN).concat(BDO_CLOSE)
  end

  def bidi_html_borders
    prepend(BDE_OPEN).concat(BDE_CLOSE)
  end
end
