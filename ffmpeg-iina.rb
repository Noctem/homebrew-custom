# Last check with upstream: 59f8c6ca4c9485fa7e97e9f8cd30ce42f8466395
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ffmpeg.rb

class FfmpegIina < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.2.tar.xz"
  sha256 "b95f0ae44798ab1434155ac7f81f30a7e9760a02282e4b5898372c22a335347b"
  head "https://github.com/FFmpeg/FFmpeg.git"

  keg_only "this formula is only used for building IINA, not recommended for daily use"

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
  depends_on "libvpx"
  depends_on "openjpeg"
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
      --enable-libvpx
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libass
      --enable-libopenjpeg
      --enable-librtmp
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
      --enable-libsoxr
      --disable-encoders
      --disable-doc
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
