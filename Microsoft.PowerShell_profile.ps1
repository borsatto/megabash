function Invoke-Starship-TransientFunction {
	&starship module character
}

$ENV:STARSHIP_CONFIG = "/root/.config/powershell/tokyo-night.toml"


Invoke-Expression (&starship init powershell)
