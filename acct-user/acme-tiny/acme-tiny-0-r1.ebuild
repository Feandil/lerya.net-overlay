EAPI=8

inherit acct-user

DESCRIPTION="user for acme-tiny cron"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( acme-tiny )
ACCT_USER_HOME=/opt/acme-tiny

acct-user_add_deps
