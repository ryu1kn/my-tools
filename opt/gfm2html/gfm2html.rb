#!/usr/bin/env ruby

require 'redcarpet'

class GFMRender < Redcarpet::Render::HTML
  def block_code(code, language)
    %Q{<pre class="prettyprint">#{inline_code(code, language)}</pre>\n}
  end
 
  def codespan(code)
    /^#!(\S+)\s([\s\S]*)/ =~ code
    if $2 then
      inline_code($2, $1)
    else
      inline_code(code, $1)
    end
  end
 
  def inline_code(code, language)
    if specified?(language) then
      %Q{<code class="language-#{language}">#{escape_html(code)}</code>}
    else
      "<code>#{escape_html(code)}</code>"
    end
  end

  def escape_html(text)
    text.gsub(/[<>&"]/,
                "<" => "&lt;",
                ">" => "&gt;",
                "&" => "&amp;",
                '"' => "&quot;")
  end

  def specified?(attribute)
    return false if attribute.nil?
    return false if attribute.empty?
    return true
  end
end

def main()
  input = String.new
  $stdin.each do |line|
    input += line
  end

  options = {
      :no_intra_emphasis  => true,
      :superscript        => true,
      :fenced_code_blocks => true,
      :gh_blockcode       => true,
      :escape_html        => true
    }
  markdown = Redcarpet::Markdown.new(GFMRender, options)
  puts markdown.render(input)
end

main()

