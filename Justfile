alias eb := export-build
alias l := list
alias u := update
alias am := add-modrinth
alias ag := add-github
alias rm := remove
alias s := status
alias rml := release-modlist
alias rd := release-darwin

set working-directory := 'modpack'

_default:
	@just --list

export-build:
    @pakku export --no-server

list:
    @pakku ls

update:
    @pakku update --all

add-modrinth MOD_SLUG:
    @pakku add prj --modrinth {{MOD_SLUG}}

add-github MOD_REPO:
    @pakku add prj --gh {{MOD_REPO}}

remove MOD_SLUG:
    @pakku rm {{MOD_SLUG}}

status:
    @pakku status

release-modlist:
    @../scripts/release-modlist.bash pakku-lock.json

release-darwin:
    @just export-build
    @just release-modlist | pbcopy - 
    @open build/modrinth
