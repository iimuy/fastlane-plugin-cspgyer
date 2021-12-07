describe Fastlane::Actions::CspgyerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The cspgyer plugin is working!")

      Fastlane::Actions::CspgyerAction.run(nil)
    end
  end
end
