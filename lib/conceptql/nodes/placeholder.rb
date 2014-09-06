require_relative 'pass_thru'
require_relative 'recall'

module ConceptQL
  module Nodes
    class Placeholder < PassThru
      def query(db)
        db.from(stream.evaluate(db))
      end

      private
      def name
        arguments.first
      end

      def stream
        r = Recall.new(name)
        r.scope = scope
        r
      end

      def table_name
        @table_name ||= namify(name)
      end
    end
  end
end

