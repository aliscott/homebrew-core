class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.57",
      revision: "c3b6f4341184583f3a65d38985595dadfb41b730"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59a1744e514bf9259241b8dfcf7d27b8df987408892a6d1f8e186f66b1b8a1b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a1744e514bf9259241b8dfcf7d27b8df987408892a6d1f8e186f66b1b8a1b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a1744e514bf9259241b8dfcf7d27b8df987408892a6d1f8e186f66b1b8a1b8"
    sha256 cellar: :any_skip_relocation, ventura:        "daa46b0d25c2bc6814221790cccc0f920b68901ca0cf6572896da12308a31d43"
    sha256 cellar: :any_skip_relocation, monterey:       "daa46b0d25c2bc6814221790cccc0f920b68901ca0cf6572896da12308a31d43"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa46b0d25c2bc6814221790cccc0f920b68901ca0cf6572896da12308a31d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b66bf4501b771ec57591ffc8469aaf27683343d9c67e6526d957a563f16e1e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
