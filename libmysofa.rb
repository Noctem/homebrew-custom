class Libmysofa < Formula
  desc "Reader for AES SOFA files to get better HRTFs"
  homepage "https://github.com/hoene/libmysofa"
  url "https://github.com/hoene/libmysofa/archive/v1.1.tar.gz"
  sha256 "e30846be11499c2282ad85edcab7bcca9bf86502df40c343d1f3ff07db17c765"
  license "BSD"

  depends_on "cmake" => :build
  depends_on "cunit" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
