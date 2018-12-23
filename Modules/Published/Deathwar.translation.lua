T = {
	fr = {
		scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victoires<font face='Lucida Console'><r>\n   n. joueur           victoires     survies\n</r>",
		offset = "Ton offset a bien été changé en X:%d Y:%d.",
		accept = " Acceptes-tu ? </fc><vp><a href='event:%s$oui'>Oui</a></vp> | <r><a href='event:%s$non'>Non</a><r/>",
		help_txt = "Bienvenue dans DeathWar,\nCe module consiste à avoir des équipes ( 5 maximum ) qui s'affrontent. Chaque équipe peut contenir 10 joueurs maximum.\nUn chef par équipe sera désigné pour mettre de l'ordre. Il aura la possibilité de faire certaines <a href='event:$call$help$n$N2'><u><vp>!commande</vp></u></a>.\n\nUne fois que toutes les équipes sont prêtes, le combat commence !\n\nSignalez-moi les bugs que vous rencontrez par messages sur le forum! Décrivez le bug avec autant de détails que possible, avec un screen si possible.\n\n<p align='right'>Module imaginé par <bv>Sourixl</bv>, créé par <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
		win_close = "Fermer cette fenêtre",
		team = {
			color = "Choisis la couleur de ton équipe.",
			done = "Prêts",
			quit = "Quitter",
			join = "Rejoindre",
			win = "%s a gagné !"
		},
		commands = {
			pause = {
				ask = "<j>%s</j><fc> veut faire une pause.",
				set = "La pause arrive à la prochaine map !",
			},
			nc_last = {
				ask = "<j>%s</j><fc> veut annuler le point précédant.",
				set = "Le dernier point a été annulé !",
			},
			nc_next = {
				ask = "<j>%s</j><fc> veut annuler le prochain point.",
				set = "Le prochain point ne comptera pas !",
			},
			skip = {
				ask = "<j>%s</j><fc> veut passer la map.",
				set = "Passons à la prochaine map !",
			},
			untilwin = {
				ask = "<j>%s</j><fc> veut mettre un temps illimité à cette partie.",
				set = "Le temps de cette partie est infini !",
			},
		},
		HELP = {
			title={txt="Liste des commandes", color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
			p = {
				{txt="Pour les chefs d'équipes:", u=true,
					content = {
						{cmd="help",                  description="Affiche de l'aide."},
						{cmd="commands",              description="Affiche la liste des commandes."},
						{cmd="color",                 description="Changer la couleur de son équipe."},
						{cmd="name",  arg={"nom"},    description="Changer le nom de son équipe."},
						{cmd="ban",   arg={"joueur"}, description="Bannir une personne de son équipe."},
						{cmd="unban", arg={"joueur"}, description="Dé-bannir une personne de son équipe."},
						{cmd="done",                  description="Une fois que l'équipe est prête."},
						{cmd="pause",                 description="Faire un vote pour une pause de maximum 5min."},
						{cmd="skip",                  description="Mets la map suivante."},
						{cmd="untilwin",              description="La map est jouée jusqu'à la victoire d'une équipe."},
						{cmd="nc",    arg={"type"},   description="Deux types différents:\n\t\t\t\t\t\t\t\t- 'last' qui annule le point précédant.\n\t\t\t\t\t\t\t\t- 'next' qui annule le prochain point."},
						--{cmd="<r>changement</r>", arg={"j1", "j2", f={"j", "fc"}}, description="Permet de remplacer une <j>personne de votre équipe</j> par un <fc>spectateur</fc>."},
					}
				},
				{txt="Pour les joueurs:", u=true,
					content = {
						{cmd="off",    arg={"x", "y"}, description="Changer son offset."},
						{cmd="offset", arg={"x", "y"}, description="Similaire à !off."},
						{cmd="help",                   description="Montre de l'aide."},
						{cmd="command",                description="Montre toutes les commandes."},
						{cmd="cmd",                    description="Similaire à !command."},
					}
				}
			}
		}
	},
	en = {
		scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victories<font face='Lucida Console'><r>\n   n. player           victories     survives\n</r>",
		offset = "Your offset has been changed into X:%s Y:%s.",
		accept = " Do you accept ? </fc><vp><a href='event:%s$oui'>Yes</a></vp> | <r><a href='event:%s$non'>No</a><r/>",
		help_txt = "Welcome to DeathWar,\nThis module consist to be in a confrontation between others teams ( 5 maximum ). Each team can had a maximum of 10 players.\nThe player who create a team is its leader, all leaders make order. They have the possibility to make some <a href='event:$call$help$n$N2'><u><vp>!commands</vp></u></a>.\n\nWhen all teams are ready, the fight can begin !\n\nReport me all the bugs you meet on the forum! Describe the bug and if possible, give me a screenshot.\n\n<p align='right'>Module conceived by <bv>Sourixl</bv>, created by <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
		win_close = "Close",
		team = {
			color = "Choose your team's color.",
			done = "Ready",
			quit = "Quit",
			join = "Join",
			win = "%s has won !"
		},
		commands = {
			pause = {
				ask = "<j>%s</j><fc> wants to make a break.",
				set = "Let's make a break !"
			},
			nc_last = {
				ask = "<j>%s</j><fc> wants to delete the previous point.",
				set = "The last point has been deleted !",
			},
			nc_next = {
				ask = "<j>%s</j><fc> wants to cancel the next point.",
				set = "The next point won't count !",
			},
			skip = {
				ask = "<j>%s</j><fc> wants to skip this map.",
				set = "Let's move on the next map !",
			},
			untilwin = {
				ask = "<j>%s</j><fc> wants to set the time to infinite for this map.",
				set = "The game's time is infinite !",
			},
		},
		HELP = {
			title={txt="Commands list", color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
			p = {
				{txt="For the leaders:", u=true,
					content = {
						{cmd="help",                  description="Shows the help."},
						{cmd="commands",              description="Shows the commands list."},
						{cmd="color",                 description="Change your team's color."},
						{cmd="name",  arg={"name"},   description="Change your name's team."},
						{cmd="ban",   arg={"player"}, description="Ban a player from your team."},
						{cmd="unban", arg={"player"}, description="Unban a player from your team."},
						{cmd="done",                  description="To inform the others teams that you're ready. You can't do any team commands while you're 'done'."},
						{cmd="pause",                 description="Make a break of 5 min max."},
						{cmd="skip",                  description="Skip the map."},
						{cmd="untilwin",              description="The current map is played until one team win."},
						{cmd="nc",    arg={"type"},   description="Two different types:\n\t\t\t\t\t\t\t\t- 'last' cancel the previous point.\n\t\t\t\t\t\t\t\t- 'next' cancel the next point."},
					}
				},
				{txt="For all:", u=true,
					content = {
						{cmd="off",    arg={"x", "y"}, description="Change your offset."},
						{cmd="offset", arg={"x", "y"}, description="Similar to !off."},
						{cmd="lang",  arg={"lang"},    description="Change the language of the module."},
						{cmd="help",                   description="Shows help."},
						{cmd="command",                description="Shows all the commands."},
						{cmd="cmd",                    description="Similar to !command."},
					}
				}
			}
		}
	},
	lv = {
		scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victories<font face='Lucida Console'><r>\n   n. player           victories     survives\n</r>",
		offset = "Your offset has been changed into X:%s Y:%s.",
		accept = " Do you accept ? </fc><vp><a href='event:%s$oui'>Yes</a></vp> | <r><a href='event:%s$non'>No</a><r/>",
		help_txt = "Welcome to DeathWar,\nThis module consist to be in a confrontation between others teams ( 5 maximum ). Each team can had a maximum of 10 players.\nThe player who create a team is its leader, all leaders make order. They have the possibility to make some <a href='event:$call$help$n$N2'><u><vp>!commands</vp></u></a>.\n\nWhen all teams are ready, the fight can begin !\n\nReport me all the bugs you meet on the forum! Describe the bug and if possible, give me a screenshot.\n\n<p align='right'>Module conceived by <bv>Sourixl</bv>, created by <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
		win_close = "Close",
		team = {
			color = "Choose your team's color.",
			done = "Ready",
			quit = "Quit",
			join = "Join",
			win = "%s has won !"
		},
		commands = {
			pause = {
				ask = "<j>%s</j><fc> wants to make a break.",
				set = "Let's make a break !"
			},
			nc_last = {
				ask = "<j>%s</j><fc> wants to delete the previous point.",
				set = "The last point has been deleted !",
			},
			nc_next = {
				ask = "<j>%s</j><fc> wants to cancel the next point.",
				set = "The next point won't count !",
			},
			skip = {
				ask = "<j>%s</j><fc> wants to skip this map.",
				set = "Let's move on the next map !",
			},
			untilwin = {
				ask = "<j>%s</j><fc> wants to set the time to infinite for this map.",
				set = "The game's time is infinite !",
			},
		},
		HELP = {
			title={txt="Commands list", color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
			p = {
				{txt="For the leaders:", u=true,
					content = {
						{cmd="help",                  description="Shows the help."},
						{cmd="commands",              description="Shows the commands list."},
						{cmd="color",                 description="Change your team's color."},
						{cmd="name",  arg={"name"},   description="Change your name's team."},
						{cmd="ban",   arg={"player"}, description="Ban a player from your team."},
						{cmd="unban", arg={"player"}, description="Unban a player from your team."},
						{cmd="done",                  description="To inform the others teams that you're ready. You can't do any team commands while you're 'done'."},
						{cmd="pause",                 description="Make a break of 5 min max."},
						{cmd="skip",                  description="Skip the map."},
						{cmd="untilwin",              description="The current map is played until one team win."},
						{cmd="nc",    arg={"type"},   description="Two different types:\n\t\t\t\t\t\t\t\t- 'last' cancel the previous point.\n\t\t\t\t\t\t\t\t- 'next' cancel the next point."},
					}
				},
				{txt="For all:", u=true,
					content = {
						{cmd="off",    arg={"x", "y"}, description="Change your offset."},
						{cmd="offset", arg={"x", "y"}, description="Similar to !off."},
						{cmd="lang",  arg={"lang"},    description="Change the language of the module."},
						{cmd="help",                   description="Shows help."},
						{cmd="command",                description="Shows all the commands."},
						{cmd="cmd",                    description="Similar to !command."},
					}
				}
			}
		}
	},
	br = {
		scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victories<font face='Lucida Console'><r>\n   n. player           victories     survives\n</r>",
		offset = "Your offset has been changed into X:%s Y:%s.",
		accept = " Do you accept ? </fc><vp><a href='event:%s$oui'>Yes</a></vp> | <r><a href='event:%s$non'>No</a><r/>",
		help_txt = "Welcome to DeathWar,\nThis module consist to be in a confrontation between others teams ( 5 maximum ). Each team can had a maximum of 10 players.\nThe player who create a team is its leader, all leaders make order. They have the possibility to make some <a href='event:$call$help$n$N2'><u><vp>!commands</vp></u></a>.\n\nWhen all teams are ready, the fight can begin !\n\nReport me all the bugs you meet on the forum! Describe the bug and if possible, give me a screenshot.\n\n<p align='right'>Module conceived by <bv>Sourixl</bv>, created by <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
		win_close = "Close",
		team = {
			color = "Choose your team's color.",
			done = "Ready",
			quit = "Quit",
			join = "Join",
			win = "%s has won !"
		},
		commands = {
			pause = {
				ask = "<j>%s</j><fc> wants to make a break.",
				set = "Let's make a break !"
			},
			nc_last = {
				ask = "<j>%s</j><fc> wants to delete the previous point.",
				set = "The last point has been deleted !",
			},
			nc_next = {
				ask = "<j>%s</j><fc> wants to cancel the next point.",
				set = "The next point won't count !",
			},
			skip = {
				ask = "<j>%s</j><fc> wants to skip this map.",
				set = "Let's move on the next map !",
			},
			untilwin = {
				ask = "<j>%s</j><fc> wants to set the time to infinite for this map.",
				set = "The game's time is infinite !",
			},
		},
		HELP = {
			title={txt="Commands list", color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
			p = {
				{txt="For the leaders:", u=true,
					content = {
						{cmd="help",                  description="Shows the help."},
						{cmd="commands",              description="Shows the commands list."},
						{cmd="color",                 description="Change your team's color."},
						{cmd="name",  arg={"name"},   description="Change your name's team."},
						{cmd="ban",   arg={"player"}, description="Ban a player from your team."},
						{cmd="unban", arg={"player"}, description="Unban a player from your team."},
						{cmd="done",                  description="To inform the others teams that you're ready. You can't do any team commands while you're 'done'."},
						{cmd="pause",                 description="Make a break of 5 min max."},
						{cmd="skip",                  description="Skip the map."},
						{cmd="untilwin",              description="The current map is played until one team win."},
						{cmd="nc",    arg={"type"},   description="Two different types:\n\t\t\t\t\t\t\t\t- 'last' cancel the previous point.\n\t\t\t\t\t\t\t\t- 'next' cancel the next point."},
					}
				},
				{txt="For all:", u=true,
					content = {
						{cmd="off",    arg={"x", "y"}, description="Change your offset."},
						{cmd="offset", arg={"x", "y"}, description="Similar to !off."},
						{cmd="lang",  arg={"lang"},    description="Change the language of the module."},
						{cmd="help",                   description="Shows help."},
						{cmd="command",                description="Shows all the commands."},
						{cmd="cmd",                    description="Similar to !command."},
					}
				}
			}
		}
	},
	tr = {
		scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s puan\t\t%s zaferler<font face='Lucida Console'><r>\n   n. Oyuncular         zaferler     hayatta kalmalar\n</r>",
		offset =     "Ofsetiniz X:%s Y:%s olarak değiştirildi.",
		accept =     " Kabul ediyor musun? </fc><vp><a href='event:%s$oui'>Evet</a></vp> | <r><a href='event:%s$non'>Hayır</a><r/>",
		help_txt =   "DeathWar'a hoş geldin, \nBu modül diğer takımlarla çatışma halinde bulunmaktan ibarettir.(en fazla beş). Her takımda en fazla on oyuncu olabilir. \nTakımı kuran ilk oyuncu takım lideri olur, tüm liderler emir verir. Liderin bazı <a href='event:$call$help$n$N2'><u><vp>!commands</vp></u></a> yapma imkanına sahiptir.\n\nTüm takımlar hazır olduğunda, savaş başlayabilir!\n\nKraşılaştığınız hataları forum üzerinden bana bildirin! Eğer mümkünse hatayı açıklayın, bana ekran görüntüsü yollayın.\n\n<p align='right'><bv>Sourixl</bv> tarafından tasarlanmış, <n2>Athesdrake#0000</n2> tarafından oluşturulmuştur.<vp>Honorabilis</vp> tarafından Türkçeleştirildi.</p>\n\n\n<vi>Sürüm</vi> <rose>%s</rose>",
		win_close =  "Kapat",
		team = {
			color = "Takımının rengini seç.",
			done =  "Hazır",
			quit =  "Çık",
			join =  "Katıl",
			win =   "%s kazandı!"
		},
		commands = {
			pause = {
				ask = "<j>%s</j><fc> mola istiyor.",
				set = "Hadi mola verelim!"
			},
			nc_last = {
				ask = "<j>%s</j><fc> bir önceki puanı yok saymak istiyor.",
				set = "Son puan yok sayıldı!",
			},
			nc_next = {
				ask = "<j>%s</j><fc> bir sonraki puanı yok saymak istiyor.",
				set = "Bir sonraki puan yok sayılacak.",
			},
			skip = {
				ask = "<j>%s</j><fc> bu haritayı geçmek istiyor.",
				set = "Hadi sonraki haritaya geçelim!",
			},
			untilwin = {
				ask = "<j>%s</j><fc> bu haritanın süresini sınırsız yapmak istiyor.",
				set = "Bu haritanın süresi sınırsız!",
			},
		},
		HELP = {
			title={txt="Komutlar Listesi",color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
			p = {
				{txt="Liderler için:", u=true,
					content = {
						{cmd="help",                  description="Yardım sayfasını gösterir."},
						{cmd="commands",              description="Komutlar listesini gösterir."},
						{cmd="color",                 description="Takımını rengini değiştirir."},
						{cmd="name",  arg={"isim"},   description="Takımının ismini değiştirir."},
						{cmd="ban",   arg={"oyuncu"}, description="Takımındaki bir oyuncuyu yasaklar."},
						{cmd="unban", arg={"oyuncu"}, description="Takımındaki bir oyuncunun yasağını kaldırır."},
						{cmd="done",                  description="Diğer takımlara senin takımının hazır olduğunu bildirir. Hazırken hiçbir takım komuu veremezsin."},
						{cmd="pause",                 description="En fazla beş dakikalık mola verir."},
						{cmd="skip",                  description="Haritayı geçer."},
						{cmd="untilwin",              description="Herhangi bir takım kazanana kadar geçerli harita oynanır."},
						{cmd="nc",    arg={"tür"},    description="İki farklı tür:\n\t\t\t\t\t\t\t\t- 'last' bir önceki punaı yok sayar.\n\t\t\t\t\t\t\t\t- 'next' bir sonraki puanı yok sayar."},
					}
				},
				{txt="Herkes için:", u=true,
					content = {
						{cmd="off",    arg={"x", "y"}, description="Ofsetini değiştirir."},
						{cmd="offset", arg={"x", "y"}, description="!off komutu ile aynıdır."},
						{cmd="help",                   description="Yardım menüsünü gösteirir."},
						{cmd="command",                description="Tüm komutların listesini gösterir."},
						{cmd="cmd",                    description="!command komutu ile aynıdır."},
					}
				}
			}
		}
	},
}