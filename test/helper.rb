ENV['DATA_MODEL'] ||= 'omopv4'

require_relative 'db'

if ENV['COVERAGE']
  require 'coverage'
  require 'simplecov'

  ENV.delete('COVERAGE')
  SimpleCov.instance_exec do
    start do
      add_filter "/test/"
      add_group('Missing'){|src| src.covered_percent < 100}
      add_group('Covered'){|src| src.covered_percent == 100}
      yield self if block_given?
    end
  end
end

$: << "lib"
require 'conceptql'
require 'minitest/spec'
require 'minitest/autorun'

require 'logger'
require 'pp'
require 'fileutils'

CDB = ConceptQL::Database.new(DB, :data_model=>ENV['DATA_MODEL'].to_sym)
DB.extension :error_sql

#ENV["OVERWRITE_CONCEPTQL_TEST_RESULTS"] = '1'

class Minitest::Spec
  def annotate(test_name, statement)
    load_check(test_name, statement){|statement| query(statement).annotate}
  end

  def scope_annotate(test_name, statement)
    load_check(test_name, statement){|statement| query(statement).scope_annotate}
  end

  def domains(test_name, statement)
    load_check(test_name, statement){|statement| query(statement).domains}
  end

  def query(statement)
    CDB.query(statement)
  end

  def dataset(statement)
    statement = query(statement) unless statement.is_a?(ConceptQL::Query)
    statement.query
  end

  def count(test_name, statement)
    load_check(test_name, statement){|statement| dataset(statement).count}
  rescue
    puts $!.sql if $!.respond_to?(:sql)
    raise
  end

  def criteria_ids(test_name, statement)
    load_check(test_name, statement){|statement| hash_groups(statement, :criterion_domain, :criterion_id)}
  end

  # If no statement is passed, this function loads the statement from the specified test
  # file. If a statement is passed, it is written to the file.
  def load_statement(test_name, statement=nil)
    statementPath = "test/statements/#{test_name}"
    if statement
      jsonStatement = JSON.generate(statement)
      FileUtils.mkdir_p(File.dirname(statementPath))
      File.open(statementPath, 'w') { |file| file.write(jsonStatement) }
      return statement
    else
      File.open(statementPath, 'r') { |file| statement = file.read }
      return JSON.parse(statement)
    end
  end

  def check_output(test_name, results)
    actualOutput = JSON.generate(results)
    expectedOutputPath = "test/results/#{ENV["DATA_MODEL"]}/#{test_name}"
    if ENV["OVERWRITE_CONCEPTQL_TEST_RESULTS"]
      FileUtils.mkdir_p(File.dirname(expectedOutputPath))
      File.open(expectedOutputPath, 'w') { |file| file.write(actualOutput) }
    else
      File.open(expectedOutputPath, 'r') do |file|
        expectedOutput = file.read
        actualOutput.must_equal(expectedOutput)
      end
    end
    results
  end

  def numeric_values(test_name, statement)
    load_check(test_name, statement){|statement| hash_groups(statement, :criterion_domain, :value_as_number)}
  end

  def criteria_counts(test_name, statement)
    load_check(test_name, statement){|statement| query(statement).query.from_self.group_and_count(:criterion_domain).to_hash(:criterion_domain, :count)}
  end

  def optimized_criteria_counts(test_name, statement)
    load_check(test_name, statement){|statement| query(statement).optimized.query.from_self.group_and_count(:criterion_domain).to_hash(:criterion_domain, :count)}
  end

  def hash_groups(statement, key, value)
    dataset(statement).from_self.distinct.order(*value).to_hash_groups(key, value)
  rescue
    puts $!.sql if $!.respond_to?(:sql)
    raise
  end

  def load_check(test_name, statement)
    check_output(test_name, yield(load_statement(test_name, statement)))
  end

  def log
    DB.loggers << Logger.new($stdout)
    yield
  ensure
    DB.loggers.clear
  end
end
