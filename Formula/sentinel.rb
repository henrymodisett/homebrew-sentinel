class Sentinel < Formula
  desc "Autonomous meta-agent for software projects, across multiple LLM providers"
  homepage "https://github.com/autumngarage/sentinel"
  url "https://github.com/autumngarage/sentinel/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "608ec962a0ee4308fafeafbbd2802cf1788c7c64222b2ea2b47feb2a265c1aed"
  license "MIT"

  depends_on "python@3.11"
  depends_on "uv"

  preserve_rpath

  def install
    # Install the Python package into a venv under libexec
    venv = libexec/"venv"
    system "uv", "venv", venv, "--python", "python3.11"
    system "uv", "pip", "install", ".", "--python", venv/"bin/python"
    bin.install_symlink venv/"bin/sentinel"

    # Install lenses and templates alongside the package
    lenses = Dir["lenses/**/*"]
    templates = Dir["templates/**/*"]
    (libexec/"lenses").install lenses unless lenses.empty?
    (libexec/"templates").install templates unless templates.empty?
  end

  def caveats
    <<~'EOS'
      sentinel
       ____             _   _            _
      / ___|  ___ _ __ | |_(_)_ __   ___| |
      \___ \ / _ \ '_ \| __| | '_ \ / _ \ |
       ___) |  __/ | | | |_| | | | |  __/ |
      |____/ \___|_| |_|\__|_|_| |_|\___|_|

      Get started:
        cd your-project
        sentinel init
        sentinel scan

      Requires at least one LLM provider CLI:
        brew install claude       # then: claude login
        brew install ollama       # then: ollama pull qwen2.5-coder:14b
        npm install -g @google/gemini-cli
        npm install -g @openai/codex
    EOS
  end

  test do
    assert_match "sentinel, version", shell_output("#{bin}/sentinel --version")
  end
end
