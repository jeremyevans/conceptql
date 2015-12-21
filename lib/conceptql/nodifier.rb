require_relative 'operators/operator'

module ConceptQL
  class Nodifier
    attr :tree, :algorithm_fetcher

    def initialize(tree, opts={})
      @tree = tree
      @algorithm_fetcher = opts[:algorithm_fetcher] || (proc do |alg|
        nil
      end)
    end

    def create(scope, operator, *values)
      if operator.to_s == 'algorithm'
        statement, desc = algorithm_fetcher.call(values.first)   
        raise "Can't find algorithm for '#{values.first}'" unless statement
        tree.send(:start_traverse, statement)
      else
        unless klass = operators[operator.to_s]
          raise "Can't find operator for '#{operator}' in #{operators.keys.sort}"
        end
        operator = klass.new(*values)
        operator.scope = scope
        operator
      end
    end

    def to_metadata
      Hash[operators.map { |k, v| [k, v.to_metadata]}.select { |k, v| v[:desc] }]
    end

    private

    def operators
      Operators.operators
    end
  end
end
