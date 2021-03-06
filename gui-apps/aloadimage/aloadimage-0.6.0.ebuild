# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake

DESCRIPTION="A simple command-line imageviewer for arcan"
HOMEPAGE="https://github.com/letoram/arcan/tree/master/src/tools/${PN}"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/letoram/arcan.git"
else
        SRC_URI="https://github.com/letoram/arcan/archive/${PV}.tar.gz -> arcan-${PV}.tar.gz"
        KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

SLOT="0"
LICENSE="BSD GPL-2+ LGPL-2 OFL-1.1"
RDEPEND="media-video/arcan
         seccomp? ( sys-libs/seccomp )"

DEPEND="${RDEPEND}"

IUSE="+seccomp"
S=${WORKDIR}/arcan-${PV}/src/tools/${PN}
