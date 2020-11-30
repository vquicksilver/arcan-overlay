# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake

DESCRIPTION="Arcan is a powerful development framework for creating virtually anything from user interfaces for specialized embedded applications all the way to full-blown standalone desktop environments."
HOMEPAGE="https://arcan-fe.com/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/letoram/arcan.git"
else
        SRC_URI="https://github.com/letoram/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

SLOT="0"
LICENSE="BSD GPL-2+ LGPL-2 OFL-1.1"
IUSE="-debug +dri +frameservers +hybrid-headless +hybrid-sdl -jit -lto +lwa +simd -wayland"

# afsrv_decode depends on vlc
# afsrv_encode depends on ffmpeg and libvncserver
# afsrv_remoting depends on libvncserver
RDEPEND="
	hybrid-sdl? ( media-libs/libsdl2 )
	media-libs/freetype
	media-libs/openal
	dev-db/sqlite:3
	media-libs/mesa
	frameservers? (
	    ( media-video/vlc )
	    ( media-video/ffmpeg net-libs/libvncserver )
	    ( net-libs/libvncserver )
	)
	"
DEPEND="${RDEPEND}
        dev-util/cmake
        virtual/opengl
        !jit? ( dev-lang/lua )
        jit? ( dev-lang/luajit )
        "

S=${S}/src
src_prepare() {
        cmake_src_prepare
		
        libdst=$(get_libdir)
		if [[ ${libdst} != "lib" ]]; then
			sed -i "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $libdst|g" ${S}/a12/CMakeLists.txt || die
            sed -i "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $libdst|g" ${S}/a12/CMakeLists.txt || die
			sed -i "s|ASHMIF_INSTPATH lib|ASHMIF_INSTPATH $libdst|g" ${S}/shmif/CMakeLists.txt || die
		fi
}

src_configure() {
	if use debug; then
	    bt="Debug"
	else
	    bt="Release"
	fi
       local mycmakeargs=(
            -DAGP_PLATFORM=gl21
            -DHYBRID_HEADLESS=$(usex hybrid-headless)
            -DHYBRID_SDL=$(usex hybrid-sdl)
            -DSTATIC_SQLite3=Off
            -DSTATIC_OPENAL=Off
            -DSTATIC_FREETYPE=Off
            -DBUILTIN_LUA=Off
            -DENABLE_LTO=$(usex lto)
            -DENABLE_LWA=$(usex lwa)
            -DENABLE_SIMD=$(usex simd)
            -DLIBRARY_OUTPUT_DIRECTORY=$(get_libdir)
       )
       if use jit; then
           mycmakeargs+=( -DDISABLE_JIT=Off )
       else
           mycmakeargs+=( -DDISABLE_JIT=On )
       fi
       if use frameservers; then
           mycmakeargs+=( -DNO_FSRV=Off )
       else
           mycmakeargs+=( -DNO_FSRV=On )
       fi
       if use wayland; then
           mycmakeargs+=( -DDISABLE_WAYLAND=Off )
       else
           mycmakeargs+=( -DDISABLE_WAYLAND=On )
       fi
       if use dri; then
           mycmakeargs+=(-DVIDEO_PLATFORM=egl-dri)
       else
           mycmakeargs+=(-DVIDEO_PLATFORM=sdl2)
       fi

       CMAKE_BUILD_TYPE=${bt}
       cmake_src_configure
}
