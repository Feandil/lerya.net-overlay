# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="7"

IUSE=""
MODS="acmetiny"
POLICY_FILES="acmetiny.fc acmetiny.te"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for acme-tiny"

KEYWORDS="~amd64 ~x86"
