# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="phpfpm"
BASEPOL="2.20120725-r5"
POLICY_FILES="phpfpm.if phpfpm.fc phpfpm.te"

inherit distutils eutils selinux-policy-2

DESCRIPTION="SELinux policy for phpfpm"

KEYWORDS="~amd64 ~x86"
DEPEND="${DEPEND}
        sec-policy/selinux-apache
"
RDEPEND="${DEPEND}"
