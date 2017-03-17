require 'cgi'
require 'rdocplus/output_stream'

class String
  def escape_html
    CGI.escapeHTML(self)
  end

  def escape_http
    CGI.escape(self)
  end
end


class HTMLOutputStream < OutputStream
  #-----------------------------------------------------------------
  # Constants
  #-------------------------------------------------------------- ++

  MIME_TYPE = 'text/html'

  #-----------------------------------------------------------------
  # Singleton
  #-------------------------------------------------------------- ++

  def self.add_tag(name)
    method_definition = %{
        def #{name}(*args, &block)
          tag("#{name}", *args, &block)
        end
      }
      module_eval(method_definition)
  end

  def self.add_tags(*names)
    names.each {|name| add_tag(name) }
  end

  def self.add_inline_tags(*names)
    names.each {|name| add_inline_tag(name) }
  end
  
  private_class_method :add_tag, :add_tags, :add_inline_tags
  
  #-----------------------------------------------------------------
  # Constructor
  #-------------------------------------------------------------- ++

  def initialize(parameters=nil)
    super(parameters)
    @form = nil # current form being output
  end

  #-----------------------------------------------------------------
  # Commands
  #-------------------------------------------------------------- ++

  def doctype_xhtml1strict(encoding, inlang, outlang)
    @output << %{<?xml version="1.0" encoding="#{encoding}" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="#{inlang}" lang="#{outlang}">
        }
    yield self
    @output << %{
</html>
      }
  end

  def append(obj)
    @output << obj.to_s
  end

  # Output an HTML tag.
  def tag(name, attrs=nil, &block)
    attrs ||= {}
    if attrs.size > 0
      attrs_str = ' '
      attrs_str << attrs.map{|k,v| "#{k}=\"#{v}\"" }.join(' ')
    else
      attrs_str = ''
    end
    if block.nil?
      @output << "<#{name}#{attrs_str}/>"
    else
      @output << "<#{name}#{attrs_str}>"
      block.call(self)
      @output << "</#{name}>"
    end
  end

  def inline_tag(tag, text, attrs=nil)
    tag(tag, attrs) do
      self.text text
    end
  end

  def hidden(var, val)
    attrs = {:type => :hidden, :name => var, :id => var, :value => val.to_s}
    add_name_to_form(attrs)
    tag(:input, attrs)
    nl
  end

  def hidden_array(var, ary)
    raise ArgumentError, "Value is not enumerable" unless ary.respond_to?(:each)
    add_name_to_form(:name => var)
    ary.each do |val|
      tag(:input, :type => :hidden, :name => var, :id => var, :value => val.to_s)
    end
  end

  def hidden_hash(values)
    values.each do |key, value|
      hidden_array(key, value)
    end
  end

  def form(command=nil, attrs=nil, &block)
    attrs = {
      :action => '/',
      :method => :post,
      :name => command
    }.merge(attrs||{})
    tag(:form, attrs) do
      if !command.nil?
        hidden(:command, command)
      end
      block.call(self)
    end
  end

  def submit(attrs=nil)
    attrs = {
      :type => :submit,
      :class => :button
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
  end

  def reset(attrs=nil)
    attrs = {
      :type => :reset,
      :class => :button
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
  end

  def text_field(attrs=nil)
    attrs = {
      :type => :textfield,
      :class => :text
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
  end

  def password_field(attrs=nil)
    attrs = {
      :type => :password,
      :class => :text
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
  end

  def text(text)
    @output << text.to_s.escape_html
  end

  def textnl(text)
    @output << text.to_s << "\n"
  end

  def img(src, alt_text, attrs=nil)
    attrs = {
      :src => src,
      :alt => alt_text
    }.merge(attrs||{})
    tag(:img, attrs)
  end
  alias :image :img

  def a(href, attrs=nil, &block)
    attrs = {:href => href}.merge(attrs||{})
    tag(:a, attrs, &block)
  end
  alias :link :a

  def a_popup(href, attrs=nil, &block)
    attrs = {:href => "javascript:popupForLinkWindow('#{href}')"}.merge(attrs||{})
    tag(:a, attrs, &block)
  end
  alias :link_popup :a_popup
  
  def dummy_link(attrs=nil, &block)
    attrs = {:href => '#'}.merge(attrs||{})
    tag(:a, attrs, &block)
  end

  # Output a link containing all the current HTTP parameters,
  # overwriting them with those values supplied.
  def relative_link(params, attrs=nil, &block)
    params.each do |k,v|
      params[k.to_s] = params.delete(k)
    end
    params = @parameters.to_hash.merge(params)
    a(Session.http_get_address(params), attrs, &block)
  end

  class Form
    def initialize
      @values = []
    end

    def add(variable)
      #        if @values.include? variable
      #          raise "Form variable '#{variable}' is already defined"
      #        else
      @values.push(variable.to_s)
      #        end
    end

    def values
      @values
    end
  end

  # Output a form containing all the HTTP parameters listed in
  # backup_variables, an array of strings/symbols.
  def relative_form(attrs=nil, &block)
    tag(:form, attrs) do
      @form = Form.new
      block.call(self)
      backup = {}
      (@parameters.to_hash.keys - @form.values).each do |key|
        backup[key] = @parameters.value_array(key)
      end
      hidden_hash(backup)
      @form = nil
    end
  end

  def add_name_to_form(attrs)
    if !@form.nil? and (attrs.key?(:name) or attrs.key?('name'))
      @form.add(attrs[:name] || attrs['name'])
    end
  end

  def h(level, text, attrs=nil)
    tag("h#{level}", attrs){ self.text text }
  end

  def radio(name, value, label=nil, attrs=nil)
    label ||= ''
    attrs = {
      :type => :radio,
      :name => name,
      :value => value
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
    if !label.nil?
      nbsp
      text_nobreaks(label)
    end
  end

  def checkbox(name, value, label=nil, attrs=nil)
    attrs = {
      :type => :checkbox,
      :name => name,
      :value => value
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:input, attrs)
    if !label.nil?
      nbsp
      text_nobreaks(label)
    end
  end

  def button(label, onclick, attrs=nil)
    attrs = {
      :type => :button,
      :value => label,
      :onclick => onclick,
      :class => :button
    }.merge(attrs||{})
    tag(:input, attrs)
  end

  def option(label, name, value, attrs=nil)
    attrs = {
      :name => name.to_s,
      :value => value.to_s
    }.merge(attrs||{})
    tag(:option, attrs)
    text_nobreaks(label)
    br
  end

  def select(name, options, rows=1, attrs=nil)
    attrs = {
      :name => name,
      :id => "select_#{name}",
      :size => rows
    }.merge(attrs||{})
    add_name_to_form(attrs)
    tag(:select, attrs) do
      options.each do |value, label, selected|
        if selected
          option(label, label, value, :selected => 1)
        else
          option(label, label, value)
        end
      end
    end
  end

  def javascript(attrs=nil, &block)
    attrs = {
      :type => 'text/javascript',
      :language => 'JavaScript'
    }.merge(attrs||{})
    if block.nil?
      tag(:script, attrs) do
        # empty
      end
    else
      tag(:script, attrs) do
        text "\n<!--\n"
        block.call(self)
        text "\n// -->\n"
      end
    end
  end

  def non_breaking_space
    text '&nbsp;'
  end
  alias :nbsp :non_breaking_space

  def space
    text ' '
  end

  def text_nobreaks(txt)
    text txt.gsub(/\s+/, '&nbsp;')
  end

  def newline
    text "\n"
  end
  alias :nl :newline

  # Position everything in the block in the absolute centre of the page.
  def dead_centre(width, height, &block)
    div :style => "text-align: center; position: absolute; top: 50%; left: 0px; width: 100%; height: 1px; display: block; overflow: visible;" do
      div :style => "position: absolute; top: -#{height/2}px; left: 50%; margin-left: -#{width/2}px; width: #{width}px; height: #{height}px;" do
        unless block.nil?
          block.call(self)
        end
      end
    end
  end

  def row_head(text, attrs=nil)
    attrs = {:class => :rowhead}.merge(attrs||{})
    td attrs do
      text_nobreaks text
    end
  end

  def row(*args, &block)
    tag('tr', *args, &block)
    newline
  end

  def squish(&block)
    table(:width => '1%') do
      tr do
        td(:style => 'text-align: right'){ block.call(self) }
      end
    end
  end

  add_tags :title
  add_tags :p, :b, :i, :u, :font
  add_tags :html, :head, :body
  add_tags :hr, :br
  add_tags :table, :td, :th, :tr, :caption
  add_tags :div, :span
  add_tags :code, :pre
end
