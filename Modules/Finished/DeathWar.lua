--[[        Module created by Athesdrake        ]]--
--[[  http://atelier801.com/topic?f=6&t=852348  ]]--

limite = 10
function main()
	--vars:
		start = false
		setup = true
		lobby = true
		joinQuit = true
		uwin = true
		fireworks = false
		format = string.format
		currentMap = "@0"
		nextMap = "normal"
		version = "1.3.2"
		C = "center"
		L = "left"
		R = "right"
	--ids:
		idTeam = 100
		id_scoreboard = 5
		idTitle = 6
		idHelp = 7
		idPause = 8
		idTimer = 9
		idWinner = 10
		idOffChange = 11
		idLang = 12
		idInfo = 13
	--tables:
		players = {}
		pause = {p = false, vote={nbr=0, oui=0, non=0}}
		vote = {current=false}
		record = {}
		aft = {}
		nextRecord = true
		lastRecord = false
		--maps:
			maps = {"@4795468", "@4773530", "@4741240", "@4741230", "@4741187", "@4741121", "@4734142", "@4734088", "@4733964", "@4589495", "@4386849", "@3899992", "@3661362", "@3654127", "@3598126", "@3425866", "@3387205", "@3377082", "@3326933", "@3274133", "@3271109", "@3255179", "@3242667", "@3242517", "@3237641", "@3228893", "@3219038", "@3210915", "@3192515", "@2614830", "@2336509", "@2262150", "@2242196", "@2221226", "@2173893", "@2155997", "@2147778", "@2135605", "@2135145", "@2119852", "@2119800", "@2117839", "@2105100", "@2103061", "@2068587", "@2059382", "@2054347", "@2050554", "@2040205", "@2004074", "@1997222", "@1985670", "@1979178", "@1967362", "@1966987", "@1943308", "@1904053", "@1900275", "@1897581", "@1897390", "@1879154", "@1846255", "@1829042", "@1825269", "@1705433", "@1682014", "@1675013", "@1643446", "@1533678", "@1531279", "@1408028", "@1314982", "@1312845", "@1311136", "@1288489", "@1286824", "@965024", "@589708", "@559644", "@559634", "@541917", "@4741135", "@1922239", "@1659906"}
			-- previous list{'@5032645', '@5028790', '@5028785', '@5028742', '@5028732', '@5028724', '@5028719', '@5028718', '@5028713', '@5028712', '@5028710', '@5028708', '@5028706', '@5028703', '@5028698', '@4795468', '@4788935', '@4773530', '@4741240', '@4741230', '@4741210', '@4741187', '@4741180', '@4741135', '@4741121', '@4734196', '@4734142', '@4734088', '@4734030', '@4733964', '@4589495', '@4482813', '@4469762', '@4464477', '@4462420', '@4428376', '@4419442', '@4392183', '@4386849', '@4383742', '@4383258', '@4374762', '@4131862', '@3899992', '@3827437', '@3798599', '@3661362', '@3654127', '@3598126', '@3577308', '@3532350', '@3497786', '@3479878', '@3446890', '@3425866', '@3387205', '@3377082', '@3326933', '@3282267', '@3274133', '@3271109', '@3255179', '@3242667', '@3242517', '@3237641', '@3228893', '@3219038', '@3210915', '@3192515', '@2867351', '@2633322', '@2614830', '@2386206', '@2336509', '@2262150', '@2242196', '@2226913', '@2222125', '@2221623', '@2221226', '@2218853', '@2217944', '@2186266', '@2173893', '@2155997', '@2147778', '@2145870', '@2135605', '@2135145', '@2130154', '@2124484', '@2119852', '@2119800', '@2117839', '@2105100', '@2103061', '@2068587', '@2059382', '@2054347', '@2050554', '@2040205', '@2024135', '@2004074', '@1997222', '@1985670', '@1979178', '@1967497', '@1967362', '@1966987', '@1960602', '@1953765', '@1943308', '@1922239', '@1904053', '@1901780', '@1900275', '@1897960', '@1897581', '@1897390', '@1879801', '@1879154', '@1870360', '@1846255', '@1840913', '@1829042', '@1825269', '@1824622', '@1794409', '@1790994', '@1768083', '@1766854', '@1757177', '@1745896', '@1741100', '@1738707', '@1737915', '@1705433', '@1700322', '@1700119', '@1699880', '@1682014', '@1675316', '@1675013', '@1659906', '@1643446', '@1624034', '@1616785', '@1601580', '@1596270', '@1582146', '@1563534', '@1545219', '@1533678', '@1531402', '@1531320', '@1531316', '@1531295', '@1531279', '@1408028', '@1351237', '@1349878', '@1348152', '@1343986', '@1318248', '@1314982', '@1312845', '@1311136', '@1298164', '@1296949', '@1288489', '@1286824', '@1276664', '@1255983', '@1057753', '@965024', '@910078', '@873428', '@869836', '@770600', '@644588', '@623770', '@589800', '@589708', '@559644', '@559634', '@541917'}
			-- 198 maps → 84 maps
			lobby_map = [[<C><P F="7" /><Z><S><S P="0,0,0,,0,0,0,0" L="10" o="324650" H="400" Y="200" T="12" X="-5" /><S P="0,0,0.3,0.2,,0,0,0" L="820" o="324650" H="10" Y="-5" T="12" X="400" /><S P="0,0,0,,0,0,0,0" L="10" o="324650" H="400" Y="200" T="12" X="805" /><S P="0,0,0.3,0.2,,0,0,0" L="820" o="324650" H="10" Y="405" T="12" X="400" /><S P="0,0,0.3,0.2,,0,0,0" L="800" o="324650" H="10" Y="145" T="12" X="400" /><S L="51" o="222222" c="4" X="710" H="10" Y="83" T="13" P="0,0,0.3,0.2,,0,0,0" /><S c="4" P="0,0,0.3,0.2,,0,0,0" L="49" o="292929" H="10" Y="83" T="13" X="710" /><S P="0,0,0.3,0.2,,0,0,0" L="39" o="1b1b1b" c="4" X="708" Y="91" T="13" H="10" /><S P="0,0,0.3,0.2,,0,0,0" L="40" c="4" o="292929" X="711" Y="86" T="13" H="10" /><S P="0,0,0.3,0.2,,0,0,0" L="12" o="4a5257" c="4" X="737" Y="57" T="13" H="10" /><S L="60" c="4" o="5c676d" X="710" H="10" Y="83" T="12" P="0,0,0.3,0.2,,0,0,0" /><S L="30" o="5c676d" c="4" X="725" H="10" Y="72" T="12" P="0,0,0.3,0.2,40,0,0,0" /><S P="0,0,0.3,0.2,-40,0,0,0" L="30" o="5c676d" c="4" H="10" Y="94" T="12" X="725" /><S P="0,0,0.3,0.2,,0,0,0" L="10" o="4a5257" c="4" X="710" Y="44" T="13" H="10" /><S P="0,0,0.3,0.2,,0,0,0" L="51" o="222222" c="4" H="10" Y="83" T="13" X="92" /><S L="49" c="4" o="292929" H="10" X="92" Y="83" T="13" P="0,0,0.3,0.2,,0,0,0" /><S L="39" o="1b1b1b" c="4" X="96" H="10" Y="90" T="13" P="0,0,0.3,0.2,,0,0,0" /><S L="40" c="4" o="292929" X="93" H="10" Y="85" T="13" P="0,0,0.3,0.2,,0,0,0" /><S L="12" o="4a5257" c="4" X="64" H="10" Y="57" T="13" P="0,0,0.3,0.2,,0,0,0" /><S P="0,0,0.3,0.2,,0,0,0" L="60" o="5c676d" c="4" H="10" Y="83" T="12" X="92" /><S P="0,0,0.3,0.2,140,0,0,0" L="30" o="5c676d" c="4" H="10" Y="72" T="12" X="77" /><S L="30" o="5c676d" c="4" H="10" X="77" Y="93" T="12" P="0,0,0.3,0.2,-140,0,0,0" /><S L="10" o="4a5257" c="4" X="92" H="10" Y="43" T="13" P="0,0,0.3,0.2,,0,0,0" /></S><D><DS Y="83" X="399" /></D><O /></Z></C>]]
		--fin maps
		teams = {}
		todespawn = {}
		T = {
			fr = {
				scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victoires<font face='Lucida Console'><r>\n   n. joueur           victoires     survies\n</r>",
				offset = "Ton offset a bien été changé en X:%d Y:%d.",
				accept = " Acceptes-tu ? </fc><vp><a href='event:%s$oui'>Oui</a></vp> | <r><a href='event:%s$non'>Non</a><r/>",
				help_txt = "Bienvenue dans DeathWar,\nCe module consiste à avoir des équipes ( 5 maximum ) qui s'affrontent. Chaque équipe peut contenir 10 joueurs maximum.\nUn chef par équipe sera désigné pour mettre de l'ordre. Il aura la possibilité de faire certaines <a href='event:$call$help$n$N1'><u><vp>!commande</vp></u></a>.\n\nUne fois que toutes les équipes sont prêtes, le combat commence !\n\nSignalez-moi les bugs que vous rencontrez par messages sur le forum! Décrivez le bug avec autant de détails que possible, avec un screen si possible.\n\n<p align='right'>Module imaginé par <bv>Sourixl</bv>, créé par <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
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
				help_txt = "Welcome to DeathWar,\nThis module consist to be in a confrontation between others teams ( 5 maximum ). Each team can had a maximum of 10 players.\nThe player who create a team is its leader, all leaders make order. They have the possibility to make some <a href='event:$call$help$n$N1'><u><vp>!commands</vp></u></a>.\n\nWhen all teams are ready, the fight can begin !\n\nReport me all the bugs you meet on the forum! Describe the bug and if possible, give me a screenshot.\n\n<p align='right'>Module conceived by <bv>Sourixl</bv>, created by <n2>Athesdrake#0000</n2>.</p>\n\n\n<vi>Version</vi> <rose>%s</rose>",
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
				help_txt =   "DeathWar'a hoş geldin! \nBu modül diğer takımlarla çatışma halinde bulunmaktan ibarettir (en fazla beş). Her takımda en fazla on oyuncu olabilir. \nTakımı kuran ilk oyuncu takım lideri olur. Tüm liderler emirler verebilir. Liderler bazı <a href='event:$call$help$n$N1'><u><vp>!commands</vp></u></a> yapma imkanına sahiptir.\n\nTüm takımlar hazır olduğunda, savaş başlayabilir!\n\nKarşılaştığınız hataları forum üzerinden bana bildirin! Eğer mümkünse hatayı açıklayın, bana ekran görüntüsü yollayın.\n\n<p align='right'><bv>Sourixl</bv> tarafından tasarlanmış, <n2>Athesdrake#0000</n2> tarafından oluşturulmuştur.\n<vp>Honorabilis</vp> tarafından Türkçeleştirilmiştir.</p>\n\n\n<vi>Sürüm:</vi> <rose>%s</rose>",
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
						set = "Hadi, mola verelim!"
					},
					nc_last = {
						ask = "<j>%s</j><fc> bir önceki puanı yok saymak istiyor.",
						set = "Bir önceki puan yok sayıldı!",
					},
					nc_next = {
						ask = "<j>%s</j><fc> bir sonraki puanı yok saymak istiyor.",
						set = "Bir sonraki puan yok sayılacak.",
					},
					skip = {
						ask = "<j>%s</j><fc> bu haritayı geçmek istiyor.",
						set = "Hadi, sonraki haritaya geçelim!",
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
								{cmd="color",     	          description="Takımın rengini değiştirir."},
								{cmd="name",  arg={"isim"},   description="Takımın ismini değiştirir."},
								{cmd="ban",   arg={"oyuncu"}, description="Takımındaki bir oyuncuyu yasaklar."},
								{cmd="unban", arg={"oyuncu"}, description="Takımındaki bir oyuncunun yasağını kaldırır."},
								{cmd="done",                  description="Diğer takımlara senin takımının hazır olduğunu bildirir. Hazırken hiçbir takım komutu veremezsin."},
								{cmd="pause",                 description="En fazla beş dakikalık mola verir."},
								{cmd="skip",                  description="Geçerli haritayı atlar."},
								{cmd="untilwin",              description="Herhangi bir takım kazanana kadar geçerli harita oynanır."},
								{cmd="nc",    arg={"tür"},    description="İki farklı tür:\n\t\t\t\t\t\t\t\t- 'last', bir önceki punaı yok sayar.\n\t\t\t\t\t\t\t\t- 'next', bir sonraki puanı yok sayar."},
							}
						},
						{txt="Herkes için:", u=true,
							content = {
								{cmd="off",    arg={"x", "y"}, description="Ofsetini değiştirir."},
								{cmd="offset", arg={"x", "y"}, description="'!off' ile aynıdır."},
								{cmd="help",                   description="Yardım menüsünü gösterir."},
								{cmd="command",                description="Tüm komutların listesini gösterir."},
								{cmd="cmd",                    description="'!command' ile aynıdır."},
							}
						}
					}
				}
			},
			lv = {
				scoreboard = "%s<font size='%d'><u><b>%s</b></u></font>\t\t%s points\t\t%s victories<font face='Lucida Console'><r>\n   n. player           victories     survives\n</r>",
				offset = "Tavas izšaušanas koordinātas mainītas uz X:%s Y:%s.",
				accept = " Vai Tu piekrīti? ? </fc><vp><a href='event:%s$oui'>Jā</a></vp> | <r><a href='event:%s$non'>Nē</a><r/>",
				help_txt = "Esi sveicināts DeathWar,\nŠis modulis sastāv no cīņas starp komandām(Maksimāli 5). Katrā komandā var būt līdz pat desmit spēlētājiem.\nSpēlētājs, kas izveido komandu ir tās līderis. Tie spēj izmantot vairāk <a href='event:$call$help$n$N2'><u><vp>!čata komandu</vp></u></a>.\n\nKad visas komandas ir gatavas, cīņa var sākties !\n\nReportē man visas kļūdas, ko atrodi forumā! Paskaidro kļūdu, un ja iespējams, parādi ekrānuzņēmumu.\n\n<p align='right'>Ideja par module radās lietotājam <bv>Sourixl</bv>, veidoja <n2>Athesdrake#0000</n2>.\nTranslated in Latvian by <vp>Marciskris</vp>.</p>\n\n\n<vi>Versija</vi> <rose>%s</rose>",
				win_close = "Aizvērt",
				team = {
					color = "Izvēlies savas komandas krāsu.",
					done = "Gatavs",
					quit = "Iziet",
					join = "Pievienoties",
					win = "%s uzvarēja !"
				},
				commands = {
					pause = {
						ask = "<j>%s</j><fc> vēlas izsludināt pārtraukumu.",
						set = "Izsludinām pārtraukumu !"
					},
					nc_last = {
						ask = "<j>%s</j><fc> vēlas dzēst pēdējo punktu.",
						set = "Iepriekšējais punkts netika ieskaitīts !",
					},
					nc_next = {
						ask = "<j>%s</j><fc> vēlas neieskaitīt nākošo punktu.",
						set = "Nākošais punkts netiks ieskaitīts !",
					},
					skip = {
						ask = "<j>%s</j><fc> vēlas izlaist šo karti.",
						set = "Pārejam uz nākošo mapi !",
					},
					untilwin = {
						ask = "<j>%s</j><fc> vēlas noņemt laika ierobežojumus šajai mapei.",
						set = "Spēles laiks ir neierobežots !",
					},
				},
				HELP = {
					title={txt="Čata komandu saraksts", color=nil, bcolor=nil, size=nil, align=C, u=true, b=true, i=false},
					p = {
						{txt="Līderu čata komandas:", u=true,
							content = {
								{cmd="color",                 description="Nomaina Tavas komandas krāsu."},
								{cmd="name",  arg={"name"},   description="Nomaina Tavas komandas nosaukumu."},
								{cmd="ban",   arg={"player"}, description="Izmet spēlētāju no Tavas komandas."},
								{cmd="unban", arg={"player"}, description="Atbloķē spēlētāju no pievienošanās Tavai komandai."},
								{cmd="done",                  description="Paziņo citām komandām, ka esat gatavi. Jūs vairs nevarat lietot komandas čata komandas pēc šīs čata komandas lietošanas."},
								{cmd="pause",                 description="Izveido pārraukumu līdz 5 minūtēm."},
								{cmd="skip",                  description="Izlaiž tagadējo mapi."},
								{cmd="untilwin",              description="Esošā mape tiek spēlēta, līdz viena no komandām uzvar."},
								{cmd="nc",    arg={"type"},   description="Divi dažādi veidi:\n\t\t\t\t\t\t\t\t- 'last' neieskaita iepriekšējo punktu.\n\t\t\t\t\t\t\t\t- 'next' neieskaita nākošo punktu."},
							}
						},
						{txt="Publiskās čata komandas:", u=true,
							content = {
								{cmd="off",    arg={"x", "y"}, description="Izmaina izšaušanas koordinātas."},
								{cmd="offset", arg={"x", "y"}, description="Alteratīva !off."},
								{cmd="lang",  arg={"lang"},    description="Izmaina moduļa valodu."},
								{cmd="help",                   description="Parāda palīdzību."},
								{cmd="command",                description="Parāda visas komandas."},
								{cmd="cmd",                    description="Alternatīva !command."},
							}
						}
					}
				}
			},
		}
	--sytème:
		table.foreach(--disable
			{
				"AutoNewGame",
				"AutoShaman",
				"AutoTimeLeft",
				"AfkDeath",
				"MortCommand",
				"DebugCommand",
				"PhysicalConsumables"
			},
			function(_,v)
				tfm.exec["disable"..v](true)
			end
			)
		table.foreach({"off", "offset", "debug"}, function(_,v) system.disableChatCommandDisplay(v, true) end)
		table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
		setUp()
