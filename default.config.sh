#!/bin/bash

####################################################################################################################################################################
# sabPreProcessing DEFAULT CONFIG FILE - copy to config.sh and override the variables with your data.                                                              #
# When unset, default variable will be used.                                                                                                                       #
# Use $DIR for the actual directory of the script.                                                                                                                 #
# Use ARRAY+=('bar') when you want to extend default arrays like GAMES_GROUPS, CLEAN_ARRAY or EXCEPTIONS.                                                          #
####################################################################################################################################################################

MIN_RELEASENAME_SIZE='13';           # Minimum string lenght of releasename before -GROUP

SERIES_CATEGORY='series';            # Your SAB-cat of your tv shows
SERIES_MIN_SIZE=180;                 # Minimum tv show size in megabytes before it gets paused
SERIES_PRIORITY='1';                 # Default priority of tv shows (-100 -2, -1, 0 or 1, meaning Default, Paused, Low, Normal, High)
SERIES_SCRIPT='';                    # Post-Processing script of tv shows

MOVIES_CATEGORY='movies';            # Your SAB-cat of your movies
MOVIES_MIN_SIZE=400                  # Minimum movie size in megabytes before it gets paused
MOVIES_PRIORITY='1';                 # Default priority of movies (-100 -2, -1, 0 or 1, meaning Default, Paused, Low, Normal, High)
MOVIES_SCRIPT='';                    # Post-Processing script of movies
INCLUDE_IMDB_ID=true;                # Include the IMDB in the final nzb name using CouchPotato tagging ("RELEASENAME.cp(tt0432425)")

