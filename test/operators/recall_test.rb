require_relative '../helper'

describe ConceptQL::Operators::Recall do
  it "should produce correct results" do
    criteria_ids(
      [
        :union,
        [
          "icd9",
          "412",
          {
            "label": "Heart Attack"
          }
        ],
        [
          "recall",
          "Heart Attack"
        ],
      ]
    ).must_equal("condition_occurrence"=>[1712, 1829, 4359, 5751, 6083, 6902, 7865, 8397, 8618, 9882, 10196, 10443, 10865, 13016, 13741, 15149, 17041, 17772, 17774, 18412, 18555, 19736, 20005, 20037, 21006, 21619, 21627, 22875, 22933, 24437, 24471, 24707, 24721, 24989, 25309, 25417, 25875, 25888, 26766, 27388, 28177, 28188, 30831, 31387, 31542, 31792, 31877, 32104, 32463, 32981])

    criteria_ids(
      [
        :except,
        {
          left: [
            "icd9",
            "412",
            {
              "label": "Heart Attack"
            }
          ],
          right: [
            "recall",
            "Heart Attack"
          ],
        }
      ]
    ).must_equal({})
  end
end