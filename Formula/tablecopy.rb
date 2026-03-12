class Tablecopy < Formula
  desc "Convert Unicode box-drawing tables to Markdown / Image format"
  homepage "https://github.com/wataame/tablecopy"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wataame/tablecopy/releases/download/v0.1.0/tablecopy-aarch64-apple-darwin.tar.xz"
      sha256 "a0fd8bff0ed48923ca78b42c35d5183adf48919b3d77cb4d2ca45959b7b754a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wataame/tablecopy/releases/download/v0.1.0/tablecopy-x86_64-apple-darwin.tar.xz"
      sha256 "c347a6a816e66264ee70f1124ebbd7ba6dd659467d157a81f743b8b4a352710c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/wataame/tablecopy/releases/download/v0.1.0/tablecopy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "20ed2676d2e1a8f92913d178fc746fa15a3990e77f715355cb106a7705aac94a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tablecopy" if OS.mac? && Hardware::CPU.arm?
    bin.install "tablecopy" if OS.mac? && Hardware::CPU.intel?
    bin.install "tablecopy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
