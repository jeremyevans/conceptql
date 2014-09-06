require_relative 'pass_thru'
require_relative 'define'

module ConceptQL
  module Nodes
    class Func < PassThru
      def evaluate(db)
        db.from(:person)
      end

      def scope=(s)
        @scope = s
        @scope.add_func(name, self)
        @child_scope = Scope.new(s)
        children.each { |c| c.scope = @child_scope }
      end

      def call(db, parent_scope, args)
        raise "Expected #{arguments.length - 1}, got #{args.length}" unless args.length == arguments.length - 1
        # This gets us a fresh execution scope
        self.scope = parent_scope
        args.length.times do |index|
          name = arguments[index + 1]
          child = args[index]
          d = Define.new(name, child)
          d.scope = child_scope
        end
        children.map { |c| c.evaluate(db) }.last.from_self
      end

      private
      attr :child_scope

      def name
        arguments.first
      end
    end
  end
end

