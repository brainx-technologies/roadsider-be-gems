describe Paginator::Core do
  describe '.paginate' do
    let!(:object) { Record }
    subject { Paginator.paginate(object, limit: limit, offset: offset) }

    context 'with nil limit and offset' do
      let(:limit) { nil }
      let(:offset) { nil }

      it 'returns correct paginated object' do
        expect(subject.limit_value).to eq(25)
        expect(subject.offset_value).to eq(0)
      end
    end

    context 'with very large limit and offset' do
      let(:limit) { Faker::Number.between(from: 999, to: 9999) }
      let(:offset) { Faker::Number.between(from: 999, to: 9999) }

      it 'returns correct paginated object' do
        expect(subject.limit_value).to eq(25)
        expect(subject.offset_value).to eq(offset)
      end
    end

    context 'with negative limit and offset' do
      let(:limit) { -Faker::Number.between(from: 1, to: 20) }
      let(:offset) { -Faker::Number.between(from: 999, to: 9999) }

      it 'returns correct paginated object' do
        expect(subject.limit_value).to eq(limit.abs)
        expect(subject.offset_value).to eq(-offset)
      end
    end

    context 'with valid limit and offset' do
      let(:limit) { Faker::Number.between(from: 1, to: 20) }
      let(:offset) { Faker::Number.between(from: 999, to: 9999) }

      it 'returns correct paginated object' do
        expect(subject.limit_value).to eq(limit)
        expect(subject.offset_value).to eq(offset)
      end
    end
  end

  describe '.pagination' do
    before { create_list(:record, 5) }
    let!(:object) { Paginator.paginate(Record, limit: limit, offset: offset) }
    let!(:limit) { 2 }
    let!(:offset) { 1 }
    subject { Paginator.pagination(object, root: root) }

    context 'with true root' do
      let(:root) { true }

      it 'returns correct paginated object' do
        expect(subject[:pagination]).to be
        expect(subject[:pagination][:limit]).to eq(limit)
        expect(subject[:pagination][:offset]).to eq(offset)
        expect(subject[:pagination][:count]).to eq(limit)
        expect(subject[:pagination][:total_count]).to eq(Record.count)
      end
    end

    context 'with nil root' do
      let(:root) { nil }

      it 'returns correct paginated object' do
        expect(subject[:limit]).to eq(limit)
        expect(subject[:offset]).to eq(offset)
        expect(subject[:count]).to eq(limit)
        expect(subject[:total_count]).to eq(Record.count)
      end
    end

    context 'with symbol root' do
      let(:root) { :symbol_root }

      it 'returns correct paginated object' do
        expect(subject[:symbol_root]).to be
      end
    end
  end
end