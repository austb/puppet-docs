module Jekyll
  module Tags
    class MarkdownBlock < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
        @prefix = ""
        @suffix = ""
      end

      def render(context)
        md_converter = context.registers[:site].converters.select {|c| c.matches('.md')}.first
          # Found that bit via Jekyll::Renderer's converters method.
        block_contents = super.to_s
          # IDK why you'd need to_s on a string, but the highlight tag does it, so we will too.

        output = md_converter.convert(block_contents)
        @prefix + output + @suffix
      end
    end

    class CollapseBlock < MarkdownBlock
      def initialize(tag_name, markup, tokens)
        super
        @prefix = "opening tag(s) for collapse code goes here"
        @suffix = "closing tag(s) here"
      end
    end

  end
end

# This is where we set the UI names for our tags. Setting that first one to 'md' means we'll call it as {% md %} ... {% endmd %}
Liquid::Template.register_tag('md', Jekyll::Tags::MarkdownBlock)
Liquid::Template.register_tag('collapse', Jekyll::Tags::CollapseBlock)