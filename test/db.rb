require 'sequelizer'

DB = Object.new.extend(Sequelizer).db unless defined?(DB)


if %w(omopv4 omopv4_plus).include?(ENV['DATA_MODEL']) && !DB.table_exists?(:source_to_concept_map)
  $stderr.puts <<END
The source_to_concept_map table doesn't exist in this database,
so it appears this doesn't include the necessary OMOP vocabulary
data. Please review the README for how to setup the test database
with the vocabulary, which needs to be done before running tests.
END
  exit 1
end

if DB.opts[:database] && DB.opts[:database] !~ /test/
  $stderr.puts <<END
The test database name doesn't include the substring "test".
Exiting now to avoid potential modification of non-test database.
Please rename your test database to include the substring "test".
END
  exit 1
end

