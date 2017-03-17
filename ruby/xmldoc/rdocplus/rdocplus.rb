require 'pp'

require 'rdoc/rdoc'
require 'rexml/document'

require 'rdocplus/html_output_stream'
require 'rdocplus/css_output_stream'
require 'rdocplus/extensions'

module RDocPlus

  VERSION = '1.0'

  class RDP_Module
    def initialize(id, name, infiles, description=nil, mixins=nil, methods=nil)
      @id = id
      name_parts = name.split('::')
      @name = name_parts.pop
      @namespace = name_parts.join('::')
      @infiles = infiles
      @mixins = mixins || []
      @description = description
      @methods = methods || []
    end

    def self.parse(elem)
      print_progress('M') if $rdp_verbose

      id = nil
      name = nil
      infiles = {}
      mixins = []
      methods = []

      id = elem.attributes['id']
      name = elem.attributes['name']
      info_elem = elem.elements['classmod-info']
      infiles_elem = info_elem.elements['infiles']
      REXML::XPath.match(infiles_elem, 'infile').each do |infile_elem|
        infile_elem.each_element do |e|
          file_id = e.attributes['href']
          infiles[file_id] = e.text.to_s
        end
      end

      contents_elem = elem.elements['contents']
      mixins_elem = contents_elem.elements['included-module-list']
      if mixins_elem
        mixins_elem.each_element{|e| mixins << e.attributes['name'] }
      end

      description_elem = elem.elements['description']
      description = description_elem && description_elem.elements.to_a

      methods_elem = contents_elem.elements['method-list']
      if methods_elem
        methods_elem.each_element do |e|
          method = RDP_Method.parse(e)
          methods << method
        end
      end
      new(id, name, infiles, description, mixins, methods)
    end

    attr_reader :id, :name, :namespace, :infiles, :description, :mixins, :methods

    def fully_qualified_name
      @namespace + '::' + @name
    end

    def href
      (['.'] + fully_qualified_name.split('::')).join_path + '.html'
    end

    def namespace_href
      (['.'] + @namespace.split('::')).join_path + '.html'
    end

    def type
      'Module'
    end

    def <=>(other)
      [@namespace, type, @name] <=> [other.namespace, other.type, other.name]
    end
    include Comparable
  end

  class RDP_Class < RDP_Module
    def initialize(id, name, infiles, description=nil, superclass=nil, mixins=nil, methods=nil)
      super(id, name, infiles, description, mixins, methods)
      @superclass = superclass
    end

    def self.parse(elem)
      print_progress('C') if $rdp_verbose

      id = nil
      name = nil
      superclass = nil
      infiles = {}
      mixins = []
      methods = []

      id = elem.attributes['id']
      name = elem.attributes['name']
      info_elem = elem.elements['classmod-info']

      infiles_elem = info_elem.elements['infiles']
      REXML::XPath.match(infiles_elem, 'infile').each do |infile_elem|
        infile_elem.each_element do |e|
          file_id = e.attributes['href']
          infiles[file_id] = e.text.to_s
        end
      end

      superclass_elem = info_elem.elements['superclass']
      if superclass_elem
        superclass_elem.each_element_with_text{|t| superclass = t.text }
      end

      contents_elem = elem.elements['contents']
      mixins_elem = contents_elem.elements['included-module-list']
      if mixins_elem
        mixins_elem.each_element{|e| mixins << e.attributes['name'] }
      end

      description_elem = elem.elements['description']
      description = description_elem && description_elem.elements.to_a

      methods_elem = contents_elem.elements['method-list']
      if methods_elem
        methods_elem.each_element do |e|
          method = RDP_Method.parse(e)
          methods << method
        end
      end
      new(id, name, infiles, description, superclass, mixins, methods)
    end

    attr_reader :superclass

    def type
      'Class'
    end
  end

  class RDP_Constant
  end

  class RDP_Method
    def initialize(id, name, type, category, parameters, description=nil, listing=nil)
      @id, @name, @type, @category, @parameters = id, name, type, category, parameters
      @description, @listing = description, listing
    end

    def self.parse(elem)
      print_progress('.') if $rdp_verbose

      id = elem.attributes['id']
      name = elem.attributes['name']
      type = elem.attributes['type']
      category = elem.attributes['category']
      parameters = elem.elements['parameters'].text
      description_elem = elem.elements['description']
      description = description_elem && description_elem.elements.to_a
      listing_elem = elem.elements['source-code-listing']
      listing = listing_elem && listing_elem.elements.to_a
      new(id, name, type, category, parameters, listing)
    end
  end


  class DocFile
    #---------------------------------------------------
    # Constructors
    #------------------------------------------------ ++

    def initialize(documentation, ostream, path)
      @documentation = documentation
      @ostream = ostream
      @path = File.join(@documentation.directory, path)
    end

    #---------------------------------------------------
    # Accessors
    #------------------------------------------------ ++

    attr_writer :title

    def path(from=nil)
      if from.nil?
        @path
      else
        Directory.relative(from, @path)
      end
    end

    #---------------------------------------------------
    # Commands
    #------------------------------------------------ ++

    def output
      STDERR.puts format('-> %s', path)
      o = @ostream.new
      output_file(o)
      o.write(path)
    end
  end


  class CSSFile < DocFile
    def initialize(documentation, path)
      super(documentation, CSSOutputStream, path)
    end

    def output_file(o)
      o.append(<<-END_CSS)