# List of games release-groups for the games-recognition, thanks to xREL.to for the list.
GAMES_GROUPS=('iTWINS' 'LND' 'GENESIS' 'NESSUNO' 'MONEY' 'SiLENTGATE' 'PRD' 'JoWood' 'RELOADED' 'HOODLUM' 'DEViANCE' 'MYTH' 'DRT' 'ISO'
              'VNGCLONE' 'PHXISO' 'JAM' 'DEFA' 'SPiRO' 'MAX' 'AF' 'NOGROUP' 'XMAFT' 'SPiTFiRE' 'ConFUSiON' 'ELEGANCE' 'SKY' 'iNSTiNCT'
              'DIE' 'OGR' 'FANiSO' 'TNT' 'TECHNiC' 'VENGEANCE' 'Carbon' 'PARADOX' 'NMP' 'COREiSO' 'iND' 'FASiSO' 'RAiN' 'BACKLASH' 'CTi'
              'TWK' 'DVN' 'GGS' 'TRDogs' 'MKN' 'CLONECD' 'DAW' 'ViTALiTY' 'iNFECTED' 'VACE' 'RoME' 'ALiAS' 'EiDOS' 'DYNAMiCS' 'FiLTH'
              'DownLink' 'DARKLiGHT' 'BiN' 'MDeth' 'ViOLENTFATE' 'ST0N3D' 'NETSHOW' 'SUSPECTS' 'GRG' 'Legends' 'SUBTiLE' 'iLLUSiON'
              'MiRROR' 'RiTUEL' 'BRiGHTLiGHT' 'ENLIGHT' 'DEV' 'ADDICTION' 'TRSi' 'SWiFT' 'TetrisEmu' 'DEATHROW' 'REVENGE' 'IAM' 'iNDUCT'
              'EMPORiO' 'GRiSO' 'DiViNE' 'REFLEX' 'POSTMORTEM' 'TIP' 'iRRM' 'GOD' 'UNDERWORLD' 'DVNiSO' 'PLATiN' 'FAiRLiGHT' 'SiNiSTER'
              'FiSO' 'HANF' 'YYePGiSO' 'I_KnoW' 'RFD' 'DELiGHT' 'CSiSO' 'NicJr' 'PCGAME' 'cRacKPoTs' 'iR' 'F4CG' 'JuNGLEFeVER' 'CORE'
              'SECRETDOOR' 'ACERTCLONE' 'MATRiX' 'bC' 'GROUPNAME' 'MONCUL' 'GBX' 'BTG' 'PLEX' 'OPIUM' 'FLT' 'GHC' 'Unleashed' 'PROViSiON'
              'UNITED' 'SCRABBLE' 'SKiNOTE' 'CLOWNDVD' 'ABSENTiA' 'ExAuST' 'CFFiSO' 'JGTiSO' 'gSR' 'iMMORTALITY' 'oNePiEcE' 'GRATIS'
              'PillePalle' 'HG' 'ASSHOLES' 'CRIME' 'CRD' 'Px777' 'HTF' 'UKT' 'Razor1911' 'GAYLESS' 'QUARTEX' 'MDAtje' 'BK' 'PROCYON'
              'Bamboocha' 'PROPER' 'DETONATiON' 'DONViTO' 'RLDSUX' 'UTOPiA' 'FUCKTRADERS' 'iCLONE' 'BDM' 'EDGEISO' 'GLAMOURY' 'STEAMRULES'
              'LOADiNG' 'ZZGiSO' 'PSYFER' 'RESTORE' 'DOD' 'RECHARGED' 'CiFE' 'CALiBAN' 'STON3D' 'WORKiNG' 'Pravetz' 'SRG' 'BloodAngels'
              'RHI' 'JiNi' 'WUSELFAKTOR' 'LYNCH' 'xCLONE' 'HATRED' 'iRRMiSO' 'JFKPC' 'Micronauts' 'TFTISO' 'TOPOLANEK' 'FEGEFEUER'
              'SEXMORTEM' 'ViSTA' 'OVERDUE' 'FFO' 'JBL' 'ABSURD' 'NOSP' 'BiRDFLUSUX' 'STFU' 'TMD' 'SYNDiCATE' 'CLONEGAME' 'TEAMKNiGHTZ'
              'TiWLTH' 'VLiSO' 'AVENGED' 'LZ0' 'TheDarkSeed' 'OSX' 'DH' 'CLONE' 'ZRY' 'R55' 'RiSiNG' 'DOLLiE' 'VAMPYRES' 'AERiS' 'ENiGMA'
              'ADDONiA' 'SKiDROW' 'LEMON' 'ONEHiTWONDER' 'LOLCATS' 'ARMADA' 'SEXYPC' 'iONOS' 'ADDONi' 'RAGAiSO' 'kringspiermusketier' 'ANNO'
              'TOPGUN' 'FLTDOX' 'CrystalMeth' 'DINOByTES' 'RETARDS' 'HI2U' 'Crackpot' 'hV' 'WEIHNACHTSMANNISO' 'TiNYiSO' 'EPiSODE' 'WaLMaRT'
              '4FRiENDS' '2xKiDS' 'HHT' 'WARG' 'TNTANAL' 'ELYSIUM' 'ALCOHOLIC' 'ASRG' 'REDHERRING' '0x0007' 'NLiSO' 'SACRED' 'HYBRiD' 'TibaK'
              'PROPHET' 'DYNASTY' 'DiP' 'ALiASISO' 'GiNALiSA' 'GOW' 'UBiSHiT' 'EDGE' 'NRG' 'Coolpoint' 'DarkCoder' 'KiWi' 'iMMXpC' 'WHOCARES'
              'TiME' 'CiA' 'ATOMiC' 'CLASSiO' 'FM09' '0x0008' 'OWNAGE' 'UNLOADED' 'OneUp' 'EPH' 'LOBO' 'Wurstsuppe' 'ISOGER' 'KICKASS' 'TRM'
              'FASDOX' 'TRI' 'KOENIGSWASSER' 'Sq00pS' 'MAGNUSSOFT' 'RazorDOX' 'DPS' 'KLAUS' 'TPRoxxTheHouse' 'INLAWS' 'EViLISO' 'CPY'
              'BLACKBEAUTY' 'LOOPING' 'DERROTEBARON' 'BAUERHEINRICH' 'DoggyStyle' 'REdownLOADED' 'NO' 'ReVOLVeR' 'HEiRLOOM' 'BDP' 'BAT'
              'GNSDOX' 'HOOLiGANS' 'KALISTO' 'X' 'SiNALCO' 'nWo' 'RAZOR' 'THG' 'TDT' 'MOBLISS' 'INC' 'TE' 'ARM' 'FIRM' 'PTL' 'LOW' 'OWI' 'TGC'
              'KNiFE' 'DCW' 'RESURGE' 'SWEETPEA' 'PE' 'ATLANTIS' 'OFG' 'ANTHEM' 'UNIQ' 'LOP' '8088' 'NINGA' 'TTG' 'DREAM' 'EXTASY' 'PYRADiCAL'
              'RGB' 'XAP' 'CLS' 'IMPACT' 'Rondomedia' 'PUSSYCAT' 'Outlaws' 'EPiC' 'SWR' 'FERNETiSO' 'DTSISO' 'iMMERSiON' 'IMPLUSION' 'SPiN'
              'OUTCAST' 'Prestige' 'ANON' 'ReUnion' 'CoolPointDox' 'LXTDOX' 'Souldrinker' 'NOiSOME' 'GFH' 'SPLATTERKiNGS' 'DIECAMPER' 'Bambocha'
              'DORMINE' '1C' 'PiMoCK' 'PETA' 'ViSiON' 'BCC' 'LiBERTY' 'aSxDOX' 'PoisonIvy' 'ZHONGGUO' 'MEiGUO' 'ROM' 'FAGLIGHT' 'Baboocha'
              'ArCADE' 'SKiTFiSKE' 'CRiMEBOOM' 'iNDEPENDANT' 'JAGUAR' 'ABSiSO' 'JayKhan' 'DST' 'BIOWARE' 'VALK' 'UNTOUCHABLES' 'HEiST'
              'TcS' 'nXs' 'BT' 'CFBISO' 'GREENPEACE' 'iV' 'THXiSO' 'EiTheLiSO' 'iMPERiAL' 'ASiNUS' 'RAM' 'PARADiGM' 'ORiGiN' 'JAGUAR_'
              'SUPERiOR' 'SQUiDiSO' 'AMNESTYINTERNATIONAL' 'SHiTROW' 'ThakuR' 'gimpsRus' 'TBT' 'CLSISO' 'GAME' 'StyLe' 'LEGEND' 'Bambbocha'
              'PEACECORPS' 'PNWiSO' 'KAISER' 'STN' 'RazorISO' 'WWLiSO' 'CXZISO' 'PRS' 'GiRLiSO' 'CLA' 'DOM' 'DW' 'DYNAMIX' 'FTH' 'FRM' 'FLT-USA'
              'FDN' 'GNS' 'HBD' 'LGD' 'ZEUZ' 'VSW' 'UTB' 'UNITY' 'TWA' 'SKL' 'SCT' 'SCP' 'TRT' 'ROR' 'ROMKIDS' 'QNT' 'PiL' 'PHX' 'SDR' 'NPM' 'CPC'
              'RSi' 'NEUA' 'STEALTH' 'CONEHEAD' 'PTG' 'NEXUS' 'TRA' 'BUDGET' 'UNT' 'MALiGN' 'PENTAGRAM' 'GAMES' 'TDUJAM' 'TSC' 'GTA' 'SHK' 'TOL' 'UCU'
              'ASCENSION' 'iSLE' 'TRPS' 'PASH' 'FiGHTCLUB' 'PDM' 'VOLKSWAGEN' 'TDD' 'BSP' 'DD' 'DEADREZ' 'TYRANNY' 'Eclipse' 'BOS' 'RAGE' 'EXCRETE'
              'GLORY' 'SKILLION' 'NAPALM' 'PCI' 'SMURFS' 'SABBOTAGE' 'RZR' 'PSG' 'INTERPOL' 'REFLUX' 'Coop' 'CURSED' 'SHOCK' 'PTM' 'AFL' 'NU' 'EOD'
              'TRACKERS' 'R2' 'PDX' 'TWG' 'TNWC' 'ESP' 'DEFiANT' 'LiO' 'NOVA' 'KARMA' 'PHM' 'SKN' 'Doom_Wads' 'PNC' 'DBD' 'JORUNE' 'ROM1911' 'SYND'
              'ONYX' 'TYRANY' 'SOI' 'PREMiERE' 'FAITH' 'BWH' 'DRG' 'PTA' 'CCG' 'MENNEN' 'Dutch_League' 'Spanish_League' 'SMOS' 'SECiSO' 'ZOMBIES'
              'POLICE' 'SHURIKEN' 'CAS' 'TDU' 'FOTL' 'D_PLUT_PAK_CRACK' 'EXCRETION' 'IFFTIC' 'FBI' 'II' 'WILDCARDS' 'SYNAPSE' 'COPS' 'HCC' 'RAZORCD'
              'UTC' 'SCUM' 'TUB' 'SABOTAGE' 'PC-EXEC' 'WICKED' 'UA' 'PENTAX' 'VEN' 'DDD' 'ETN' 'BUDGETSIS' 'NMS' 'EN' 'DEBRIS' 'UNICEF' 'ARBORETUM'
              'RFC' 'FULL_CD' 'WILD' 'RTN' '95_Edition' 'BDE' 'IC' 'STORM' 'TWZ' 'JL' 'EXTREME' 'TNC' 'RENEGADE' 'MANTIS' 'REBELS' 'ZEUS' 'TERRATRON'
              'C0D' 'OTFW' 'VIA' 'DENiAL' 'MAPS' 'TEAM' 'BLH' '0x0815' 'ErES' 'PROFiT' 'PWZ' 'HATEDOX' 'CHEATERS' 'IZI' 'BLeH' 'BREEZE' 'PWZiSO' 'DWi'
              'ORiON' 'CLASS' 'Greenpace' 'JAGDOX' 'ENERGY' 'MORESMELLYTNTANUSFARTS' 'HALFLIFE' 'MAXiNN' 'CONSPiRE' 'CLASSICS' 'PPTCLASSiCS' 'DEVLATiON'
              'FiSKPiNNE' 'ISOCD' 'CiMS' 'CURE' 'SUNE' 'SNOTiSO' 'GOLD' 'MaXXiM' 'FTFiSO' 'MOJiTO' 'COGENT' 'Ultima' 'CKY' 'SMACKs' 'ViCTiMS' 'TSUiSO' 'gTFiSO'
              'Cyclone' 'OBiT' 'KraftDinner' 'CALISO' 'TSU' 'LuZiFeR' 'FRiHET' 'LAiSO' 'CFiSO' 'iNVFX' 'ALDi' 'TURD' 'PYROTECHNIK' 'HorseGame' 'SANTA' 'CLOCK'
              'VERMiSO' 'iPF' 'SHOGUN' 'cPEiSO' 'PAWS' 'STYiSO' 'CODEX' 'DOGE' 'NCRYSO');

