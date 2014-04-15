require 'spec_helper'

module RansackWrap
  describe Search do

    describe '#initialize' do
      it 'does not raise exception for string :params argument' do
        -> { 
          Person.wrap_searcher('')
        }.should_not raise_error
      end
    end

    describe '#build' do
      it 'accept ransack attributes' do
        search = Person.wrap_searcher(name_eq: 'Ernie')
        condition = search.ransack.base[:name_eq]
        condition.should be_a Ransack::Nodes::Condition
        condition.predicate.name.should eq 'eq'
        condition.attributes.first.name.should eq 'name'
        condition.value.should eq 'Ernie'
      end
    end
    
    describe '#result' do
      let(:people_table)               { "#{quote_table_name("people")}" }
      let(:people_name_field)          { "#{quote_table_name("people")}.#{quote_column_name("name")}" }
      let(:people_salary_field)        { "#{quote_table_name("people")}.#{quote_column_name("salary")}" }
      let(:parents_people_name_field)  { "#{quote_table_name("parents_people")}.#{quote_column_name("name")}" }
      let(:children_people_name_field) { "#{quote_table_name("children_people")}.#{quote_column_name("name")}" }
      
      it 'evalutes Ransack attributes' do
        search = Person.wrap_searcher(children_name_eq: 'Ernie')
        search.result.should be_an ActiveRecord::Relation
        search.result.to_sql.should match /#{children_people_name_field} = 'Ernie'/
      end
      
      it 'evalutes Ransack aliased attributes' do
        search = Person.wrap_searcher(in_family_with: 'Ernie')
        search.result.should be_an ActiveRecord::Relation
        search.should respond_to :in_family_with
        search.ransack.should respond_to search.ransack_aliases[:in_family_with]
        search.result.to_sql.should match /#{children_people_name_field} LIKE '%Ernie%'/
        search.result.to_sql.should match /#{parents_people_name_field} LIKE '%Ernie%'/
      end
      
      it 'evalutes Scopes attributes' do
        search = Person.wrap_searcher(only_with_large_salary: true)
        search.result.should be_an ActiveRecord::Relation
        search.result.to_sql.should match /#{people_salary_field} > 40000/
      end
      
      it 'evalutes Ransack alias and Scopes attributes' do
        search = Person.wrap_searcher(in_family_with: 'Ernie', only_with_large_salary: true)
        search.result.should be_an ActiveRecord::Relation
        search.result.to_sql.should match /#{people_salary_field} > 40000/
        search.result.to_sql.should match /#{children_people_name_field} LIKE '%Ernie%'/
        search.result.to_sql.should match /#{parents_people_name_field} LIKE '%Ernie%'/
      end
      
      it 'evalutes Ransack and skips Scopes boolean false attributes' do
        search = Person.wrap_searcher(children_name_eq: 'Ernie', only_with_large_salary: false)
        search.result.should be_an ActiveRecord::Relation
        search.result.to_sql.should match /#{children_people_name_field} = 'Ernie'/
        search.result.to_sql.should_not match /#{people_salary_field} > 40000/
      end
    end
  end
end
