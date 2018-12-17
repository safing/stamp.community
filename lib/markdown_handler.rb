require 'redcarpet'

module MarkdownHandler
  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(template)
    options = {
      fenced_code_blocks: true,
      autolink: true
    }

    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    "#{@markdown.render(template.source).inspect}.html_safe"
  end
end

ActionView::Template.register_template_handler(:md, MarkdownHandler)
