# :enddoc:

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

class Person < ActiveRecord::Base
  if ActiveRecord::VERSION::MAJOR == 3
    default_scope order('id DESC')
  else
    default_scope { order(id: :desc) }
  end
  belongs_to :parent, class_name: 'Person', foreign_key: :parent_id
  has_many   :children, class_name: 'Person', foreign_key: :parent_id
  has_many   :articles
  has_many   :comments
  has_many   :authored_article_comments, through: :articles,
              source: :comments, foreign_key: :person_id
  has_many   :notes, as: :notable
  
  scope :with_large_salary, -> {
    where("\"people\".\"salary\" > ?", 40000)
  }
end

class Article < ActiveRecord::Base
  belongs_to              :person
  has_many                :comments
  has_and_belongs_to_many :tags
  has_many                :notes, as: :notable
end

class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :person
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles
end

class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true
end

module Schema
  def self.create
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :people, force: true do |t|
        t.integer  :parent_id
        t.string   :name
        t.string   :email
        t.string   :only_search
        t.string   :only_sort
        t.string   :only_admin
        t.integer  :salary
        t.boolean  :awesome, default: false
        t.timestamps
      end

      create_table :articles, force: true do |t|
        t.integer :person_id
        t.string  :title
        t.text    :body
      end

      create_table :comments, force: true do |t|
        t.integer :article_id
        t.integer :person_id
        t.text :body
      end

      create_table :tags, force: true do |t|
        t.string :name
      end

      create_table :articles_tags, force: true, id: false do |t|
        t.integer :article_id
        t.integer :tag_id
      end

      create_table :notes, force: true do |t|
        t.integer :notable_id
        t.string :notable_type
        t.string :note
      end
    end

    10.times do
      person = Person.make
      Note.make(notable: person)
      3.times do
        article = Article.make(person: person)
        3.times do
          article.tags = [Tag.make, Tag.make, Tag.make]
        end
        Note.make(notable: article)
        10.times do
          Comment.make(article: article, person: person)
        end
      end
    end

    Comment.make(body: 'First post!', article: Article.make(title: 'Hello, world!'))
  end
end