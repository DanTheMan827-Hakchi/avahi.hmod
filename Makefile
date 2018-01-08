GIT_COMMIT := $(shell echo "`git rev-parse --short HEAD``git diff-index --quiet HEAD -- || echo '-dirty'`")

export ac_cv_func_setpgrp_void="yes"

all: out/avahi-$(GIT_COMMIT).hmod

out/avahi-$(GIT_COMMIT).hmod: src/avahi-0.7/avahi-daemon/.libs/avahi-daemon mod/bin/avahi-daemon mod/lib/libavahi-common.so.3.5.3 mod/lib/libavahi-core.so.7.0.2 mod/lib/libdaemon.so.0.5.0 mod/lib/libexpat.so.1.6.0
	mkdir -p out/
	chmod +x mod/bin/* mod/lib/*
	tar -czvf "$@" -C mod/ etc usr bin lib
	touch "$@"
	
mod/lib/libexpat.so.1.6.0:
	mkdir -p "mod/lib/"
	cp "src/expat-2.1.0/.libs/libexpat.so.1.6.0" "$@"
	arm-linux-gnueabihf-strip "mod/lib/libexpat.so.1.6.0"
	[ -f "mod/lib/libexpat.so.1" ] || ln -s "libexpat.so.1.6.0" "mod/lib/libexpat.so.1"
	[ -f "mod/lib/libexpat.so" ] || ln -s "libexpat.so.1.6.0" "mod/lib/libexpat.so"
	touch "$@"
	
mod/lib/libdaemon.so.0.5.0:
	mkdir -p "mod/lib/"
	cp "src/libdaemon-0.14/libdaemon/.libs/libdaemon.so.0.5.0" "$@"
	arm-linux-gnueabihf-strip "mod/lib/libdaemon.so.0.5.0"
	[ -f "mod/lib/libdaemon.so.0" ] || ln -s "libdaemon.so.0.5.0" "mod/lib/libdaemon.so.0"
	[ -f "mod/lib/libdaemon.so" ] || ln -s "libdaemon.so.0.5.0" "mod/lib/libdaemon.so"
	touch "$@"
	
mod/lib/libavahi-core.so.7.0.2:
	mkdir -p "mod/lib/"
	cp "src/avahi-0.7/avahi-core/.libs/libavahi-core.so.7.0.2" "$@"
	arm-linux-gnueabihf-strip "mod/lib/libavahi-core.so.7.0.2"
	[ -f "mod/lib/libavahi-core.so.7" ] || ln -s "libavahi-core.so.7.0.2" "mod/lib/libavahi-core.so.7"
	[ -f "mod/lib/libavahi-core.so" ] || ln -s "libavahi-core.so.7.0.2" "mod/lib/libavahi-core.so"
	touch "$@"
	
mod/lib/libavahi-common.so.3.5.3:
	mkdir -p "mod/lib/"
	cp "src/avahi-0.7/avahi-common/.libs/libavahi-common.so.3.5.3" "$@"
	arm-linux-gnueabihf-strip "mod/lib/libavahi-common.so.3.5.3"
	[ -f "mod/lib/libavahi-common.so.3" ] || ln -s "libavahi-common.so.3.5.3" "mod/lib/libavahi-common.so.3"
	[ -f "mod/lib/libavahi-common.so" ] || ln -s "libavahi-common.so.3.5.3" "mod/lib/libavahi-common.so"
	touch "$@"

mod/bin/avahi-daemon: src/avahi-0.7/avahi-daemon/.libs/avahi-daemon
	mkdir -p "mod/bin/"
	cp "src/avahi-0.7/avahi-daemon/.libs/avahi-daemon" "mod/bin/"
	arm-linux-gnueabihf-strip "mod/bin/avahi-daemon"
	chmod +x "mod/bin/avahi-daemon"
	
src/avahi-0.7/avahi-daemon/.libs/avahi-daemon: src/avahi-0.7/Makefile
	mkdir -p "src/workbench/"
	make -C "src/avahi-0.7/"
	touch "$@"

src/avahi-0.7/Makefile: src/workbench/lib/libdaemon.la src/workbench/lib/libexpat.la src/avahi-0.7/configure
	export CPPFLAGS="-I`pwd`/src/workbench/include/ -I`pwd`/src/workbench/include/"; \
	export LDFLAGS="-L`pwd`/src/workbench/lib/ -L`pwd`/src/workbench/lib/"; \
	export PKG_CONFIG_PATH="`pwd`/src/workbench/lib/pkgconfig"; \
	cd "src/avahi-0.7/"; \
	./configure --host arm-linux-gnueabihf --with-distro=none --prefix="`pwd`/../workbench/" --sysconfdir=/etc --localstatedir=/var --disable-glib --disable-qt3 --disable-qt4 --disable-gtk --disable-gtk3 --disable-gdbm --disable-pygtk --disable-mono --disable-monodoc --disable-stack-protector --disable-manpages --disable-autoipd --with-avahi-user=root --with-avahi-group=root --with-autoipd-user=root --with-autoipd-group=root --with-systemdsystemunitdir=no  --with-xml=expat --enable-compat-libdns_sd --disable-dbus --disable-glib --disable-gobject --disable-python --disable-python-dbus
	touch "$@"
	
src/avahi-0.7/configure: src/avahi-0.7.tar.gz
	tar -xzvf "$<" -C "src/"
	touch "$@"

src/avahi-0.7.tar.gz:
	-mkdir -p src
	wget "https://github.com/lathiat/avahi/releases/download/v0.7/avahi-0.7.tar.gz" -O "$@"

src/workbench/lib/libexpat.la: src/expat-2.1.0/Makefile
	make -C "src/expat-2.1.0/"
	make -C "src/expat-2.1.0/" install

src/expat-2.1.0/Makefile: src/expat-2.1.0/configure
	mkdir -p "src/workbench/"
	cd "src/expat-2.1.0/"; \
	./configure --host=arm-linux-gnueabihf --prefix="`pwd`/../workbench/"
	touch "$@"

src/expat-2.1.0/configure: src/expat-2.1.0.tar.gz
	tar -xzvf "$<" -C "src/"
	touch "$@"

src/expat-2.1.0.tar.gz:
	mkdir -p src
	wget https://github.com/libexpat/libexpat/releases/download/R_2_1_0/expat-2.1.0.tar.gz -O "$@"

src/workbench/lib/libdaemon.la: src/libdaemon-0.14/Makefile
	make -C "src/libdaemon-0.14/"
	make -C "src/libdaemon-0.14/" install

src/libdaemon-0.14/Makefile: src/libdaemon-0.14/Makefile.am
	mkdir -p "src/workbench/"
	cd "src/libdaemon-0.14/"; \
	./configure --prefix="`pwd`/../workbench/" --disable-static --host=arm-linux-gnueabihf

src/libdaemon-0.14/Makefile.am: src/libdaemon-0.14.tar.gz
	tar -xzvf "$<" -C "src/"
	touch "$@"

src/libdaemon-0.14.tar.gz:
	mkdir -p src
	wget "http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz" -O "$@"

clean: clean-hmod
	-rm -rf "src/"

clean-hmod:
	-rm -rf "out/" "mod/bin/" "mod/lib/"

.PHONY: clean clean-hmod
