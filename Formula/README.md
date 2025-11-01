# Homebrew Formula for table-extractor

This directory contains the Homebrew formula for `table-extractor`.

## For Users

### Installation

```bash
# Add the tap
brew tap acamino/tap

# Install table-extractor
brew install table-extractor
```

Or in one command:
```bash
brew install acamino/tap/table-extractor
```

### Fast Installation with Pre-Built Binaries

The formula uses a **hybrid approach** for fast, reliable installation:

- ✅ **Pre-built binaries** for common platforms (macOS ARM64, macOS x86_64, Linux x86_64)
  - **Installation time**: ~1 second
  - **Download size**: 2-3 MB
  - **No compilation required**

- ✅ **Source compilation fallback** for other platforms
  - Ensures universal compatibility
  - Automatically compiles when binary not available

### Usage

After installation, the `tabx` command will be available:

```bash
# Convert CSV to TSV
cat data.csv | tabx

# Convert with specific output format
cat data.csv | tabx -o csv

# Generate shell completions manually (if needed)
tabx completions bash > ~/.bash_completions/tabx
tabx completions zsh > ~/.zsh/completions/_tabx
tabx completions fish > ~/.config/fish/completions/tabx.fish

# See all options
tabx --help
```

**Note**: Shell completions are automatically installed by Homebrew during installation.

## For Maintainers

### Formula Structure

The formula uses platform detection to choose between pre-built binaries and source compilation:

```ruby
if OS.mac? && Hardware::CPU.arm?
  # Download macOS ARM64 binary
elsif OS.mac? && Hardware::CPU.intel?
  # Download macOS x86_64 binary
elsif OS.linux? && Hardware::CPU.intel?
  # Download Linux x86_64 binary
else
  # Fallback: compile from source with Rust
end
```

### Updating the Formula

#### Manual Updates

When releasing a new version manually:

1. Update the `version` in GitHub (create new release with tag)
2. Calculate SHA256 for all binaries and source:
   ```bash
   VERSION=X.Y.Z

   # macOS ARM64
   curl -sL "https://github.com/acamino/table-extractor/releases/download/v${VERSION}/tabx-macos-aarch64" | shasum -a 256

   # macOS x86_64
   curl -sL "https://github.com/acamino/table-extractor/releases/download/v${VERSION}/tabx-macos-x86_64" | shasum -a 256

   # Linux x86_64
   curl -sL "https://github.com/acamino/table-extractor/releases/download/v${VERSION}/tabx-linux-x86_64" | shasum -a 256

   # Source tarball
   curl -sL "https://github.com/acamino/table-extractor/archive/refs/tags/v${VERSION}.tar.gz" | shasum -a 256
   ```

3. Update the formula `table-extractor.rb`:
   - Line 4: `version "X.Y.Z"`
   - Line 10: macOS ARM64 `sha256 "..."`
   - Line 13: macOS x86_64 `sha256 "..."`
   - Line 16: Linux x86_64 `sha256 "..."`
   - Line 20: Source tarball `sha256 "..."`
   - Line 9, 12, 15, 19: Update version in URLs
   - Line 55: Update version in test assertion

### Testing Locally

```bash
# Tap the local repository
brew tap acamino/tap /path/to/homebrew-tap

# Install from the tap
brew install acamino/tap/table-extractor

# Test the formula
brew test acamino/tap/table-extractor

# Audit the formula (strict mode)
brew audit --strict --online acamino/tap/table-extractor

# Force build from source (to test source compilation path)
brew install --build-from-source acamino/tap/table-extractor
```

### Verifying Binary Installation

To confirm you're using the binary (not source):

```bash
brew install acamino/tap/table-extractor 2>&1 | grep -i cargo
# Should return nothing if using binary

brew install acamino/tap/table-extractor 2>&1 | grep "built in"
# Should show "built in 1-2 seconds" for binary
```

## Troubleshooting

### Installation is slow / compiling from source
- Check your platform: `brew config | grep -E "CPU|Homebrew"`
- Ensure you're on macOS or Linux x86_64
- Verify binaries exist in the GitHub release
- Try reinstalling: `brew reinstall acamino/tap/table-extractor`

### "Binary not found" error
- Binaries may not be uploaded yet for the latest release
- Formula will automatically fall back to source compilation
- Wait a few minutes and try again, or force source build

## Resources

- [Main Repository](https://github.com/acamino/table-extractor)
- [Homebrew Tap Repository](https://github.com/acamino/homebrew-tap)
- [Automation Documentation](../AUTOMATION.md)
- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
