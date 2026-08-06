mtg
===

Magic the Gathering scripts.

scripts
=======

* `analyze_deck_colors` - reports colors of the deck according to correct algorithm [ http://t-a-w.blogspot.com/2013/03/simple-and-correct-algorithm-for.html ]
* `clean_up_decklist` - clean up manually created decklist
* `cod2dck` - convert Cockatrice's .cod to XMage's .dck
* `cod2txt` - convert Cockatrice's .cod to .txt format
* `txt2cod` - convert plaintext deck formats to Cockatrice's cod
* `txt2dck` - convert plaintext deck format to XMage
* `txt2txt` - convert plaintext deck format to plaintext deck format (i.e. normalize the decklist)
* `url2cod` - download decklists from URL and convert to .cod (a few popular websites supported)
* `url2dck` - download decklists from URL and convert to XMage .dck format
* `url2txt` - download decklists from URL and convert to .txt format

The `txt2*` scripts autodetect Arena-style decklists (`4 Bonecrusher Giant (ELD) 115`),
which is what MTG Arena, Moxfield, Archidekt, TappedOut, ManaBox, and MTGGoldfish all
write. That covers `About`/`Name`, `Deck`, `Commander`, `Companion`, `Maybeboard`, and
`Sideboard` sections, `4x` counts, `*F*` / `*E*` / `(F)` finish markers, `*CMDR*`,
Moxfield `#tags`, and Archidekt `[Categories]` and `^Labels^`.
The companion is skipped, as Arena also lists it in the sideboard, and so is the
maybeboard. Finish markers are dropped, this deck model has nowhere to put them.

Also read: XMage `.dck`, Forge `.dck`, Deckstats (`//Main` sections and `[SET#NUM]`),
Magic Workstation, MTGO, Apprentice, and mtg.wtf's own `[SET:NUM]` exports.


data management
===============

These are used to generate data in `data/`, you probably won't need to run them yourself

* `generate_colors_tsv_mtgjson` - generate `data/colors.tsv` from mtgjson's AllSets-x.json (recommended)
* `generate_colors_tsv_cockatrice` - generate `data/colors.tsv` from cockatrice's cards.xml (use mtgjson instead)
* `mage_card_map_generator` - generate `data/mage_cards.txt`
