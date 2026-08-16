alias me := modrinth-export
alias r := refresh
alias l := list
alias lf := list-files
alias u := update
alias mi := modrinth-install
alias rm := remove

set working-directory := 'modpack'

_default:
	@just --list

modrinth-export:
    @packwiz modrinth export

refresh:
    @packwiz refresh

list:
    @packwiz list --version

list-files:
    @ls mods

update:
    @packwiz update --all

modrinth-install MOD_NAME:
    @packwiz modrinth install {{MOD_NAME}}

remove MOD_NAME:
    @packwiz rm {{MOD_NAME}}
