describe Blueprint::Base do
  describe '.attribute' do
    before { TestAttributeBlueprint.attribute(attribute_name) }
    subject { TestAttributeBlueprint.attributes }

    context 'with valid attribute name' do
      let(:attribute_name) { :attribute }

      it 'returns valid attributes' do
        expect(subject.count).to eq(1)
      end
    end
  end

  describe '.attributes_for' do
    subject { HashBlueprint.attributes_for(attribute_names) }

    context 'with valid attribute names' do
      let(:attribute_names) { [
        :a,
        'a',
        :g,
        'b',
        { z: :h, c: 'd' },
        1
      ] }

      it 'returns valid attributes' do
        expect(subject.count).to eq(3)
        expect(subject[0].name).to eq(:a)
        expect(subject[1].name).to eq(:b)
        expect(subject[2].name).to eq(:c)
      end
    end

    context 'with invalid attribute names' do
      let(:attribute_names) { [
        { g: :h },
        2,
        :l
      ] }

      it 'returns empty attributes' do
        expect(subject.empty?).to be_truthy
      end
    end

    context 'with nil attribute names' do
      let(:attribute_names) { nil }

      it 'returns valid attributes' do
        expect(subject.count).to eq(2)
        expect(subject[0].name).to eq(:a)
        expect(subject[1].name).to eq(:b)
      end
    end
  end

  describe '.attribute_for' do
    subject { HashBlueprint.attribute_for(attribute_name) }

    context 'with valid attribute name' do
      let(:attribute_name) { 'a' }

      it 'returns valid attribute' do
        expect(subject.name).to eq(:a)
      end
    end
  end
end