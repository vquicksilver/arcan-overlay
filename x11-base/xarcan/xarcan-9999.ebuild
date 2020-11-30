# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Patched Xserver that bridge connections to arcan"
HOMEPAGE="https://github.com/letoram/xarcan"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/letoram/xarcan.git"
else
        SRC_URI="https://github.com/letoram/${PN}/archive/${PV}.tar.gz -> ${PV}.tar.gz"
fi

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="+libglvnd"

# TODO: Dependencies are probably entirely wrong
DEPEND="x11-libs/libX11
		libglvnd? ( media-libs/libglvnd[X] )
		media-video/arcan"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-libglvnd.patch" )

src_install() {
	# This is kinda hacky but it works, search for a better alternative
	# We don't want conflicts with x11-base/xorg-server we just need the binary
	exeinto /usr/bin
	doexe "${WORKDIR}"/${P}-build/hw/kdrive/arcan/Xarcan
}
