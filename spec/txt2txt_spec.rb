describe "txt2cod" do
  let(:binary) { Pathname(__dir__) + "../bin/txt2txt" }
  let(:txt) { `#{binary} <#{deck_path}` }

  describe "Uro Commander deck" do
    let(:deck_path) { Pathname(__dir__) + "data/uro_titan_of_ffs.dck" }
    let(:expected) {
      <<~EOF
        // NAME: Uro, Titan of FFS
        COMMANDER: 1 Uro, Titan of Nature's Wrath
        1 Jace, Wielder of Mysteries
        1 Laboratory Maniac
        1 Marit Lage's Slumber
        1 Scrying Sheets
        46 Snow-Covered Forest
        49 Snow-Covered Island

        Sideboard
        1 Courser of Kruphix
        1 Hedron Crab
        1 Oracle of Mul Daya
        1 Roil Elemental
        1 Tatyova, Benthic Druid
        1 Thassa's Oracle
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  describe "Arena deck" do
    let(:deck_path) { Pathname(__dir__) + "data/arena_orzhov_scornmage.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        4 Lecturing Scornmage
        4 Informed Inkwright
        4 Inkling Mascot
        4 Scolding Administrator
        4 Stirring Hopesinger
        3 Sheoldred, the Apocalypse
        4 Cut Down
        4 Fatal Push
        4 Go for the Throat
        2 Heartless Act
        4 Concealed Courtyard
        4 Caves of Koilos
        4 Brightclimb Pathway // Grimclimb Pathway
        2 Restless Fortress
        1 Shattered Sanctum
        4 Swamp
        4 Plains

        Sideboard
        3 Thoughtseize
        2 Duress
        2 Ghost Vacuum
        2 Power Word Kill
        2 Liliana of the Veil
        2 Skyclave Apparition
        2 Bitter Triumph
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  describe "Arena deck with About section" do
    let(:deck_path) { Pathname(__dir__) + "data/arena_about_name.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Prismari Midrange
        2 Alrund's Epiphany
        4 Bonecrusher Giant
        4 Brazen Borrower
        2 Den of the Bugbear
        4 Dragon's Fire
        4 Fabled Passage
        3 Galazeth Prismari
        4 Goldspan Dragon
        2 Hall of Storm Giants
        2 Inferno of the Star Mounts
        7 Island
        2 Magic Missile
        4 Mazemind Tome
        6 Mountain
        2 Mystical Dispute
        2 Prismari Command
        4 Riverglide Pathway
        2 Saw It Coming

        Sideboard
        3 Burning Hands
        1 Disdainful Stroke
        2 Iymrith, Desert Doom
        1 Mystical Dispute
        1 Negate
        2 Phoenix of Ash
        3 Redcap Melee
        1 Shadowspear
        1 Test of Talents
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # Companion is also listed in the sideboard, so it must not be counted twice
  describe "Arena deck with Companion section" do
    let(:deck_path) { Pathname(__dir__) + "data/arena_gyruda_companion.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        5 Forest
        1 Incubation Druid
        1 Plains
        4 Fabled Passage
        1 Temple of Plenty
        2 Temple of Mystery
        1 Temple of Enlightenment
        4 Temple Garden
        2 Island
        4 Hallowed Fountain
        4 Breeding Pool
        4 Growth Spiral
        2 End-Raze Forerunners
        3 Gyruda, Doom of Depths
        1 Dream Trawler
        2 Umori, the Collector
        4 Thassa, Deep-Dwelling
        4 Spark Double
        3 Elite Guardmage
        4 Paradise Druid
        4 Charming Prince

        Sideboard
        2 Disdainful Stroke
        2 Return to Nature
        4 Aether Gust
        1 Gyruda, Doom of Depths
        4 Destiny Spinner
        2 Dovin's Veto
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  describe "Arena Brawl deck with Commander and Companion sections" do
    let(:deck_path) { Pathname(__dir__) + "data/arena_brawl_daxos.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        COMMANDER: 1 Daxos, Blessed by the Sun
        1 Stonecoil Serpent
        1 Healer's Hawk
        22 Plains
        1 Ajani's Pridemate
        1 Soulmender
        1 Hunted Witness
        1 Charmed Stray
        1 Beloved Princess
        1 Alseid of Life's Bounty
        1 Charming Prince
        1 Daybreak Chaplain
        1 Gingerbrute
        1 Impassioned Orator
        1 Hushbringer
        1 Grateful Apparition
        1 Drannith Healer
        1 Haazda Marshal
        1 Sworn Companions
        1 Shadowspear
        1 The Birth of Meletis
        1 Sentinel's Mark
        1 Battlefield Promotion
        1 Dawn of Hope
        1 Desperate Lunge
        1 Moment of Heroism
        1 Rally for the Throne
        1 Triumphant Surge
        1 Take Heart
        1 Light of Hope
        1 Golden Egg
        1 Shatter the Sky
        1 Citywide Bust
        1 Unbreakable Formation
        1 Ravnica at War
        1 Inspired Charge
        1 Faerie Guidemother
        1 Solid Footing
        1 Sentinel's Eyes

        Sideboard
        1 Lurrus of the Dream Den
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # Every site writing Arena-style lines annotates them differently:
  # `*F*` foil, `*E*` etched foil, `(F)` foil, `*CMDR*` commander,
  # `#tags`, and Archidekt's `[Categories]` and `^Label,#colour^`
  describe "Arena-style deck with annotations" do
    let(:deck_path) { Pathname(__dir__) + "data/arena_annotations.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        COMMANDER: 1 Kenrith, the Returned King
        1 Ainok Bond-Kin
        4 Counterspell
        1 Pegasus Guardian // Rescue the Foal
        1 Agadeem's Awakening // Agadeem, the Undercrypt
        1 Ashnod's Altar
        1 Amulet of Vigor
        1 Sol Ring
        1 Arcane Signet

        Sideboard
        1 Containment Priest
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # Archidekt exports cards from sets which never made it to Arena
  # with an empty set code, like `1x Think Twice () 92`
  describe "Archidekt deck with empty set codes" do
    let(:deck_path) { Pathname(__dir__) + "data/archidekt_no_set_code.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        1 Think Twice
        1 Snapcaster Mage
        1 Isochron Scepter

        Sideboard
        1 Dispel
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # mtg.wtf puts `[SET:NUM]` after the name, and marks foils separately
  describe "mtg.wtf deck export" do
    let(:deck_path) { Pathname(__dir__) + "data/mtgwtf_export.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Blood Rush - Dragon's Maze Event Deck
        COMMANDER: 1 Karador, Ghost Chieftain
        4 Lightning Bolt [foil]
        1 Sire of Seven Deaths
        1 Day of Judgment [foil]

        Sideboard
        2 Naturalize
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  describe "Deckstats deck with sections as comments" do
    let(:deck_path) { Pathname(__dir__) + "data/deckstats_sections.txt" }
    let(:expected) {
      <<~EOF
        // NAME: Unknown
        1 Ash Barrens
        1 Blinkmoth Nexus

        Sideboard
        1 Darksteel Citadel
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # https://www.mtgsalvation.com/forums/the-game/modern/established-modern/aggro-tempo/782962-burn
  describe "deck using 4x counts" do
    let(:deck_path) { Pathname(__dir__) + "data/burn_4x.txt" }
    let(:expected) {
      <<~EOF
        // NAME: RWg Burn
        4 Arid Mesa
        4 Inspiring Vantage
        3 Mountain
        2 Sacred Foundry
        3 Scalding Tarn
        1 Stomping Ground
        3 Wooded Foothills
        4 Eidolon of the Great Revel
        4 Goblin Guide
        4 Monastery Swiftspear
        4 Boros Charm
        4 Lava Spike
        4 Lightning Bolt
        4 Lightning Helix
        4 Rift Bolt
        4 Searing Blaze
        4 Skullcrack

        Sideboard
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end
end
