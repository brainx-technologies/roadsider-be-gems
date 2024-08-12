describe Serializer::Core do
  describe '.serialize!' do
    let!(:object) { create(:record_with_relations) }
    subject {
      if options.present?
        Serializer.send(:serialize, object, root: root, attribute_names: attribute_names, **(options))
      else
        Serializer.send(:serialize, object, root: root, attribute_names: attribute_names)
      end
    }

    context 'with empty or nil attribute names' do
      let(:root) { false }
      let(:attribute_names) { [[], nil].sample }
      let(:options) { { } }

      it 'returns correct serialized object' do
        expect(subject.keys).to eq(RecordBlueprint.attributes.reject(&:optional).map(&:name))
      end
    end

    context 'with attribute names' do
      let(:root) { false }
      let(:attribute_names) { [
        :id,
        { polymorphicable: [:id, :created_at, :updated_at, :not_existed_column] },
        { has_one_record: [:id, :integer_column, :float_column, :boolean_column, :string_column, :datetime_column, :created_at, :updated_at, :not_existed_column] },
        {
          has_many_records: [:id, :integer_column, :float_column, :boolean_column, :string_column, :datetime_column, :created_at, :updated_at, :not_existed_column],
          has_and_belongs_to_many_records: [:id, :integer_column, :float_column, :boolean_column, :string_column, :datetime_column, :created_at, :updated_at, :not_existed_column]
        },
        :integer_column,
        :float_column,
        :boolean_column,
        :string_column,
        :datetime_column,
        :integer_method,
        { record_method: [:id] },
        :blueprint_inline_reader,
        {
          blueprint_inline_reader_with_object: [:id],
          blueprint_inline_reader_with_object_and_options: [:id]
        },
        :blueprint_method_reader,
        {
          blueprint_method_reader_with_object: [:id],
          blueprint_method_reader_with_object_and_options: [:id]
        },
        :blueprint_inline_if,
        {

          blueprint_inline_if_with_object: [:id],
          blueprint_inline_if_with_object_and_options: [:id]
        },
        :blueprint_method_if,
        {
          blueprint_method_if_with_object: [:id],
          blueprint_method_if_with_object_and_options: [:id]
        },
        :blueprint_inline_unless,
        {
          blueprint_inline_unless_with_object: [:id],
          blueprint_inline_unless_with_object_and_options: [:id]
        },
        :blueprint_method_unless,
        {
          blueprint_method_unless_with_object: [:id],
          blueprint_method_unless_with_object_and_options: [:id]
        },
        {
          blueprint_inline_options: [:id, :integer_column_if_with_object_and_options],
          blueprint_inline_hash_options: [:id, :integer_column_if_with_object_and_options],
          blueprint_inline_options_with_object: [:id, :integer_column_if_with_object_and_options],
          blueprint_inline_options_with_object_and_options: [:id, :integer_column_if_with_object_and_options]
        },
        {
          blueprint_method_options: [:id, :integer_column_if_with_object_and_options],
          blueprint_method_options_with_object: [:id, :integer_column_if_with_object_and_options],
          blueprint_method_options_with_object_and_options: [:id, :integer_column_if_with_object_and_options]
        },
        :created_at,
        :updated_at,
        :not_existed_column
      ] }
      let(:option) { Faker::Boolean.boolean }
      let(:options) { { option: option } }

      it 'returns correct serialized object' do
        expect(subject[:id]).to eq(object.id)
        expect(subject[:polymorphicable].keys).to eq(attribute_names[1][:polymorphicable] - [:not_existed_column])
        expect(subject[:polymorphicable][:id]).to eq(object.polymorphicable.id)
        expect(subject[:polymorphicable][:not_existed_column]).to be_nil
        expect(subject[:has_one_record].keys).to eq(attribute_names[2][:has_one_record] - [:not_existed_column])
        expect(subject[:has_one_record][:id]).to eq(object.has_one_record.id)
        expect(subject[:has_one_record][:not_existed_column]).to be_nil
        expect(subject[:has_many_records][0].keys).to eq(attribute_names[3][:has_many_records] - [:not_existed_column])
        expect(subject[:has_many_records][0][:id]).to eq(object.has_many_records.first.id)
        expect(subject[:has_many_records][0][:not_existed_column]).to be_nil
        expect(subject[:has_and_belongs_to_many_records][0].keys).to eq(attribute_names[3][:has_and_belongs_to_many_records] - [:not_existed_column])
        expect(subject[:has_and_belongs_to_many_records][0][:id]).to eq(object.has_and_belongs_to_many_records.first.id)
        expect(subject[:has_and_belongs_to_many_records][0][:not_existed_column]).to be_nil
        expect(subject[:integer_column]).to eq(object.integer_column)
        expect(subject[:float_column]).to eq(object.float_column)
        expect(subject[:boolean_column]).to eq(object.boolean_column)
        expect(subject[:string_column]).to eq(object.string_column)
        expect(subject[:datetime_column]).to eq(object.datetime_column)
        expect(subject[:integer_method]).to eq(object.integer_column)
        expect(subject[:record_method][:id]).to eq(object.has_one_record.id)
        expect(subject[:blueprint_inline_reader]).to eq(1)
        expect(subject[:blueprint_inline_reader_with_object][:id]).to eq(object.has_one_record.id)
        expect(subject[:blueprint_inline_reader_with_object_and_options].present?).to eq(option)
        expect(subject[:blueprint_inline_reader_with_object_and_options][:id]).to eq(object.has_one_record.id) if option
        expect(subject[:blueprint_method_reader]).to eq(1)
        expect(subject[:blueprint_method_reader_with_object][:id]).to eq(object.has_one_record.id)
        expect(subject[:blueprint_method_reader_with_object_and_options].present?).to eq(option)
        expect(subject[:blueprint_method_reader_with_object_and_options][:id]).to eq(object.has_one_record.id) if option
        expect(subject[:blueprint_inline_if].present?).to be_truthy
        expect(subject[:blueprint_inline_if_with_object].present?).to eq(object.boolean_column)
        expect(subject[:blueprint_inline_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:blueprint_method_if].present?).to be_truthy
        expect(subject[:blueprint_method_if_with_object].present?).to eq(object.boolean_column)
        expect(subject[:blueprint_method_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:blueprint_inline_unless].present?).to be_falsey
        expect(subject[:blueprint_inline_unless_with_object].present?).to eq(!object.boolean_column)
        expect(subject[:blueprint_inline_unless_with_object_and_options].present?).to eq(!object.boolean_column || !option)
        expect(subject[:blueprint_method_unless].present?).to be_falsey
        expect(subject[:blueprint_method_unless_with_object].present?).to eq(!object.boolean_column)
        expect(subject[:blueprint_method_unless_with_object_and_options].present?).to eq(!object.boolean_column || !option)
        expect(subject[:blueprint_inline_options][:integer_column_if_with_object_and_options].present?).to eq(option)
        expect(subject[:blueprint_inline_hash_options][:integer_column_if_with_object_and_options].present?).to eq(option)
        expect(subject[:blueprint_inline_options_with_object][:integer_column_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:blueprint_inline_options_with_object_and_options][:integer_column_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:blueprint_method_options][:integer_column_if_with_object_and_options].present?).to eq(option)
        expect(subject[:blueprint_method_options_with_object][:integer_column_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:blueprint_method_options_with_object_and_options][:integer_column_if_with_object_and_options].present?).to eq(object.boolean_column && option)
        expect(subject[:created_at]).to eq(object.created_at)
        expect(subject[:updated_at]).to eq(object.updated_at)
        expect(subject[:not_existed_column]).to be_nil
      end
    end

    context 'with root true' do
      let(:root) { true }
      let(:attribute_names) { nil }
      let(:options) { nil }

      it 'returns correct serialized object' do
        expect(subject.key?(:record)).to be_truthy
      end
    end

    context 'with root string' do
      let(:root) { 'string' }
      let(:attribute_names) { nil }
      let(:options) { nil }

      it 'returns correct serialized object' do
        expect(subject.key?(:string)).to be_truthy
      end
    end

    context 'with root symbol' do
      let(:root) { :symbol }
      let(:attribute_names) { nil }
      let(:options) { nil }

      it 'returns correct serialized object' do
        expect(subject.key?(:symbol)).to be_truthy
      end
    end
  end

  describe '.name_for' do
    subject { Serializer.send(:name_for, object) }

    context 'with class object' do
      let(:object) { Hash }

      it 'returns correct name' do
        expect(subject).to eq('Hash')
      end
    end

    context 'with active record class object' do
      let(:object) { Record }

      it 'returns correct name' do
        expect(subject).to eq('Record')
      end
    end

    context 'with instance object' do
      let(:object) { { a: :b } }

      it 'returns correct name' do
        expect(subject).to eq('Hash')
      end
    end

    context 'with active record instance object' do
      let(:object) { create(:record) }

      it 'returns correct name' do
        expect(subject).to eq('Record')
      end
    end

    context 'with invalid object' do
      let(:object) { nil }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.call_in' do
    let!(:object) { create(:record_with_relations) }
    let!(:blueprint) { RecordBlueprint }

    subject { Serializer.send(:call_in, blueprint, callable) }

    context 'with method callable' do
      let(:callable) { RecordBlueprint.attributes_for([:blueprint_method_reader]).first.reader }

      it 'returns correct name' do
        expect(subject).to eq(1)
      end
    end

    context 'with proc callable' do
      let(:callable) { RecordBlueprint.attributes_for([:blueprint_inline_reader]).first.reader }

      it 'returns correct name' do
        expect(subject).to eq(1)
      end
    end
  end
end