end

function eventNewPlayer(name)
	local co = tfm.get.room.playerList[name].community
	if not players[name] then
		players[name] = {team = 0, points = 0, survies = 0, offset = {x=2, y=8}, timestamp = os.time() +3000, chef=false, down = false, lang = T[co] and co or "en", afk_time=os.time()}
	elseif lobby and players[name].team~=0 then
		for k, v in pairs(teams) do
			if v[name] then
				v[name] = 1
				players[name].team = k
			end
		end
		tfm.exec.respawnPlayer(name)
		if teams[players[name].team].hide then teams[players[name].team].hide = false; reloadTeams(true) end
		tfm.exec.movePlayer(name, teams[players[name].team].spawn, 350)
	end
	help(name, 0)
	if tfm.get.room.currentMap=="@0" then
		ui.setMapName("<j>Sourixl<g> - @7103699 | <j>V"..version.." <n2>created by Athesdrake#0000\n")
		ui.addTextArea(idTitle, "<p align='center'><font color='#CC2126' size='75' face='Bauhaus 93'>DeathWar", nil, 0, 30, 800, 150, 0x0)
		reloadTeams()
		tfm.exec.respawnPlayer(name)
	end
	table.foreach({0,1,2,3,32,76}, function(k,v) system.bindKeyboard(name, v, true, true) end)
