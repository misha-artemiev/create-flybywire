alias e := export
alias r := refresh
alias l := list
alias u := update

_default:
	@just --list

export:
	@packwiz --pack-file modpack/pack.toml modrinth export

refresh:
	@packwiz --pack-file modpack/pack.toml refresh

list:
	@packwiz --packfile modpack/pack.toml list --version

update:
	@packwiz --packfile modpack/pack.toml update --all
