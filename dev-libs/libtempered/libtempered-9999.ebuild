EAPI="3"

inherit toolchain-funcs eutils git-2 cmake-utils

EGIT_REPO_URI="https://github.com/edorfaus/TEMPered.git"
KEYWORDS=""

DESCRIPTION="C library and program for reading the TEMPer family of thermometer and hygrometer devices"
HOMEPAGE="https://github.com/edorfaus/TEMPered"

LICENSE="BSD-2"
SLOT="0"
RDEPEND="dev-libs/hidapi"

src_prepare() {
	epatch "${FILESDIR}/libtempered-9999-build-only-lib.patch"
}