end

function eventPlayerLeft(name)
	if players[name] and players[name].team~=0 then
		teams[players[name].team].listPl[name] = 0
		if checkTeamActivity(players[name].team) then
			if lobby then
				reloadTeams(true)
			else
				local count = 0
				for key, data in pairs(teams) do
					if not data.hide then
						count = count +1
					end
				end
				if count<=1 then

				end
			end
		end
	end
end

function eventPlayerDied(name)
	if lobby then tfm.exec.respawnPlayer(name)
	elseif win and players[name].team~=0 then
		if countPl().alive<=1 then
			tfm.exec.setGameTime(5)
		end
		local team = leftTeam()
		if team~=0 and teams[team] then
			win = false
			uwin = true
			tfm.exec.setGameTime(5)
		end
	end
end

function eventKeyboard(name, key, down, x, y)
	local data = tfm.get.room.playerList[name]
	local pl = players[name]
	if key==0 then
		data.isFacingRight = false
		pl.isFacingRight = false
	end
	if key==2 then
		data.isFacingRight = true
		pl.isFacingRight = true
	end
	if (key==3 or key==32) and pl.timestamp<=os.time() and (not data.isDead) and start then
		local id = tfm.exec.addShamanObject(17, x+(pl.isFacingRight and pl.offset.x or -pl.offset.x), y+pl.offset.y, pl.isFacingRight and 90 or 270)
		table.insert(todespawn, {time = os.time()+1000, id = id})
		pl.timestamp = os.time() +1500
	end
	if key==76 and #teams>0 then
		if not players[name].down then
			players[name].down = true
			local txt = "<p align='center'><font size='30'><u>Scoreboard</u></font></p>\n"
			for k,data in pairs(teams) do
				local points, size = 0, (#data.name<=35 and 20 or 12)
				table.foreach(data.listPl, function(k,v) points = points +players[k].points end)
				data.points = points
				txt = format(translate("scoreboard", name), txt, size, data.name, points, data.victory)
				table.sort(data.listPl, function(a,b) return players[data.listPl[a]].points>players[data.listPl[b]].points end)
				local key = 1
				for pl, ishere in pairs(data.listPl) do
					local pt, su = tostring(players[pl].points), tostring(players[pl].survies)
					txt = format("%s   <n>%0d. <v>%s<n><j>%s</j></n></v></n>\n", txt, key, pl..(" "):rep(21 -#pl), pt..(" "):rep(13 -#pt)..su)
					key = key +1
				end
				-- local pl, pt = "Dieutoutpuissant", "∞"
				-- txt = format("%s   <n>%0d. <v>%s<n><j>%s</j></n></v></n>\n", txt, 2, pl..(" "):rep(21 -#pl), pt..(" "):rep(13 -#pt).."0")
				txt = txt.."</font>\n\n"
			end
			ui.addBox(id_scoreboard, txt, name, 50, 27, 700, 350)
			ui.addTextArea(id_scoreboard*100+6, "<b>"..string.char(77, 111, 100, 117, 108, 101, 32, 99, 114, 101, 97, 116, 101, 100, 32, 98, 121, 32, 65, 116, 104, 101, 115, 100, 114, 97, 107, 101), name, 57, 357, nil, nil, 0x0, 0x0, 0, true)
			ui.addTextArea(id_scoreboard*100+7, "<p align='right'><b>V"..version, name, 50, 357, 697, nil, 0x0, 0x0, 0, true)
		else
			--77, 111, 100, 117, 108, 101, 32, 99, 114, 101, 97, 116, 101, 100, 32, 98, 121, 32, 65, 116, 104, 101, 115, 100, 114, 97, 107, 101
			ui.removeBox(id_scoreboard, name)
			players[name].down = false
		end
	end
end

function eventChatCommand(name, cmd)
	players[name].afk_time = os.time()
	local arg = {}
	for w in cmd:gmatch("%S+") do
		table.insert(arg, w)
	end
	if arg[1]=="lang" or arg[1]=="language" then
		if (not arg[2]) or arg[2]=="" then
			ui.addTextArea(idLang, "<cep>The languages available are: <j>Français</j> (<v>fr</v>), <j>English</j> (<v>en</v>), <j>Türkçe</j> (<v>tr</v>) and <j>Latviešu</j> (<v>lv</v>).", name, 300, 380, 495, 25, nil, nil, 1, true)
		elseif T[arg[2]:lower()] then
			players[name].lang = arg[2]:lower()
			ui.addTextArea(idLang, format("<cep>Language set to <v>%s</v>", arg[2]:upper()), name, 670, 380, 125, 25, nil, nil, 1, true)
		else
			ui.addTextArea(idLang, format("<cep>The <v>%s</v> translation isn't made yet. Contact Athesdrake#0000 or Sourixl if you want to help to translate !", arg[2]), name, 400, 360, 395, 45, nil, nil, 1, true)
		end
		after(5, function() ui.removeTextArea(idLang, name) end)
	end
	if arg[1]:sub(0,7)=="command" or arg[1]=="cmd" then help(name, 1) end
	if (arg[1]=="off" or arg[1]=="offset") and arg[2] and arg[2]~="" and arg[3] and arg[3]~="" then
		local x, y = tonumber(arg[2]:match("%-?%d+")), tonumber(arg[3]:match("%-?%d+"))
		if (not (x and y)) then
			ui.addTextArea(idOffChange, "<r><b>Invalid Offset", name, 700, 380, 95, 25, nil, nil, 1, true)
		else
			players[name].offset.x = x<-25 and -25 or (x>25 and 25 or x)
			players[name].offset.y = y<-25 and -25 or (y>25 and 25 or y)
			ui.addTextArea(idOffChange, format(translate("offset", name), players[name].offset.x, players[name].offset.y), name, 500, 380, 295, 25, nil, nil, 1, true)
		end
		after(2, function() ui.removeTextArea(idOffChange, name) end)
	elseif arg[1]=="help" then
		if arg[2] and arg[2]=="cmd" then
			help(name, 1)
		else
			help(name, 0)
		end
	elseif players[name].chef then
		if (not start) then
			if not teams[players[name].team].done then
				if arg[1]=="name" and arg[2] and arg[2]~="" then
					local txt = ""
					for i=2, #arg do
						txt = txt..arg[i].." "
					end
					txt = txt:sub(0, #txt-1)
					teams[players[name].team].name = txt:sub(0,58)
					reloadTeams()
				end
				if arg[1]=="color" then
					ui.showColorPicker(1, name, 0x1, translate("team", name).color)
				end
				if arg[1]=="ban" and arg[2] and arg[2]~="" and capitalize(arg[2])~=name then
					teams[players[name].team].ban[arg[2]:lower()] = 1
					for pl,ishere in pairs(teams[players[name].team].listPl) do
						if pl:lower()==arg[2]:lower() then
							teams[players[name].team].listPl[pl] = nil
							tfm.exec.killPlayer(capitalize(arg[2]))
							players[capitalize(arg[2])].team = 0
							reloadTeams()
							break
						end
					end
				end
				if arg[1]=="unban" and arg[2] and arg[2]~="" then
					teams[players[name].team].ban[arg[2]:lower()] = nil
				end
			elseif arg[1]=="name" or arg[1]=="color" or arg[1]=="ban" or arg[1]=="unban" then
				ui.addTextArea(idInfo, format("<j>You can't do the <v>%s</v> command unless you're not '<vp>done</vp>'.", arg[1]), name, 400, 380, 395, 25, nil, nil, 1, true)
				after(5, function() ui.removeTextArea(idInfo, name) end)
			end
			if arg[1]=="done" then
				teams[players[name].team].done = (not teams[players[name].team].done)
				reloadTeams()
				if #teams>1 then
					local t = 0
					for k,v in pairs(teams) do if v.done then t = t +1 end end
					if t==#teams then for i=idTeam, idTeam+100 do ui.removeTextArea(i) end; tfm.exec.newGame(maps[math.random(#maps)]); pause.p = false end
				end
			end
		else
			if arg[1]=="pause" and (not pause.p) and not vote.current then
				pause = {p = true, vote={nbr=0, oui=0}, t1=os.time() +120000}
				vote = {current=true, type="pause", nbr=1, oui=1}
				for c in roomPl() do
					if players[c].chef and c~=name then
						pause.vote.nbr = pause.vote.nbr +1
						ui.addTextArea(idPause, format(translate("commands", c).pause.ask..translate("accept", c), name, "pause", "pause"), c, 5, 375, 400, 25, nil, nil, 1, true)
					end
				end
			elseif arg[1]=="nc" and arg[2] and not vote.current then
				vote = {current=true, type="nc", nbr=1, oui=1}
				if arg[2]=="last" and lastRecord then
					vote.type = vote.type.."l"
					for c in roomPl() do
						if players[c].chef and c~=name then
							vote.nbr = vote.nbr +1
							ui.addTextArea(idPause, format(translate("commands", c).nc_last.ask..translate("accept", c), name, "ncl", "ncl"), c, 5, 375, 400, 25, nil, nil, 1, true)
						end
					end
				elseif arg[2]=="next" then
					vote.type = vote.type.."n"
					for c in roomPl() do
						if players[c].chef and c~=name then
							vote.nbr = vote.nbr +1
							ui.addTextArea(idPause, format(translate("commands", c).nc_next.ask..translate("accept", c), name, "ncn", "ncn"), c, 5, 375, 400, 25, nil, nil, 1, true)
						end
					end
				end
			elseif arg[1]=="skip" and not vote.current then
				vote = {current=true, type="skip", nbr=1, oui=1}
				for c in roomPl() do
					if players[c].chef and c~=name then
						vote.nbr = vote.nbr +1
						ui.addTextArea(idPause, format(translate("commands", c).skip.ask..translate("accept", c), name, "skip", "skip"), c, 5, 375, 400, 25, nil, nil, 1, true)
					end
				end
			elseif arg[1]=="untilwin" and not vote.current then
				vote = {current=true, type="untilwin", nbr=1, oui=1}
				for c in roomPl() do
					if players[c].chef and c~=name then
						vote.nbr = vote.nbr +1
						ui.addTextArea(idPause, format(translate("commands", c).untilwin.ask..translate("accept", c), name, "untilwin", "untilwin"), c, 5, 375, 470, 25, nil, nil, 1, true)
					end
				end
			end
		end
	end
	if name=="Athesdrake#0000" and cmd=="debug" then
		ui.addPopup(666, 2,"DEBUG", name)
	end
end

function eventPopupAnswer(id, name, ans)
	print(format("PopupAnswer>> %s with popupId %d answers \"%s\"", name, id, ans))
	if id==666 then
		arg = string.split(ans)
		if arg[1]=="call" then -- call a function with all the given args (eg: 'awesome_function$test$n$N35' → awesome_function('test', name, 35))
			local sub = {}
			for i=3, #arg do
				if arg[i]=="n" then
					table.insert(sub, name)
				elseif arg[i]:sub(0,1)=="N" then
					table.insert(sub, tonumber(arg[i]:sub(2)))
				else
					table.insert(sub, arg[i])
				end
			end
			_G[arg[2]](table.unpack(sub))
		end
	end
end

function eventColorPicked(id, name, color)
	if color==-1 then return end
	if id==1 then
		teams[players[name].team].color = color
		reloadTeams()
	end
end

function eventTextAreaCallback(id, name, callback)
	local arg = {}
	for a in callback:gmatch("[^$]+") do
		table.insert(arg, a)
	end
	if arg[1]=="pause" then
		ui.removeTextArea(idPause, name)
		if arg[2]=="non" then
			ui.removeTextArea(idPause)
			pause.p = false
			vote = {current=false}
			--ui.addTextArea("%s") PK j'ai fais ça ? je sais plus.
		else
			pause.vote.oui = pause.vote.oui +1
			if pause.vote.oui==pause.vote.nbr then
				nextMap = "pause"
				for pl in roomPl() do
					ui.addTextArea(idPause, translate("commands", pl).pause.set, pl, 5, 375, 400, 25, nil, nil, 1, true)
				end
				after(3, function() vote = {current=false}; ui.removeTextArea(idPause) end)
			end
		end
	end
	if arg[1]=="ncl" then
		ui.removeTextArea(idPause, name)
		if arg[2]=="non" then
			ui.removeTextArea(idPause)
			vote = {current=false}
		else
			vote.oui = vote.oui +1
			if vote.oui==vote.nbr then
				teams[record[#record].team].victory = teams[record[#record].team].victory -1
				for _,pl in pairs(record[#record].pl) do
					players[pl].survies = players[pl].survies -1
					players[pl].points = players[pl].points - (record[#record].team>1 and 1 or record[#record].team)
				end
				table.remove(record, #record)
				lastRecord = false
				for pl in roomPl() do
					ui.addTextArea(idPause, translate("commands", pl).nc_last.set, pl, 5, 375, 400, 25, nil, nil, 1, true)
				end
				after(3, function() vote = {current=false}; ui.removeTextArea(idPause) end)
			end
		end
	end
	if arg[1]=="ncn" then
		ui.removeTextArea(idPause, name)
		if arg[2]=="non" then
			ui.removeTextArea(idPause)
			vote = {current=false}
		else
			vote.oui = vote.oui +1
			if vote.oui==vote.nbr then
				nextRecord = false
				for pl in roomPl() do
					ui.addTextArea(idPause, translate("commands", pl).nc_next.set, pl, 5, 375, 400, 25, nil, nil, 1, true)
				end
				after(3, function() vote = {current=false}; ui.removeTextArea(idPause) end)
			end
		end
	end
	if arg[1]=="skip" then
		ui.removeTextArea(idPause, name)
		if arg[2]=="non" then
			ui.removeTextArea(idPause)
			vote = {current=false}
		else
			vote.oui = vote.oui +1
			if vote.oui==vote.nbr then
				nextMap = "normal"
				for pl in roomPl() do
					ui.addTextArea(idPause, translate("commands", pl).skip.set, pl, 5, 375, 400, 25, nil, nil, 1, true)
				end
				after(3, function() vote = {current=false}; ui.removeTextArea(idPause); newMap() end)
			end
		end
	end
	if arg[1]=="untilwin" then
		ui.removeTextArea(idPause, name)
		if arg[2]=="non" then
			ui.removeTextArea(idPause)
			vote = {current=false}
		else
			vote.oui = vote.oui +1
			if vote.oui==vote.nbr then
				vote = {current=false}
				uwin = false
				if leftTeam()~=0 then
					uwin = true
				end
				for pl in roomPl() do
					ui.addTextArea(idPause, translate("commands", pl).untilwin.set, pl, 5, 375, 400, 25, nil, nil, 1, true)
				end
				after(3, function() vote = {current=false}; ui.removeTextArea(idPause) end)
			end
		end
	end
	if arg[1]=="team" and (not players[name].chef) then
		if players[name].team~=0 then
			teams[players[name].team].listPl[name] = nil
		end
		local sep = tonumber(arg[2])+1
		if sep==6 then
			sep = 5
		end
		players[name].team = #teams+1
		players[name].chef = true
		players[name].afk_time = os.time()
		teams[#teams+1] = {name="Unknown", chef=name, spawn=200, color=0x0, listPl={[name]=1}, ban={}, id=#teams+1, points=0, victory=0}
		if #teams>0 then
			reloadTeams(true)
		end
	end
	if arg[1]=="join" then
		if players[name].chef then

		elseif getn(teams[tonumber(arg[2])].listPl)<=10 and (not teams[tonumber(arg[2])].ban[name:lower()]) and players[name].team~=tonumber(arg[2]) then
			tfm.exec.movePlayer(name, teams[tonumber(arg[2])].spawn, 350)
			tfm.exec.setNameColor(name, teams[tonumber(arg[2])].color)
			if players[name].team~=0 and ams[players[name].team] and teams[players[name].team].listPl then
				teams[players[name].team].listPl[pl] = nil
			end
			players[name].team = tonumber(arg[2])
			teams[tonumber(arg[2])].listPl[name] = 1
			reloadTeams()
		end
	end
	if arg[1]=="quit" then
		if players[name].chef then
			players[name].chef = false
			for pl, ishere in pairs(teams[players[name].team].listPl) do
				players[pl].team = 0
				tfm.exec.killPlayer(pl)
			end
			for i=idTeam+teams[#teams].id*10+1, idTeam+teams[#teams].id*10+5 do
				tfm.exec.removePhysicObject(i)
				ui.removeTextArea(i)
			end
			table.remove(teams, tonumber(arg[2]))
			--table.sort(teams)
			reloadTeams(true)
		elseif players[name].team~=0 then
			teams[players[name].team].listPl[name] = nil
			tfm.exec.killPlayer(name)
			players[name].team = 0
			reloadTeams()
		end
	end
	if arg[1]=="close" then
		ui["remove"..arg[2]](tonumber(arg[3]), name)
	end
	if arg[1]=="call" then
		table.foreach(arg, function(k,v) if v=="n" then arg[k]=name elseif v:sub(0,1)=="N" then arg[k] = tonumber(v:sub(2)) end end)
		_G[arg[2]](arg[3], arg[4])
	end
end

function eventLoop(t1, t2)
	for k,v in ipairs(todespawn) do
		if v.time<=os.time() then
			tfm.exec.removeObject(v.id)
			table.remove(todespawn, k)
		end
	end
	for key,data in ipairs(aft) do
		if data.t<=os.time() then
			data.f()
			table.remove(aft, key)
		end
	end
	if timer and timer<=os.time() then start=true; ui.removeTextArea(idTimer); for i=1,4 do ui.removeTextArea(idTimer*100+i) end
	elseif timer then
		local epaisseur = 2
		local t = {{x=epaisseur,y=0},{x=-epaisseur,y=0},{x=0,y=epaisseur},{x=0,y=-epaisseur}}
		for i=1,4 do
			ui.addTextArea(idTimer*100+i, "<p align='center'><font size='75' color='#000000' face='Agency FB'><b>"..tostring(math.ceil((timer-os.time())/1000)), nil, 0, 300+t[i].x, 800+t[i].y, nil, 0x0, 0x0, 0, true)
		end
		ui.addTextArea(idTimer, "<p align='center'><font size='75' color='#6A7595' face='Agency FB'><b>"..tostring(math.ceil((timer-os.time())/1000)), nil, 0, 300, 800, nil, 0x0, 0x0, 0, true)
	end
	if t2<0 and uwin and currentMap~="@0" and (not lobby) then
		local team, pl = leftTeam(), {}
		for k,v in roomPl() do
			if not v.isDead then
				if teams[team] then
					tfm.exec.giveCheese(k)
					tfm.exec.playerVictory(k)
				end
				if nextRecord then
					if teams[team] then players[k].points = players[k].points +1 end
					players[k].survies = players[k].survies +1
				end
				table.insert(pl, k)
			end
		end
		if nextRecord then
			if teams[team] then
				teams[team].victory = teams[team].victory +1
				if teams[team].victory>=limite then
					nextMap = "end"
				end
			end
			table.insert(record, {team=team, pl=pl})
		end
		nextRecord = true
		lastRecord = true
		if teams[team] and teams[team].victory>=limite then
			nextMap = "end"
		end
		newMap()
	end
	if pause.p then
		if pause.t2 then
			if pause.t2<=os.time() then
				pause.p = false
				joinQuit = true
				for i=idTeam, idTeam+100 do ui.removeTextArea(i) end
				newMap()
			end
		elseif pause.t1<=os.time() then
			ui.removeTextArea(idPause)
			nextMap = "pause"
		end
	end
	if fireworks then
		local tbl = {1,4,9}
		for i=1, (math.random(1,5)==1 and 2 or 1) do
			firework(tbl[math.random(#tbl)], math.random(100, 700), math.random(100, 400))
		end
	end
	if setup then
		for pl, data in pairs(players) do
			if data.chef and data.afk_time<=os.time()-30000 and not teams[data.team].done then
				eventTextAreaCallback(1, pl, format("quit$%d", data.team))
			end
		end
	end
end

function eventNewGame()
	lobby = false
	tfm.exec.disableAfkDeath(tfm.get.room.currentMap=="@0")
	if tfm.get.room.currentMap=="@0" then
		timer = false
		lobby = true
		ui.setMapName("<j>Sourixl<g> - @7103699 | <j>V"..version.." <n2>created by Athesdrake#0000\n")
		ui.addTextArea(idTitle, "<p align='center'><font color='#CC2126' size='75' face='Bauhaus 93'>DeathWar", nil, 0, 30, 800, 150, 0x0)
		-- font: Wide Latin, Algerian, Bauhaus 93, Castellar, Goudy Stout
		-- font: ui.addTextArea(1, "<font size='50' face='Wide Latin'>DeathWar</font>\n<font size='50' face='Algerian'>DeathWar</font>\n<font size='50' face='Bauhaus 93'>DeathWar</font>\n<font size='50' face='Castellar'>DeathWar</font>\n<font size='50' face='Goudy Stout'>DeathWar</font>\n<font size='50>DeathWar</font>")
	else
		ui.removeTextArea(idTitle)
		timer = os.time() +6000
		for k,v in roomPl() do
			if players[k].team==0 then
				tfm.exec.killPlayer(k)
			else
				tfm.exec.setNameColor(k, teams[players[k].team].color)
			end
		end
	end
	start = false
	win = true
	currentMap = tfm.get.room.currentMap
end

function setUp()
	tfm.exec.newGame(lobby_map)
	ui.addTextArea(idTeam, "<p align='center'><font size='30'>\n\n\n<b><a href='event:$team$1'>+", nil, 5, 155, 790, 237, nil, nil, 0.5)
end

function reloadTeams(tp)
	local sep = setup and (#teams+1==6 and 5 or #teams+1) or #teams
	table.foreach(teams, function(k,v) if v.hide then sep = sep -1 end end)
	table.sort(teams,
		function(a, b)
			if a.hide and not b.hide then
				return false
			end
			return true
		end
	)
	for k,v in pairs(teams) do
		v.id = k
		if v.hide then
			for i=idTeam+k*10+1,idTeam+k*10+4 do
				tfm.exec.removePhysicObject(i)
				ui.removeTextArea(i)
			end
		else
			v.spawn = (400*(2*(k-1)+1)/sep)
			tfm.exec.addPhysicObject(idTeam+k*10+1, (k-1)*(800/sep)+5, 275, {type=12, width=10, height=250, color=v.color})
			tfm.exec.addPhysicObject(idTeam+k*10+2, k*(800/sep)-5, 275, {type=12, width=10, height=250, color=v.color})
			tfm.exec.addPhysicObject(idTeam+k*10+3, v.spawn, 175, {type=12, width=800/sep, height=50, color=v.color})
			tfm.exec.addPhysicObject(idTeam+k*10+4, v.spawn, 395, {type=12, width=800/sep, height=10, color=v.color, friction=0.3})
			ui.addTextArea(idTeam+k*10+1, format("<p align='center'><font size='%d'>%s",#v.name>15 and 15 or 25, v.name), nil, (k-1)*(800/sep)+5, 150, 800/sep-10, nil, 0x0, 0x0, 0)
			if joinQuit then
				if v.done then
					for pl in roomPl() do
						ui.addTextArea(idTeam+k*10+2, "<p align='center'><font size='25' color='#00FF00'>"..translate("team", pl).done, pl, (k-1)*(800/sep)+5, 350, 800/sep-10, nil, 0x0, 0x0, 0)
					end
				else
					for pl in roomPl() do
						if players[pl].team==k then
							ui.addTextArea(idTeam+k*10+2, format("<p align='center'><font size='25'><a href='event:quit$%d'><r>"..translate("team", pl).quit, k), pl, (k-1)*(800/sep)+5, 350, 800/sep-10, nil, 0x0, 0x0, 0)
						else
							ui.addTextArea(idTeam+k*10+2, format("<p align='center'><font size='25'><a href='event:join$%d'>"..translate("team", pl).join, k), pl, (k-1)*(800/sep)+5, 350, 800/sep-10, nil, 0x0, 0x0, 0)
						end
					end
				end
			end
		end
		for pl,ishere in pairs(v.listPl) do
			if tp then
				tfm.exec.movePlayer(pl, v.spawn, 350)
			end
			tfm.exec.setNameColor(pl, v.color)
			players[pl].team = k
		end
	end
	if #teams~=5 and joinQuit then
		ui.addTextArea(idTeam, "<p align='center'><font size='30'>\n\n\n<b><a href='event:$team$"..sep.."'>+", nil, 800-800/sep, 155, 800/sep, 237, nil, nil, 0.5)
	else
		ui.removeTextArea(idTeam)
	end
end

function newMap()
	joinQuit, fireworks, setup = false, false, false
	if nextMap=="normal" then
		local temp_map = ""
		repeat
			temp_map = maps[math.random(#maps)]
		until temp_map~=currentMap
		currentMap = temp_map
		tfm.exec.newGame(temp_map)
	elseif nextMap=="pause" then
		tfm.exec.newGame(lobby_map)
		nextMap = "normal"
		pause.t2 = os.time() +300000
		pause.t1 = false
		for k,v in pairs(teams) do v.done = false end
		after(1, function() reloadTeams(true) end)
	elseif nextMap=="end" then
		tfm.exec.newGame(lobby_map)
		nextMap = "normal"
		after(1, function() reloadTeams(true);win_() end)
	end
end

function roomPl() return next, tfm.get.room.playerList, nil end

function countPl()
	local all, alive, dead = 0, 0, 0
	for k,v in roomPl() do
		all = all +1
		if v.isDead then
			dead = dead +1
		else
			alive = alive +1
		end
	end
	return {
		all = all,
		alive = alive,
		dead = dead
	}
end

function capitalize(str) return str:sub(0,1):upper()..str:sub(2):lower() end

function wHtml(str)
	if type(str)=="string" then
		return str:gsub("<[^>]+",""):gsub(">","") -- Supprime toutes la balises HTML
	end
end

function leftTeam()
	local team = 0
	for k,v in roomPl() do
		if not v.isDead then
			if team==0 then team = players[k].team end
			if team~=players[k].team then return 0 end
		end
	end
	return team
end

function help(name, page)
	if page==0 then
		ui.addTextPopup(idHelp, format(translate("help_txt", name), version), name, 225, 58, 350, 280)
	elseif page==1 then
		local HELP = translate("HELP", name)
		local H = HELP.title
		local f = H.txt
		if H.bcolor then f = format("<%s>%s</%s>", H.bcolor, f, H.bcolor) end
		if H.b then f = format("<b>%s</b>", f) end;if H.u then f = format("<u>%s</u>", f) end;if H.i then f = format("<i>%s</i>", f) end
		local txt = format("<p align='%s'><font color='#%s' size='%d'>%s</font></p>\n\n", H.align and H.align or L, H.color and tostring(H.color) or "c2c2da", H.size and H.size or 12, f)


		H = HELP.p[page]
		f = H.txt
		if H.bcolor then f = format("<%s>%s</%s>", H.bcolor, f, H.bcolor) end
		if H.b then f = format("<b>%s</b>", f) end;if H.u then f = format("<u>%s</u>", f) end;if H.i then f = format("<i>%s</i>", f) end
		txt = format("%s<p align='%s'><font color='#%s' size='%d'>%s</font></p>", txt, H.align and H.align or L, H.color and tostring(H.color) or "c2c2da", H.size and H.size or 12, f)
		for key in pairs(HELP.p[page].content) do
			H = HELP.p[page].content[key]
			local args = ""
			if H.arg then
				for kk, arg in pairs(H.arg) do
					if type(kk)=="number" then
						local space = string.rep(" ", H.space or 1)
						if H.arg.f then f = format("<%s>%s</%s>", H.arg.f[kk], arg, H.arg.f[kk]) else f = arg end
						args = format("%s%s[%s]", args, space, f)
					end
				end
			end
			txt = format("%s<font face='Lucida Console'>!%s%s%s</font>%s\n", txt, H.cmd, args, (" "):rep(24-string.len(wHtml(H.cmd..args))), H.description)
		end

		ui.addTextPopup(idHelp, txt, name, 100, 35, 600, 335)
		local x, y, width = 625, 352, 60
		ui.addTextArea(idHelp*100+7, " ", name, x-1, y-1, width-1, 11, 0x5D7D90, 0x5D7D90, 1, true)
		ui.addTextArea(idHelp*100+8, " ", name, x+1, y+1, width  , 12, 0x11171C, 0x11171C, 1, true)
		ui.addTextArea(idHelp*100+9, " ", name, x  , y  , width  , 12, 0x3C5064, 0x3C5064, 1, true)
		ui.addTextArea(idHelp*100+10, "<p align='center'><a href='event:call$help$n$N2'>&gt;", name, x  , y-3, width  , 20, 0x0, 0x0, 0, true)
	elseif page==2 then
		local HELP = translate("HELP", name)
		local H = HELP.title
		local f = H.txt
		if H.bcolor then f = format("<%s>%s</%s>", H.bcolor, f, H.bcolor) end
		if H.b then f = format("<b>%s</b>", f) end;if H.u then f = format("<u>%s</u>", f) end;if H.i then f = format("<i>%s</i>", f) end
		local txt = format("<p align='%s'><font color='#%s' size='%d'>%s</font></p>\n\n", H.align and H.align or L, H.color and tostring(H.color) or "c2c2da", H.size and H.size or 12, f)

		H = HELP.p[page]
		f = H.txt
		if H.bcolor then f = format("<%s>%s</%s>", H.bcolor, f, H.bcolor) end
		if H.b then f = format("<b>%s</b>", f) end;if H.u then f = format("<u>%s</u>", f) end;if H.i then f = format("<i>%s</i>", f) end
		txt = format("%s<p align='%s'><font color='#%s' size='%d'>%s</font></p>", txt, H.align and H.align or L, H.color and tostring(H.color) or "c2c2da", H.size and H.size or 12, f)
		for key in pairs(HELP.p[page].content) do
			H = HELP.p[page].content[key]
			local args = ""
			if H.arg then
				for kk, arg in pairs(H.arg) do
					if type(kk)=="number" then
						local space = string.rep(" ", H.space or 1)
						if H.arg.f then f = format("<%s>%s</%s>", H.arg.f[kk], arg, H.arg.f[kk]) else f = arg end
						args = format("%s%s[%s]", args, space, f)
					end
				end
			end
			txt = format("%s<font face='Lucida Console'>!%s%s%s</font>%s\n", txt, H.cmd, args, (" "):rep(24-string.len(wHtml(H.cmd..args))), H.description)
		end

		ui.addTextPopup(idHelp, txt, name, 100, 35, 600, 335)
		local x, y, width = 115, 352, 60
		ui.addTextArea(idHelp*100+7, " ", name, x-1, y-1, width-1, 11, 0x5D7D90, 0x5D7D90, 1, true)
		ui.addTextArea(idHelp*100+8, " ", name, x+1, y+1, width  , 12, 0x11171C, 0x11171C, 1, true)
		ui.addTextArea(idHelp*100+9, " ", name, x  , y  , width  , 12, 0x3C5064, 0x3C5064, 1, true)
		ui.addTextArea(idHelp*100+10, "<p align='center'><a href='event:call$help$n$N1'>&lt;", name, x  , y-3, width  , 20, 0x0, 0x0, 0, true)
	elseif page==3 then
		-- Old Help
		ui.addTextPopup(idHelp, format("Module imaginé par <bv>Sourixl</bv>, créé par <n2>Athesdrake#0000</n2>.\n\nSignalez-moi les bugs que vous rencontrez par messages sur le forum! Décrivez le bug avec autant de détails que possible, avec un screen si possible.\n\n\n\n<vi>Version</vi> <rose>%s</rose>", version), name, 225, 75, 350, 180)
	end
end

function win_()
	local winners, sep = "", #teams
	for k,v in pairs(teams) do
		if v.victory>=limite then
			winners = v
		end
	end
	if winners and winners.id and sep then
		local name = winners.name
		ui.addTextArea(idWinner, "<p align='center'><font face='Webdings' size='75' color='#ffff00'>%", nil, (winners.id-1)*(800/sep)+5, 250, 800/sep-10, nil, 0x0, 0x0, 0)
		for pl in roomPl() do
			ui.addTextArea(idWinner*100, format("<p align='center'><font face='Lucida Console' size='30'>"..translate('team', pl).win, #name>19 and name:sub(0,16).."..." or name), nil, 0, 105, 800, nil, 0x0, 0x0, 0, true)
		end
		fireworks = true
		after(2, function() after(30, restart) end)
	else
		error(format("<r>ERROR 404. NOT FOUND. Please report to Athesdrake#0000 on the forum these informations: -%s -%s -%s", tostring(winners), tostring(winners.id), tostring(sep)))
	end
end

function checkTeamActivity(team)
	for pl, ishere in pairs(teams[team].listPl) do
		if ishere==1 then
			teams[team].hide = false
			return false
		end
	end
	teams[team].hide = true
	return true
end

function restart()
	for key, data in pairs(teams) do
		data.points = 0
		data.victory = 0
		data.done = false
	end
	start = false
	setup = true
	lobby = true
	joinQuit = true
	uwin = true
	fireworks = false
	reloadTeams(true)
	ui.removeTextArea(idWinner)
	ui.removeTextArea(idWinner*100)
end

function math.rand_negative(...)
	local x = 0
	repeat
		x = math.random(-1, 1)
	until x~=0
	return x*math.random(table.unpack({...}))
end

function getn(tbl)
	local lenght = 0
	for k,v in next, tbl do
		lenght = lenght +1
	end
	return lenght
end

function torad(deg)
	return deg*math.pi/180
end

function firework(id, x, y, name)
	for i=0, 10 do
		local angle = math.rand_negative(0, 180)
		local xs, ys, xa, ya = 2*math.cos(torad(angle)), 2*math.sin(torad(angle)), math.rand_negative()/10, math.rand_negative()/10
		tfm.exec.displayParticle(id, x, y, xs, ys, 0, 0, name)
		tfm.exec.displayParticle(id, x, y, xs, ys, xa, ya, name)
	end
end

function after(temps, func)
	table.insert(aft, {t=os.time()+temps*1000, f=func})
end

ui.addBox = function(id, txt, name, x, y, largeur, hauteur)
	if (not txt) then txt = "" end
	if (not x) then x = 100 end
	if (not y) then y = 100 end
	if (not hauteur) then hauteur = 200 end
	if (not largeur) then largeur = 200 end
	ui.addTextArea(id*100+0 ," ", name, x+0, y+0, largeur     , hauteur   , 0x2D211A, 0x2D211A, 0.8, true)
	ui.addTextArea(id*100+1 ," ", name, x+1, y+1, largeur-2   , hauteur-2 , 0x986742, 0x986742, 1  , true)
	ui.addTextArea(id*100+2 ," ", name, x+4, y+4, largeur-8   , hauteur-8 , 0x171311, 0x171311, 1  , true)
	ui.addTextArea(id*100+3 ," ", name, x+5, y+5, largeur-10  , hauteur-10, 0x0C191C, 0x0C191C, 1  , true)
	ui.addTextArea(id*100+4 ," ", name, x+6, y+6, largeur-12  , hauteur-12, 0x24474D, 0x24474D, 1  , true)
	ui.addTextArea(id*100+5 ," ", name, x+7, y+7, largeur-14  , hauteur-14, 0x183337, 0x183337, 1  , true)
	ui.addTextArea(id       ,txt, name, x+8, y+8, largeur-16  , hauteur-16, 0x122528, 0x122528, 1  , true)
end

ui.addTextPopup = function(id, txt, name, x, y, largeur, hauteur)
	ui.addTextArea(id*100+0, " ", name, x-1, y-1, largeur-1, hauteur-1, 0x648FA4, 0x648FA4, 1, true)
	ui.addTextArea(id*100+1, " ", name, x+1, y+1, largeur  , hauteur  , 0x0E1417, 0x0E1417, 1, true)
	ui.addTextArea(id*100+2, txt, name, x  , y  , largeur  , hauteur  , 0x324650, 0x324650, 1, true)

	local x2, y2, l2, h2, tx2 = x+largeur*0.15, y+hauteur-18, largeur*0.7, 12, format("<p align='center'><a href='event:$close$Pop$%d'>%s", id, translate("win_close", name))
	ui.addTextArea(id*100+3, " ", name, x2-1, y2-1, l2-1, h2-1, 0x5D7D90, 0x5D7D90, 1, true)
	ui.addTextArea(id*100+4, " ", name, x2+1, y2+1, l2  , h2  , 0x11171C, 0x11171C, 1, true)
	ui.addTextArea(id*100+5, " ", name, x2  , y2  , l2  , h2  , 0x3C5064, 0x3C5064, 1, true)
	ui.addTextArea(id*100+6, tx2, name, x2  , y2-3, l2  , 20  , 0x0, 0x0, 0, true)
end

ui.removePop = function(id, name)
	for i=id*100, id*100+10 do
		ui.removeTextArea(i, name)
	end
end

ui.removeBox = function(id, name)
	if id then
		ui.removeTextArea(id, name)
		for i=id*100, id*100+15 do
			ui.removeTextArea(i, name)
		end
	end
end

ui.addText = function(id, txt, name, x, y, border, size)
	local i = id*100
	for ox=-1, 1 do
		for oy=-1, 1 do
			if math.abs(ox)~=math.abs(oy) and ox~=-oy and (not (ox==0 and oy==0) or t==2) then
				i = i +1
				ui.addTextArea(i, "<p align='center'><b><font color='#000000' size='"..(size or 35).."'>"..txt, name, x+ox*(border or 1)-350, y+oy*(border or 1)-size/1.5, 700, nil, 0x0, 0x0, 0)
			end
		end
	end
	ui.addTextArea(i+1, "<p align='center'><b><font color='#6A7595' size='"..(size or 35).."'>"..txt, name, x-350, y-size/1.5, 700, nil, 0x0, 0x0, 0)
end

function translate(msg, name)
	return T[players[name].lang][msg]
end

function string:split(sep, maxsplit) -- Return a list of the words in the strings using `sep` as the delimiter string
	local sep, tmp = sep or "$", {}
	for element in self:gmatch("[^"..sep.."]+") do
		tmp[#tmp+1] = element
		if maxsplit and #tmp==maxsplit then
			return tmp
		end
	end
	return tmp
end

main()