divert(-1)

# We require the _BOARD_ variable to be defined so let's check
ifdef(`_BOARD_',,`errprint(`_BOARD_ have to be defied when gerating new userlist. For example pass argument -D _BOARD_=turris to m4.')m4exit(`1')')
# Also we use the _BRANCH_ variable, but if it isn't defined than it means deploy
# and if defined as deploy then we undefine it.
ifelse(_BRANCH_,deploy,`undefine(`_BRANCH_')',)


# Transform lines in file to comma separated arguments
# Usage: file2args(`FILE')
define(`file2args',`syscmd(test -f _INCLUDE_`'$1)ifelse(sysval,0,,`errprint(File $1 is missing!)m4exit(`1')')dnl
esyscmd(`sed "/^#/d;s/\s//g;/^\s*\$/d" '_INCLUDE_`$1 | paste -sd "," | tr -d "\n"')')

# Expand second argument for all arguments after second one defined as macro
# with name of first argument.
# Usage: foreach(X,TEXT(X),a,b)
define(`foreach',`ifelse(eval($#>2),1,`pushdef(`$1',`$3')$2`'popdef(`$1')`'ifelse(eval($#>3),1,`$0(`$1',`$2',shift(shift(shift($@))))')')')

# Expand second argument for all arguments after third one defined as macro with
# name of fist argument. Every argument is then joined by third argument.
# Usage: foreach_join(X,TEXT(X),Y,a,b)
define(`foreach_join',`ifelse(eval($#>3),1,`pushdef(`$1',`$4')$2`'ifelse(eval($#>4),1,`$3')`'popdef(`$1')`'ifelse(eval($#>4),1,`$0(`$1',`$2',`$3',shift(shift(shift(shift($@)))))')')')

# Generate Install command with given PKGBASE and PKGPARTs joined: PKGBASE-PKGPART
# Usage: forInstall(PKGBASE, PKGPARTa, PKGPARTb)
define(`forInstall',`Install(foreach_join(PKGPART,`"$1-PKGPART"',`, ',shift($@)), { priority = 40 })')
define(`forInstallCritical',`Install(foreach_join(PKGPART,`"$1-PKGPART"',`, ',shift($@)), { critical = true })')

# Add languages packages for Luci
# Usage: _LUCI_I18N_(APP)
define(`_LUCI_I18N_',`local luci_i18n = {["en"] = true} -- we always install English localization
for _, lang in pairs(l10n or {}) do
	luci_i18n[lang] = true
end
for lang in pairs(luci_i18n) do
	for _, pkg in pairs({foreach_join(X,`"X"',`, ',$@)}) do
		Install("luci-i18n-" .. pkg .. "-" .. lang, { ignore = {"missing"}, priority = 40 })
	end
end')

# Feature guard
# Some packages might not be installable without some features. Skipping every
# additional packages ensures that at least updater is updated.
define(`_FEATURE_GUARD_', `if features and features.provides and features.conflicts then -- Advanced dependencies guard')
define(`_END_FEATURE_GUARD_', `end')

divert(0)dnl
