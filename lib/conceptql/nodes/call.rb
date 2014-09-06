require_relative 'pass_thru'

module ConceptQL
  module Nodes
    class Call < PassThru
      def query(db)
        stream(db)
      end

      private

      def func
        scope.functions(name)
      end

      def stream(db)
        func.call(db, scope, children)
      end

      def name
        arguments.first
      end
    end
  end
end

