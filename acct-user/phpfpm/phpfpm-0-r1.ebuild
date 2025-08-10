EAPI=8

inherit acct-user

DESCRIPTION="user for PHP fpm"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( phpfpm icinga icingacmd )
ACCT_USER_HOME=/var/www

acct-user_add_deps
