alias em := export-modpack
alias l := list
alias u := update
alias a := add
alias rm := remove

set working-directory := 'modpack'

_default:
	@just --list

export-modpack:
    @pakku export --no-server

list:
    @pakku ls

update:
    @pakku update --all

add MOD_SLUG:
    @pakku add prj --modrinth {{MOD_SLUG}}

remove MOD_SLUG:
    @pakku rm {{MOD_SLUG}}
