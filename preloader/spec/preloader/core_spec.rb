describe Preloader::Core do
  describe '.includes_options' do
    let!(:object) { Record }
    let!(:blueprint) { RecordBlueprint }
    subject { Preloader.send(:includes_options, object, blueprint, attribute_names) }

    context 'with empty or nil attribute names' do
      let(:attribute_names) { [[], nil].sample }

      it 'returns correct eager load options' do
        expect(subject).to eq([])
      end
    end

    context 'with ids attribute names' do
      let(:attribute_names) { [
        { has_many_record_ids: [:record] },
      ] }

      it 'returns correct eager load options' do
        expect(subject).to eq([:has_many_records])
      end
    end

    context 'with attribute names' do
      let(:attribute_names) { [
        :polymorphicable,
        :has_one_record,
        {
          has_many_records: [{ record: [:id] }]
        },
        :has_and_belongs_to_many_records,
        :has_many_record_ids,
      ] }

      it 'returns correct eager load options' do
        expect(subject).to eq([:has_one_record, { has_many_records: [:record] }, :has_and_belongs_to_many_records])
      end
    end
  end

  describe '.preload_options' do
    let!(:object) { Record }
    let!(:blueprint) { RecordBlueprint }
    subject { Preloader.send(:preload_options, object, blueprint, attribute_names) }

    context 'with empty or nil attribute names' do
      let(:attribute_names) { [[], nil].sample }

      it 'returns correct preload options' do
        expect(subject).to eq([])
      end
    end

    context 'with attribute names' do
      let(:attribute_names) { [
        :polymorphicable,
        :has_one_record,
        {
          has_many_records: [{ record: [:id] }]
        },
        :has_and_belongs_to_many_records,
        :polymorphicable_ids,
      ] }

      it 'returns correct preload options' do
        expect(subject).to eq([:polymorphicable])
      end
    end
  end

  describe '.merge_scopes' do
    let!(:object) { Record }
    let!(:blueprint) { RecordBlueprint }
    subject { Preloader.send(:merge_scopes, object, blueprint, attribute_names) }

    context 'with empty or nil attribute names' do
      let(:attribute_names) { [[], nil].sample }

      it 'returns correct merge scopes' do
        expect(subject).to eq([])
      end
    end

    context 'with inline preloader attribute names' do
      let(:attribute_names) { [
        :polymorphicable,
        :has_one_record,
        {
          has_many_records: [{ record: [:id] }]
        },
        :has_and_belongs_to_many_records,
        :polymorphicable_ids,
        :blueprint_inline_preloader,
      ] }

      it 'returns correct merge scopes' do
        expect(subject).to eq([Record.joins(:has_one_record)])
      end
    end

    context 'with method preloader attribute names' do
      let(:attribute_names) { [
        :polymorphicable,
        :has_one_record,
        {
          has_many_records: [{ record: [:id] }]
        },
        :has_and_belongs_to_many_records,
        :polymorphicable_ids,
        :blueprint_method_preloader,
      ] }

      it 'returns correct merge scopes' do
        expect(subject).to eq([Record.joins(:has_one_record)])
      end
    end
  end
end