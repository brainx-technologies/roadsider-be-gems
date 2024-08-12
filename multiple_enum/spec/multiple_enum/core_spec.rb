describe MultipleEnum::Core do
  describe '.multiple_enum' do
    context 'set nil' do
      let!(:object) { create(:record, colors: nil) }

      it 'returns true' do
        expect(object.colors).to eq([])
      end
    end

    context 'set empty array' do
      let!(:object) { create(:record, colors: []) }

      it 'returns true' do
        expect(object.colors).to eq([])
      end
    end

    context '_prefix' do
      before { Record.multiple_enum new_colors: [:r, :g, :b], _prefix: :pref }
      subject { Record.respond_to?(:with_pref_new_colors) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context '_suffix' do
      before { Record.multiple_enum new_colors: [:r, :g, :b], _suffix: :suff }
      subject { Record.respond_to?(:with_new_colors_suff) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context '_scopes' do
      before { Record.multiple_enum new_colors: [:r, :g, :b], _scopes: false }
      subject { Record.respond_to?(:with_new_colors) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.colors' do
    subject { Record.colors }

    it 'returns correct multiple enum values' do
      expect(subject).to eq({ 'red' => 0, 'green' => 1, 'blue' => 2 })
    end
  end

  describe '.red?' do
    subject { object.red? }

    context 'for existing color' do
      let(:object) { create(:record, colors: [:red, :green]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'for not existing color' do
      let(:object) { create(:record, colors: [:green, :blue]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.with_colors' do
    subject { Record.with_colors(:red, :green).exists? }

    context 'for existing colors' do
      let!(:object) { create(:record, colors: [:red, :green]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'for not existing colors' do
      let!(:object) { create(:record, colors: [:green, :blue]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.without_colors' do
    subject { Record.without_colors(:red, :green).exists? }

    context 'for existing colors' do
      let!(:object) { create(:record, colors: [:red, :green]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'for not existing colors' do
      let!(:object) { create(:record, colors: [:green, :blue]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe '.red' do
    subject { Record.red.exists? }

    context 'for existing colors' do
      let!(:object) { create(:record, colors: [:red, :green]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'for not existing colors' do
      let!(:object) { create(:record, colors: [:green, :blue]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.not_red' do
    subject { Record.not_red.exists? }

    context 'for existing colors' do
      let!(:object) { create(:record, colors: [:red, :green]) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'for not existing colors' do
      let!(:object) { create(:record, colors: [:green, :blue]) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end