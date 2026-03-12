class Tablecopy < Formula
  desc "Convert Unicode box-drawing tables to Markdown / Image format"
  homepage "https://github.com/wataame/tablecopy"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wataame/tablecopy/releases/download/v0.2.0/tablecopy-aarch64-apple-darwin.tar.xz"
      sha256 "3144b5d381a8fc3454ab6563146f2fdd5d26ce87eee3e685a6c2f7b49b789bd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wataame/tablecopy/releases/download/v0.2.0/tablecopy-x86_64-apple-darwin.tar.xz"
      sha256 "3f002d35efad1924108510c8c06859a4316cce927a7b70967fc2f433a7cc803b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/wataame/tablecopy/releases/download/v0.2.0/tablecopy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c4587280e19acc7d3875f1d74039a5c687dd416cf8b8697805bcfee8cb3235c"
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
