alias e := export
alias r := refresh

_default:
	@just --list

export:
	@packwiz modrinth export

refresh:
	@packwiz refresh
