class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/p/mp4v2/"
  url "https://github.com/TechSmith/mp4v2/archive/Release-MP4v2-3.0.1.1.tar.gz"
  sha256 "93ef7d96a31e4c5727cf76579c8d058e964fe0d1bbd55ea564ca4edd919a5ea9"

  bottle do
    cellar :any
    revision 1
    sha256 "52d299e61126db288d73a3e6e8b40c3eff25af1c7498c4a74787dce2dda02e9a" => :el_capitan
    sha256 "14ca4b71690959d461d41b4338be70005de4553566996677f973094c1a56c3fb" => :yosemite
    sha256 "bb51275338ca5b157b303fb9d024922c9b73ddcac69973ba2fe9d880ad6dc914" => :mavericks
    sha256 "ec42cf726369e5f6c3a4956cffbf44ab8d4b74f5bec35892a0c041641c2f4d4c" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-man"
  end
end
