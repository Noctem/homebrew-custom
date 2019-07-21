class FfmpegGit < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  head "https://github.com/FFmpeg/FFmpeg.git"

  keg_only "This formula is only intended to be a dependency for packages requiring the latest ffmpeg."

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
