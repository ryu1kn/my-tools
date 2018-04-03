# coding: UTF-8
rootdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift "#{rootdir}/lib"

if defined? Encoding
  Encoding.default_internal = 'UTF-8'
end

require 'test/unit'
require 'redcarpet'
require 'redcarpet/render_man'
require 'nokogiri'

def html_equal(html_a, html_b)
  assert_equal Nokogiri::HTML::DocumentFragment.parse(html_a).to_html,
    Nokogiri::HTML::DocumentFragment.parse(html_b).to_html
end

class CustomRenderTest < Test::Unit::TestCase
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

  def setup
    # options = {
    #     :no_intra_emphasis  => true,
    #     :superscript        => true,
    #     :fenced_code_blocks => true,
    #     :gh_blockcode       => true,
    #     :escape_html        => true
    #   }
    # @markdown = Redcarpet::Markdown.new(GFMRender, options)
    @markdown = Redcarpet::Markdown.new(GFMRender)
    @original_markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  def render_with(flags, text)
    Redcarpet::Markdown.new(GFMRender, flags).render(text)
  end

  def original_render_with(flags, text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, flags).render(text)
  end

  # ========================
  #  Test for customisation
  def test_link_syntax_is_not_processed_within_code_blocks
    markdown = @markdown.render("    This is a code block\n    This is a link [[1]] inside\n")
    html_equal "<pre class=\"prettyprint\"><code>This is a code block\nThis is a link [[1]] inside\n</code></pre>\n",
      markdown
  end

  def test_that_chevrons_ampersands_and_double_quotations_are_escaped_in_code_blocks
    markdown = @markdown.render("This HTML code (`<em class=\"cool\">Ruby & Rails<em>`) should be escaped.\n")
    html_equal "<p>This HTML code (<code>&lt;em class=&quot;cool&quot;&gt;Ruby &amp; Rails&lt;em&gt;</code>) should be escaped.</p>\n",
      markdown
  end

  def test_that_inline_code_block_can_take_language_specification
    markdown = @markdown.render("You can simply write `#!ruby p array` to print the contents of an array.\n")
    html_equal "<p>You can simply write <code class=\"language-ruby\">p array</code> to print the contents of an array.</p>\n",
      markdown
  end

  def test_that_code_block_can_take_language_specification
    markdown = render_with({:fenced_code_blocks => true}, "```ruby\ndef sayHello\n  puts \"Hello, World!\"\nend\n```\n")
    html_equal "<pre class=\"prettyprint\"><code class=\"language-ruby\">def sayHello\n  puts \"Hello, World!\"\nend\n</code></pre>\n",
      markdown
  end

  def test_that_block_must_have_empty_lines_above_its_beginning
    # "<p>This is a normal paragraph:\n    This is a code block.</p>"
    original_markdown = @original_markdown.render("This is a normal paragraph:\n    This is a code block.")
    markdown = @markdown.render("This is a normal paragraph:\n    This is a code block.")
    html_equal original_markdown, markdown
  end
end
