class Keymaster < Formula
  desc "Secure macOS Keychain helper with Touch ID and password protection"
  homepage "https://github.com/bmansvk/keymaster"
  head "https://github.com/bmansvk/keymaster.git", branch: "master"
  license "MIT"

  depends_on :macos => :monterey  # macOS 12+

  def install
    # Compile the Swift source with release optimizations
    system "swiftc", "-O", "keymaster.swift", "-o", "keymaster"
    
    # Install the binary
    bin.install "keymaster"
  end

  test do
    # Verify the binary runs and check basic functionality
    output = shell_output("#{bin}/keymaster --help 2>&1", 1)
    assert_match(/Usage:|set|get|delete/, output)
  end
end
