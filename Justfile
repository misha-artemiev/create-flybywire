alias e := export
alias r := refresh
alias l := list
alias u := update
alias mi := modrinth-install

set working-directory := 'modpack'

_default:
	@just --list

export:
	@packwiz modrinth export

refresh:
	@packwiz modpack/pack.toml refresh

list:
	@packwiz list --version

update:
	@packwiz update --all

modrinth-install MOD_NAME:
	@packwiz modrinth install {{MOD_NAME}}
