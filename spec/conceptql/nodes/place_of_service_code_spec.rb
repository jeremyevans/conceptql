require 'spec_helper'
require 'conceptql/operators/place_of_service_code'

describe ConceptQL::Operators::PlaceOfServiceCode do
  it_behaves_like(:evaluator)

  describe '#query' do
    it 'works for 23' do
      correct_query = "SELECT * FROM visit_occurrence AS v INNER JOIN vocabulary.concept AS vc ON (vc.concept_id = v.place_of_service_concept_id) WHERE ((vc.concept_code IN ('23')) AND (vc.vocabulary_id = 14))"
      expect(ConceptQL::Operators::PlaceOfServiceCode.new('23').query(Sequel.mock).sql).to eq(correct_query)
    end

    it 'works for 23 as number' do
      correct_query = "SELECT * FROM visit_occurrence AS v INNER JOIN vocabulary.concept AS vc ON (vc.concept_id = v.place_of_service_concept_id) WHERE ((vc.concept_code IN ('23')) AND (vc.vocabulary_id = 14))"
      expect(ConceptQL::Operators::PlaceOfServiceCode.new(23).query(Sequel.mock).sql).to eq(correct_query)
    end

    it 'works for multiple values' do
      correct_query = "SELECT * FROM visit_occurrence AS v INNER JOIN vocabulary.concept AS vc ON (vc.concept_id = v.place_of_service_concept_id) WHERE ((vc.concept_code IN ('23', '22')) AND (vc.vocabulary_id = 14))"
      expect(ConceptQL::Operators::PlaceOfServiceCode.new('23', '22').query(Sequel.mock).sql).to eq(correct_query)
    end
  end
end

