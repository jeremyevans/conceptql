require_relative "../../helper"

describe ConceptQL::DateAdjuster do
  describe ".adjust" do
    let(:op) do
      op = Minitest::Mock.new
      op.expect :rdbms, rdbms
      op
    end

    let(:rdbms) do
      class Rd
        def cast_date(arg)
          arg
        end
      end
      Rd.new
    end

    let(:da) do
      Sequel.extension :date_arithmetic
      ConceptQL::DateAdjuster.new(op, str)
    end

    let(:db) do
      Sequel.mock(host: :postgres)
    end

    describe "with days" do
      let(:str) { "6d" }

      it "should work with days" do
        da.adjust(:start_date).interval.must_equal({days: 6})
      end
    end

    describe "with weeks" do
      let(:str) { "6w" }

      it "should work with weeks" do
        da.adjust(:start_date).interval.must_equal({days: 42})
      end
    end

    describe "with months" do
      let(:str) { "6m" }

      it "should work with months" do
        da.adjust(:start_date).interval.must_equal({months: 6})
      end
    end

    describe "with years" do
      let(:str) { "6y" }

      it "should work with years" do
        da.adjust(:start_date).interval.must_equal({years: 6})
      end
    end

    describe "with no digit" do
      let(:str) { "dwmy" }

      it "should pick out each interval" do
        da.adjustments.must_equal([[:days, 1], [:weeks, 1], [:months, 1], [:years, 1]])
      end
    end

    describe "with minuses and no digit" do
      let(:str) { "-dw-my" }

      it "should only subtract days and months" do
        da.adjustments.must_equal([[:days, -1], [:weeks, 1], [:months, -1], [:years, 1]])
      end
    end

    describe "with repeated characters" do
      let(:str) { "ddd" }

      it "should add 3 days" do
        da.adjustments.must_equal([[:days, 1], [:days, 1], [:days, 1]])
      end
    end
  end
end


