require_relative 'binary_operator_operator'

module ConceptQL
  module Operators
    class Filter < BinaryOperatorOperator
      register __FILE__

      desc 'If a result in the left hand results (LHR) has a corresponding result in the right hand results (RHR) with the same person, criterion_id, and criterion_domain, it is passed through.'
      default_query_columns

      def query(db)
        rhs = right.evaluate(db)
        rhs = rhs.from_self.select_group(:person_id, :criterion_id, :criterion_domain)
        query = db.from(Sequel.as(left.evaluate(db), :l))
        query = query
          .left_join(Sequel.as(rhs, :r), l__person_id: :r__person_id, l__criterion_id: :r__criterion_id, l__criterion_domain: :r__criterion_domain)
          .exclude(r__criterion_id: nil)
          .select_all(:l)
        db.from(query)
      end
    end
  end
end

