class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.2.0.tar.gz"
  sha256 "544c72fc482b636e7f6460bfee205adafc55de534067819e4e4914980f0d1350"
  head "https://github.com/cloudflare/boringtun.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/boringtun", "--help"
  end
end
