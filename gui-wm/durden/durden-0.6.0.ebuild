# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Desktop environment for Arcan"
HOMEPAGE="https://durden.arcan-fe.com"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/letoram/${PN}.git"
else
        SRC_URI="https://github.com/letoram/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/arcan-${PV}"
RDEPEND="${DEPEND}"

src_install() {
		dodir /usr/share/durden
		cp -R "${S}/durden" "${D}/usr/share/durden/durden" || die "Install failed!"
		exeinto /usr/bin
		doexe distr/durden
}
