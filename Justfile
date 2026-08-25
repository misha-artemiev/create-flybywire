alias em := export-modpack
alias r := refresh
alias l := list
alias u := update
alias a := add
alias rm := remove
alias ml := modlist

set working-directory := 'modpack'

_default:
	@just --list

export-modpack:
    @pakku export --no-server

refresh:
    @packwiz refresh

list:
    @pakku ls

update:
    @pakku update --all

add MOD_SLUG:
    @pakku add prj --modrinth {{MOD_SLUG}}

remove MOD_NAME:
    @packwiz rm {{MOD_NAME}}

modlist:
    @python ../scripts/modlist.py
