# Last check with upstream: 001752dcbd545a39926a2998dde53642634bccad
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ffmpeg.rb

class FfmpegIina < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.3.tar.xz"
  sha256 "0c3020452880581a8face91595b239198078645e7d7184273b8bcc7758beb63d"
  revision 1
  head "https://github.com/FFmpeg/FFmpeg.git"

  keg_only "This formula is intended to only be used for building IINA. It is not recommended for daily use."

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "rtmpdump"
  depends_on "rubberband"
  depends_on "snappy"
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-hardcoded-tables
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gnutls
      --enable-nonfree
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-librubberband
      --enable-libsnappy
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libass
      --enable-librtmp
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
      --enable-libsoxr
      --disable-doc
      --disable-encoders
      --disable-programs
      --disable-muxers
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
