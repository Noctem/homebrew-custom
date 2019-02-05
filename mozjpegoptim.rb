class Mozjpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.6.tar.gz"
  sha256 "c44dcfac0a113c3bec13d0fc60faf57a0f9a31f88473ccad33ecdf210b4c0c52"
  head "https://github.com/tjko/jpegoptim.git"

  conflicts_with "jpegoptim", :because => "both install a jpegoptim binary"
  conflicts_with "jpegturbooptim", :because => "both install a jpegoptim binary"

  depends_on "mozjpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