body {
	margin: 0px;
	padding: 0px;
	color: #000;
	background-color: #fff;
	font-size: 90%;
	font-family: verdana, arial, helvetica, Sans-Serif;
}

.top {
}

.title {
	background-color: #8e2400;
	color: white;
	padding: 10px;
	margin: 0px;
}

.title h1 {
	margin: 0px;
	padding: 0px;
	margin-top: 20px;
}

.nav {
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;

	color: #8e2400;
	background-color: #fff1ec;

    border-bottom-style: dashed;
    border-bottom-color: #ff9999;
	border-bottom-width: 1px;
}

.body {
	padding-left: 10px;
	padding-right: 10px;
}

a {
	color: #ea3a00;
	background-color: transparent;
	text-decoration: underline;
}

a:visited {
	color: #c63200;
	background-color: transparent;
}

a:hover {
	color: #ff6835;
	background-color: transparent;
	text-decoration: underline;
}

table.files td, table.classes td, table.modules td {
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 3px;
	padding-bottom: 3px;
}

table .even {
	background-color: #fff1ec;
}

table .headings * {
	font-weight: bold;
	background-color: #c63200;
	color: white;
}

table .name { font-weight: bold; }
table .desc { font-style: italic; }
.mixins a { font-weight: bold; }
table .namespace a { font-weight: bold; }

.footer {
    border-top-style: dashed;
    border-top-color: #ff9999;
	border-top-width: 1px;

	margin-top: 4em;
	padding-left: 10px;
	padding-top: 10px;
	text-align: left;
	line-height: 20px;
}

.footer a {
	margin-top: 50px;
	text-align: right;
	text-decoration: none;
}

.method-alphabet {
	margin: 1em;
}

.features dt {
	font-family: monospace;
}

.features dd {
	padding-bottom: 1em;
}

.features dl {
	padding: 0px;
	margin: 0px;
}

.features h4 {
	margin-top: 0px;
}

dt {
	font-weight: bold;
}

h2,h3,h4,h5, .heading { font-weight: bold; font-style: italic; font-family: "times new roman", serif; }
h1 { font-size: 200%; }
h2 { font-size: 150%; }
h3 { font-size: 125%; }
h4 { font-size: 112%; }

.classormodule {
	font-size: 90%;
	font-weight: normal;
}

a.source {
	text-decoration: none;
}

.id {
	font-family: monospace;
}

