describe Blueprint::Finding do
  describe '.find_for' do
    subject { Blueprint.find_for(object) }

    context 'with class object' do
      let(:object) { Hash }

      it 'returns correct blueprint' do
        expect(subject).to eq(HashBlueprint)
      end
    end

    context 'with active record class object' do
      let(:object) { Record }

      it 'returns correct blueprint' do
        expect(subject).to eq(RecordBlueprint)
      end
    end

    context 'with active model class object' do
      let(:object) { Model }

      it 'returns correct blueprint' do
        expect(subject).to eq(ModelBlueprint)
      end
    end

    context 'with instance object' do
      let(:object) { { a: :b } }

      it 'returns correct blueprint' do
        expect(subject).to eq(HashBlueprint)
      end
    end

    context 'with active record instance object' do
      let(:object) { create(:record) }

      it 'returns correct blueprint' do
        expect(subject).to eq(RecordBlueprint)
      end
    end

    context 'with active model instance object' do
      let(:object) { build(:model) }

      it 'returns correct blueprint' do
        expect(subject).to eq(ModelBlueprint)
      end
    end

    context 'with moduled active model class object' do
      context 'for no-moduled blueprint' do
        let(:object) { FirstModule::SecondModule::FirstModuledModel }

        it 'returns correct blueprint' do
          expect(subject).to eq(FirstModuledModelBlueprint)
        end
      end

      context 'for one-moduled blueprint' do
        let(:object) { FirstModule::SecondModule::SecondModuledModel }

        it 'returns correct blueprint' do
          expect(subject).to eq(SecondModule::SecondModuledModelBlueprint)
        end
      end

      context 'for two-moduled blueprint' do
        let(:object) { FirstModule::SecondModule::ThirdModuledModel }

        it 'returns correct blueprint' do
          expect(subject).to eq(FirstModule::SecondModule::ThirdModuledModelBlueprint)
        end
      end
    end

    context 'with invalid object' do
      let(:object) { [1, 2, 3] }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end