class DecklinkSdk < Formula
  desc "BlackMagic Design DeckLink Software Development Kit headers"
  homepage "https://www.blackmagicdesign.com/support/family/capture-and-playback"
  url "https://github.com/Noctem/DeckLink-SDK/releases/download/v12.0/decklinksdk-12.0.tar.xz"
  sha256 "4c05ca1a8907fbc7f106654c512028fe21e7754f228971fcce250668a419ca04"

  def install
    include.install Dir["include/*"]
  end
end
