EAPI="2"

inherit eutils linux-mod

SRC_URI="https://github.com/Feandil/${PN}/archive/${PVR}.tar.gz"

DESCRIPTION="Kernel-based network logging tool"
HOMEPAGE="https://github.com/Feandil/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"
MODULE_NAMES="netlog(misc:${S}:${S}) "

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -ie 's/\tmake/\t+make/' Makefile || die "Sed failure"
}

pkg_setup() {
        CONFIG_CHECK="KPROBES OPTPROBES !GRKERNSEC_HIDESYM"

        linux-mod_pkg_setup

        BUILD_TARGETS="all"
}

src_compile() {
        linux-mod_src_compile
}

src_install() {
        linux-mod_src_install
}

pkg_preinst() {
        linux-mod_pkg_preinst
}

