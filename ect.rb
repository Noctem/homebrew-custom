class Ect < Formula
  desc "File and image optimizer. It supports PNG, JPEG, GZIP and ZIP files."
  homepage "https://github.com/fhanau/Efficient-Compression-Tool"
  url "https://github.com/fhanau/Efficient-Compression-Tool/archive/v0.8.2.tar.gz"
  sha256 "f3f36082bedc44fece8e81dbaabcd5cf745311f898fa5dafbe4f078f513d3b37"
  head "https://github.com/fhanau/Efficient-Compression-Tool.git"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "boost" => :optional

  def install
    if build.head?
      args = std_cmake_args
      args << '-DECT_FOLDER_SUPPORT=ON' if build.with? "boost"

      system "cmake", "src", *args
      system "make"
    else
      if build.with? "boost"
        ENV.append "CXXFLAGS", "-DBOOST_SUPPORTED"
        ENV.append "LDFLAGS", "-lboost_filesystem -lboost_system"
      end
      system "make", "-C", "src"
    end
    bin.install "ECT"
  end

  test do
    system "#{bin}/ECT", "-help"
  end
end
