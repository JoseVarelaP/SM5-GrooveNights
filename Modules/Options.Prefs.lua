return {
	DefaultJudgmentSize =
	{
		Default = 1,
		Choices = fornumrange(0.1,1.5,0.1),
		Values = fornumrange(0.1,1.5,0.1),
	},
	DefaultJudgmentOpacity =
	{
		Default = 1,
		Choices = fornumrange(0,1,0.1),
		Values = fornumrange(0,1,0.1),
	},
	ToggleJudgmentBounce =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TournamentCrownEnabled =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	DefaultComboSize =
	{
		Default = 1,
		Choices = fornumrange(0.1,1.5,0.1),
		Values = fornumrange(0.1,1.5,0.1),
	},
	ToggleComboSizeIncrease =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleComboBounce =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleComboExplosion =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleEXPCounter = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
}
