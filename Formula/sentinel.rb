class Sentinel < Formula
  desc "Autonomous meta-agent for software projects, across multiple LLM providers"
  homepage "https://github.com/autumngarage/sentinel"
  url "https://github.com/autumngarage/sentinel/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d15d410dd8d93b577e59c082d219e8216ccd12d42ceb5be7b29cc8036dec6069"
  license "MIT"

  depends_on "python@3.11"
  depends_on "uv"

  def install
    # Install the Python package into a venv under libexec
    venv = libexec/"venv"
    system "uv", "venv", venv, "--python", "python3.11"
    system "uv", "pip", "install", ".", "--python", venv/"bin/python"
    bin.install_symlink venv/"bin/sentinel"

    # Install lenses and templates alongside the package
    (libexec/"lenses").install Dir["lenses/**/*"]
    (libexec/"templates").install Dir["templates/**/*"]
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
