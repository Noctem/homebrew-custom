class Ffmpeg < Formula
  desc "ffmpeg with fdk-aac, wavpack, and zimg"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.2.1.tar.xz"
  sha256 "cec7c87e9b60d174509e263ac4011b522385fd0775292e1670ecc1180c9bb6d4"
  head "https://github.com/FFmpeg/FFmpeg.git"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom"
  depends_on "fdk-aac"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "theora"
  depends_on "wavpack"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"
  depends_on "zimg"

  depends_on "noctem/custom/decklink-sdk" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-avresample
      --enable-ffplay
      --enable-gpl
      --enable-nonfree
      --enable-pthreads
      --enable-shared
      --enable-version3
      --enable-frei0r
      --enable-gnutls
      --enable-libaom
      --enable-libass
      --enable-libbluray
      --enable-libfdk-aac
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-librtmp
      --enable-libsnappy
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libwavpack
      --enable-libx264
      --enable-libx265
      --enable-libzimg
      --enable-lzma
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
    ]

    args << "--enable-decklink" if build.with?("decklink-sdk")

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
