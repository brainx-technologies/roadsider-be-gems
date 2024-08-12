describe Blueprint::Attributing do
  describe '.attribute_names_for' do
    let!(:attribute_names) { [
      :a,
      {
        c: [:h, :j, :l],
        b: [:a, :b, :c, {
          g: [:h, :j]
        }]
      },
      :d
    ] }
    subject { Blueprint.attribute_names_for(attribute, attribute_names) }

    context 'with existing attribute' do
      let(:attribute) { Blueprint::Attribute.new(:b) }

      it 'returns correct nested attribute names' do
        expect(subject).to eq(attribute_names[1][:b])
      end
    end

    context 'with not existing attribute' do
      let(:attribute) { Blueprint::Attribute.new(:q) }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end