GAMES_CATEGORY='games';              # Your SAB-cat of your games
GAMES_PRIORITY='-1';                 # Default priority of games (-100 -2, -1, 0 or 1, meaning Default, Paused, Low, Normal, High)
GAMES_SCRIPT='';                     # Post-Processing script of games

EXCEPTIONS=('had551');               # Strings in titles which shouldn't be parsed at all

BADWORDS=('Videomann');              # Strings in titles which shouldn't be downloaded

# Strings which will be replaced after fetching the password. Regex allowed, search and replace splittet by /.
CLEAN_ARRAY=('\(http[s]\?:\/\/\|www\.\)\{1\}[a-zA-Z0-9\.-]\{4,\}\.[a-zA-Z]\{2,4\}[\/]\?/'
				' \./\.'
				'\. /\.'
				'D ubbed/Dubbed'
				'Dub bed/Dubbed'
				'DVD-Rip/DVDRip'
				'WEB-DL/WEBDL'
				'Usenetrevolution\.info/'
				'\[ TOWN \]-/'
				'\.par2/'
				'yEnc/'
				'\[[0-9]\{1,3\}\/[0-9]\{1,3\}\]/'
				'partner of/'
				'powered by/'
				'SSL-News\.info/'
				'Sponsored.by./'
				'Lords-of-Usenet/'
				'Uploader\.Presents-/'
				'usenet-space-cowboys\.info/'
				'brothers-of-usenet\.info/'
				'newsconnection\.eu/'
				'Powered by httpssecre/'
				'presents\./'
				'usenet-4all\.info/'
				'Serien\.-\./'
				'(/'
				')/'
				' \/ /'
				'_PW_/');

HIGH_PRIORITY_SIZE=100;              # Below this size (in megabytes) priority will always be high

ADD_TO_PASSWORD_FILE=true            # Enable or disable adding the passwords to a password file
PASSWORD_FILE="$DIR"'/passwordlist'; # (WHOLE!) Path to password file, f.e. '/home/username/.sabnzbdplus/passwordlist'

DO_LOG=true;                         # To log or not to log, thats the question
LOGFILE="$DIR"'/preprocessing.log';  # (WHOLE!) Path to logfile, f.e. '/home/username/.sabnzbdplus/preprocessing.log'
