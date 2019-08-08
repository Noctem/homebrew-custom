class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.1.tar.gz"
  sha256 "095509b088ed1c3ba452ee0fed4a5f134719ac817ffc594f79557f499ad9fa6b"
  head "https://github.com/vapoursynth/vapoursynth.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "noctem/custom/ffmpeg"
  depends_on "imagemagick"
  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python"
  depends_on "zimg"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{Formula["cython"].opt_bin}/cython"
    system "make", "install"
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
