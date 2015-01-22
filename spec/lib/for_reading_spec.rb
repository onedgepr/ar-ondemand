require 'spec_helper'
require 'ar-ondemand'

describe 'ForReading' do
  context 'Testing' do
    context 'Ensure Persistance Works' do
      before(:each) do
        create(:audit_record)
      end

      it 'should do persist' do
        AuditRecord.all.length.should eq(1)
      end

      it 'should do foo' do
        AuditRecord.first.action.should eq('create')
      end
    end

    context 'Iterating' do
      before(:each) do
        (1..100).each do
          create(:audit_record)
        end
      end

      it 'should support iterating' do
        total = 0
        AuditRecord.where(customer_id: 1).for_reading.each do |r|
          total += 1
        end
        total.should eq(100)
      end

      it 'should produce same results as regular iterating' do
        records_a = Set.new
        AuditRecord.where(customer_id: 1).for_reading.each do |r|
          records_a.add r.id
        end

        records_b = Set.new
        AuditRecord.where(customer_id: 1).each do |r|
          records_b.add r.id
        end

        records_a.should eq(records_b)
      end

    end
  end
end