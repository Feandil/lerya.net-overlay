EAPI="2"

inherit eutils linux-mod
SRC_URI="https://github.com/Feandil/${PN}/archive/v${PVR}.tar.gz"

DESCRIPTION="Block incoming modules and log emergency alerts in case of trying to insert a new module or removing an existing one"
HOMEPAGE="https://github.com/CERN-CERT/${PN}/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"
MODULE_NAMES="dresden(misc:${S}:${S}) "

pkg_setup() {
	CONFIG_CHECK="~CONFIG_MODULES"

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

