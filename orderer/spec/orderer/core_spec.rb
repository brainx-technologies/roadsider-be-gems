describe Orderer::Core do
  describe '.joins_options' do
    let!(:object) { Record }
    let!(:blueprint) { RecordBlueprint }
    subject { Orderer.send(:joins_options, object, blueprint, order_directions) }

    context 'with empty or nil attribute names' do
      let(:order_directions) { [[], nil].sample }

      it 'returns correct joins options' do
        expect(subject).to eq([])
      end
    end

    context 'with attribute names' do
      let(:order_directions) { {
        has_many_records: { record: { id: :asc } },
        id: :desc
      } }

      it 'returns correct joins options' do
        expect(subject).to eq([has_many_records: [:record]])
      end
    end
  end

  describe '.order_options' do
    let!(:object) { Record }
    let!(:blueprint) { RecordBlueprint }
    subject { Orderer.send(:order_options, object, blueprint, order_directions) }

    context 'with empty or nil attribute names' do
      let(:order_directions) { [[], nil].sample }

      it 'returns correct order options' do
        expect(subject).to eq([])
      end
    end

    context 'with attribute names' do
      let(:order_directions) { {
        created_at: :asc,
        id: :desc,
        has_many_records: { record: { id: :asc } }
      } }

      it 'returns correct order options' do
        expect(subject.count).to eq(3)
      end
    end
  end
end