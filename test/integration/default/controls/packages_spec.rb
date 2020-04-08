# frozen_string_literal: true

control 'chrome package' do
  title 'should be installed'

  package_name =
    case platform[:family]
    when 'suse'
      'google-chrome-stable'
    when 'redhat'
      'google-chrome-stable'
    when 'debian'
      'google-chrome-stable'
    when 'linux'
      'chrome'
    end
  end

  describe package(package_name) do
    it { should be_installed }
  end
end
