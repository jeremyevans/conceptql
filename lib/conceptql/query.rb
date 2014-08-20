require 'psych'
require_relative 'tree'

module ConceptQL
  class Query
    attr :statement
    def initialize(db, statement, tree = Tree.new)
      @db = db
      @statement = statement
      @tree = tree
    end

    def queries
      build_query(db)
    end

    def query
      queries.last
    end

    def sql
      queries.map(&:sql).join(";\n") + ';'
    end

    # To avoid a performance penalty, only execute the last
    # SQL statement in an array of ConceptQL statements so that define's
    # "create_table" SQL isn't executed twice
    def execute
      query.all
    end

    def types
      tree.root(self).last.types
    end

    private
    attr :yaml, :tree, :db

    def build_query(db)
      tree.root(self).map { |n| n.evaluate(db) }
    end
  end
end
