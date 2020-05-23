module RedmineMentions
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      return javascript_include_tag('redmine_mentions.js', :plugin => 'redmine_mentions')
    end
  end
end
