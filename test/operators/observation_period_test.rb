require_relative '../helper'

describe ConceptQL::Operators::ObservationPeriod do
  it "should produce correct results" do
    criteria_ids(
      [:observation_period, [:icd9, '412']]
    ).must_equal("observation_period"=>[1])

    criteria_ids(
      [:observation_period, [:gender, 'Male']]
    ).must_equal("observation_period"=>[1])

    criteria_ids(
      [:observation_period, [:gender, 'Female']]
    ).must_equal({})
  end

  it "should handle errors when annotating" do
    query(
      [:observation_period, [:icd9, '412'], [:gender, 'Male']]
    ).annotate.must_equal(
      ["observation_period",
       ["icd9", "412", {:annotation=>{:condition_occurrence=>{:rows=>50, :n=>38}}, :name=>"ICD-9 CM"}],
       ["gender", "Male", {:annotation=>{:person=>{:rows=>126, :n=>126}}}],
       {:annotation=>{:errors=>[["has multiple upstreams"]]}}]
    )

    query(
      [:observation_period, 1, [:gender, 'Male']]
    ).annotate.must_equal(
      ["observation_period",
       ["gender", "Male", {:annotation=>{:person=>{:rows=>126, :n=>126}}}],
       1,
       {:annotation=>{:errors=>[["has arguments"]]}}]
    )
  end
end
