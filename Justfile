alias e := export
alias r := refresh
alias l := list
alias u := update

_default:
	@just --list

export:
	@packwiz modrinth export

refresh:
	@packwiz refresh

list:
	@packwiz list --version

update:
	@packwiz update --all
