require 'spec_helper'

describe Datagrid::Drivers::ActiveRecord do

  describe ".match?" do
    subject { described_class }

    it {should be_match(Entry)}
    it {should be_match(Entry.scoped)}
    it {should_not be_match(MongoidEntry)}
  end

  it "should convert any scope to AR::Relation" do
    subject.to_scope(Entry).should be_a(ActiveRecord::Relation)
    subject.to_scope(Entry.limit(5)).should be_a(ActiveRecord::Relation)
    subject.to_scope(Group.create!.entries).should be_a(ActiveRecord::Relation)
  end

  it "should support append_column_queries" do
    scope = subject.append_column_queries(Entry.scoped, [Datagrid::Columns::Column.new(SimpleReport, :sum_group_id, 'sum(entries.group_id)')])
    scope.to_sql.strip.should == 'SELECT "entries".*, sum(entries.group_id) AS sum_group_id FROM "entries"'
  end
end
