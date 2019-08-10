class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz"
  sha256 "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd"

  patch :DATA

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end

__END__
diff --git a/Makefile b/Makefile
index bac5b7f..7c83a6c 100644
--- a/Makefile
+++ b/Makefile
@@ -7,7 +7,7 @@
 
 #
 OFLAGS  = -O2
-CFLAGS  = -std=gnu99 -fPIC -Wall -Wno-format-truncation $(OFLAGS)
+CFLAGS  = -std=gnu99 -fPIC -Wall $(OFLAGS)
 
 SHELL = /bin/sh
 TAR = tar
@@ -32,7 +32,7 @@ SOURCES = dgif_lib.c egif_lib.c gifalloc.c gif_err.c gif_font.c \
 HEADERS = gif_hash.h  gif_lib.h  gif_lib_private.h
 OBJECTS = $(SOURCES:.c=.o)
 
-USOURCES = qprintf.c quantize.c getarg.c 
+USOURCES = qprintf.c quantize.c getarg.c gif_err.c
 UHEADERS = getarg.h
 UOBJECTS = $(USOURCES:.c=.o)
 
@@ -67,21 +67,21 @@ all: libgif.so libgif.a libutil.so libutil.a $(UTILS)
 $(UTILS):: libgif.a libutil.a
 
 libgif.so: $(OBJECTS) $(HEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libgif.so.$(LIBMAJOR) -o libgif.so $(OBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(LDFLAGS) -o libgif.dylib $(OBJECTS)
 
 libgif.a: $(OBJECTS) $(HEADERS)
 	$(AR) rcs libgif.a $(OBJECTS)
 
 libutil.so: $(UOBJECTS) $(UHEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libutil.so.$(LIBMAJOR) -o libutil.so $(UOBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(LDFLAGS) -o libutil.dylib $(UOBJECTS)
 
 libutil.a: $(UOBJECTS) $(UHEADERS)
 	$(AR) rcs libutil.a $(UOBJECTS)
 
 clean:
-	rm -f $(UTILS) $(TARGET) libgetarg.a libgif.a libgif.so libutil.a libutil.so *.o
-	rm -f libgif.so.$(LIBMAJOR).$(LIBMINOR).$(LIBPOINT)
-	rm -f libgif.so.$(LIBMAJOR)
+	rm -f $(UTILS) $(TARGET) libgetarg.a libgif.a libgif.dylib libutil.a libutil.dylib *.o
+	rm -f libgif.dylib.$(LIBMAJOR).$(LIBMINOR).$(LIBPOINT)
+	rm -f libgif.dylib.$(LIBMAJOR)
 	rm -fr doc/*.1 *.html doc/staging
 
 check: all
@@ -99,9 +99,9 @@ install-include:
 install-lib:
 	$(INSTALL) -d "$(DESTDIR)$(LIBDIR)"
 	$(INSTALL) -m 644 libgif.a "$(DESTDIR)$(LIBDIR)/libgif.a"
-	$(INSTALL) -m 755 libgif.so "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBVER)"
-	ln -sf libgif.so.$(LIBVER) "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBMAJOR)"
-	ln -sf libgif.so.$(LIBMAJOR) "$(DESTDIR)$(LIBDIR)/libgif.so"
+	$(INSTALL) -m 755 libgif.dylib "$(DESTDIR)$(LIBDIR)/libgif.$(LIBMAJOR).dylib"
+	ln -sf libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.$(LIBMAJOR).dylib"
+	ln -sf libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.dylib"
 install-man:
 	$(INSTALL) -d "$(DESTDIR)$(MANDIR)/man1"
 	$(INSTALL) -m 644 doc/*.1 "$(DESTDIR)$(MANDIR)/man1"
@@ -112,7 +112,7 @@ uninstall-include:
 	rm -f "$(DESTDIR)$(INCDIR)/gif_lib.h"
 uninstall-lib:
 	cd "$(DESTDIR)$(LIBDIR)" && \
-		rm -f libgif.a libgif.so libgif.so.$(LIBMAJOR) libgif.so.$(LIBVER)
+		rm -f libgif.a libgif.dylib libgif.dylib.$(LIBMAJOR) libgif.dylib.$(LIBVER)
 uninstall-man:
 	cd "$(DESTDIR)$(MANDIR)/man1" && rm -f $(shell cd doc >/dev/null && echo *.1)
 
