module ConceptQL
  # Scope coordinates the creation of any common table expressions that might
  # be used when a Recall operator is present in the statement.
  #
  # Any time an operator is given a label, it becomes a candidate
  # for a Recall operator to reuse the output of that operator
  # somewhere else in the statement.
  #
  # Scope keeps track of all labeled operators and provides an
  # API for Recall operators to fetch the results/types from
  # labeled operators.
  class Scope
    attr_accessor :person_ids

    attr :known_operators, :recall_stack, :recall_dependencies

    def initialize
      @known_operators = {}
      @recall_dependencies = {}
      @recall_stack = []
    end

    def nest(op)
      return yield unless label = op.is_a?(Operators::Recall) ? op.source : op.label
      begin
        recall_dependencies[label] ||= []
        if last = recall_stack.last
          recall_dependencies[last] << label
        end
        recall_stack.push(label)
        yield
      ensure
        recall_stack.pop if recall_stack.last == label
      end
    end

    def add_operator(operator)
      known_operators[operator.label] = operator
    end

    def from(db, label)
      ds = db.from(label)

      if ENV['CONCEPTQL_CHECK_COLUMNS']
        # Work around requests for columns by operators.  These
        # would fail because the CTE would not be defined.  You
        # don't want to define the CTE normally, but to allow the
        # columns to still work, send the columns request to the
        # underlying operator.
        op = fetch_operator(label)
        (class << ds; self; end).send(:define_method, :columns) do
          (@main_op ||= op.evaluate(db)).columns
        end
      end

      ds
    end

    def types(label)
      fetch_operator(label).types
    end

    def sort_ctes(sorted, unsorted, deps)
      if unsorted.empty?
        return sorted
      end

      add, unsorted = unsorted.partition do |label, _|
        deps[label].length == 0
      end

      sorted += add

      new_deps = {}
      deps.map do |label, deps|
        new_deps[label] = deps - sorted.map(&:first)
      end

      sort_ctes(sorted, unsorted, new_deps)
    end

    def with_ctes(query, db)
      ctes = sort_ctes([], known_operators, recall_dependencies)

      ctes.each do |label, operator|
        query = query.with(label, operator.evaluate(db))
      end

      query
    end

    private

    def fetch_operator(label)
      known_operators[label] || raise("No operator with label: '#{label}'")
    end
  end
end
