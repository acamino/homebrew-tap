class TableExtractor < Formula
  desc "Convert various tabular data formats (Markdown, MySQL, PostgreSQL, CSV, TSV)"
  homepage "https://github.com/acamino/table-extractor"
  version "0.2.1"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/acamino/table-extractor/releases/download/v0.2.1/tabx-macos-aarch64"
    sha256 "f102d22969ec00a56e914c53576b38bc5df3e51c38023e4ba23389e1cddd8bd4"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/acamino/table-extractor/releases/download/v0.2.1/tabx-macos-x86_64"
    sha256 "f21ea33292464481fb4ac4e9a1066de94f0add2f11cce3729e29d7cc48ce74e4"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/acamino/table-extractor/releases/download/v0.2.1/tabx-linux-x86_64"
    sha256 "0bfabec5a78f43999280686c479784f988d8fa19d00b7113bd00afd2823af90d"
  else
    url "https://github.com/acamino/table-extractor/archive/refs/tags/v0.2.1.tar.gz"
    sha256 "3b5989056e2f41cea720b06d85e009cfea813bd33e10656552baf1edfedc4b49"
  end

  head "https://github.com/acamino/table-extractor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build if !OS.mac? && !(OS.linux? && Hardware::CPU.intel?)

  def install
    using_binary = (OS.mac? || (OS.linux? && Hardware::CPU.intel?)) && !build.head?

    if using_binary
      if OS.mac? && Hardware::CPU.arm?
        # Make binary executable before installing
        chmod 0755, "tabx-macos-aarch64"
        bin.install "tabx-macos-aarch64" => "tabx"
      elsif OS.mac? && Hardware::CPU.intel?
        chmod 0755, "tabx-macos-x86_64"
        bin.install "tabx-macos-x86_64" => "tabx"
      elsif OS.linux? && Hardware::CPU.intel?
        chmod 0755, "tabx-linux-x86_64"
        bin.install "tabx-linux-x86_64" => "tabx"
      end
    else
      system "cargo", "install", *std_cargo_args
    end

    # Generate shell completions (binary includes 'completions' subcommand)
    generate_completions_from_executable(bin/"tabx", "completions")
  end

  test do
    (testpath/"test.csv").write("id,name\n1,Alice\n2,Bob")
    output = shell_output("#{bin}/tabx < #{testpath}/test.csv")
    assert_match "Alice", output
    assert_match "Bob", output

    assert_match "0.2.1", shell_output("#{bin}/tabx --version")
  end
end
