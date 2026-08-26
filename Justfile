alias eb := export-build
alias l := list
alias u := update
alias a := add
alias rm := remove
alias s := status

set working-directory := 'modpack'

_default:
	@just --list

export-build:
    @pakku export --no-server

list:
    @pakku ls

update:
    @pakku update --all

add MOD_SLUG:
    @pakku add prj --modrinth {{MOD_SLUG}}

remove MOD_SLUG:
    @pakku rm {{MOD_SLUG}}

status:
    @pakku status