.id a {
	text-decoration: none;
}
      END_CSS
    end
  end


  class HTMLPage < DocFile
    def initialize(documentation, title, path)
      super(documentation, HTMLOutputStream, path)
      @title = title
    end

    def full_title
      @documentation.title + ': ' + @title
    end

    attr_reader :title

    def output_file(o)
      o.doctype_xhtml1strict('utf-8', 'en', 'en') do
        o.head do
          o.title { o.text full_title }
          o.tag 'meta', 'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'
          o.nl
          o.tag 'link', :href => @documentation.css_file.path(path), :rel => 'stylesheet', :type => 'text/css'
          o.nl
        end
        o.body do

          o.div(:class => :top) do
            o.div(:class => :title) do
              o.h 1, @documentation.title
            end
            o.div(:class => :nav) do
              nav_items = @documentation.nav_items.map do |p|
                if p == self
                  p.title
                else
                  format('<a href="%s">%s</a>', p.path(path), p.title)
                end
              end.join(' | ')
              o.append nav_items
            end
          end

          o.div(:class => :body) do
            o.h 2, @title
            output_html(o)
          end

          o.div(:class => :footer) do
            o << '<a href="http://rdoc.sourceforge.net"><img align="middle" border="0" src="ruby-16x16b.png" alt="Ruby"> Generated on ' + @documentation.timestamp.to_s + ' by RDocPlus ' + RDocPlus::VERSION + '</a><br/>'
            o << '<a href="http://www.ruby-lang.org"><img align="middle" border="0" src="ruby-16x16b.png" alt="Ruby"> Powered by Ruby ' + RUBY_VERSION + '</a>'
          end
        end
      end
    end
  end

  class IndexPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Index', path)
    end

    def output_html(o)
      o.p do
        o.text 'This page was generated from RDoc XML output.'
      end
    end
  end

  class ClassesAndModulesPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Classes and Modules', path)
    end

    def output_html(o)
      o.table :class => :classes do
        o.tr :class => :headings do
          o.td { o.text 'Namespace' }
          o.td { o.text 'Type' }
          o.td { o.text 'Name' }
          o.td { o.text 'Description' }
        end
        @documentation.classes_and_modules.each_with_even_odd do |classmod, css_class|
          o.tr :class => css_class do
            o.td(:class => :namespace) { o.a(classmod.namespace_href) { o.text classmod.namespace } }
            o.td(:class => :type) { o.text classmod.type }
            o.td(:class => :name) { o.a(classmod.href) { o.text classmod.name } }
            o.td(:class => :description) { o.append classmod.description }
          end
        end
      end
    end
  end

  class ClassHierarchyPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Class Hierarchy', path)
    end

    def output_html(o)
      o.text "BLAH!"
    end
  end

  class MethodsPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Methods', path)
    end

    def output_html(o)
      o.text "BLAH!"
    end
  end

  class ConstantsPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Constants', path)
    end

    def output_html(o)
      o.text "BLAH!"
    end
  end

  class FilesPage < HTMLPage
    def initialize(documentation, path)
      super(documentation, 'Files', path)
    end

    def output_html(o)
      o.text "BLAH!"
    end
  end

  class Documentation
    def initialize(filename, directory, options=nil)
      options ||= {}
      $rdp_verbose = options[:verbose] == true

      @filename = filename
      @directory = directory
      @author = '<Author>'
      @title = '<Title>'
      @classes = {}
      @modules = {}

      parse(filename)

      @index = IndexPage.new(self, 'index.html')
      @css_file = CSSFile.new(self, 'rdocplus.css')
      @classes_and_modules = ClassesAndModulesPage.new(self, 'classes_and_modules.html')
      @class_hierarchy = ClassHierarchyPage.new(self, 'class_hierarchy.html')
      @methods = MethodsPage.new(self, 'methods.html')
      @constants = ConstantsPage.new(self, 'constants.html')
      @files = FilesPage.new(self, 'files.html')

      @timestamp = Time.now
    end

    def nav_items
      [@index, @classes_and_modules, @class_hierarchy, @methods, @constants, @files]
    end

    #---------------------------------------------------
    # Queries
    #------------------------------------------------ ++

    attr_reader :filename, :directory
    attr_reader :author, :title
    attr_reader :index, :css_file
    attr_reader :timestamp

    def classes
      @classes.values
    end

    def classes_and_modules
      (classes + modules).sort
    end

    def modules
      @modules.values
    end

    def path_root(from=nil)
      if from.nil?
        @directory
      else
        Directory.relative_path(from, @directory)
      end
    end

    #---------------------------------------------------
    # Commands
    #------------------------------------------------ ++

    def add_class(klass)
      @classes[klass.id] = klass
    end

    def add_module(mod)
      @modules[mod.id] = mod
    end

    def parse(filename)
      puts format('Parsing XML document "%s"...', filename) if $rdp_verbose

      xmldoc = nil
      File.open(filename) do |f|
        xmldoc = REXML::Document.new(f)
      end

      parse_classes(xmldoc)
      parse_modules(xmldoc)
    end

    def parse_classes(xmldoc)
      print 'Parsing classes: ' if $rdp_verbose
      xmldoc.elements.each('/rdoc/class-module-list/Class') do |elem|
        klass = RDP_Class.parse(elem)
        add_class(klass)
      end
      puts if $rdp_verbose
    end

    def parse_modules(xmldoc)
      print 'Parsing modules: ' if $rdp_verbose
      xmldoc.elements.each('/rdoc/class-module-list/Module') do |elem|
        mod = RDP_Module.parse(elem)
        add_module(mod)
      end
      puts if $rdp_verbose
    end

    def output
      @index.output
      @css_file.output
      @classes_and_modules.output
      @class_hierarchy.output
      @methods.output
      @constants.output
      @files.output
    end
  end
end
