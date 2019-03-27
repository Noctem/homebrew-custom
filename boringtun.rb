class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/vTEST2.tar.gz"
  sha256 "011fd5a8230ca7314d93cdc75479380453fa4882a56778ae1cc52d23f312b3ad"
  version "0.2.0"
  head "https://github.com/cloudflare/boringtun.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/boringtun", "--help"
  end
end
