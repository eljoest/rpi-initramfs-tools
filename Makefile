.PHONY := help install uninstall


help:
	@echo "$(MAKE) [install|uninstall]"

install: postinst postrm
	cp -a postinst /etc/kernel/postinst.d/rpi-initramfs-tools
	chmod 755 /etc/kernel/postinst.d/rpi-initramfs-tools
	cp -a postrm /etc/kernel/postrm.d/rpi-initramfs-tools
	chmod 755 /etc/kernel/postrm.d/rpi-initramfs-tools

uninstall:
	rm -fv /etc/kernel/postinst.d/rpi-initramfs-tools \
	  /etc/kernel/postrm.d/rpi-initramfs-tools
	rm -frv /var/lib/rpi-initramfs
