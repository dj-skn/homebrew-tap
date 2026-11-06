class ScheduleSend < Formula
  desc "Schedule messages and key presses into Herdr agents and terminal panes"
  homepage "https://github.com/dj-skn/schedule-send"
  # Each release fills in url and sha256, with tools/bump-tap in dj-skn/schedule-send.
  url "https://github.com/dj-skn/schedule-send/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ad8aa352a1e7b0cb9b301e823120e947e15da3a9f42da5b3feb075468bd815af"
  license "MIT"
  head "https://github.com/dj-skn/schedule-send.git", branch: "main"

  depends_on "go" => :build

  on_macos do
    depends_on "coreutils"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["SCHEDULE_SEND_LDFLAGS"] = "-s -w"
    # The program arms jobs only from the path compiled into it. opt_bin stays
    # the same across upgrades, so a job armed before one still runs after it.
    bin.mkpath
    system "tools/build", bin/"schedule-send", opt_bin/"schedule-send", version.to_s
  end

  def caveats
    <<~EOS
      schedule-send drives Herdr, which is installed separately:
        brew install herdr
    EOS
  end

  test do
    assert_equal "schedule-send #{version}", shell_output("#{bin}/schedule-send --version").strip
  end
end
