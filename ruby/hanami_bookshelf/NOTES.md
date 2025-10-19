- Why are views and actions different?
  - Actions are controllers handling HTTP requests, OK sure, why didn't we call them controllers but OK
  - Views are sets of functions available (via `expose`) to templates, like Phoenix views I guess, but they seem so verbose...

- Is a repo meant to be a gateway to the persistence layer? It doesn't encapsulate it if it's returning relation objects though?

- So many separate files called index.rb, like index.js everywhere in JS projects :(

- Why is there SO MUCH metaprogramming?
  - Repo knows what `books` is magically
  - Deps[] what is Deps? `Dry::AutoInject::Builder`? It defines... accessor methods? Was Zeitwerk no good? Ah it lets you do `MyClass.new(my_dependency: ...)` conveniently... but it's so ... ugly.
  - Is books_repo memoized? How do I know this? ... Had to read the source code of dry-auto_inject :(
  - How does 'repos.book_repo' get added? Is that a pathname? Then why not 'repos/book_repo'?

  Less DSLy way?

  ```rb
  class Index < Bookshelf::View
    dependencies [
      { path: 'repos/book_repo' },
      { path: 'repos/book_repo', instance_name: :repo },
      { path: 'repos/book_repo', new: -> { Repos::BookRepo.new(x: 1, y: 2) } },
    ]
  end

  # POR?

  class Index < Bookshelf::View
    attr_reader :book_repo
    attr_reader :other_dep

    def initialize(book_repo: Default.instance(:book_repo), other_dep: Default.instance(:other_dep))
      @book_repo = book_repo
      @other_dep = other_dep
    end
  end

  # ----------------------------------------------------------------------
  # OOP considered harmful?

  # lib/bookshelf.rb

  module Bookshelf
    include Ume::Module

    def books_in_order
      DB::Books.order(DB::Books[:title].asc)
    end

    def find_book(id:)
      DB::Books.find(id)
    end
  end

  # or if you want, lib/bookshelf/books.rb

  module Bookshelf::Books
    include Ume::Module

    def find(id:)
      DB::Books.find(id)
    end

    def in_order
      DB::Books.order(DB::Books[:title].asc)
    end
  end

  # lib/bookshelf/db.rb

  module Bookshelf::DB
    include Ume::DB # migration functions

    # Allow the OOP ORM a class, where we strictly need it
    class Books < Bookshelf::DB::Relation
      schema :books, infer: true
    end
  end

  # lib/bookshelf/web.rb

  module Bookshelf::Web
    include Ume::Web

    get '/books', to: Controllers::BooksController.method(:index)
    get '/books/:id', to: Controllers::BooksController.method(:show)
  end

  # lib/bookshelf/web/controllers/books_controller.rb

  module Bookshelf::Web::Controllers::BooksController
    include Ume::Controller

    rescue_from DB::NotFound do |request:, response:, error:|
      response.render_error error
    end

    def index(request:, response:)
      response.render_view Index
    end

    def show(request:, response:)
      response.render_view Show
    end

    module Index
      include Ume::View
      template_path 'books/index.erb'
      let(:books) { Bookshelf.books_in_order }
    end

    module Show
      include Ume::View
      let(:book) { Bookshelf.find_book(id: params[:id]) }

      # inline if you want
      template_erb <<~ERB
        <h1><%= book[:title] %></h1>
      ERB
    end
  end
  ```

  ```html
  <# lib/bookshelf/web/templates/books/index.erb #>
  <ul>
    <% books.each do |book| %>
      <li><a href="/books/<%= book[:id] %>"><%= book[:title] %>, by <%= book[:author] %></a>
    <% end %>
  </ul>
  ```

